///////////////////////////////////////////////////////////////////////////////////////////////////
// Time wasting delay library for STM8S MCU
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"

#define F_CPU 16000000UL // CPU frequency
#define dly_const (F_CPU / 16000000.0F) // Cycle to 1 us constant


void delay_us(unsigned int value)
{
	unsigned int loops = (dly_const * value) * 1.174; // Times 1.174 to get closer to real value
	
	while(loops)
	{
		_asm("nop");
		loops--;
	}
}

void delay_ms(unsigned int value)
{
	while(value)
	{
		delay_us(1000);
		value--;
	}
}