#include "../headers/utilities.h"

//Table inizialization

//-------------------------------
void table_creation(taskTable Table[])
{
    //the only purpouse on this project is the scheduling so i will use only 2 task (the OS and task1)

    //simple sequence to calculate the offset between the 2 tasks
    uint16_t stack_dimension = _stack_start - _stack_bottom;
    uint16_t offset_tasks = (uint16_t) (stack_dimension / 2);

    //setting the Stack pointer for the task1 using the offset
    Table[0].STL =  _stack_start - offset_tasks;
    Table[0].STH = ((_stack_start - offset_tasks) >> 8);

}


void task_create(int table_index, int16_t task_address, taskTable Table[])
{
    int8_t pch = (task_address >> 8) & 0xFF, pcl = task_address & 0xFF;
    Table[table_index].PCH = pch;
    Table[table_index].PCL = pcl;
}
//----------------------------------------







//Timer configuration

//------------------------------
void init_timer1()
{
    //setting CTC mode on the Timer1 (16 bit better resolution) for the context switch

    TCCR1A = 0;                 // Normal mode, no output compare
    TCCR1B |= (1 << WGM12);     // CTC Mode (Clear Timer on Compare Match)
    OCR1A = 62500 - 1;          // Compare value for 1 second delay (16MHz / 256 prescaler)

    // Enabling the interrupt on match using the OCR1A register
    TIMSK1 |= (1 << OCIE1A);

    // Enabling Global interrupt
    sei();
}

void start_timer1()
{
    TCCR1B &= ~(1 << CS12 | 1 << CS11 | 1 << CS10);     // Reset prescaler
    TCCR1B |= (1 << CS12);                              // Prescaler: 256
}
//-----------------------------------------

