mov ax, 0B800h
mov es, ax

mov si, 0

; Write "HELLO WORLD" on the left side
mov al, 'H'
mov [es:si], al
add si, 2
mov al, 'E'
mov [es:si], al
add si, 2
mov al, 'L'
mov [es:si], al
add si, 2
mov al, 'L'
mov [es:si], al
add si, 2
mov al, 'O'
mov [es:si], al
add si, 2
mov al, ' '
mov [es:si], al
add si, 2
mov al, 'W'
mov [es:si], al
add si, 2
mov al, 'O'
mov [es:si], al
add si, 2
mov al, 'R'
mov [es:si], al
add si, 2
mov al, 'L'
mov [es:si], al
add si, 2
mov al, 'D'
mov [es:si], al

; Start from right side (position 158 = last column)
mov si, 158

; Write "DLROW OLLEH" on the right (mirrored)
mov al, 'D'
mov [es:si], al
sub si, 2
mov al, 'L'
mov [es:si], al
sub si, 2
mov al, 'R'
mov [es:si], al
sub si, 2
mov al, 'O'
mov [es:si], al
sub si, 2
mov al, 'W'
mov [es:si], al
sub si, 2
mov al, ' '
mov [es:si], al
sub si, 2
mov al, 'O'
mov [es:si], al
sub si, 2
mov al, 'L'
mov [es:si], al
sub si, 2
mov al, 'L'
mov [es:si], al
sub si, 2
mov al, 'E'
mov [es:si], al
sub si, 2
mov al, 'H'
mov [es:si], al

int 20h
