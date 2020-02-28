///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 using internal Timer1 to blink LED
// 
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"


void GPIO_setup(void);
void CLOCK_setup(void);
void TIM1_setup(void);


main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	TIM1_setup();
	
	while (TRUE)
	{
		// Check counter status
		// 1953 = 2 sec, 976 = 1 sec
		if (TIM1_GetCounter() > 976) GPIO_WriteHigh(GPIOD, GPIO_PIN_3); // 2nd second - turn on LED
		else GPIO_WriteLow(GPIOD, GPIO_PIN_3); // 1st second - turn off LED
		
		delay_ms(1); // Slow down main loop a little bit
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOD);
	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // LED, Output, Push-Pull, Low on Init, Fast
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
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE); // Enable Timer1 peripheral
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
}

void TIM1_setup(void)
{
	// Timer1 initialization function
	TIM1_DeInit(); // Deinitialize Timer1 peripheral
	
	TIM1_TimeBaseInit(16384, TIM1_COUNTERMODE_UP, 1953, 0); // Initialize Timer1
	// (prescaller, counting mode, overflow value, number of repetitions)
	// Counted time = (prescaller * number_of_repetitions * number_of_counts) / peripheral_clock
	// (16384 * 1 * 1953) / 16000000 = 1.9999 ~ 2 sec
	// number_of_counts is a difference between starting value and overflow value
	
	TIM1_Cmd(ENABLE); // Turn on Timer1
}