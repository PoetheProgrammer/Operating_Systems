#ifndef __TYPES_H__
#define __TYPES_H__

#define byte    unsigned char
#define word    unsigned short
#define dword   unsigned int
#define qword   unsigned long
#define bool    unsigned char

#define true    1
#define false   0
#define NULL    0

struct video_char_data {
    byte data;
    byte attr;
}__attribute__ ((packed));

#endif /*__TYPES_H__*/