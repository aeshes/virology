#include "pe.h"

constexpr PIMAGE_SECTION_HEADER FIRST_SECTION(LPBYTE lpView)
{
	return PIMAGE_SECTION_HEADER((DWORD)lpView +
		PIMAGE_DOS_HEADER(lpView)->e_lfanew +
		sizeof(IMAGE_NT_HEADERS));
}

PEInfo ParsePE(LPBYTE lpView)
{
	PIMAGE_DOS_HEADER pDosHeader = (PIMAGE_DOS_HEADER)lpView;
	if (pDosHeader->e_magic != IMAGE_DOS_SIGNATURE)
		throw std::runtime_error("Incorrect PE file: wrong DOS signature");

	PIMAGE_NT_HEADERS pNtHeaders = PIMAGE_NT_HEADERS((DWORD)lpView + pDosHeader->e_lfanew);
	if (pNtHeaders->Signature != IMAGE_NT_SIGNATURE)
		throw std::runtime_error("Incorrect PE file: wrong PE signature");

	PIMAGE_SECTION_HEADER pSectionHeader = FIRST_SECTION(lpView);
	pSectionHeader += (pNtHeaders->FileHeader.NumberOfSections - 1);

	DWORD oepRva = pNtHeaders->OptionalHeader.AddressOfEntryPoint;

	return PEInfo{
		pDosHeader,
		pNtHeaders,
		pSectionHeader,
		oepRva
	};
}