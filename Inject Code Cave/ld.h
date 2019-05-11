#pragma once

#define BITMASK8(b7, b6, b5, b4, b3, b2, b1, b0)				\
(																\
	(b0 << 0x00) | (b1 << 0x01) | (b2 << 0x02) | (b3 << 0x03) | \
	(b4 << 0x04) | (b5 << 0x05) | (b6 << 0x06) | (b7 << 0x07)	\
)

unsigned int disasm(const unsigned char* opcode);