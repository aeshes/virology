.586p
.model flat, stdcall

option prologue:none
option epilogue:none
option casemap:none

include    windows.inc
includelib kernel32.lib

extrn ExitProcess@4 : proc

.data
	kernel dd 0
	
.code
main:
	call get_kernel32_peb
	mov kernel, eax
	
	call get_pe_header
	call get_export
	
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

; ASSUME: eax containg virtual address of PE header
get_export:
	lea eax, [eax + 78h]
	mov eax, [eax]
	
	ret

end main