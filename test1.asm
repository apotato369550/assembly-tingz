org 100h

mov ax, 0b800H
mov ds, ax

mov si, 0
mov dl, 'A'
mov b[ds:si], dl

mov si, 2
mov dl, 'B'
mov b[ds:si], dl

ret


