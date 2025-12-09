mov ax, 0B800h
mov es, ax

; Display welcome message
mov ah, 09h
mov dx, offset welcome_msg
int 21h

paint_loop:
    ; Display prompt
    mov ah, 09h
    mov dx, offset prompt_msg
    int 21h

    ; Read X coordinate
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    ; Read Y coordinate
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al

    ; Calculate video memory offset
    ; Offset = (Y * 80 * 2) + (X * 2)
    mov ax, 0
    mov al, bh
    mov cl, 160
    mul cl
    mov cx, ax
    mov al, bl
    mov bh, 0
    add al, bl
    add cx, ax
    add cx, ax

    mov si, cx

    ; Paint a colored character at position
    mov al, '*'
    mov [es:si], al
    inc si
    mov al, 0Fh
    mov [es:si], al

    ; Ask if continue
    mov ah, 09h
    mov dx, offset continue_msg
    int 21h

    mov ah, 01h
    int 21h

    cmp al, 'y'
    je paint_loop
    cmp al, 'Y'
    je paint_loop

int 20h

welcome_msg db 13, 10, "=== PAINT PROGRAM ===", 13, 10
            db "Paint colored pixels on screen!", 13, 10
            db "Enter single digit coordinates (0-9)", 13, 10, "$"

prompt_msg db 13, 10, "Enter X (0-9), then Y (0-9): $"

continue_msg db 13, 10, "Paint another? (y/n): $"
