PROG=		fire

all: ${PROG}

run: ${PROG}
	qemu-system-i386 -hda ${PROG}

${PROG}: ${PROG}.S
	gcc -o ${PROG}.o -c -nostdlib -Ttext 0 -m32 $<
	objcopy -O binary --only-section=.text ${PROG}.o ${PROG}

clean:
	rm -rf ${PROG}.o ${PROG}