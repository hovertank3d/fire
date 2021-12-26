; fire.asm -- fire simulation in x86 real mode
; `nasm fire.asm -f bin -o fire.bin`
[bits 16]
[org 0x7c00]

jmp init

%include "rand.inc"

init:
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov sp, 0x9E00
	mov ax, 0xA000
	mov es, ax 
	mov ax, 0x7000
	mov gs, ax

	xor ah, ah
	mov al, 0x13
	int 0x10 ; set video mode to 0x13
	
init_fire:
	xor di, di
.fire_space:
	mov byte gs:[di], 0

	inc di
	cmp di, 320*199
	jnz .fire_space
.fire_origin:
	mov byte gs:[di], 31

	inc di
	cmp di, 320*200
	jnz .fire_origin

fire_loop:
	mov di, 320
.do_fire:
	call spread_fire
	inc di
	cmp di, 320*200
	jnz .do_fire

	xor di, di
.render:
	movzx bx, gs:[di]
	mov al, byte [palette + bx]
	stosb

	cmp di, 320*200
        jnz .render

	jmp fire_loop

spread_fire:
	call rand 
	xor dx, dx
	mov bx, 3
	div bx
	
	and dx, 1
	
	mov al, byte gs:[di]
	
	cmp al, 0
	jz .skip_if_zero

	sub al, dl	

.skip_if_zero:
	push di
	sub di, dx
	inc di
	sub di, 320
	mov byte gs:[di], al

	pop di
	ret

palette db 0x00, 0xB8, 0xB8, 0xB9, 0xB9, 0x70, 0x06, 0x06, 0x28, 0x28, 0x29, 0x29, 0x27, 0x27, 0x2A, 0x2A, 0x2B, 0x2B, 0x2C, 0x2C, 0x0E, 0x0E, 0x43, 0x43, 0x44, 0x44, 0x45, 0x45, 0x5E, 0x5D, 0x5C, 0x0F  

times 510-($-$$) db 0
dw 0xAA55
