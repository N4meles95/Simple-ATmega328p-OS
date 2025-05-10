#include "../headers/utilities.h"
#include "../headers/task0.h"


// I create the process table in the main which represents the OS
taskTable Table[2] = {

    {   // Task1 table
        .general_registers = {0},
        .STL = 0,
        .STH = 0,
        .SREG_t = 0,
        .PCL = 0,
        .PCH = 0
    },
    {   //OS Table
        .general_registers = {0},
        .STL = 0,
        .STH = 0,
        .SREG_t = 0,
        .PCL = 0,
        .PCH = 0
    }
};

//simple flag mechanism used in the context switch
int FLAG_SWITCH_TASK = 1;


int main()
{
    //inizialitation of the process table
    table_creation(Table);
    //coupling the task function to the task table holded by the os
    task_create(0, (int16_t)(uintptr_t)task0, Table);

    //init and start the timer that triggers the interrupt
    init_timer1();             
    start_timer1();


    //this is used only for debugging
    //-----------------
    DDRD |= (1 << PD7);

    while (1){
        PORTD ^= (1 << 7);
        //delay
        for(int i=0; i < 100000; i++);
    }
    //-------------------  
    
    return 0;
}
