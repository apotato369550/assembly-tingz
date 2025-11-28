
 mov ds,cs
 mov dx, offset buffer
 mov ah, 0ah
 int 21h
 
jmp print
 buffer db 30 dup('$')
 
print:
 MOV AH, 02H
 MOV BH, 00H ; page no
 MOV DH, 12 ; row
 MOV DL, 30 ; column
 INT 10H




 mov dx, offset buffer+2
 mov ah, 9
 int 21h


 int 020