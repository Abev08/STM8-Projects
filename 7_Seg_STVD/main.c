///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 interfaceing 7 segment display by parallel communication
// Single display connected to PortC
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"


// Definition of 7 segment display digits by PortC pin status
#define ZERO					0b01111110
#define JEDEN				0b00001100
#define DWA						0b10110110
#define TRZY					0b10011110
#define CZTERY			0b11001100
#define PIEC					0b11011010
#define SZESC				0b11111010
#define SIEDEM			0b00001110
#define OSIEM				0b11111110
#define DZIEWIEC	0b11011110


void GPIO_setup(void);
void CLOCK_setup(void);


uint16_t blink; // Variable for blinking debugging LED
uint16_t cyfraZmien; // "Timer" for changing displaying number
uint8_t cyfra = 0; // Displaying number


main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	
	
	while (TRUE)
	{
		blink++; // Increment LED blink "timer"
		if (blink >= 1000) // Blink every 1 sec
		{
			GPIO_WriteReverse(GPIOB, GPIO_PIN_2); // Blink LED
			blink = 0; // Reset blink timer
		}
		
		cyfraZmien++; // Increment displayed number "timer"
		if (cyfraZmien >= 500) // Change displayed number every 500 ms
		{
			switch (cyfra) // Simple switch statement to determine what value to output on PortC
			{
				case 0:
					GPIO_Write(GPIOC, ~ZERO);
					break;
				case 1:
					GPIO_Write(GPIOC, ~JEDEN);
					break;
				case 2:
					GPIO_Write(GPIOC, ~DWA);
					break;
				case 3:
					GPIO_Write(GPIOC, ~TRZY);
					break;
				case 4:
					GPIO_Write(GPIOC, ~CZTERY);
					break;
				case 5:
					GPIO_Write(GPIOC, ~PIEC);
					break;
				case 6:
					GPIO_Write(GPIOC, ~SZESC);
					break;
				case 7:
					GPIO_Write(GPIOC, ~SIEDEM);
					break;
				case 8:
					GPIO_Write(GPIOC, ~OSIEM);
					break;
				case 9:
					GPIO_Write(GPIOC, ~DZIEWIEC);
					break;
			}
			
			cyfra++; // Increment displayed number
			if (cyfra >= 10) cyfra = 0; // If displayed number is equal or bigger than 10 reset it
			cyfraZmien = 0; // Reset displayed number timer
		}
		
		delay_ms(1); // Slow down main loop
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
 GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // Debugging LED, Output, Push-Pull, Low on Init, Fast
	
	GPIO_DeInit(GPIOC);
	GPIO_Init(GPIOC, GPIO_PIN_1, GPIO_MODE_OUT_PP_HIGH_FAST); // PC1 - segment A, Output, Push-Pull, High on Init, Fast
	GPIO_Init(GPIOC, GPIO_PIN_2, GPIO_MODE_OUT_PP_HIGH_FAST); // PC2 - segment B
	GPIO_Init(GPIOC, GPIO_PIN_3, GPIO_MODE_OUT_PP_HIGH_FAST); // PC3 - segment C
	GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_HIGH_FAST); // PC4 - segment D
	GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST); // PC5 - segment E
	GPIO_Init(GPIOC, GPIO_PIN_6, GPIO_MODE_OUT_PP_HIGH_FAST); // PC6 - segment F
	GPIO_Init(GPIOC, GPIO_PIN_7, GPIO_MODE_OUT_PP_HIGH_FAST); // PC7 - segment G
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