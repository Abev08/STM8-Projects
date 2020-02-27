///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 LED Blink
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"

#define LedPort   GPIOB
#define LedPin    GPIO_PIN_2

void GPIO_setup(void);
void CLOCK_setup(void);

void main(void)
{
  // Initialization functions
  CLOCK_setup();
  GPIO_setup();
	
  while (TRUE)
  {
    GPIO_WriteReverse(LedPort, LedPin); // Change state of LEDs
    GPIO_WriteReverse(GPIOD, GPIO_PIN_3);
    delay_ms(1000); // Wait 1 sec
  }
}

void GPIO_setup(void)
{
  GPIO_DeInit(GPIOB);
  GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // Output, Push-Pull, Low on Init, Fast Output
	
  GPIO_DeInit(GPIOD);
  GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_HIGH_FAST); // Output, Push-Pull, High on Init, Fast Output
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
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
}