///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 Timer1 started by external interrupt, then timer starts measuring delay, after delay interrupt
// turn on LED and measure LED on time, after LED on time interrupt turn LED off and wait for next external interrupt
//
// Created: 03.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////
// Problems:
// - After firing first external interrupt timer interrupt will be immediate. Next ones will work well.
// I have bypassed this problem by firing timer interrupt just after its configuration and quickly using return in interrupt function.

#include "stm8s.h"
#include "stm8s_delay.h"
#include "_to_string.h"
#include "lcd.h"


void GPIO_setup(void);
void CLOCK_setup(void);
void EXTI_setup(void);
void TIM1_setup(void);


const char txt1[] = {"TEST COMB. INT."}; // Static text to display on LCD

uint16_t ledBlink = 0; // LED blink timer
uint16_t lcdUpdate = 0; // LCD update timer
uint16_t delayTime = 3000; // LED turn on delay
uint16_t onStateTime = 1000; // LED on state
uint8_t LEDstate = 0; // no init (0), led turned off (1), measuring delay (2), led on (3)


main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	EXTI_setup();
	TIM1_setup();
	
	
	// Initialize LCD and clear screen
	LCD_init();
	LCD_clear_home();
	
	// Put static text on LCD
	LCD_goto(0, 1);
	LCD_putstr(txt1);
	
	
	while (TRUE)
	{
		ledBlink++; // Increment LED blink "timer"
		if (ledBlink >= 1000) // Blink every 1 sec
		{
			GPIO_WriteReverse(GPIOB, GPIO_PIN_2); // Blink LED
			ledBlink = 0; // Reset blink timer
		}
		
		lcdUpdate++;
		if (lcdUpdate >= 250) // Update LCD every 250 ms
		{
			LCD_goto(0, 0);
			LCD_putint8(LEDstate); // Put LED state on LCD for debugging
			
			lcdUpdate = 0; // Reset LCD update timer
		}
		
		delay_ms(1); // Slow down main loop
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
 GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // Debugging LED, Output, Push-Pull, Low on Init, Fast
	
	GPIO_DeInit(GPIOD);
	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_OUT_PP_LOW_FAST); // LED, Output, Push-Pull, Low on Init, Fast
	GPIO_Init(GPIOD, GPIO_PIN_0, GPIO_MODE_IN_FL_NO_IT); // ENK_A, Input, Floating, No Interrupt
	GPIO_Init(GPIOD, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT); // ENK_B, Input, Floating, No Interrupt
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
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE); // Enable Timer1 peripheral
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
}

void TIM1_setup(void)
{
	// Timer1 initialization function
	TIM1_DeInit(); // Deinitialize Timer1 peripheral
	
	TIM1_TimeBaseInit(16000, TIM1_COUNTERMODE_UP, 1, 0); // Initialize Timer1
	// (prescaller, counting mode, overflow value, number of repetitions)
	// Counted time = (prescaller * number_of_repetitions * number_of_counts) / peripheral_clock
	// prescaller between 1 and 65536 in increments of 1 (only for Timer1)
	// (16000 * 1 * 1000) / 16000000 = 1 sec
	// number_of_counts is a difference between starting value and overflow value
	
	TIM1_ITConfig(TIM1_IT_UPDATE, ENABLE); // Enable Timer1 interrupt on overflow
	
	TIM1_Cmd(ENABLE); // Turn on Timer1
	
	enableInterrupts(); // Enable interrupts
}

void EXTI_setup(void)
{
	// External interrupt initialization function
	ITC_DeInit(); // Deinitialize interrupts
	ITC_SetSoftwarePriority(ITC_IRQ_PORTD, ITC_PRIORITYLEVEL_1); // Set software priority of external interrupts on PortD to 1 (0 to 3, 0 highest)
	
	EXTI_DeInit(); // Deinitialize external interrupts
	EXTI_SetTLISensitivity(EXTI_TLISENSITIVITY_RISE_ONLY); // Set sensitivity of external interrupt on TLI (Top Level Interrupt) input to rising edge only
	
	//enableInterrupts(); // Enable interrupts, already done in TIM1_setup
}