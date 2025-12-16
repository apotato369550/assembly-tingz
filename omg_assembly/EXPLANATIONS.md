# Assembly Programs: String Processing & Vertical Scrolling

## Program 1: string_reverse_vowel_remover.asm

### Overview
This program takes a user input string, reverses it, and removes all vowels (A, E, I, O, U in both cases), then displays the result.

### How It Works

#### Step 1: Input
- Uses DOS interrupt **INT 21h with AH=0Ah** (buffered keyboard input)
- Accepts up to 100 characters from the user
- The buffer stores the length byte first, followed by the actual characters

#### Step 2: Calculate String Length
```asm
find_length:
    mov al, [input_buffer + si]
    cmp al, 13              ; CR (carriage return) marks end
    je length_found
    inc cx                  ; CX holds the length
    inc si
    jmp find_length
```
- Scans through the input buffer until it finds ASCII 13 (carriage return)
- Counts the actual characters in the string
- CR is inserted automatically by DOS when the user presses Enter

#### Step 3: Reverse the String
```asm
reverse_loop:
    mov al, [input_buffer + di + 1]   ; Read from end (di is decremented)
    mov [reversed_buffer + si], al     ; Write to start (si is incremented)
    inc si
    dec di
    jmp reverse_loop
```
- Reads characters from the end of the input string backwards
- Writes them to `reversed_buffer` from start to end
- Result: String is reversed

#### Step 4: Remove Vowels
```asm
vowel_loop:
    mov al, [reversed_buffer + si]
    cmp al, 'A'      ; Check for each vowel
    je skip_char     ; Skip if it's a vowel
    ; ... more vowel checks ...
    mov [no_vowels_buffer + di], al   ; Keep if not a vowel
    inc di
```
- Iterates through the reversed string
- Checks if each character is a vowel (A, E, I, O, U, a, e, i, o, u)
- Only writes non-vowel characters to `no_vowels_buffer`

#### Step 5: Display Result
- Uses **INT 21h with AH=09h** to display the processed string
- The string must be terminated with '$' character

### Example
```
Input:  "HELLO"
Step 1: Reversed → "OLLEH"
Step 2: Remove vowels (O, E) → "LLH"
Output: "LLH"
```

### Key Registers
- **SI**: Source index (reading from strings)
- **DI**: Destination index (writing to strings)
- **CX**: Counter for string length
- **AL**: Character buffer for comparisons
- **AH**: Function selector for DOS interrupts
- **DX**: Pointer to strings/buffers

### Data Buffers
- `input_buffer` (100 bytes): Raw user input
- `reversed_buffer` (100 bytes): String after reversal
- `no_vowels_buffer` (100 bytes): Final result without vowels

---

## Program 2: vertical_scroll.asm

### Overview
Similar to `rotation_screen.asm`, but displays text on 2 lines and scrolls them vertically (up and down) instead of horizontally. The text "SCROLL" and "BOUNCE" animate down the screen and wrap to the top.

### How It Works

#### Video Memory Layout
- DOS text mode uses segment **0B800h** for video memory
- Screen is **80 columns × 25 rows**
- Each character uses **2 bytes**: character code + color attribute
- Each row uses **160 bytes** (80 columns × 2 bytes)

#### Positioning Formula
```
Offset = (Row × 160) + (Column × 2)
```

#### Step 1: Set Video Segment
```asm
mov ax, 0B800h
mov es, ax        ; ES = video segment
```
- Points to video memory where text appears on screen

#### Step 2: Write Text on Two Lines
```asm
; Write "SCROLL" on line 1 (SI = 0)
mov al, 'S'
mov [es:si], al
add si, 2         ; Move to next character position
; ... repeat for C, R, O, L, L ...

; Move to line 2
add si, 160       ; Move down one row
; Write "BOUNCE" on line 2
```
- Characters are written 2 bytes apart (character + color attribute)
- Moving to the next line adds 160 bytes (one full row)

#### Step 3: Erase Previous Text
```asm
mov [es:si], bx   ; BX contains space character
add si, 2
; ... repeat for all characters ...
```
- Overwrites previous positions with space character
- Creates the scrolling animation effect

#### Step 4: Move Down and Wrap
```asm
add si, 160       ; Move down one row
cmp si, 3520      ; Check if near bottom (row 22)
jle vertical_loop ; Continue if not at bottom
mov si, 0         ; Wrap to top
```
- Each iteration moves text down by one row (160 bytes)
- When text reaches row 22 (position 3520), it wraps back to row 0
- Creates a bouncing/wrapping effect

#### Step 5: Delay
```asm
delay:
    mov cx, 0ffff     ; Large counter (65535)
    wait_loop:
    dec cx            ; Decrement
    cmp cx, 0         ; Check if done
    jne wait_loop
    ret
```
- Countdown loop to create visible animation
- Without delay, scrolling would be too fast to see

### Visual Example
```
Frame 1:  SCROLL    (row 0)
          BOUNCE    (row 1)

Frame 2:
          SCROLL    (row 1)
          BOUNCE    (row 2)

... continues until ...

Frame N:
          BOUNCE    (row 23)
          [wraps]   (row 0) - SCROLL returns to top
```

### Key Differences from rotation_screen.asm
| Aspect | rotation_screen.asm | vertical_scroll.asm |
|--------|-------------------|-------------------|
| Direction | Left to right (horizontal) | Top to bottom (vertical) |
| Lines | Single line | Two lines |
| Increment | +2 bytes per position | +160 bytes per row |
| Wrapping | At column 154 | At row 22 |
| Text | "SCROLL" only | "SCROLL" and "BOUNCE" |

### Key Registers
- **AX**: Segment address (0B800h)
- **ES**: Extra segment (points to video memory)
- **SI**: Current position offset in video memory
- **AL**: Character being written
- **BX**: Space character for erasing
- **CX**: Counter for delay loop

### How to Run
1. Assemble with: `nasm vertical_scroll.asm -o vertical_scroll.com` (or your preferred assembler)
2. Run in DOSBox: `dosbox vertical_scroll.com`
3. Watch "SCROLL" and "BOUNCE" scroll down and wrap to the top continuously
4. Press Ctrl+C to stop

---

## Comparison: Both Programs

| Feature | string_reverse_vowel_remover | vertical_scroll |
|---------|------------------------------|-----------------|
| Input | User keyboard input | Hardcoded text |
| Output | Text display + processing | Direct video memory |
| Interrupts | INT 21h (DOS I/O) | Direct memory access |
| Complexity | String manipulation | Video memory control |
| Skill Demo | Buffer management, string operations | Direct hardware access, animation |
