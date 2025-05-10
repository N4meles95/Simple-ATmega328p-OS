;All the simbols are specified on the linker script

.section .startup, "ax", @progbits

.global _start
.extern main


_start:

    SPH = 0x3E
    SPL = 0x3D

    cli                         ; Disabling Global interrupts

    ldi r16, lo8(_stack_start)  ; Loading the low address of the SP (0xFF) in r16
    out SPL, r16

    ldi r16, hi8(_stack_start)  ; Loading the high address of the SP (0x08) in r16
    out SPH, r16                

    

_init_data:
    ldi r30, lo8(__data_load_start)         ; Data start
    ldi r31, hi8(__data_load_start)
    ldi r26, lo8(__data_start)              ; Start section .data
    ldi r27, hi8(__data_start)              
    ldi r18, lo8(__data_end)                ; End section .data
    ldi r19, hi8(__data_end)

    
copy_data:
    ld r0, Z+                       ; Load 1 byte from the flash
    st X+, r0                       ; SWrite data into the SRAM
    cp r26, r18                    
    cpc r27, r19
    brne copy_data                  ; Continue until the end of .data section

    
init_bss:
    ldi r30, lo8(__bss_start)
    ldi r31, hi8(__bss_start)
    
    ldi r24, 0              

    ldi r18, lo8(__bss_end)    
    ldi r19, hi8(__bss_end)

zero_bss_loop:
    st Z+, r24                  ; clearing Memory
    cp r30, r18                 ; Compare low
    cpc r31, r19                ; Compare High
    brlo zero_bss_loop          ; Continue until the end of the .bss


jump_to_main:

    clr r1
    clr r16
    clr r17
    clr r18
    clr r19
    clr r26
    clr r27
    clr r28
    clr r29
    clr r30
    clr r31

    jmp main                ; jmp to the main (OS)
