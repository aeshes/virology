.586p
.model flat, stdcall

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
	
GetKernel32:
one:
	cmp byte ptr [ebp + Kernel32Limit], 00h
	jz WeFailed
	
	cmp word ptr [esi], "ZM"
	jz CheckPE
two:
	sub esi, 10000h
	dec byte ptr [ebp + Kernel32Limit]
	jmp one
	
CheckPE:
	mov edi, [esi + 3Ch]		; e_lfanew
	add edi, esi			; RVA of PE header
	cmp dword ptr [edi], "EP"	; Seek for PE signature
	jz WeGotKernel32
	jmp two
WeFailed:
	mov esi, 0BFF70000h
WeGotKernel32:
	xchg eax, esi
	ret
end main