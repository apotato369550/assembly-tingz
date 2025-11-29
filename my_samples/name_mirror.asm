mov ax, 0B800h
mov es, ax

mov si, 0

; Write "John Andre Yap" on the left
mov al, 'J'
mov [es:si], al
add si, 2
mov al, 'o'
mov [es:si], al
add si, 2
mov al, 'h'
mov [es:si], al
add si, 2
mov al, 'n'
mov [es:si], al
add si, 2
mov al, ' '
mov [es:si], al
add si, 2
mov al, 'A'
mov [es:si], al
add si, 2
mov al, 'n'
mov [es:si], al
add si, 2
mov al, 'd'
mov [es:si], al
add si, 2
mov al, 'r'
mov [es:si], al
add si, 2
mov al, 'e'
mov [es:si], al
add si, 2
mov al, ' '
mov [es:si], al
add si, 2
mov al, 'Y'
mov [es:si], al
add si, 2
mov al, 'a'
mov [es:si], al
add si, 2
mov al, 'p'
mov [es:si], al

; Start from right side (position 158 = last column)
mov si, 158

; Write "paY erdnA nhoJ" on the right
mov al, 'p'
mov [es:si], al
sub si, 2
mov al, 'a'
mov [es:si], al
sub si, 2
mov al, 'Y'
mov [es:si], al
sub si, 2
mov al, ' '
mov [es:si], al
sub si, 2
mov al, 'e'
mov [es:si], al
sub si, 2
mov al, 'r'
mov [es:si], al
sub si, 2
mov al, 'd'
mov [es:si], al
sub si, 2
mov al, 'n'
mov [es:si], al
sub si, 2
mov al, 'A'
mov [es:si], al
sub si, 2
mov al, ' '
mov [es:si], al
sub si, 2
mov al, 'n'
mov [es:si], al
sub si, 2
mov al, 'h'
mov [es:si], al
sub si, 2
mov al, 'o'
mov [es:si], al
sub si, 2
mov al, 'J'
mov [es:si], al

int 20h
