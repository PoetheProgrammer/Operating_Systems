[ORG 0x00]		; set startup address to 0x00
[BITS 16]		; use 16bit code

SECTION .text		; define .text section

jmp 0x07c0:START	; far-jump to START label with store the 0x07C0 into CS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	TEN OS Environment Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TOTALSECTORCOUNT:	dw	0x02	; TEN OS image size without bootloader(512byte)
								; TEN OS image can be maximum 1152 sectors(0x90000byte)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CODE AREA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START:
	mov ax, 0x07c0	; AX <- 0x07c0
	mov ds, ax		; DS <- AX(0x07c0)

	mov ax, 0xB800	; AX <- 0xB800
	mov es, ax		; ES <- AX(0xB800)

	; init stack (0x0000:0000~0x0000:FFFF, 64KiB)
	mov ax, 0x0000	; 
	mov ss, ax		; SS <- AX(0x0000)
	mov sp, 0xFFFE	;
	mov bp,	0xFFFE	;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	clear desktop, foreground - light green
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov si, 0

.SCREENCLEARLOOP:			; remove screen (80*28*2)
	mov byte [es:si], 0		; remove character
	mov byte [es:si + 1], 0x02	; see. table 4-2, on book1 (p.123)
					; set background:black 
					; set foreground:green

	add si, 2		; move next character position

	cmp si, 80*25*2		; si value will be size of screen

	jl .SCREENCLEARLOOP	; if si less than 80*25*2, clear next position.

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	Startup Message print
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	push MESSAGE1		; push PRINT message
	push 0				; Y point(0)
	push 0				; X point(0)
	call PRINTMESSAGE	; call PRINTMESSAGE
	add sp, 6			; remove input parameter

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	TEN OS image loading Message print
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	push IMAGELOADINGMESSAGE	;
	push 1						;
	push 0						;
	call PRINTMESSAGE			;
	add sp, 6

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	Loading TEN OS image from disk
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	Reset Floppy device before loading image
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RESETDISK:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	Call BIOS Reset Function
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; service num 0, drive num(0=Floppy)
	mov ax, 0
	mov dl, 0
	int 0x13
	;	error handling
	jc HANDLEDISKERROR

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	Read Sector from Disk
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; set the address(es:bx) that copied from disk into 0x10000
	mov si, 0x1000
	mov es, si
	mov bx, 0x0000
	mov di, word [TOTALSECTORCOUNT]

READDATA:
	cmp di, 0
	je READEND
	sub di, 0x1

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	Call BIOS Read Function
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ah, 0x02
	mov al, 0x1
	mov ch, byte [TRACKNUMBER]
	mov cl, byte [SECTORNUMBER]
	mov dh, byte [HEADNUMBER]
	mov dl, 0x00
	int 0x13
	jc HANDLEDISKERROR

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	add si, 0x0020
	mov es, si

	mov al, byte [SECTORNUMBER]
	add al, 0x01
	mov byte [SECTORNUMBER], al
	cmp al, 19
	jl READDATA

	xor byte [HEADNUMBER], 0x01
	mov byte [SECTORNUMBER], 0x01

	cmp byte [HEADNUMBER], 0x00
	jne READDATA

	add byte [TRACKNUMBER], 0x01
	jmp READDATA
READEND:

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	TEN OS image loading complete Message print
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	push LOADINGCOMPLETEMESSAGE
	push 1
	push 20
	call PRINTMESSAGE
	add sp, 6


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	Start TEN OS
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	jmp 0x1000:0x0000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;	Function Code Area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; handle disk error
HANDLEDISKERROR:
	push DISKERRORMESSAGE
	push 1
	push 20
	call PRINTMESSAGE

	jmp $

PRINTMESSAGE:
	push bp
	mov bp, sp

	push es
	push si
	push di
	push ax
	push cx
	push dx
	mov ax, 0xB800
	mov es, ax

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax, word [bp+6]
	mov si, 160
	mul si
	mov di, ax

	;
	mov ax, word [bp+4]
	mov si, 2
	mul si
	add di, ax

	;
	mov si, word[bp+8]

.MESSAGELOOP:
	mov cl, byte [si]	; set cl register to MESSAGE1 label
						;
						;
						;

	cmp cl, 0		; until cl == 0 (this mean, boot message is end with 0)
	je .MESSAGEEND

	mov byte [es:di], cl	; set character from MESSAGE1 label.

	add si, 1		; move next character of MESSAGE1
	add di, 2		; skip back/foreground character

	jmp .MESSAGELOOP

.MESSAGEEND:			; If we print all of MESSAGE1, we will be here.
	pop dx
	pop cx
	pop ax
	pop di
	pop si
	pop es
	pop bp
	ret

MESSAGE1:				db 'TEN OS Boot Loader Start~!!', 0	; BootLoader Message
DISKERRORMESSAGE:		db 'DISK Error~!!', 0
IMAGELOADINGMESSAGE:	db 'OS Image Loading...', 0
LOADINGCOMPLETEMESSAGE:	db 'Complete~!!',0

SECTORNUMBER:	db 0x02
HEADNUMBER:		db 0x00
TRACKNUMBER:	db 0x00

times 510 - ( $ - $$)	db 0x00	; $: current address
				; $$: start address of currect section(.text section)
				; $-$$: offset related by current section

dw 0xAA55		; bootloader magic number
