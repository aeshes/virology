#include "ld.h"

const static unsigned int prefix_t[128] = {
	// Group 1 prefixes
	0xF0,	// Lock-prefix
	0xF2,	// repne prefix
	0xF3	// repe
};

unsigned int disasm(const unsigned char* opcode) {

	switch (*opcode) {
	case 0x60: case 0x5D: case 0x50:
	case 0x51: case 0xC3:
		return 1;
	case 0xFF:
		return 2;
	case 0x83: case 0x8D:
		return 3;
	case 0xE8: case 0xB8: case 0x68:
		return 5;
	default:
		return 0;
	}
}