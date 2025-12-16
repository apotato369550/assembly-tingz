; Scans entire screen and replaces 'COM' or 'com' with 'HIS'
org 100h

mov ax, 0B800h
mov es, ax          ; ES points to video memory

mov si, 0           ; Start at beginning of video memory

scan_loop:
    ; Check if we've reached end of screen (80 cols x 25 rows x 2 bytes = 4000)
    cmp si, 4000
    jge done

    ; Get current character
    mov al, [es:si]

    ; Check for 'C' or 'c'
    cmp al, 'C'
    je check_om_upper
    cmp al, 'c'
    je check_om_lower

    ; Not a match, move to next character (skip attribute byte)
    add si, 2
    jmp scan_loop

check_om_upper:
    ; Check if next char is 'O'
    mov al, [es:si+2]
    cmp al, 'O'
    jne next_char

    ; Check if third char is 'M'
    mov al, [es:si+4]
    cmp al, 'M'
    jne next_char

    ; Found "COM" - replace with "HIS"
    mov byte [es:si], 'H'
    mov byte [es:si+2], 'I'
    mov byte [es:si+4], 'S'

    ; Skip past the replaced word
    add si, 6
    jmp scan_loop

check_om_lower:
    ; Check if next char is 'o'
    mov al, [es:si+2]
    cmp al, 'o'
    jne next_char

    ; Check if third char is 'm'
    mov al, [es:si+4]
    cmp al, 'm'
    jne next_char

    ; Found "com" - replace with "HIS"
    mov byte [es:si], 'H'
    mov byte [es:si+2], 'I'
    mov byte [es:si+4], 'S'

    ; Skip past the replaced word
    add si, 6
    jmp scan_loop

next_char:
    ; Move to next character
    add si, 2
    jmp scan_loop

done:
    int 20h
