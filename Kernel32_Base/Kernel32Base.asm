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
end start
