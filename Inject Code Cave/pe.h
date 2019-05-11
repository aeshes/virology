#pragma once

#include <windows.h>
#include <stdexcept>
#include "file.h"

struct PEInfo
{
	PIMAGE_DOS_HEADER pDosHeader;
	PIMAGE_NT_HEADERS pNtHeaders;
	PIMAGE_SECTION_HEADER pLastSection;
	DWORD EntryPoint;
};

PEInfo ParsePE(LPBYTE lpView);