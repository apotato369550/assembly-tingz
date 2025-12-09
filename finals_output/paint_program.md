# paint_program.asm - Interactive Paint Program

This program allows the user to paint colored pixels on the screen by entering X and Y coordinates.

## Video Memory Setup
```asm
mov ax, 0B800h
mov es, ax
```
- **0B800h** = Text mode video memory
- **ES register** = Segment for video memory access

## Welcome Message
```asm
mov ah, 09h
mov dx, offset welcome_msg
int 21h
```
- **AH=09h** = DOS function to display string
- Displays program title and instructions
- Shows coordinate range (0-9) for simplicity

## Main Paint Loop
```asm
paint_loop:
    mov ah, 09h
    mov dx, offset prompt_msg
    int 21h
```
- Continuously prompts for coordinates
- Allows multiple paint operations

## Read X Coordinate
```asm
mov ah, 01h
int 21h
sub al, '0'
mov bl, al
```
- **AH=01h** = DOS function to read single character
- **sub al, '0'** = Convert ASCII digit to numeric value
- **BL register** = Stores X coordinate

## Read Y Coordinate
```asm
mov ah, 01h
int 21h
sub al, '0'
mov bh, al
```
- Similar to X coordinate
- **BH register** = Stores Y coordinate

## Calculate Video Memory Offset
```asm
mov ax, 0
mov al, bh
mov cl, 160
mul cl
mov cx, ax
mov al, bl
add al, bl
add cx, ax
add cx, ax
```
- Video memory: 2 bytes per character
- Screen width: 80 characters = 160 bytes per line
- **Offset = (Y × 160) + (X × 2)**
- **CX register** = Final offset in video memory
- **SI register** = Set to offset for writing

## Paint the Pixel
```asm
mov al, '*'
mov [es:si], al
inc si
mov al, 0Fh
mov [es:si], al
```
- **'*'** = Visible character to paint
- **[es:si]** = Character position in video memory
- **inc si** = Move to attribute byte
- **0Fh** = Color attribute (bright white)

## Continue Prompt
```asm
mov ah, 01h
int 21h
cmp al, 'y'
je paint_loop
cmp al, 'Y'
je paint_loop
```
- Asks if user wants to paint another pixel
- Loops back to paint_loop if 'y' or 'Y' entered
- Exits if any other key pressed

## Result
User can paint colored '*' characters at any coordinate pair (0-9, 0-9) on the screen. Multiple pixels can be painted to create patterns.
