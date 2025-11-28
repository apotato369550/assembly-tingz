
jmp start
msg db "hello world $"

start:
	mov dx, offset msg
	mov ah, 9
	int 21h




int 20h