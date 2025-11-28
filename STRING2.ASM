
jmp start
STRING DB 'This is a sample string', '$'

start:
 LEA si,STRING 
 mov di,0
 mov es, 0b800

retrieve_print:
 mov ah, b[ds:si]
 mov b[es:di], ah
 inc si
 add di, 2
 cmp  ah, '$'
 jne retrieve_print



int 020
