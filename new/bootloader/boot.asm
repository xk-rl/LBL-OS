org 0x7C00			; define startpoint for the Assembler as the OS start
bits 16				; tell the Assembler to use 16 bits for the boot

start:				; start label
	mov ah, 0eh		; video Teltype Output
	mov al, 'W'		; character to print
	mov bh, 0		; set page number for Teltype
	int 0x10		; bios video interrupt

	jmp $

; writing bios signature
times 510-($-$$) db 0
dw 0xAA55
