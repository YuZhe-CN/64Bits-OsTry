ENTRY(start)

SECTIONS
{   
    /*
    * Especifies that our binary set up the current address to 1M
    * Our OS data will start 1M in
    * It is a convention
    */
    . = 1M;


    /*
    * We start 1M in, and we will have out multibootHeader
    * the we will have all the cpu instructions
    */
    .boot :
    {
        KEEP(*(.multiboot_header))
    }

    .text :
    {
        *(.text)
    }

}