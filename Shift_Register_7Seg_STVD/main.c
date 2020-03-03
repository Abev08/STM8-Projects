///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 communicating with STP16CP05 using software SPI
//
//
// Created: 03.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"
#include "STP16CP05.h"


// Definition of bits to select each digit on 7 segment 4 digit display
#define DIG1 0x7000 // Bit 16 set to 0 in last 4 bits
#define DIG2 0xB000 // Bit 15 set to 0 in last 4 bits
#define DIG3 0xD000 // Bit 14 set to 0 in last 4 bits
#define DIG4 0xE000 // Bit 13 set to 0 in last 4 bits

// Definition of numbers to display on 7 segment display
// Bits are arranged: 0b_DP_G_F_E_D_C_B_A
// Table is arranged: {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
static const uint8_t numbers[] = {0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110,
																																		0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111};
#define DP 0b10000000 // Decimal point declaration


void GPIO_setup(void);
void CLOCK_setup(void);
void test(void);


uint16_t i = 0; // Index for numbers table
uint16_t update = 0; // Number update timer
uint16_t blinkLED = 0; // Timer for LED blinking
uint8_t digit = 0; // Selected digit on display
uint16_t value = 0; // Value displayed on display (last case only)


main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	
	
	while (TRUE)
	{
		blinkLED++;
		if (blinkLED >= 1000)
		{
			GPIO_WriteReverse(GPIOB, GPIO_PIN_2); // Blink debugging LED
			blinkLED = 0;
		}
		
		
		//test(); // Test function
		
		
		update++;
		
		//***********************************************************************************************
		// Take a number from numbers table and display it on 7 segment display (digit is selected manually by user)
		//if (update >= 1000) // Increment displayed number ever 1 sec
		//{
		//	i = (i + 1) % 10;
		//	STP16CP05_Write8bits(numbers[i]);
		//	
		//	update = 0;
		//}
		
		
		//***********************************************************************************************
		// Same as above but with digit selection
		//if (update >= 1000) // Increment displayed number ever 1 sec
		//{
		//	i = (i + 1) % 10;
		//	STP16CP05_Write16bits(numbers[i] | DIG4); // Display number on digit 4
		//	
		//	update = 0;
		//}
		
		
		//***********************************************************************************************
		// Display the same number on every digit
		//if (update >= 1000) // Increment displayed number ever 1 sec
		//{
		//	i = (i + 1) % 10;
		//	update = 0;
		//}
		//digit = (digit + 1) % 4; // In every main loop cycle (~1 ms) change used digit
		//switch (digit) // Display number on selected digit
		//{
		//	case 0:
		//		STP16CP05_Write16bits(numbers[i] | DIG4);
		//		break;
		//	case 1:
		//		STP16CP05_Write16bits(numbers[i] | DIG3);
		//		break;
		//	case 2:
		//		STP16CP05_Write16bits(numbers[i] | DIG2);
		//		break;
		//	case 3:
		//		STP16CP05_Write16bits(numbers[i] | DIG1);
		//		break;
		//}
		
		
		//***********************************************************************************************
		// Display big number on whole 4 digit 7 segment display
		if (update >= 100) // Increment displayed number every 100 ms
		{
			value = (value + 1) % 10000; // Max displayed value 9999
			update = 0;
		}
		digit = (digit + 1) % 4; // In every main loop cycle (~1 ms) change used digit
		switch (digit) // Display number on selected digit
		{
			case 0:
				i = value % 10; // Look only at last digit of value
				STP16CP05_Write16bits(numbers[i] | DIG4);
				break;
			case 1:
				i = value;
				while (i > 1000) i = i - 1000; // Get rid of thousands
				while (i > 100) i = i - 100; // Get rid of hundreds
				i = i / 10; // Look at 2nd digit of value
				STP16CP05_Write16bits(numbers[i] | DIG3 | DP); // Also display dot after 3rd digit
				break;
			case 2:
				i = value;
				while (i > 1000) i = i - 1000; // Get rid of thousands
				i = i / 100; // Look at 3rd digit of value
				STP16CP05_Write16bits(numbers[i] | DIG2);
				break;
			case 3:
				i = value / 1000; // Look at 4th digit of value
				STP16CP05_Write16bits(numbers[i] | DIG1);
				break;
		}
		
		
		delay_ms(1);
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
	GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // DEBUGGING LED, Output, Push-Pull, Low on Init, Fast
	
	GPIO_DeInit(GPIOC);
	GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST); // Latch, Output, Push-Pull, Low on Init, Fast
	GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); // Output enable, Output, Push-Pull, Low on Init, Fast
	GPIO_Init(GPIOC, GPIO_PIN_6, GPIO_MODE_OUT_PP_LOW_FAST); // CLK, Output, Push-Pull, Low on Init, Fast
	GPIO_Init(GPIOC, GPIO_PIN_7, GPIO_MODE_OUT_PP_LOW_FAST); // SDI, Output, Push-Pull, Low on Init, Fast
}

void CLOCK_setup(void)
{
	CLK_DeInit();
	CLK_HSECmd(DISABLE);
 CLK_LSICmd(DISABLE);
 CLK_HSICmd(ENABLE); // Enable High Speed Internal clock
 while (CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE); // Wait for clock source to stabilize
	
	CLK_ClockSwitchCmd(ENABLE);
 CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); // Prescaler = 1 -> 16 MHz clock
 CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
	
	CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI, DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
	
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
}

void test(void)
{
	// Test code that blinks LEDs connected to outputs 6 and 7 of STP16CP05 (bits 7 and 8)
	// It uses global uint8_t variable "i"
	// Just uncomment the function you want to test
	
	i = (i + 1) % 4; // Increment between switch statement
	
	//STP16CP05_WriteBit(i <= 1);
	switch (i)
	{
		case 0:
			STP16CP05_Write8bits(0x00);
			//STP16CP05_Write16bits(0x0000);
			break;
		case 1:
			STP16CP05_Write8bits(0x40);
			//STP16CP05_Write16bits(0x0040);
			break;
		case 2:
			STP16CP05_Write8bits(0xC0);
			//STP16CP05_Write16bits(0x00C0);
			break;
		case 3:
			STP16CP05_Write8bits(0x80);
			//STP16CP05_Write16bits(0x0080);
			break;
	}
}