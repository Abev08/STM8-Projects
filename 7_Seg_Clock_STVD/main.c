///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 communicating with STP16CP05 using software SPI and DS3231 using I2C
// Time from DS3231 is displayed on 7 segment 4 digit clock display via STP16CP05.
// This project is a combination between DS3231 I2C and shift register STP16CP05 projects.
//
// Created: 03.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"
#include "STP16CP05.h"
#include "DS3231.h"


// Definition of bits to select each digit on 7 segment 4 digit display
#define DIG1 0x7000 // Bit 16 set to 0 in last 4 bits
#define DIG2 0xB000 // Bit 15 set to 0 in last 4 bits
#define DIG3 0xD000 // Bit 14 set to 0 in last 4 bits
#define DIG4 0xE000 // Bit 13 set to 0 in last 4 bits

// Definition of numbers to display on 7 segment display
// Bits are arranged: 0b_DP_G_F_E_D_C_B_A
// Table is arranged: {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
static const uint8_t numbers[] = {0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110,
																																		0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111};
#define DP 0b10000000 // Dot between hours and minutes, only for DIG3 and DIG4


void GPIO_setup(void);
void CLOCK_setup(void);
void I2C_setup(void);


uint16_t ledBlink = 0; // Timer for blinking debugging LED
uint16_t updateTime = 1000; // Timer for reading data from DS3231
uint8_t digit = 0; // Selected digit on display
uint16_t i = 0; // Index for numbers table


main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	STP16CP05_GPIOInit();
	I2C_setup();
	
	DS3231_Init(); // Initialize DS3231 (probably not required)
	delay_us(10);
	
	
	while (TRUE)
	{
		ledBlink++;
		if (ledBlink >= 1000)
		{
			GPIO_WriteReverse(GPIOB, GPIO_PIN_2); // Blink debugging LED every 1 sec
			ledBlink = 0;
		}
		
		
		updateTime++;
		if (updateTime >= 1000) // Read data from DS3231 every ~1 sec
		{
			// Reading interval could be tweaked to read exactly every 1 sec
			DS3231_ReadAll();
			updateTime = 0;
		}
		
		
		digit = (digit + 1) % 4; // In every main loop cycle (~1 ms) change used digit
		switch (digit) // Display number on selected digit
		{
			case 0:
				i = DS3231_Data.TimeDate.Minutes % 10; // Look at 2nd digit of minutes
				if ((DS3231_Data.TimeDate.Seconds % 2) == 1) STP16CP05_Write16bits(numbers[i] | DIG4 | DP); // If seconds modulo 2 is equal to 1 display dots between hours and minutes
				else STP16CP05_Write16bits(numbers[i] | DIG4);
				break;
			case 1:
				i = DS3231_Data.TimeDate.Minutes / 10; // Look at 1st digit of minutes
				if ((DS3231_Data.TimeDate.Seconds % 2) == 1) STP16CP05_Write16bits(numbers[i] | DIG3 | DP); // If seconds modulo 2 is equal to 1 display dots between hours and minutes
				else STP16CP05_Write16bits(numbers[i] | DIG3);
				break;
			case 2:
				i = DS3231_Data.TimeDate.Hours % 10; // Look at 2nd digit of hours
				STP16CP05_Write16bits(numbers[i] | DIG2);
				break;
			case 3:
				i = DS3231_Data.TimeDate.Hours / 10; // Look at 1st digit of hours
				STP16CP05_Write16bits(numbers[i] | DIG1);
				break;
		}
		
		delay_ms(1);
	}
}


void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
	GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // DEBUGGING LED, Output, Push-Pull, Low on Init, Fast
	GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_OUT_OD_HIZ_FAST); // I2C_SCL (Open Drain)
	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_OD_HIZ_FAST); // I2C_SDA (Open Drain)
	
	GPIO_DeInit(GPIOC);
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
	
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
}

void I2C_setup(void)
{
	I2C_DeInit(); // Deinitialize I2C peripheral
	
	I2C_Init((uint32_t)400000,	// Transmission frequency in Hz - 100 kHz
										(uint16_t)0x0A,// My address - 0x0A = 10
										I2C_DUTYCYCLE_2, // Transmission duty cycle
										I2C_ACK_CURR, // ACK type
										I2C_ADDMODE_7BIT, // 7 bit address
										(uint8_t)(CLK_GetClockFreq() / 1000000)); // Frequency of peripheral clock in MHz
	
	I2C_Cmd(ENABLE); // Turn on I2C peripheral
}