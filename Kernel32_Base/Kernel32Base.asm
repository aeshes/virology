.386
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\macros\macros.asm
uselib kernel32


.code
start:
  mov esi, [esp]
  call GetBase
  pop esi
  invoke ExitProcess, 0

ValidPE proc
  push esi
  pushf
  .if word ptr [esi] == "ZM"
      assume esi: ptr IMAGE_DOS_HEADER
      add esi,[esi].e_lfanew
      .if word ptr [esi] == "EP"
          popf
          pop esi
          mov eax, 1
          ret
      .endif
  .endif
  popf
  pop esi
  xor eax, eax
  ret
ValidPE endp

GetBase proc
local Base: DWORD
    push esi
    push ecx
    pushf
    and esi, 0FFFF0000h
    mov ecx, 6

NextPage:
    call ValidPE
    .if eax == 1
        mov Base, esi
        popf
        pop ecx
        pop esi
        mov eax, Base
        ret
    .endif
    sub esi, 10000h
    loop NextPage

    popf
    pop ecx
    pop esi
    xor eax, eax
    ret
GetBase endp

GetKernelImport proc
    push esi
    push ebx
    push edi
    call AddrInModule
AddrInModule:
    mov esi, dword ptr[esp] ; Получаем адрес внутри текущего модуля
    add esp, 4
    and esi, 0FFFF0000h     ; Используем гранулярность памяти
ModuleBegin:
    call ValidPE
    .if eax == 0
        sub esi, 10000h
        jmp ModuleBegin
    .endif
    mov ebx, esi            ; Сохраняем базу текущего модуля
    assume esi: ptr IMAGE_DOS_HEADER
    add esi, [esi].e_lfanew ; Находим PE-заголовок

    assume esi: ptr IMAGE_NT_HEADERS
    lea esi, [esi].OptionalHeader

    assume esi: ptr IMAGE_OPTIONAL_HEADER
    lea esi, [esi].DataDirectory
    add esi, 8              ; К элементу массива с индексом 1
    mov eax, ebx
    add eax, dword ptr [esi]
    mov esi, eax            ; В esi - смещение таблицы импорта
    assume esi: ptr IMAGE_IMPORT_DESCRIPTOR
NextDLL:
    mov edi, [esi].Name1
    add edi, ebx
    .if dword ptr [edi] == "nrek"
        mov edi, [esi].FirstThunk
        add edi, ebx
        mov eax, dword ptr [edi]
        pop edi
        pop ebx
        pop esi
        ret
    .endif
    add esi, sizeof IMAGE_IMPORT_DESCRIPTOR
    jmp NextDLL
    
GetKernelImport endp

end start
