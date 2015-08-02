.code16
.globl _start
_start:
/***
	Setup 16-bit Stack/Environment **/
	start:	xor %ax, %ax
		mov %ax, %ds
		mov %ax, %es
		mov 0x9000, %ax
		mov %ax, %ss
		mov 0xFFFF, %sp
/***
	Kill interupts and setup GDT **/
		cli
		cli				
		pusha				
		lgdt (gdtdesc)			
		sti				
		popa			
		ret
		
/***
	Setup 32 Bits/Protected Mode **/
		cli
		movl %cr0, %eax
		or 1, %eax
		movl %eax, %cr0
		
	/***
		Enter Protected Mode **/
		ljmp $0x8, $protected

/***
	The Evil GDT **/
gdt:
	NULLDescriptor:
		.word 0x0000
		.word 0x0000
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00

	CODEDescriptor:
		.word 0xFFFF
		.word 0x0000
		.byte 0x00
		.byte 0x9A
		.byte 0xCF
		.byte 0x00

	DATADescriptor:
		.word 0xFFFF
		.word 0x0000
		.byte 0x00
		.byte 0x92
		.byte 0xCF
		.byte 0x00
		
gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt

/***
	Boot Signature **/
. = ( _start + 510 )
.byte 0x55
.byte 0xaa

/***
	Protected Mode **/
	protected:
		movw $0x10, %ax
		movw %ax, %ds
		movw %ax, %ss
		movw %ax, %es
		movl $0x9000, %esp
	/***
		We Are Here, Finally **/
		movl $0xb800, %edi
		movl 'A', (%edi)
		movl $0x7, 1(%edi)
