.586p
.model flat, stdcall

option prologue:none
option epilogue:none

includelib kernel32.lib

extrn ExitProcess@4 : proc

.data
	limit equ 5
	db 0
	Kernel32Limit dw limit
	
.code
main:
	call delta
delta:
	pop ebp
	sub ebp, offset delta
	
	mov esi, [esp]
	and esi, 0FFFF0000h
	call GetKernel32
	
	push 00000000h
	call ExitProcess@4
	
CheckPE proto

GetKernel32 proc
	.while byte ptr [ebp + Kernel32Limit] != 00h
		.if word ptr[esi] == "ZM"
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
	mov edi, [esi + 3Ch]
	add edi, esi
	.if dword ptr[edi] == "EP"
		xchg eax, esi
	.else
		xor eax, eax
	.endif
	ret
CheckPE endp

end main