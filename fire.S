#define MBR_SECTOR_SIZE 0x200
#define MBR_START 	0x1B8
#define MBR_MAGIC_POS	MBR_SECTOR_SIZE - 2

#define VGA_SEGMENT	0xA000

		.text
		.code16
		.global start
start:
	xor  %ax, 		%ax
	movw %ax, 		%ss
	movw $0x7a00,   	%sp
	movw $VGA_SEGMENT,	%ax
	movw %ax,		%es
	movw %ax, 		%ds

	jmp  $0x07c0,		$vga_mode

# 320x200 G mode
vga_mode:
	xor %ax, 	%ax
	mov $0x13, 	%al
	int $0x10

init:
	std
	movw $320, 	%cx
	movw $320*200-1,%di
	movb $0x2c, 	%al
	rep stosb

	movl $0xB19B00B5,	%edx
	movw $1, 	 	%bx
fire:
	movw $320,		%cx
	imul %bx, 		%cx
	movw $320*199-1, 	%di
        movw $320*200-1, 	%si

fire_loop:
	push 			%si
	imull $1103515245,	%edx
        addl  $12345,		%edx

	movw %dx, %ax
	andw $1,  %ax
	addw %ax, %si

	lodsb
	pop %si
	dec %si

	cmp $0x21, %al
	jge ok

	xor %ax, %ax
	stosb
	jmp skip
ok:
	andb $1,  %dh
	subb %dh, %al
	shr  $16, %edx

	stosb

skip:	loop fire_loop

	cmp $199, %bx
	jz skip_inc
	inc %bx
skip_inc:
	jmp fire

.org MBR_START
.org MBR_MAGIC_POS
	.word 0xaa55