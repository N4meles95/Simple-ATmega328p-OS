ENTRY(_start)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x0000, LENGTH = 30K
    SRAM (rwx) : ORIGIN = 0x00800100, LENGTH = 2k
}

SECTIONS
{
    /* Interrupt vectors table*/
    .vectors :
    {
        . = 0x0000;         
        KEEP(*(.vectors))
        *(.vectors)        
        . = ALIGN(2);
    } > FLASH


    /* Main code here */
    .text :
    {
        *(.startup)
        *(.text)
        *(.text.*)
        *(.rodata)
        *(.rodata.*)
    } > FLASH

    /*(.data) */
    .data : 
    {
        __data_load_start = LOADADDR(.data);
        
        /* Start .data */
        __data_start = .;

        *(.data)                                

        /* End .data */
        __data_end = .;   
                                                     
    } > SRAM AT > FLASH



    /* (.bss) */
    .bss :
    {
        __bss_start = .;            /* Start .bss */
        *(.bss)                   
        __bss_end = .;              /* End .bss */
    } > SRAM


    /* (Stack) */
    .stack (NOLOAD) :
    {
        _stack_bottom = __bss_end + 1;
        _stack_start = 0x008008FF;
    } > SRAM
}
