# jay_bounce.asm - Bouncing "JAY" Animation

This program makes the word "JAY" bounce back and forth across the top line of the screen.

## Video Memory Setup
```asm
mov ax, 0B800h
mov es, ax
```
- **0B800h** = Starting address of text mode video memory in DOS
- **ES register** = Extra Segment, used to point to video memory
- We can't load 0B800h directly into ES, so we use AX as an intermediate step

## Initial Position
```asm
mov si, 0
```
- **SI register** = Source Index, used as our screen position counter
- **0** = Top-left corner of the screen
- Video memory uses even offsets (0, 2, 4...) for characters

## Character Storage
```asm
mov al, 'J'
mov ah, 'A'
mov dl, 'Y'
mov bx, ' '
```
- **AL, AH, DL** = Three 8-bit registers to hold our three letters
- **BX** = Holds a space character to erase characters as we move
- These registers were chosen because they're available and won't interfere with SI

## Moving Right
```asm
right:
    mov [es:si], al      ; Put 'J' at current position
    add si, 2            ; Move 2 bytes right (next character slot)
    mov [es:si], ah      ; Put 'A'
    add si, 2
    mov [es:si], dl      ; Put 'Y'
```
- **[es:si]** = Memory location at ES:SI (video memory position)
- **add si, 2** = Each character takes 2 bytes (1 for char, 1 for color attribute)

```asm
    call delay           ; Pause so we can see the animation
```

```asm
    mov [es:si], bx      ; Erase the 'Y'
    sub si, 2            ; Move back
    mov [es:si], bx      ; Erase the 'A'
    sub si, 2            ; Move back
```
- Clear the trailing characters so it looks like "JAY" is moving

```asm
    cmp si, 154          ; Compare position to near the right edge
    jle right            ; If less than or equal, keep going right
```
- **154** = Position near the right edge (80 columns × 2 bytes - some space for "JAY")
- **jle** = Jump if Less than or Equal

## Moving Left
```asm
left:
    mov [es:si], bx      ; Erase all three characters first
    sub si, 2
    mov [es:si], bx
    sub si, 2
    mov [es:si], bx

    mov [es:si], al      ; Write 'J', 'A', 'Y' again
    add si, 2
    mov [es:si], ah
    add si, 2
    mov [es:si], dl

    call delay

    cmp si, 4            ; Compare to near the left edge
    jge left             ; If greater than or equal, keep going left
```
- **jge** = Jump if Greater than or Equal
- When we hit the left edge, we fall through to...

```asm
jmp right                ; Jump back to moving right (loop forever)
```

## Delay Subroutine
```asm
delay:
    mov cx, 0ffff        ; Load counter with max value (65535)

wait_loop:
    dec cx               ; Decrease counter by 1
    cmp cx, 0            ; Check if we hit zero
    jne wait_loop        ; If not zero, keep looping
    ret                  ; Return to caller
```
- **CX register** = Counter register, perfect for loops
- **0ffff** = 65535 iterations = visible delay
- This creates a pause so the animation is visible to human eyes
