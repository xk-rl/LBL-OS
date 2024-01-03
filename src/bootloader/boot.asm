; OS starts at 0x7C00
org 0x7C00
bits 16				; assembler should use 16 bits

%define NEXL 0x0D, 0x0A		; define NEXL as next line for strings

;
; FAT12 HEADER
;
jmp short start
nop

bdb_oem:			db 'MSWIN4.1'	; 8 bytes
bdb_bytes_per_sector:		dw 512
bdb_sectors_per_cluster:	db 1
bdb_reserved_sectors:		dw 1
bdb_fat_count:			db 2
bdb_dir_entry_count:		dw 0E0h
bdb_total_sectors:		dw 2880		; 2880 * 512 = 1.44Mb
bdb_media_descriptor_type:	db 0F0h		; F0 = 3.5" Floppy disk
bdb_sectors_per_fat:		dw 9		; 9 Sectors Fat
bdb_sectors_per_track:		dw 18
bdb_head:			dw 2
bdb_hidden_sectors:		dd 0
bdb_large_sector_count:		dd 0

;
; Extended Boot Record
;
ebr_drive_number:		db 0		; 0x00 = floppy, 0x80 = hdd, useless actually
				db 0		; reserved
ebr_signature:			db 29h
ebr_volume_id:			db 12h, 34h, 56h 78h ; Volume ID, not needed, can be anything
ebr_volume_label:		db 'LBL OS FLOD' ; 11 bytes, padded with spaces!!!
ebr_system_id:			db 'FAT12   '	; 8 bytes, padded with spaces!!!

;
; Code
;

; instantly jump to main, to avoid any loaded instructions which are made before the
; main label itself
start:
	jmp main

; print
; param:
;	ds:si, point to string, until 0 char is hit
echo:
	; put registers which we want to modify
	push si
	push ax

.loop:
	lodsb			; load next character in al
	or al, al		; check if next character is null
	jz .done		; jump if zero flag is met

	mov ah, 0x0e		; print to tty interrupt
	mov bh, 0		; set page number to zero
	int 0x10		; call bios interrupt for video mode

	jmp .loop		; else loop

.done:
	; remove the registers which we modified
	pop ax
	pop si
	ret

read:
	push bx
	push ax

	mov ah, 0x0
	int 0x16

	cmp al, 8
	je .backspace

	cmp al, 13
	je .enter
	
	inc bx

	mov ah, 0x0e
	mov bh, 0
	int 0x10
	
	jmp read

.enter:
	mov bx, 0
	mov si, empty
	call echo
	mov si, wd
	call echo

.backspace:
	cmp bx, 0
	je read

	dec bx
	
	mov ah, 0x0e
	mov bh, 0
	int 0x10

	mov al, 32
	mov ah, 0x0e
	mov bh, 0
	int 0x10

	mov al, 8
	mov ah, 0x0e
	mov bh, 0
	int 0x10

	jmp read

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

	mov si, booting
	call echo
	mov si, wd
	call echo
	mov bx, 0
	call read


	hlt

booting: db 'Booting...', NEXL, 0

.hlt:
 	jmp .hlt		; make our cpu halt loop if no task is given

wd: db 'LBL - # ', 0
empty: db '', NEXL, 0

; fill the end of the disk with AA 55 for the bios signature
times 510-($-$$) db 0
dw 0AA55h
