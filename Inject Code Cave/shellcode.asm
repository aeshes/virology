format binary
use32

start:
    pushad
    call get_delta_offset
get_delta_offset:
    pop ebp
    sub ebp, get_delta_offset
    lea eax, [ebp + dllPath]
    push eax
    mov eax, 0EEEEEEEEh
    call eax
    popad
    push 0EEEEEEEEh
    retn

dllPath:
    db "C:\windows\system32\pe.dll", 0