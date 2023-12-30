; OS starts at 0x7C00
org 0x7C00
bits 16

%define NEXL 0x0D, 0x0A

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
	int 0x10

	jmp .loop		; else loop

.done:
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
	mov sp, 0x7C00

	;print Hello World
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
	jmp .hlt

msg_1: db ' __________________________', NEXL, 0
msg_2: db '/                          \', NEXL, 0
msg_3: db '| Welcome to LBL OS!       |', NEXL, 0
msg_4: db '| An open source operating |', NEXL, 0
msg_5: db '| system made by xk-rl,    |', NEXL, 0
msg_6: db '| Have fun using it.       |', NEXL, 0
msg_7: db '| _________________________/', NEXL, 0
msg_8: db '|/', NEXL, 0

times 510-($-$$) db 0
dw 0AA55h
