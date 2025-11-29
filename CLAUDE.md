# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a learning repository for x86 assembly language programming targeting DOS/8086 architecture. The code is organized into sample directories containing various assembly programs demonstrating different concepts.

## Assembly Language Context

All `.asm` files in this repository are written for 8086/DOS environment and use:
- **Syntax**: Intel syntax (destination, source)
- **Target Platform**: DOS (16-bit real mode)
- **Common Conventions**:
  - `org 100h` indicates COM executable format
  - DOS interrupts (INT 21h for I/O, INT 20h for program termination, INT 10h for video services)
  - Video memory at 0B800h (text mode)
  - String terminator: '$' character for DOS string functions

## Repository Structure

```
assembly-tingz/
├── sir_madz_samples/    # Primary teaching samples (from instructor)
├── other_samples/       # Additional reference code
└── my_samples/          # User's personal practice code
```

### Sample Categories

**sir_madz_samples/**: Contains foundational examples including:
- Character I/O (input.asm, input2.asm)
- String operations (string.asm, STRING2.ASM)
- Direct video memory manipulation (test1.asm, INPUT3.ASM)

**other_samples/**: Additional examples like animation/graphics (gigi_sample.asm)

## Common Assembly Patterns in This Codebase

### DOS Interrupt Patterns
- **AH=01h, INT 21h**: Read character from stdin
- **AH=02h, INT 21h**: Write character in DL to stdout
- **AH=09h, INT 21h**: Display string (DX points to '$'-terminated string)
- **AH=0Ah, INT 21h**: Buffered keyboard input
- **INT 20h**: Terminate program (older DOS convention)
- **AH=02h, INT 10h**: Set cursor position (BH=page, DH=row, DL=column)

### Direct Video Memory Access
Programs frequently write directly to video memory at segment 0B800h:
- Characters at even offsets (0, 2, 4...)
- Attributes at odd offsets (1, 3, 5...)
- Screen is 80 columns × 25 rows = 4000 bytes

### Code Structure Patterns
Many samples use this pattern:
```asm
jmp start
; data section here
msg db "string$"

start:
; code here
int 20h
```

## Development Workflow

### Assembling and Running
Since this targets DOS/8086, code is typically:
1. Assembled using a DOS-compatible assembler (MASM, TASM, or emu8086)
2. Run in DOSBox or emu8086 emulator
3. Output format: `.com` files (excluded from git via .gitignore)

Note: DOSBox is available on the system (`/usr/bin/dosbox`)

### File Naming
- Samples use both lowercase (.asm) and uppercase (.ASM) extensions
- All files use CRLF line endings (DOS convention)

## When Working with Assembly Code

- Preserve the DOS interrupt calling conventions (register usage for AH, DX, etc.)
- Maintain $ string terminators for DOS string functions
- Keep segment register initialization (DS, ES) when working with data or video memory
- Remember that SI/DI often used for string operations, BX/CX for counters
- Delays typically use countdown loops (CX register)
