.586p
.model flat, stdcall

option prologue:none
option epilogue:none
option casemap:none

include    windows.inc
includelib kernel32.lib

extrn ExitProcess@4 : proc
	
.code
main:  call delta
delta: pop ebp
	   sub ebp, offset delta
	
	   call GetKernel32
	
	   push 00000000h
	   call ExitProcess@4
	
CheckPE proto

GetKernel32 proc
	assume fs:nothing
	mov esi, fs:[30h]		; Get the address of PEB
	mov esi, [esi + 0Ch]	; Get PEB->Ldr
	mov esi, [esi+ 1Ch]		; Get PEB->Ldr.InInitializationOrderModuleList.Flink (1st module)
	lodsd					; Get the 2nd module
	mov esi, eax			
	lodsd					; Get the third module
	mov eax, [eax + 08h]	; Get the 3rd entries base address (kernel32.dll)
	ret
GetKernel32 endp

CheckPE proc
	mov edi, [esi].IMAGE_DOS_HEADER.e_lfanew
	add edi, esi
	
	xor eax, eax
	.if [edi].IMAGE_NT_HEADERS.Signature == IMAGE_NT_SIGNATURE
		xchg eax, esi
	.endif
	
	ret
CheckPE endp

end main