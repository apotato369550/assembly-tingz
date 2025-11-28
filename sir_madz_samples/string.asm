jmp start
STRING DB 'This is a sample string', '$'

start:
 LEA DX,STRING 


 MOV AH,09H
 INT 21H 


int 020
