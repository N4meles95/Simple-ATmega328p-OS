#include "../headers/task0.h"

void task0()
{
    //output mode on the pin 13
    DDRB |= (1 << PB5);

    while (1)
    {
        //led toggle
        PORTB ^= (1 << PB5);

        //delay
        for(int i=0; i < 100000; i++);
    }
}