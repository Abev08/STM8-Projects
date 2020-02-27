///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 communicating with LCD HD44780 using parallel communication
// The project uses part of the code from Encoder project.
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"
#include "lcd.h"
#include "_to_string.h"

// Definitions of encoder port and "buttons"
#define ENK_PORT		GPIOD
#define ENK_A				GPIO_PIN_0
#define ENK_B				GPIO_PIN_4
#define ENK_BTN			GPIO_PIN_7

void GPIO_setup(void);
void CLOCK_setup(void);

bool enk_a, enk_a_prev; // Variables for encoder state
bool enk_b, enk_b_prev;
bool counting = FALSE; // Flag signaling counting operation might be useless depending on used encoder
// My encoder have 2 defined states - both A and B low and both A and B high

uint8_t value = 0; // Counted value

int i = 0; // LCD update timer

const char txt1[] = {"TEST ENKODER"}; // Static text to display on LCD

main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();

	GPIO_WriteHigh(GPIOB, GPIO_PIN_2); // Light on LED while initializing

	LCD_init(); // Initialize LCD
	LCD_clear_home(); // Clear LCD screen

	// Read encoder status
	enk_a = GPIO_ReadInputPin(ENK_PORT, ENK_A) > 0; // ReadInputPin returns bit state shifted by its position - convert it to TRUE or FALSE
	enk_a_prev = enk_a;

	enk_b = GPIO_ReadInputPin(ENK_PORT, ENK_B) > 0;
	enk_b_prev = enk_b;

	LCD_goto(2, 1); // Display static text on LCD
	LCD_putstr(txt1);

	while (TRUE)
	{
		// Check enkoder status
		enk_a = GPIO_ReadInputPin(ENK_PORT, ENK_A) > 0;
		enk_b = GPIO_ReadInputPin(ENK_PORT, ENK_B) > 0;

		// Check if enkoder status changed
		if ((enk_a != enk_a_prev) || (enk_b != enk_b_prev))
		{
			if (counting == TRUE) _asm("nop"); // If counting flag is set - do nothing
			else if (enk_a == enk_a_prev) value--; // Encoder is rotating in one direction - decrease value
			else if (enk_b == enk_b_prev) value++; // Encoder is rotating in another direction - increase value
			
			enk_a_prev = enk_a; // Remember actual state of encoder as previous
			enk_b_prev = enk_b;

			counting = TRUE; // Set counting flag
		}

		if (enk_a == enk_b) counting = FALSE; // Reset counting flag when encoder is in one of defined positions

		if (GPIO_ReadInputPin(ENK_PORT, ENK_BTN) == 0) value = 0; // If encoder button is pressed then reset measured value

		// Update screen every 250 ms
		if (i >= 250)
		{
			LCD_goto(0, 0); // Go to top left corner
			LCD_putint8(value); // Display measured value
			
			i = 0; // Reset LCD update timer
		}

		// Represent state of encoder A and B channels on LEDs
		if (enk_a == FALSE) GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
		else GPIO_WriteLow(GPIOD, GPIO_PIN_3);

		if (enk_b == FALSE) GPIO_WriteHigh(GPIOB, GPIO_PIN_2);
		else GPIO_WriteLow(GPIOB, GPIO_PIN_2);

		i++; // Increent LCD update timer
		delay_ms(1);
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
	GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // LED, Output, Push-Pull, Fast

	GPIO_DeInit(GPIOD);
	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // LED, Output, Push-Pull, Fast
	GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_IN_FL_NO_IT);	 // ENK_A, Input, Floating, No Interrupt
	GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);	 // ENK_B, Input, Floating, No Interrupt
	GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_IN_FL_NO_IT);	 // ENK_BTN, Input, Floating, No Interrupt
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