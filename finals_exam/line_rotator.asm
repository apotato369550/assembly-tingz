mov ax, 0B800h
mov es, ax

mov si, 0

mov al, 'X'
mov bx, ' '
mov dx, 2

line1:
    mov [es:si], bx
    add si, 2
    mov [es:si], al

    call delay

    cmp si, 158
    jle line1

add si, 158
mov [es:si], al

line2:
    mov [es:si], bx
    sub si, 2
    mov [es:si], al

    call delay

    cmp si, 158
    jne line2


int 20h

delay:
    mov cx, 0ffff

wait_loop:
    dec cx

    cmp cx, 0
    jne wait_loop
    ret