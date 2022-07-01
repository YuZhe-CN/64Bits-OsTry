global start

section .text
bits 32         ; the ISA is in 32bits at the begining
start:
    ;print 'OK' on the screen
    mov dword [0xb8000], 0x2f4b2f4f ;move the OK string in hex to the video memory, which is fix
    hlt ;order the cpu to freeze and not to read and run more instructions

