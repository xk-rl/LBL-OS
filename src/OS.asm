; OS starts at 0x7C00
org 0x7C00
bits 16				; assembler should use 16 bits

%define NEXL 0x0D, 0x0A		; define NEXL as next line for strings

; instantly jump to main, to avoid any loaded instructions which are made before the
; main label itself
start:
	jmp main

; print
; param:
;	ds:si, point to string, until 0 char is hit
echo:
	; put registers which we want to modify
	push bx
	push si
	push ax

.loop:
	lodsb			; load next character in al
	or al, al		; check if next character is null
	jz .done		; jump if zero flag is met

	mov ah, 0x0e		; print to tty interrupt
	mov bh, 0		; set page number to zero
	int 0x10		; call bios interrupt for video mode

	; someone please fix these weird characters with colored text

	mov ah, 0x9		; change color of character
	mov bh, 0		; page number
	mov cx, 1		; amount of time to repeat the character
	int 0x10		; call bio interrupt for video mode

	jmp .loop		; else loop

.done:
	; remove the registers which we modified
	pop ax
	pop si
	pop bx
	ret

main:
	; setup data segments
	mov ax, 0
	mov dx, ax
	mov es, ax

	; setup stack
	mov ss, ax
	mov sp, 0x7C00		; stack position should be before the operating
				; system or otherwise it will override the entire
				; system

	;load the starter message
	mov si, msg_1		; si register is where the string should be stored
	mov bl, 000Ch		; color
	call echo
	mov si, msg_2
	mov bl, 000Ch
	call echo
	mov si, msg_3
	mov bl, 000Ch
	call echo
	mov si, msg_4
	mov bl, 000Ch
	call echo
	mov si, msg_5
	mov bl, 000Ch
	call echo
	mov si, msg_6
	mov bl, 000Ch
	call echo
	mov si, msg_7
	mov bl, 000Ch
	call echo
	mov si, msg_8
	mov bl, 000Ch
	call echo
	
	mov ah, 0x00
    	int 16h

	hlt
.hlt
	jmp .hlt		; make our cpu halt loop if no task is given

msg_1: db '  __________________________  ', NEXL, 0
msg_2: db ' /                          \ ', NEXL, 0
msg_3: db ' | Welcome to LBL OS!       | ', NEXL, 0
msg_4: db ' | An open source operating | ', NEXL, 0
msg_5: db ' | system made by xk-rl,    | ', NEXL, 0
msg_6: db ' | Have fun using it.       | ', NEXL, 0
msg_7: db ' | _________________________/ ', NEXL, 0
msg_8: db ' |/ 				 ', NEXL, 0

; fill the end of the disk with AA 55 for the bios signature
times 510-($-$$) db 0
dw 0AA55h
