mov ah 01h
int 21h

mov al 01h
int 21h

add ah al
mov dl al
int 20h