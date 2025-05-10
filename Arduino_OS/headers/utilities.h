
#ifndef UTILITIES_H
#define UTILITIES_H

#include <stdint.h>

//used only for the definitions of the IO registers 
#include <avr/io.h>
#include <avr/interrupt.h>


//definition of the context table
typedef struct
{
    int8_t general_registers[32];
    int8_t STL;
    int8_t STH;
    int8_t SREG_t;
    int8_t PCL;
    int8_t PCH;
    
}taskTable;

//extern declarations from linker script
extern uint16_t _stack_bottom;
extern uint16_t _stack_start;


//function declarations
void table_creation(taskTable Table[]);
void task_create(int table_index, int16_t task_address, taskTable Table[]);

//functions used for the clock interrupt setting used in the context switching
void init_timer1();
void start_timer1();

#endif // UTILITIES_H
