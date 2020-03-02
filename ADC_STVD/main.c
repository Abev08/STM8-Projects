///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 ADC1 read voltage on connected potentiometer
//
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"
#include "_to_string.h"
#include "lcd.h"


void GPIO_setup(void);
void CLOCK_setup(void);
void ADC1_setup(void);


const char txt1[] = {"TEST ADC1"}; // Static text to display on LCD

uint16_t adcVal = 0; // Value readed from ADC (ADC is 10bit so 16bit variable is needed)
char tempString[6]; // Readed value converted to string to display on LCD
uint16_t tab[10]; // Table of readed values for averaging
uint8_t i = 0; // Table enumerator
uint8_t j; // Averaging enumerator


main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	ADC1_setup();
	
	LCD_init(); // Initialize LCD
	LCD_clear_home();
	
	LCD_goto(3, 1); // Display static text
	LCD_putstr(txt1);
	
	
	while (TRUE)
	{
		ADC1_StartConversion(); // Start ADC conversion
		
		while(ADC1_GetFlagStatus(ADC1_FLAG_EOC) == FALSE); // Wait for conversion to finish
		
		adcVal = ADC1_GetConversionValue(); // Read ADC value
		ADC1_ClearFlag(ADC1_FLAG_EOC); // Clear ADC End Of Conversion flag
		
		uint_to_string(adcVal, tempString); // Convert readed value to string and display it on LCD
		LCD_goto(0, 0);
		LCD_putstr(tempString);
		
		tab[i] = adcVal; // Put readed value in the table
		i = (i + 1) % 10; // Increment table enumerator
		
		adcVal = 0; // Reset ADC value
		for (j = 0; j < 10; j++)
		{
			adcVal = adcVal + tab[j]; // Add up every value in the table
		}
		adcVal = adcVal / 10; // Divide sum of table values by table length
		
		uint_to_string(adcVal, tempString); // Convert averaged value and display it on LCD
		LCD_goto(8, 0);
		LCD_putstr(tempString);
		
		delay_ms(100); // Slow down main loop a little bit
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
	GPIO_Init(GPIOB, GPIO_PIN_0, GPIO_MODE_IN_FL_NO_IT); // ADC, Input, Floating, No Interrupt
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
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, ENABLE); // Enable ADC peripheral
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
}

void ADC1_setup(void)
{
	ADC1_DeInit(); // Deinitialize ADC
	
	ADC1_Init(ADC1_CONVERSIONMODE_SINGLE, // Continous conversion mode
						ADC1_CHANNEL_0, // ADC channel 0
						ADC1_PRESSEL_FCPU_D18, // ADC clock prescaller = 18 -> 16 Mhz / 18 = 888 kHz (ADC clock should be less than 4Mhz)
						ADC1_EXTTRIG_GPIO, // Disable external trigger
						DISABLE,
						ADC1_ALIGN_RIGHT, // Align readed value to right (easier to read)
						ADC1_SCHMITTTRIG_CHANNEL0, // Disable Schmitt trigger
						DISABLE);
	
	ADC1_Cmd(ENABLE); // Enable ADC peripheral
}