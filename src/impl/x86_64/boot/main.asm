global start

section .text
bits 32         ; the ISA is in 32bits at the begining
start:

    mov esp, stack_top ;asign to esp the address of the top of the stack, as at this point there is no stack frame, stack_bottom == stack_top
    ;print 'OK' on the screen
    call check_multiboot ;check if we have been loaded by multiboot to bootloader
    call check_cpuid ;check cpu information, is a cpu instruction
    call check_long_mode ;check if cpu supports long mode, 64bits

    ;paging, virtual memory
    ;creat page tables, a single page is a chunk of 4KB memory
    call setup_page_tables
    call enable_paging
    ;the way of working of a page table is that we have 4 types of tables
    ; level 4, 3, 2, 1; each can hold 512 entries
    ;each virtual address takes 48bits of 64bits physical address, the rest are actually unused
    ;the first 9bits indicates the entry on table L4 which point to a L3 table
    ; the next 9bits of the address indicates the entry of the L3 table which points to a L2 table
    ;the next 9 bits indicates de entry on L2 table, which points to the L1 table
    ;the next 9 bits of the addres indicates the entry on the L1 table which points to the physical page
    ;the final 12 bits of the address are used as an offset
    ;cr3 register contains the poiter to the L4 table in any moment


    mov dword [0xb8000], 0x2f4b2f4f ;move the OK string in hex to the video memory, which is fix
    hlt ;order the cpu to freeze and not to read and run more instructions

;subroutines
check_multiboot:
    ;any bootloader will store the magic value in the eax register
    ;so we check if the eax register holds the value
    cmp eax, 0x36d76289
    jne .no_multiboot ;if the comparison fails we jump to no_multiboot
    ret ;otherwise we return from

.no_multiboot:
    ;if it is the case we jump to a function that shows error
    mov al, "M" ;an error code to al register
    jmp error

check_cpuid:
    ;we have to check the flag
    pushfd ;push the flag register to the stack
    pop eax ;pop the value of the flag register to eax
    mov ecx, eax ; copy the flags to ecx, after compare eax and ecx to see if the flags are correct
    xor eax, 1 << 21 ;bit 21 is cpuid
    push eax
    popfd
    pushfd
    pop eax ;copy back to the eax register, if the cpuid bit has not changed
    push ecx
    popfd
    ;the flag register mantains the original value
    cmp eax, ecx ; if they match means that cpuid is not available
    je .no_cpuid
    ret

.no_cpuid:
    mov al, "C"
    jmp error

check_long_mode:
    mov eax, 0x80000000
    cpuid ;take eax as an argument, when it sees the magic value it will return to eax a result, which will be greater than 0x80000000 if it supports extended 
    cmp eax, 0x80000001
    jb .no_long_mode

    ;otherwise
    mov eax, 0x80000001
    cpuid ;if it returns a greater value to edx this time, it means that cpu supports long mode
    test edx, 1 << 29, ;bit 29 it tells your if it support or not
    jz .no_long_mode

    ret

.no_long_mode:
    mov al, "L"
    jmp error

error:
    ;print ERR: X, X is the error code
    mov dword [0xb8000], 0x4f524f45
    mov dword [0xb8004], 0x4f3a4f52
    mov dword [0xb8008], 0x4f204f20
    mov dword [0xb800a], al
    hlt

;set up page tables
setup_page_tables:
    ;we need to do a identity mapping, which is to map a physical address to a virtual one
    ;when we enter to long mode, cu automatically enables paging
    mov eax, page_table_L3
    ;log2 4096 is 12, so
    or eax, 0b11 ;present and writable
    mov [page_table_L4], eax ; first entry of L4

    mov eax, page_table_L2
    or eax, 0b11
    mov [page_table_L3], eax
    ;if we enable the huge page flg, we can directly point from L2 to physical page
    ;so we don't have to worry about L1, and the offset will be 12 + 9 = 21 bits, 2MB

    mov ecx, 0

.loop
    mov eax, 0x200000
    mul ecx
    or eax, 0b10000011 ;huge page flag
    mov [page_table_L2 + ecx * 8], eax


    inc ecx ;increment
    cmp ecx, 512 ;if all table is mapped
    jne .loop

    ret

enable_paging:
    ;pass to the cpu the table
    mov eax, page_table_L4
    mov cr3, eax

    ;enable physical address extension
    mov eax, cr4
    or, eax, 1 << 5 ;bit 5th is physical address extension bit
    mov cr4, eax

    ;enable long mode
    mov ecx, 0xc0000080 ;magic number
    rdmsr ;return de value to eax
    or eax, 1 << 8
    wrmsr ;write eax value to the mode especific register

    ;enable paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret





;set up the stack

section .bss  ;bss contains staticallly allocated variables, this memory will be reserve when our bootloader loads out kernel
; the cpu uses the esp register to save the address which determines the current stack frame, stack pointer
align 4096 ;as each table is 4KB, we need to align 
page_table_L4:
    resb 4096
page_table_L3:
    resb 4096
page_table_L2:
    resb 4096

stack_bottom:
    resb 4096 * 4 ;reserve 16KB of memory
stack_top: