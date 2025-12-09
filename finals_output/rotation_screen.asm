mov ax, 0B800h
mov es, ax

mov bx, ' '
mov si, 0

rotate_loop:
    ; Write "SCROLL" at current position
    mov al, 'S'
    mov [es:si], al
    add si, 2
    mov al, 'C'
    mov [es:si], al
    add si, 2
    mov al, 'R'
    mov [es:si], al
    add si, 2
    mov al, 'O'
    mov [es:si], al
    add si, 2
    mov al, 'L'
    mov [es:si], al
    add si, 2
    mov al, 'L'
    mov [es:si], al

    call delay

    ; Erase the text
    sub si, 10
    mov [es:si], bx
    add si, 2
    mov [es:si], bx
    add si, 2
    mov [es:si], bx
    add si, 2
    mov [es:si], bx
    add si, 2
    mov [es:si], bx
    add si, 2
    mov [es:si], bx

    ; Move position right by 2 bytes
    add si, 2

    ; Check if we hit the right edge (position 154 = near right edge)
    cmp si, 154
    jle rotate_loop

    ; Wrap around to left
    mov si, 0
    jmp rotate_loop

int 20h

delay:
    mov cx, 0ffff

wait_loop:
    dec cx
    cmp cx, 0
    jne wait_loop
    ret
