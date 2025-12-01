# x86 Assembly Cheat Sheet (DOS/8086)
*Based on analysis of all samples in this repository*

---

## REGISTERS

### General Purpose
| Register | Size | Primary Uses |
|----------|------|--------------|
| **AX** | 16-bit | Accumulator; arithmetic ops; video memory setup |
| **AL** | 8-bit | Lower AX; character I/O; video memory writes |
| **AH** | 8-bit | Upper AX; DOS interrupt function codes |
| **BX** | 16-bit | Base register; counters; temp storage |
| **CX** | 16-bit | Counter register; loop iterations; delay timers |
| **DX** | 16-bit | Data register; string offsets; cursor position |
| **DL** | 8-bit | Lower DX; character output; cursor column |
| **DH** | 8-bit | Upper DX; cursor row |

### Index & Pointer Registers
| Register | Purpose |
|----------|---------|
| **SI** | Source index; string operations; video memory offset |
| **DI** | Destination index; string operations; offset counter |

### Segment Registers
| Register | Purpose | Common Value |
|----------|---------|--------------|
| **CS** | Code segment | Current code location |
| **DS** | Data segment | Data access (often set to CS) |
| **ES** | Extra segment | Video memory (0B800h) |

---

## CORE INSTRUCTIONS

### Data Movement
```asm
mov dest, source    ; Copy data (register/memory/immediate)
lea reg, memory     ; Load effective address (pointer)
```

### Arithmetic
```asm
add dest, source    ; Addition (often for pointer arithmetic)
sub dest, source    ; Subtraction (often for pointer arithmetic)
inc dest            ; Increment by 1
dec dest            ; Decrement by 1
```

### Control Flow
```asm
jmp label          ; Unconditional jump
call label         ; Call subroutine (push return address)
ret                ; Return from subroutine

cmp val1, val2     ; Compare (sets flags)
jne label          ; Jump if not equal (ZF=0)
jle label          ; Jump if less/equal (ZF=1 or SF≠OF)
jge label          ; Jump if greater/equal (SF=OF)
```

### System
```asm
int number         ; Software interrupt (DOS/BIOS calls)
```

---

## DOS INTERRUPTS (INT 21h)

### Character I/O
```asm
; Read single character
mov ah, 01h        ; Function: read character
int 21h            ; Returns: AL = character

; Write single character
mov ah, 02h        ; Function: write character
mov dl, 'A'        ; DL = character to output
int 21h

; Display string (ends with '$')
mov dx, offset msg ; DX = pointer to string
mov ah, 09h        ; Function: display string
int 21h
```

### Buffered Input
```asm
mov ah, 0Ah        ; Function: buffered input
mov dx, offset buf ; DX = buffer address
int 21h
```

### Program Termination
```asm
int 20h            ; Exit program (older method)
; OR
mov ah, 4Ch        ; Function: exit with return code
mov al, 0          ; Return code (0 = success)
int 21h
```

---

## BIOS INTERRUPTS (INT 10h)

### Video Services
```asm
; Set cursor position
mov ah, 02h        ; Function: set cursor
mov bh, 0          ; Page number (usually 0)
mov dh, 10         ; Row (0-24)
mov dl, 20         ; Column (0-79)
int 10h
```

---

## DIRECT VIDEO MEMORY ACCESS

### Setup
```asm
mov ax, 0B800h     ; Video memory segment (text mode)
mov es, ax         ; Load into ES
mov si, 0          ; Offset (position)
```

### Character Positioning
- **Each position = 2 bytes** (character + attribute)
- Even offsets (0, 2, 4...) = character
- Odd offsets (1, 3, 5...) = attribute
- **Move right**: `add si, 2`
- **Move left**: `sub si, 2`
- **Next row**: `add si, 160` (80 columns × 2)

### Writing Characters
```asm
mov al, 'A'        ; Character to write
mov [es:si], al    ; Write to video memory
add si, 2          ; Move to next position
```

---

## COMMON PATTERNS

### 1. Skip Data Section
```asm
jmp start          ; Jump over data

msg db "Hello$"    ; Data declarations

start:             ; Code starts here
    mov dx, offset msg
    mov ah, 09h
    int 21h
    int 20h
```

### 2. Character Echo (Read + Write)
```asm
mov ah, 1          ; Read character
int 21h            ; Input in AL

mov ah, 2          ; Write character
mov dl, al         ; Move character to DL
int 21h            ; Output
```

### 3. String Output Loop
```asm
lea si, string     ; Load string address

loop_start:
    mov ah, b[ds:si]   ; Load character
    cmp ah, '$'        ; Check terminator
    je done            ; Exit if done

    ; Process character...

    inc si             ; Next character
    jmp loop_start
done:
```

### 4. Delay Loop
```asm
delay:
    mov cx, 0FFFFh     ; Large counter
wait_loop:
    dec cx             ; Decrement
    cmp cx, 0          ; Check zero
    jne wait_loop      ; Continue if not zero
    ret
```

### 5. Animation Loop (Bounded)
```asm
mov si, 0              ; Start position
animate:
    mov [es:si], al    ; Write character
    call delay         ; Wait
    mov [es:si], ' '   ; Clear (write space)
    add si, 2          ; Next position
    cmp si, 160        ; End of line?
    jle animate        ; Continue if in bounds
```

### 6. String Declaration
```asm
; DOS string (INT 21h, AH=09h)
msg db "Hello World$"

; Buffer allocation
buffer db 30 dup('$')  ; 30 bytes, all '$'
```

### 7. Memory Access Patterns
```asm
mov b[ds:si], al       ; Write byte to data segment
mov ah, b[ds:si]       ; Read byte from data segment
mov [es:si], al        ; Write to extra segment (video)
```

---

## PROGRAM STRUCTURE

### COM File (.com)
```asm
org 100h           ; COM files start at offset 100h

jmp start          ; Skip data

; Data section
msg db "text$"

start:
    ; Initialize segments if needed
    mov ax, cs
    mov ds, ax     ; DS = CS

    ; Your code here

    int 20h        ; Exit
```

### Basic Template
```asm
; 1. Set origin
org 100h

; 2. Jump over data
jmp start

; 3. Data declarations
message db "Hello$"

; 4. Code
start:
    ; Setup (if needed)
    mov ax, 0B800h
    mov es, ax

    ; Main logic
    mov ah, 09h
    mov dx, offset message
    int 21h

    ; Exit
    int 20h
```

---

## QUICK REFERENCE

### Segment Setup
```asm
mov ds, cs         ; Data segment = code segment
mov ax, 0B800h     ; Video memory
mov es, ax
```

### Address Loading
```asm
lea dx, string     ; Modern method
mov dx, offset msg ; Alternative method
```

### String Terminators
- DOS functions (INT 21h/09h): **'$'**
- C-style: **null (0)**

### Video Memory Layout
- Segment: **0B800h**
- Size: **80 columns × 25 rows = 4000 bytes**
- Position formula: `offset = (row × 160) + (col × 2)`

### Common Immediate Values
```asm
0FFFFh             ; Max delay counter
0B800h             ; Video memory segment
100h               ; COM file origin
' '                ; Space character (clear)
'$'                ; String terminator
```

---

## DEBUGGING TIPS

1. **Segment Errors**: Ensure ES=0B800h for video, DS=CS for data
2. **String Not Showing**: Check for '$' terminator
3. **Cursor Issues**: Remember BH=0, DH=row, DL=column
4. **Offset By 1**: Video memory uses 2 bytes per position
5. **Loop Infinite**: Verify loop counter/condition updates

---

## FILE ASSEMBLY & EXECUTION

```bash
# Assemble
nasm -f bin file.asm -o file.com

# Run
dosbox file.com

# Or use the assemble script
assemble file.asm              # Builds and runs
assemble file.asm --no-run     # Just builds
```

---

*Generated from: input.asm, input2.asm, INPUT3.ASM, string.asm, STRING2.ASM, test1.asm, jay_bounce.asm, name_mirror.asm, gigi_sample.asm*
