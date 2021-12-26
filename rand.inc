; rand.inc


_seed dw 61665, 13104, 38555, 5791

rand:
	mov ax, word[_seed]
	add ax, word[_seed+1]
	add ax, word[_seed+2]
	add ax, word[_seed+3]
seed:
	mov bx, word[_seed+1]
	mov word[_seed], bx
	mov bx, word[_seed+2]
	mov word[_seed+1], bx
	mov bx, word[_seed+3]
	mov word[_seed+2], bx
	mov word[_seed+3], ax
	ret
