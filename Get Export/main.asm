.586p
.model flat, stdcall
option casemap:none

include    windows.inc
includelib kernel32.lib

extrn ExitProcess@4 : proc

.data
	kernel    dd 0
	pe_header dd 0
	hello     db "hello", 0
	
.code
main:
	call get_kernel32_peb
	mov kernel, eax
	
	call get_pe_header
	mov pe_header, eax
	
	call get_export
	
	mov esi, offset hello
	call get_name_length
	
	push 00000000h
	call ExitProcess@4
	
	
get_kernel32_peb:
	assume fs:nothing
	mov esi, fs:[30h]		; Get the address of PEB
	
	mov esi, [esi + 0Ch]	; Get PEB->Ldr
	mov esi, [esi+ 1Ch]		; Get PEB->Ldr.InInitializationOrderModuleList.Flink (1st module)
	lodsd					; Get the 2nd module
	mov esi, eax			
	lodsd					; Get the third module
	mov eax, [eax + 08h]	; Get the 3rd entries base address (kernel32.dll)
	
	ret

get_pe_header:
	mov esi, kernel	; kernel contains base address of kernel32
	
	mov esi, [esi].IMAGE_DOS_HEADER.e_lfanew
	add esi, eax
	mov eax, esi
	
	ret

get_export:
	push ebx
	
	mov ebx, pe_header
	lea eax, [ebx + 78h]
	mov eax, [eax].IMAGE_DATA_DIRECTORY.VirtualAddress
	add eax, kernel
	
	pop ebx
	
	ret
	
get_name_length:
	push edx
	push esi
	
	mov edx, esi
	.while byte ptr [esi]
		inc esi
	.endw
	sub esi, edx
	mov eax, esi
	
	pop esi
	pop edx
	
	ret

end main