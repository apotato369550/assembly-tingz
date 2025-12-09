# screen_mirroring.asm - Screen Mirroring Display

This program displays text on the left side of the screen and its horizontal mirror on the right side.

## Video Memory Setup
```asm
mov ax, 0B800h
mov es, ax
```
- **0B800h** = Text mode video memory address in DOS
- **ES register** = Extra Segment register for video memory access
- Uses AX as intermediate since we can't load directly into ES

## Left Side Display
```asm
mov si, 0
mov al, 'H'
mov [es:si], al
add si, 2
...
```
- **SI register** = Source Index, tracks screen position
- **0** = Top-left corner
- **[es:si]** = Write character to video memory
- **add si, 2** = Move to next character position (each char is 2 bytes)

Pattern: "HELLO WORLD" written left to right at position 0

## Right Side Display (Mirrored)
```asm
mov si, 158
mov al, 'D'
mov [es:si], al
sub si, 2
...
```
- **158** = Last column position (80 columns × 2 bytes - 2)
- **sub si, 2** = Move LEFT instead of right (creates mirror effect)
- Characters written in reverse order: "DLROW OLLEH"

## Result
The screen shows:
- Left: `HELLO WORLD`
- Right: `DLROW OLLEH` (mirror image)

## Program Exit
```asm
int 20h
```
- DOS interrupt to terminate the program
