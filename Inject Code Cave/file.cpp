#include "file.h"

#include <iostream>
#include <stdexcept>

LPBYTE MapFile(const char* fileName)
{
	HANDLE hFile = CreateFile(fileName, GENERIC_READ | GENERIC_WRITE,
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE) {
		std::cout << "[-] Failed to open file" << std::endl;
		return NULL;
	}

	DWORD dwFileSize = GetFileSize(hFile, 0);
	if (!dwFileSize) {
		std::cout << "[-] Failed to get file size" << std::endl;
		CloseHandle(hFile);
		return NULL;
	}

	HANDLE hMapping = CreateFileMapping(hFile, NULL, PAGE_READWRITE, 0, dwFileSize, NULL);
	if (!hMapping) {
		std::cout << "[-] Failed to create file mapping" << std::endl;
		CloseHandle(hFile);
		return NULL;
	}

	LPBYTE lpView = (LPBYTE)MapViewOfFile(hMapping, FILE_MAP_ALL_ACCESS, 0, 0, dwFileSize);
	if (!lpView) {
		std::cout << "[-] MapViewOfFile failed" << std::endl;
		CloseHandle(hMapping);
		CloseHandle(hFile);
		return NULL;
	}

	CloseHandle(hMapping);
	CloseHandle(hFile);

	return lpView;
}