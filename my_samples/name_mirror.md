# name_mirror.asm - Mirrored Name Display

This program displays "John Andre Yap" on the left side of the screen and its mirror "paY erdnA nhoJ" on the right side.

## Video Memory Setup
```asm
mov ax, 0B800h
mov es, ax
```
- **0B800h** = Text mode video memory address in DOS
- **ES register** = Extra Segment register, points to video memory
- AX is used as an intermediate because we can't load directly into ES

## Starting Position
```asm
mov si, 0
```
- **SI register** = Source Index, tracks our position in video memory
- **0** = Top-left corner of screen
- Each character position is 2 bytes apart (character + color attribute)

## Writing the Normal Name (Left Side)
```asm
mov al, 'J'
mov [es:si], al
add si, 2
mov al, 'o'
mov [es:si], al
add si, 2
...
```
- **AL register** = 8-bit register used to temporarily hold each character
- **[es:si]** = Memory address in video memory where we write
- **add si, 2** = Move to next character position (skip the color byte)
- Each character is loaded into AL, written to screen, then SI moves forward

Pattern repeats for: J-o-h-n- -A-n-d-r-e- -Y-a-p (14 characters total)

## Repositioning to Right Side
```asm
mov si, 158
```
- **158** = Last column position on screen
- The screen is 80 columns wide, each taking 2 bytes: (80 - 1) × 2 = 158
- We start from the rightmost position and work backwards

## Writing the Mirrored Name (Right Side)
```asm
mov al, 'p'
mov [es:si], al
sub si, 2
mov al, 'a'
mov [es:si], al
sub si, 2
...
```
- **sub si, 2** = Move LEFT instead of right (subtract instead of add)
- We write the name backwards: p-a-Y- -e-r-d-n-A- -n-h-o-J
- This creates the mirror effect on the right side

## Program Termination
```asm
int 20h
```
- **INT 20h** = DOS interrupt to terminate the program
- This is the older DOS way to exit a program

## Why These Registers?
- **SI** = Natural choice for memory indexing
- **AL** = 8-bit register, perfect for single characters
- **ES** = Segment register required for video memory access
- **AX** = Only way to load values into segment registers like ES
