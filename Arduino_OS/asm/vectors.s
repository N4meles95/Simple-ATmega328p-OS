
.section .vectors, "a"

.extern _start
.global vectors
.extern Table
.extern FLAG_SWITCH_TASK
.equ TABLE_OS, Table + 37
.equ TABLE_TASK1, Table


; Interrupt Vectors table
;-----------------------------------------------
vectors:
    jmp _start                     ; 0x0000 - Reset
    jmp default_handler            ; 0x0002 - External Interrupt Request 0
    jmp default_handler            ; 0x0004 - External Interrupt Request 1
    jmp default_handler            ; 0x0006 - Pin Change Interrupt Request 0
    jmp default_handler            ; 0x0008 - Pin Change Interrupt Request 1
    jmp default_handler            ; 0x000A - Pin Change Interrupt Request 2
    jmp default_handler            ; 0x000C - Watchdog Time-Out Interrupt
    jmp default_handler            ; 0x000E - Timer/Counter2 Compare Match A
    jmp default_handler            ; 0x0010 - Timer/Counter2 Compare Match B
    jmp default_handler            ; 0x0012 - Timer/Counter2 Overflow
    jmp default_handler            ; 0x0014 - Timer/Counter1 Capture Event
    jmp context_switch             ; 0x0016 - Timer/Counter1 Compare Match A
    jmp default_handler            ; 0x0018 - Timer/Counter1 Compare Match B
    jmp default_handler            ; 0x001A - Timer/Counter1 Overflow
    jmp default_handler            ; 0x001C - Timer/Counter0 Compare Match A
    jmp default_handler            ; 0x001E - Timer/Counter0 Compare Match B
    jmp default_handler            ; 0x0020 - Timer/Counter0 Overflow
    jmp default_handler            ; 0x0022 - SPI Serial Transfer Complete
    jmp default_handler            ; 0x0024 - USART Rx Complete
    jmp default_handler            ; 0x0026 - USART Data Register Empty
    jmp default_handler            ; 0x0028 - USART Tx Complete
    jmp default_handler            ; 0x002A - ADC Conversion Complete
    jmp default_handler            ; 0x002C - EEPROM Ready
    jmp default_handler            ; 0x002E - Analog Comparator
    jmp default_handler            ; 0x0030 - 2-wire Serial Interface (I2C)
    jmp default_handler            ; 0x0032 - Store Program Memory Ready
;------------------------------------------


.section .startup, "ax", @progbits

default_handler:
    nop



;----context_switch part----

context_switch:
    push 28

    ;SREG push
    lds r28, 0x005F
    push r28

    push r29
    push r30

    lds r29, FLAG_SWITCH_TASK
    cpi r29, 0
    breq switching_task0

    jmp switching_task1


;function used for switching from task0 to OS
switching_task0:
    ldi r29, 1
    sts FLAG_SWITCH_TASK, r29

    ;saving critical registers

    in r28, 0x3d
    in r29, 0x3e

    adiw r28, 4
    ld r30, Y
    sts TABLE_TASK1 + 36, r30
    adiw r28, 1
    ld r30, Y
    sts TABLE_TASK1 + 35, r30
    adiw r28, 1
    sts TABLE_TASK1 + 32, r28
    sts TABLE_TASK1 + 33, r29

    pop r30
    pop r29
    pop r28
    sts TABLE_TASK1 + 34, r28 
    pop r28

    ;saving general purpuose registers on the context table 

    sts TABLE_TASK1, r0
    sts TABLE_TASK1 + 1, r1
    sts TABLE_TASK1 + 2, r2
    sts TABLE_TASK1 + 3, r3
    sts TABLE_TASK1 + 4, r4
    sts TABLE_TASK1 + 5, r5
    sts TABLE_TASK1 + 6, r6
    sts TABLE_TASK1 + 7, r7
    sts TABLE_TASK1 + 8, r8
    sts TABLE_TASK1 + 9, r9
    sts TABLE_TASK1 + 10, r10
    sts TABLE_TASK1 + 11, r11
    sts TABLE_TASK1 + 12, r12
    sts TABLE_TASK1 + 13, r13
    sts TABLE_TASK1 + 14, r14
    sts TABLE_TASK1 + 15, r15
    sts TABLE_TASK1 + 16, r16
    sts TABLE_TASK1 + 17, r17
    sts TABLE_TASK1 + 18, r18
    sts TABLE_TASK1 + 19, r19
    sts TABLE_TASK1 + 20, r20
    sts TABLE_TASK1 + 21, r21
    sts TABLE_TASK1 + 22, r22
    sts TABLE_TASK1 + 23, r23
    sts TABLE_TASK1 + 24, r24
    sts TABLE_TASK1 + 25, r25
    sts TABLE_TASK1 + 26, r26
    sts TABLE_TASK1 + 27, r27
    sts TABLE_TASK1 + 28, r28
    sts TABLE_TASK1 + 29, r29
    sts TABLE_TASK1 + 30, r30
    sts TABLE_TASK1 + 31, r31
    
    ;loading of the OS context table
    ;starting from the SP

    lds r28, TABLE_OS + 32
    out 0x3d, r28
    lds r29, TABLE_OS + 33
    out 0x3e, r29

    ;load PC used for RETI

    lds r30, TABLE_OS + 35
    lds r31, TABLE_OS + 36

    push r30
    push r31

    ;loading general purpuose registers

    lds r30, TABLE_OS + 34
    sts 0x005F, r30

    lds r0, TABLE_OS
    lds r1, TABLE_OS + 1
    lds r2, TABLE_OS + 2
    lds r3, TABLE_OS + 3
    lds r4, TABLE_OS + 4
    lds r5, TABLE_OS + 5
    lds r6, TABLE_OS + 6
    lds r7, TABLE_OS + 7
    lds r8, TABLE_OS + 8
    lds r9, TABLE_OS + 9
    lds r10, TABLE_OS + 10
    lds r11, TABLE_OS + 11
    lds r12, TABLE_OS + 12
    lds r13, TABLE_OS + 13
    lds r14, TABLE_OS + 14
    lds r15, TABLE_OS + 15
    lds r16, TABLE_OS + 16
    lds r17, TABLE_OS + 17
    lds r18, TABLE_OS + 18
    lds r19, TABLE_OS + 19
    lds r20, TABLE_OS + 20
    lds r21, TABLE_OS + 21
    lds r22, TABLE_OS + 22
    lds r23, TABLE_OS + 23
    lds r24, TABLE_OS + 24
    lds r25, TABLE_OS + 25
    lds r26, TABLE_OS + 26
    lds r27, TABLE_OS + 27
    lds r28, TABLE_OS + 28
    lds r29, TABLE_OS + 29
    lds r30, TABLE_OS + 30
    lds r31, TABLE_OS + 31

    jmp end_context_switch


;---------------------------------------------------------


;function used for switching from OS to task0
switching_task1:
    clr r29
    sts FLAG_SWITCH_TASK, r29

    ;saving critical registers

    in r28, 0x3d
    in r29, 0x3e

    adiw r28, 4
    ld r30, Y
    sts TABLE_OS + 36, r30
    adiw r28, 1
    ld r30, Y
    sts TABLE_OS + 35, r30
    adiw r28, 1
    sts TABLE_OS + 32, r28
    sts TABLE_OS + 33, r29

    pop r30
    pop r29
    pop r28
    sts TABLE_OS + 34, r28 
    pop r28

    ;saving general purpuose registers on the context table 

    sts TABLE_OS, r0
    sts TABLE_OS + 1, r1
    sts TABLE_OS + 2, r2
    sts TABLE_OS + 3, r3
    sts TABLE_OS + 4, r4
    sts TABLE_OS + 5, r5
    sts TABLE_OS + 6, r6
    sts TABLE_OS + 7, r7
    sts TABLE_OS + 8, r8
    sts TABLE_OS + 9, r9
    sts TABLE_OS + 10, r10
    sts TABLE_OS + 11, r11
    sts TABLE_OS + 12, r12
    sts TABLE_OS + 13, r13
    sts TABLE_OS + 14, r14
    sts TABLE_OS + 15, r15
    sts TABLE_OS + 16, r16
    sts TABLE_OS + 17, r17
    sts TABLE_OS + 18, r18
    sts TABLE_OS + 19, r19
    sts TABLE_OS + 20, r20
    sts TABLE_OS + 21, r21
    sts TABLE_OS + 22, r22
    sts TABLE_OS + 23, r23
    sts TABLE_OS + 24, r24
    sts TABLE_OS + 25, r25
    sts TABLE_OS + 26, r26
    sts TABLE_OS + 27, r27
    sts TABLE_OS + 28, r28
    sts TABLE_OS + 29, r29
    sts TABLE_OS + 30, r30
    sts TABLE_OS + 31, r31
    
    ;start to load TABLE_TASK1
    ;loading SP

    lds r28, TABLE_TASK1 + 32
    out 0x3d, r28
    lds r29, TABLE_TASK1 + 33
    out 0x3e, r29

    ;load PC used from RETI

    lds r30, TABLE_TASK1 + 35
    lds r31, TABLE_TASK1 + 36

    push r30
    push r31

    ;loading general purpuose registers

    lds r30, TABLE_TASK1 + 34
    sts 0x005F, r30

    lds r0, TABLE_TASK1
    lds r1, TABLE_TASK1 + 1
    lds r2, TABLE_TASK1 + 2
    lds r3, TABLE_TASK1 + 3
    lds r4, TABLE_TASK1 + 4
    lds r5, TABLE_TASK1 + 5
    lds r6, TABLE_TASK1 + 6
    lds r7, TABLE_TASK1 + 7
    lds r8, TABLE_TASK1 + 8
    lds r9, TABLE_TASK1 + 9
    lds r10, TABLE_TASK1 + 10
    lds r11, TABLE_TASK1 + 11
    lds r12, TABLE_TASK1 + 12
    lds r13, TABLE_TASK1 + 13
    lds r14, TABLE_TASK1 + 14
    lds r15, TABLE_TASK1 + 15
    lds r16, TABLE_TASK1 + 16
    lds r17, TABLE_TASK1 + 17
    lds r18, TABLE_TASK1 + 18
    lds r19, TABLE_TASK1 + 19
    lds r20, TABLE_TASK1 + 20
    lds r21, TABLE_TASK1 + 21
    lds r22, TABLE_TASK1 + 22
    lds r23, TABLE_TASK1 + 23
    lds r24, TABLE_TASK1 + 24
    lds r25, TABLE_TASK1 + 25
    lds r26, TABLE_TASK1 + 26
    lds r27, TABLE_TASK1 + 27
    lds r28, TABLE_TASK1 + 28
    lds r29, TABLE_TASK1 + 29
    lds r30, TABLE_TASK1 + 30
    lds r31, TABLE_TASK1 + 31


end_context_switch:
    nop
    reti

    

















    
