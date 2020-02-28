///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 communicating with STP16CP05 using software SPI
//
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////
// UNDER CONSTRUCTION - NOT WORKING!

#include "stm8s.h"
#include "stm8s_delay.h"
#include "_to_string.h"
#include "STP16CP05.h"


void GPIO_setup(void);
void CLOCK_setup(void);

uint8_t i = 1;

main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	
	
	while (TRUE)
	{
		GPIO_WriteReverse(GPIOB, GPIO_PIN_2); // Blink debugging LED
		
		i = (i + 1) % 4;
		
		//STP16CP05_WriteBit(i <= 1);
		
		STP16CP05_Write8bits(0x80); // 0x9F turns on
		
		//STP16CP05_Write16bits(32800);
		
		delay_ms(1000);
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
  GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // DEBUGGING LED
	
	GPIO_DeInit(GPIOC);
	GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_LOW_FAST); // Latch
	GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST); // Output enable
	GPIO_Init(GPIOC, GPIO_PIN_6, GPIO_MODE_OUT_PP_LOW_FAST); // CLK
	GPIO_Init(GPIOC, GPIO_PIN_7, GPIO_MODE_OUT_PP_LOW_FAST); // SDI
	
	GPIO_DeInit(GPIOD);
	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // ERROR LED
	GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_IN_FL_NO_IT); // ENK_A
	GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); // ENK_B
	GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_FL_NO_IT); // ENK_BTN
}

void CLOCK_setup(void)
{
	CLK_DeInit();
  CLK_HSECmd(DISABLE);
  CLK_LSICmd(DISABLE);
  CLK_HSICmd(ENABLE); // Enable High Speed Internal clock
  while (CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE);
	
	CLK_ClockSwitchCmd(ENABLE);
  CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); // Prescaler = 1 -> 16 MHz clock
  CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
	
	CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI, DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
	
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
}