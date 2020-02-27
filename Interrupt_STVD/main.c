///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 external interrupts handling
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"
#include "lcd.h"
#include "_to_string.h"


// Definitions of encoder port and "buttons"
#define ENK_PORT GPIOD
#define ENK_A GPIO_PIN_0
#define ENK_B GPIO_PIN_4
#define ENK_BTN GPIO_PIN_7


void GPIO_setup(void);
void CLOCK_setup(void);
void EXTI_setup(void);


const char txt1[] = {"TEST PRZERWAN"}; // Static text to display on LCD
bool fastBlink; // Variable indicationg fast blinking

bool enk_a, enk_a_prev; // Variables for encoder state
bool enk_b, enk_b_prev;
bool counting = FALSE;
uint8_t val = 0; // Measured value

uint16_t i = 0; // Blinking timer
uint8_t lcdUpdate = 0; // LCD update timer

main()
{
	// Initialization functions
	GPIO_setup();
	EXTI_setup();
	CLOCK_setup();
	
	// Initialize LCD and clear screen
	LCD_init();
	LCD_clear_home();
	
	// Put static text on LCD
	LCD_goto(1, 1);
	LCD_putstr(txt1);
	
	// Read encoder status
	enk_a = GPIO_ReadInputPin(ENK_PORT, ENK_A) > 0; // ReadInputPin returns bit state shifted by its position - convert it to TRUE or FALSE
	enk_a_prev = enk_a;
	
	enk_b = GPIO_ReadInputPin(ENK_PORT, ENK_B) > 0;
	enk_b_prev = enk_b;
	
	while (TRUE)
	{
		i++; // Increment blinking timer
		lcdUpdate++; // Increment LCD update timer
		
		// When fast blinking is enabled count to 250 ms between state change
		if (fastBlink && i >= 250)
		{
			GPIO_WriteReverse(GPIOB, GPIO_PIN_2); // Change state of LED
			i = 0; // Reset blinking timer
		}
		else if (i >= 1000) // Without fast blinking count to 1000 ms
		{
			GPIO_WriteReverse(GPIOB, GPIO_PIN_2); // Change state of LED
			i = 0; // Reset blinking timer
		}
		
		// Check LCD update timer
		if (lcdUpdate >= 250)
		{
			LCD_goto(0, 0); // Go to top left position
			LCD_putint8(val); // Display measured value
			
			lcdUpdate = 0; // Reset LCD update timer
		}
		
		delay_ms(1);
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
  GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // LED, Output, Push-Pull, Low on Init, Fast
	
	GPIO_DeInit(GPIOD);
	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // LED, Output, Push-Pull, Low on Init, Fast
	GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_IN_FL_IT); // ENK_A, Input, Floating, Interrupt
	GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_IT); // ENK_B, Input, Floating, Interrupt
	GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_FL_IT); // ENK_BTN, Input, Floating, Interrupt
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

void EXTI_setup(void)
{
	// External interrupt initialization function
	ITC_DeInit(); // Deinitialize interrupts
	ITC_SetSoftwarePriority(ITC_IRQ_PORTD, ITC_PRIORITYLEVEL_1); // Set software priority of external interrupts on PortD to 1 (0 to 3, 0 highest)
	
	EXTI_DeInit(); // Deinitialize external interrupts
	EXTI_SetExtIntSensitivity(EXTI_PORT_GPIOD, EXTI_SENSITIVITY_RISE_FALL); // Set sensitivity of external interrupts on PortD to trigger on both signal edges
	EXTI_SetTLISensitivity(EXTI_TLISENSITIVITY_RISE_ONLY); // Set sensitivity of external interrupt on TLI (Top Level Interrupt) input to rising edge only
	
	enableInterrupts(); // Enable interrupts
}