///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 using internal Timer1 to blink LED with overflow interrupt
// Encoder is used to change blink intervals in 1 sec increment / decrement.
//
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"
#include "_to_string.h"
#include "lcd.h"


// Definitions of encoder port and "buttons"
#define ENK_PORT		GPIOD
#define ENK_A				GPIO_PIN_0
#define ENK_B				GPIO_PIN_4
#define ENK_BTN			GPIO_PIN_7


void GPIO_setup(void);
void CLOCK_setup(void);
void TIM1_setup(void);


const char txt1[] = {"TEST TIMER"}; // Static text to display on LCD

bool enk_a, enk_a_prev; // Variables for encoder state
bool enk_b, enk_b_prev;
bool counting = FALSE;
char valTimerString[6]; // Blinking time converted to string to display on LCD
uint16_t time = 1953; // Starting blinking time
uint8_t lcdUpdate = 0; // "Timer" for updating LCD
bool updateTime = FALSE; // Flag to change Timer1 overflow value
bool blink = FALSE; // Flag to blink characters on LCD


main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	TIM1_setup();
	
	// Initialize LCD and clear screen
	LCD_init();
	LCD_clear_home();
	
	// Put static text on LCD
	LCD_goto(3, 1);
	LCD_putstr(txt1);
	
	// Read encoder status
	enk_a = GPIO_ReadInputPin(ENK_PORT, ENK_A) > 0; // ReadInputPin returns bit state shifted by its position - convert it to TRUE or FALSE
	enk_a_prev = enk_a;
	
	enk_b = GPIO_ReadInputPin(ENK_PORT, ENK_B) > 0;
	enk_b_prev = enk_b;
	
	while (TRUE)
	{
		lcdUpdate++; // Increment LCD update time interval
		if (lcdUpdate >= 250)
		{
			LCD_goto(0, 0); // Go to top left corner
			uint_to_string((TIM1_GetCounter() - 0) / 976, valTimerString); // Convert counted time by Timer1 to string
			LCD_putstr(valTimerString); // Display counted time
			
			LCD_goto(6, 0); // Go to 6th position on 1st row
			if (updateTime) blink ^= 1; // If changed Timer1 overflow value, blink set value
			else blink = FALSE;
			if (updateTime && blink) LCD_putstr("      "); // Display empty space for blinking
			else
			{
				uint_to_string((time - 0) / 976, valTimerString); // Convert set time to string
				LCD_putstr(valTimerString); // Display it
			}
			
			lcdUpdate = 0; // Reset LCD update timer
		}
		
		
		// Check encoder status
		enk_a = GPIO_ReadInputPin(ENK_PORT, ENK_A) > 0;
		enk_b = GPIO_ReadInputPin(ENK_PORT, ENK_B) > 0;
		
		// If encoder is rotated increment or decrement set time by 1 sec
		if (((enk_a != enk_a_prev) || (enk_b != enk_b_prev)) && (updateTime == FALSE))
		{
			if (counting == TRUE) _asm("nop");
			else if (enk_a == enk_a_prev) time -= 976;
			else if (enk_b == enk_b_prev) time += 976;
			
			enk_a_prev = enk_a;
			enk_b_prev = enk_b;
			
			counting = TRUE;
		}
		
		if (enk_a == enk_b) counting = FALSE; // Reset counting flag when encoder is in one of predefined positions
		
		if (GPIO_ReadInputPin(ENK_PORT, ENK_BTN) == 0) updateTime = TRUE; // When encoder button is pressed update Timer1 overflow value
		
		delay_ms(1); // Slow down main loop a little bit
	}
}

void GPIO_setup(void)
{
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
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE); // Enable Timer1 peripheral
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
}

void TIM1_setup(void)
{
	// Timer1 initialization function
	TIM1_DeInit(); // Deinitialize Timer1 peripheral
	
	TIM1_TimeBaseInit(16393, TIM1_COUNTERMODE_UP, time, 0); // Initialize Timer1
	// (prescaller, counting mode, overflow value, number of repetitions)
	// Counted time = (prescaller * number_of_repetitions * number_of_counts) / peripheral_clock
	// (16384 * 1 * 1953) / 16000000 = 1.9999 ~ 2 sec
	// number_of_counts is a difference between starting value and overflow value
	
	TIM1_ITConfig(TIM1_IT_UPDATE, ENABLE); // Enable Timer1 interrupt on overflow
	
	TIM1_Cmd(ENABLE); // Turn on Timer1
	
	enableInterrupts(); // Enable interrupts
}