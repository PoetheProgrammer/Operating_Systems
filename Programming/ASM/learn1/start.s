/*
	See Like comments are cool
*/
.section .data

.section .text
	.global _start
	_start:	movl $1, %eax
		movl $1, %ebx
		int $0x80
		

