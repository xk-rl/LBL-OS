; OS starts at 0x7C00
org 0x7C00
bits 16

main:
	hlt
.hlt
	jmp .hlt

times 510-($-$$) db 0
dw 0AA55h
