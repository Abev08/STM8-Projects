///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 interpreting encoder inputs
// Encoder inputs are represented on LEDs.
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"

// Definitions of encoder port and "buttons"
#define ENK_PORT		GPIOD
#define ENK_A				GPIO_PIN_0
#define ENK_B				GPIO_PIN_4
#define ENK_BTN			GPIO_PIN_7


void GPIO_setup(void);
void CLOCK_setup(void);


main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	
	while (TRUE)
	{
		// When button is pressed light up both LEDs
	  if (GPIO_ReadInputPin(ENK_PORT, ENK_BTN) == FALSE)
		{
			GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
			GPIO_WriteHigh(GPIOB, GPIO_PIN_2);
		}
		else
		{
			// Light up LED depending on encoder channel state
			if (GPIO_ReadInputPin(ENK_PORT, ENK_A) == FALSE) GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
			else GPIO_WriteLow(GPIOD, GPIO_PIN_3);
			
			if (GPIO_ReadInputPin(ENK_PORT, ENK_B) == FALSE) GPIO_WriteHigh(GPIOB, GPIO_PIN_2);
			else GPIO_WriteLow(GPIOB, GPIO_PIN_2);
		}
		
		delay_ms(50); // Slow down main loop a little bit
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
  GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // LED, Output, Push-Pull, Low on Init, Fast
	
	GPIO_DeInit(GPIOD);
	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // LED, Output, Push-Pull, Low on Init, Fast
	GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_IN_FL_NO_IT); // ENK_A, Input, Floating, No Interrupt
	GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); // ENK_B, Input, Floating, No Interrupt
	GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_FL_NO_IT); // ENK_BTN, Input, Floating, No Interrupt
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