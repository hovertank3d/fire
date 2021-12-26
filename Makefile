ASM:=nasm
QEMU?=qemu-system-i386
all:
	${ASM} fire.asm -f bin -o fire
run: all
	${QEMU} -hda fire
clean:
	rm fire
