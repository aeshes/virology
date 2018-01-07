.586p
.model flat, stdcall

option prologue:none
option epilogue:none
option casemap:none

include    windows.inc
includelib kernel32.lib

extrn ExitProcess@4 : proc

.data
	limit equ 5
	db 0
	Kernel32Limit dw limit
	
.code
main:  call delta
delta: pop ebp
	   sub ebp, offset delta
	
	   mov esi, [esp]
	   and esi, 0FFFF0000h
	   call GetKernel32
	
	   push 00000000h
	   call ExitProcess@4
	
CheckPE proto

GetKernel32 proc
	.while byte ptr [ebp + Kernel32Limit] != 00h
		assume esi: ptr IMAGE_DOS_HEADER
		.if [esi].e_magic == "ZM"
			invoke CheckPE
			.if eax != 0
				ret
			.endif
		.endif
		sub esi, 10000h
		dec byte ptr[ebp + Kernel32Limit]
	.endw
	ret
GetKernel32 endp

CheckPE proc
	assume esi: ptr IMAGE_DOS_HEADER
	mov edi, [esi].e_lfanew
	add edi, esi
	
	assume edi: ptr IMAGE_NT_HEADERS
	.if [edi].Signature == IMAGE_NT_SIGNATURE
		xchg eax, esi
	.else
		xor eax, eax
	.endif
	ret
CheckPE endp

end main