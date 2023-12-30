; OS starts at 0x7C00
org 0x7C00
bits 16				; assembler should use 16 bits

%define NEXL 0x0D, 0x0A		; define NEXL as next line for strings

; instantly jump to main because out is made before main
start:
	jmp main

; print
; param:
;	ds:si, point to string, until 0 char is hit
out:
	; put registers which we want to modify
	push si
	push ax

.loop:
	lodsb			; load next character in al
	or al, al		; check if next character is null
	jz .done		; jump if zero flag is met

	mov ah, 0x0e		; call bios interrupt
	mov bh, 0		; set page number to zero
	int 0x10		; call bios interrupt for video

	jmp .loop		; else loop

.done:
	; remove the registers which we modified
	pop ax
	pop si
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
	call out
	mov si, msg_2
	call out
	mov si, msg_3
	call out
	mov si, msg_4
	call out
	mov si, msg_5
	call out
	mov si, msg_6
	call out
	mov si, msg_7
	call out
	mov si, msg_8
	call out
	
	hlt
.hlt
	jmp .hlt		; make our cpu halt loop if no task is given

msg_1: db ' __________________________', NEXL, 0
msg_2: db '/                          \', NEXL, 0
msg_3: db '| Welcome to LBL OS!       |', NEXL, 0
msg_4: db '| An open source operating |', NEXL, 0
msg_5: db '| system made by xk-rl,    |', NEXL, 0
msg_6: db '| Have fun using it.       |', NEXL, 0
msg_7: db '| _________________________/', NEXL, 0
msg_8: db '|/', NEXL, 0

; fill the end of the disk with AA 55 for the bios signature
times 510-($-$$) db 0
dw 0AA55h
