# rotation_screen.asm - Screen Content Rotation

This program displays text that rotates across the screen horizontally, moving right until it reaches the right edge, then wrapping back to the left.

## Video Memory Setup
```asm
mov ax, 0B800h
mov es, ax
mov bx, ' '
mov si, 0
```
- **0B800h** = Text mode video memory
- **ES register** = Segment register for video memory
- **BX** = Space character used to erase text
- **SI** = Current position on screen, starts at 0 (left side)

## Main Rotation Loop
```asm
rotate_loop:
    mov al, 'S'
    mov [es:si], al
    add si, 2
    ...
```
- Writes "SCROLL" at current SI position
- Each **add si, 2** moves to the next character slot
- Characters written horizontally

## Erase Previous Text
```asm
sub si, 10
mov [es:si], bx
add si, 2
mov [es:si], bx
...
```
- **sub si, 10** = Back up 10 bytes (6 characters × 2 bytes - 2)
- Writes space characters to erase the "SCROLL" text
- Clearing makes it look like the text is moving, not duplicating

## Movement
```asm
add si, 2
cmp si, 154
jle rotate_loop
```
- **add si, 2** = Move position 2 bytes right (one character position)
- **cmp si, 154** = Check if reached right edge
- **jle rotate_loop** = Continue if not at edge

## Wrapping
```asm
cmp si, 154
jle rotate_loop
mov si, 0
jmp rotate_loop
```
- When SI exceeds 154 (right edge), reset to 0 (left side)
- Text wraps around and continues indefinitely

## Delay Function
```asm
delay:
    mov cx, 0ffff
wait_loop:
    dec cx
    cmp cx, 0
    jne wait_loop
    ret
```
- Creates visible animation speed
- Countdown loop with 65535 iterations

## Result
Text "SCROLL" moves smoothly from left to right, then wraps back to left, creating a continuous rotation effect.
