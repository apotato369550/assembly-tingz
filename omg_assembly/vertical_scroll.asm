mov ax, 0B800h
mov es, ax

mov bx, ' '
mov si, 0        ; Start at row 0

vertical_loop:
    ; Write "SCROLL" on first line
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

    ; Move to second line (160 bytes = one row)
    add si, 2
    add si, 160
    sub si, 12      ; Back to column 0 of next row

    ; Write "BOUNCE" on second line
    mov al, 'B'
    mov [es:si], al
    add si, 2
    mov al, 'O'
    mov [es:si], al
    add si, 2
    mov al, 'U'
    mov [es:si], al
    add si, 2
    mov al, 'N'
    mov [es:si], al
    add si, 2
    mov al, 'C'
    mov [es:si], al
    add si, 2
    mov al, 'E'
    mov [es:si], al

    call delay

    ; Erase first line (move back up)
    sub si, 148     ; Move to start of second line text
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

    ; Erase second line (6 chars)
    sub si, 160
    sub si, 12
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

    ; Move down by one row (160 bytes)
    add si, 160

    ; Check if we hit bottom (position > 3360 = near bottom of 25 rows)
    ; Each row is 160 bytes, so row 22 starts at 3520
    cmp si, 3520
    jle vertical_loop

    ; Wrap around to top
    mov si, 0
    jmp vertical_loop

int 20h

delay:
    mov cx, 0ffff

wait_loop:
    dec cx
    cmp cx, 0
    jne wait_loop
    ret
