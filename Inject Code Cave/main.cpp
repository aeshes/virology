#include <windows.h>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include "file.h"
#include "pe.h"
#include "ld.h"
#include "shellcode.h"


int main()
{
	const unsigned char* src = shellcode;

	while (unsigned length = disasm(src)) {
		std::cout << "OP length: " << length << std::endl;
		src += length;
	}

	std::ofstream out("dump.bin");

	unsigned char mov_l[] = { 0x00, 0xDA };
	mov_l[0] = BITMASK8(1, 0, 0, 0, 1, 0, 1, 1);

	unsigned char mov_r[] = { 0x00, 0xDA };
	mov_r[0] = BITMASK8(1, 0, 0, 0, 1, 0, 0, 1);

	out.write((const char *)mov_l, 2);
	out.write((const char *)mov_r, 2);
	out.close();

	return 0;
}