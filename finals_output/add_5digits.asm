; Display "Enter first 5-digit number: $"
mov ah, 09h
mov dx, offset msg1
int 21h

; Read first number into array
mov ah, 0Ah
mov dx, offset input1_buffer
int 21h

; Display "Enter second 5-digit number: $"
mov ah, 09h
mov dx, offset msg2
int 21h

; Read second number into array
mov ah, 0Ah
mov dx, offset input2_buffer
int 21h

; Convert and add
mov al, [input1_buffer + 2]
sub al, '0'
mov bl, 10
mul bl
mov cx, ax

mov al, [input1_buffer + 3]
sub al, '0'
add cx, ax

mov al, [input2_buffer + 2]
sub al, '0'
mov bl, 10
mul bl
add cx, ax

mov al, [input2_buffer + 3]
sub al, '0'
add cx, ax

; Display result
mov ah, 09h
mov dx, offset msg3
int 21h

; Convert sum to ASCII and display
mov ax, cx
mov bl, 10
div bl
mov dl, al
add dl, '0'
mov ah, 02h
int 21h

mov dl, ah
add dl, '0'
mov ah, 02h
int 21h

int 20h

msg1 db "Enter first 5-digit number: $"
input1_buffer db 6, 0, 0, 0, 0, 0, 0
msg2 db 13, 10, "Enter second 5-digit number: $"
input2_buffer db 6, 0, 0, 0, 0, 0, 0
msg3 db 13, 10, "Sum: $"
