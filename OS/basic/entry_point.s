[ORG 0x00]
[BITS 16]

SECTION .text

;
START:
	mov ax, 0x1000

	mov ds, ax
	mov es, ax

	cli
	lgdt [ GDTR ]

	;
	mov eax, 0x4000003B
	mov cr0, eax

	jmp dword 0x08: ( PROTECTEDMODE - $$ + 0x10000 )

;
[BITS 32]
PROTECTEDMODE:
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	;
	mov ss, ax
	mov esp, 0xFFFE
	mov ebp, 0xFFFE

	;
	push ( SWITCHSUCCESSMESSAGE - $$ + 0x10000 )
	push 2
	push 0
	call PRINTMESSAGE

	add esp, 12

	jmp dword 0x08:0x10200

;
PRINTMESSAGE:
	push ebp
	mov ebp, esp

	push esi
	push edi
	push eax
	push ecx
	push edx

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, dword [ ebp + 12 ]
	mov esi, 160
	mul esi
	mov edi, eax

	;
	mov eax, dword [ ebp + 8 ]
	mov esi, 2
	mul esi
	add edi, eax

	;
	mov esi, dword [ ebp + 16 ]

.MESSAGELOOP:
	mov cl, byte [ esi ]	; set cl register to MESSAGE1 label
							;
							;
							;

	cmp cl, 0		; until cl == 0 (this mean, boot message is end with 0)
	je .MESSAGEEND

	mov byte [ edi + 0xB8000 ], cl	; set character from MESSAGE1 label.

	add esi, 1		; move next character of MESSAGE1
	add edi, 2		; skip back/foreground character

	jmp .MESSAGELOOP

.MESSAGEEND:			; If we print all of MESSAGE1, we will be here.
	pop edx
	pop ecx
	pop eax
	pop edi
	pop esi
	pop ebp
	ret

;
align 8, db 0

dw 0x0000

GDTR:
	dw GDTEND - GDT - 1
	dd ( GDT - $$ + 0x10000 )

;
GDT:
	NULLDescriptor:
		dw 0x0000
		dw 0x0000
		db 0x00
		db 0x00
		db 0x00
		db 0x00

	CODEDescriptor:
		dw 0xFFFF
		dw 0x0000
		db 0x00
		db 0x9A
		db 0xCF
		db 0x00

	DATADescriptor:
		dw 0xFFFF
		dw 0x0000
		db 0x00
		db 0x92
		db 0xCF
		db 0x00
GDTEND:

SWITCHSUCCESSMESSAGE: db 'Switch To Protected Mode Success~!!', 0

times 512 - ( $ - $$ ) db 0x00