mov ax, 0B800h
mov es, ax

mov si, 0

mov al, 'J'
mov ah, 'A'
mov dl, 'Y'
mov bx, ' '

right:
    mov [es:si], al
    add si, 2
    mov [es:si], ah
    add si, 2
    mov [es:si], dl

    call delay

    mov [es:si], bx
    sub si, 2
    mov [es:si], bx
    sub si, 2

    cmp si, 154
    jle right

left:
    mov [es:si], bx
    sub si, 2
    mov [es:si], bx
    sub si, 2
    mov [es:si], bx

    mov [es:si], al
    add si, 2
    mov [es:si], ah
    add si, 2
    mov [es:si], dl

    call delay

    cmp si, 4
    jge left

jmp right

int 20h

delay:
    mov cx, 0ffff

wait_loop:
    dec cx
    cmp cx, 0
    jne wait_loop
    ret
