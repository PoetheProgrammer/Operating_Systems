#include "types.h"

void kprint_string(int x, int y, const char *str);

void main()
{
	kprint_string(0, 3, "Protected Mode C Language Kernel Started!!!");

	while (1);
}

void kprint_string(int x, int y, const char *str)
{
	int i;
	struct video_char_data *video_mem_addr = (struct video_char_data *)0xB8000;

	//calculate the position to print string
	video_mem_addr = video_mem_addr + (y * 80) + x;

	//print string
	for (i = 0; str[i] != '\0'; i++) {
		video_mem_addr[i].data = str[i];
	}
}