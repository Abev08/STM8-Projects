///////////////////////////////////////////////////////////////////////////////////////////////////
// Library for interfaceing STP16CP05 using software SPI
//
//
// Created: 03.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////
// When sending more than 1 bit (8 or 16) to STP16CP05 MSB is send first.

#include "stm8s.h"

//extern void delay_ns(unsigned int value); // External delay ns function
// MCU clock speed at 16 Mhz makes that the shortest MCU cycle will be 62.5 ns which should be plenty for delay between signals change


#define STP16CP05_PORT		GPIOC // Port where signals to STP16CP05 are connected
#define STP16CP05_SDI			GPIO_PIN_7	// STP16CP05 Serial Data In
#define STP16CP05_CLK			GPIO_PIN_6	// STP16CP05 Clock
#define STP16CP05_OE				GPIO_PIN_5	// STP16CP05 Output Enable (active low)
#define STP16CP05_LE				GPIO_PIN_4	// STP16CP05 Latch Input


void STP16CP05_ToggleCLK(void);
void STP16CP05_ToggleLE(void);
void STP16CP05_WriteBit(bool in);
void STP16CP05_Write8bits(uint8_t in);
void STP16CP05_Write16bits(uint16_t in);


// Function toggles CLK output
void STP16CP05_ToggleCLK(void)
{
	GPIO_WriteHigh(STP16CP05_PORT, STP16CP05_CLK); // Output high on CLK line
	GPIO_WriteLow(STP16CP05_PORT, STP16CP05_CLK); // Output low on CLK line
}

// Function toggles LE output
void STP16CP05_ToggleLE(void)
{
	GPIO_WriteHigh(STP16CP05_PORT, STP16CP05_LE); // Output high on LE line
	GPIO_WriteLow(STP16CP05_PORT, STP16CP05_LE); // Output low on LE line
}

// Function writes 1 bit into STP16CP05
void STP16CP05_WriteBit(bool in)
{
	// Output high / low on SDI line depending on passed parameter
	if (in == TRUE) GPIO_WriteHigh(STP16CP05_PORT, STP16CP05_SDI);
	else GPIO_WriteLow(STP16CP05_PORT, STP16CP05_SDI);
	
	STP16CP05_ToggleCLK(); // Toggle CLK
	
	STP16CP05_ToggleLE(); // Toggle LE
}

// Function writes 8 bits into STP16CP05
void STP16CP05_Write8bits(uint8_t in)
{
	uint8_t i = 0;
	for (i = 0; i < 8; i++)
	{
		// Output high / low on SDI line depending on passed parameter
		if ((in & (0x80 >> i)) > 0) GPIO_WriteHigh(STP16CP05_PORT, STP16CP05_SDI);
		else GPIO_WriteLow(STP16CP05_PORT, STP16CP05_SDI);
		
		STP16CP05_ToggleCLK(); // Toggle CLK
	}
	
	STP16CP05_ToggleLE(); // Toggle LE
}

// Function writes 16 bits into STP16CP05
void STP16CP05_Write16bits(uint16_t in)
{
	uint8_t i = 0;
	for (i = 0; i < 16; i++)
	{
		// Output high / low on SDI line depending on passed parameter
		if ((in & (0x8000 >> i)) > 0) GPIO_WriteHigh(STP16CP05_PORT, STP16CP05_SDI);
		else GPIO_WriteLow(STP16CP05_PORT, STP16CP05_SDI);
		
		STP16CP05_ToggleCLK(); // Toggle CLK
	}
	
	STP16CP05_ToggleLE(); // Toggle LE
}