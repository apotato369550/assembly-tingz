# add_5digits.asm - Add 5-Digit Numbers

This program prompts the user to enter two 5-digit numbers, adds them together, and displays the sum.

## Display First Prompt
```asm
mov ah, 09h
mov dx, offset msg1
int 21h
```
- **AH=09h** = DOS function to display string
- **DX** = Pointer to string ending with '$'
- **INT 21h** = DOS interrupt for I/O operations
- Displays "Enter first 5-digit number: "

## Read First Number
```asm
mov ah, 0Ah
mov dx, offset input1_buffer
int 21h
```
- **AH=0Ah** = DOS function for buffered keyboard input
- **input1_buffer** = Array to store user input
- First byte = max size (6), second = actual input length, rest = characters

## Display Second Prompt
```asm
mov ah, 09h
mov dx, offset msg2
int 21h
```
- Similar to first prompt
- Includes line feed (13, 10) for newline
- Displays "Enter second 5-digit number: "

## Read Second Number
```asm
mov ah, 0Ah
mov dx, offset input2_buffer
int 21h
```
- Same as first number read
- Stores in separate buffer (input2_buffer)

## Convert and Add
```asm
mov al, [input1_buffer + 2]
sub al, '0'
mov bl, 10
mul bl
mov cx, ax
```
- **input1_buffer + 2** = Start of actual input (skip length bytes)
- **sub al, '0'** = Convert ASCII digit to numeric value
- **mul bl** = Multiply by 10 (using BL register)
- **CX** = Accumulator for sum

Repeats for remaining digits and second number, adding all values to CX

## Display Result
```asm
mov ah, 09h
mov dx, offset msg3
int 21h
```
- Displays "Sum: "

## Convert Sum to ASCII
```asm
mov ax, cx
mov bl, 10
div bl
mov dl, al
add dl, '0'
mov ah, 02h
int 21h
```
- **AX = CX** = Move sum into AX
- **div bl** = Divide by 10 (quotient in AL, remainder in AH)
- **add dl, '0'** = Convert numeric digit to ASCII
- **AH=02h** = Display single character
- Displays tens digit first, then ones digit

## Data Section
```asm
msg1 db "Enter first 5-digit number: $"
input1_buffer db 6, 0, 0, 0, 0, 0, 0
msg2 db 13, 10, "Enter second 5-digit number: $"
input2_buffer db 6, 0, 0, 0, 0, 0, 0
msg3 db 13, 10, "Sum: $"
```
- Strings terminated with '$' for DOS display function
- Input buffers: [max_size, actual_length, char1, char2, ...]
- 13, 10 = Carriage return and line feed
