global long_mode_start
extern kernel_main

section .text
bits 64
long_mode_start:
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    ; load a bunch of registers so allt he cpu instructions will function correctly

    ;mov dword [0xb8000], 0x2f4b2f4f ;move the OK string in hex to the video memory, which is fix
    ;hlt ;order the cpu to freeze and not to read and run more instructions
    call kernel_main
    hlt
