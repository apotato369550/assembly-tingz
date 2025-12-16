; Two-row animation that wraps at middle and continues from middle of bottom
org 100h

mov ax, 0B800h
mov es, ax

mov bx, ' '          ; Space to clear previous position

main_loop:
    ; === LINE 1: Row 0, col 0 -> col 40, then row 24 col 40 -> col 80 ===
    mov si, 0            ; Start at row 0, col 0
    mov al, 'A'

    line1_top:
        mov [es:si], bx  ; Clear previous position first
        add si, 2
        mov [es:si], al  ; Draw at new position
        call delay
        cmp si, 80       ; Until middle (column 40 * 2 bytes)
        jl line1_top

    ; Jump to row 24 middle (24*160 + 80 = 3920)
    mov si, 3920

    line1_bottom:
        mov [es:si], bx  ; Clear previous position first
        add si, 2
        mov [es:si], al  ; Draw at new position
        call delay
        cmp si, 4000     ; End of row 24 (80 columns * 2)
        jl line1_bottom

    jmp main_loop    ; Loop forever

int 20h

delay:
    push cx
    mov cx, 0x4000   ; Delay counter

wait_loop:
    dec cx
    jnz wait_loop
    pop cx
    ret
