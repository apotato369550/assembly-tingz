; Data section
input_buffer db 100 dup(0)      ; Buffer for input string
reversed_buffer db 100 dup(0)   ; Buffer for reversed string
no_vowels_buffer db 100 dup(0)  ; Buffer for vowel-removed string
prompt db "Enter a string: $"
result_msg db 13,10,"Result: $"

start:
    ; Display prompt
    lea dx, [prompt]
    mov ah, 09h
    int 21h

    ; Read input string
    lea dx, [input_buffer]
    mov ah, 0Ah
    mov byte [input_buffer], 100  ; Max length 100
    int 21h

    ; Get actual length of input (skip the length byte)
    mov si, 1                       ; SI points to start of string
    xor cx, cx                      ; CX will hold string length

find_length:
    mov al, [input_buffer + si]
    cmp al, 13                      ; CR marks end
    je length_found
    inc cx
    inc si
    jmp find_length

length_found:
    ; CX now has actual string length
    ; SI points to end of string
    ; Now reverse the string into reversed_buffer
    mov si, 0
    mov di, cx
    dec di                          ; DI points to last position

reverse_loop:
    cmp di, 0
    jl reverse_done

    mov al, [input_buffer + di + 1] ; +1 to skip length byte
    mov [reversed_buffer + si], al

    inc si
    dec di
    jmp reverse_loop

reverse_done:
    mov byte [reversed_buffer + si], '$' ; Null-terminate

    ; Now remove vowels from reversed_buffer and put in no_vowels_buffer
    mov si, 0                       ; SI reads from reversed_buffer
    mov di, 0                       ; DI writes to no_vowels_buffer

vowel_loop:
    mov al, [reversed_buffer + si]
    cmp al, '$'                     ; End of string
    je vowel_done

    ; Check if vowel
    cmp al, 'A'
    je skip_char
    cmp al, 'E'
    je skip_char
    cmp al, 'I'
    je skip_char
    cmp al, 'O'
    je skip_char
    cmp al, 'U'
    je skip_char
    cmp al, 'a'
    je skip_char
    cmp al, 'e'
    je skip_char
    cmp al, 'i'
    je skip_char
    cmp al, 'o'
    je skip_char
    cmp al, 'u'
    je skip_char

    ; Not a vowel, keep it
    mov [no_vowels_buffer + di], al
    inc di

skip_char:
    inc si
    jmp vowel_loop

vowel_done:
    mov byte [no_vowels_buffer + di], '$' ; Null-terminate

    ; Display result message
    lea dx, [result_msg]
    mov ah, 09h
    int 21h

    ; Display the final result
    lea dx, [no_vowels_buffer]
    mov ah, 09h
    int 21h

    ; New line before exit
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h

    int 20h
