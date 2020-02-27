///////////////////////////////////////////////////////////////////////////////////////////////////
// STM8S105K6 communicating with DS3231 by hardware I2C
// and displaying DS3231 data on LCD
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"
#include "stm8s_delay.h"
#include "lcd.h"
#include "_to_string.h"
#include "DS3231.h"

void GPIO_setup(void);
void CLOCK_setup(void);
void I2C_setup(void);

uint8_t i = 0;

char time[9]; // Char arrays to hold converted DS3231 data
char temp[7];
char date[11];

bool enk_a, enk_a_prev; // Encoder will be used as 2 buttons
bool enk_b, enk_b_prev;
bool enk_btn, enk_btn_prev;

uint16_t lcdUpdate = 1000; // LCD update interval
uint16_t lcdUpdateTime;

uint16_t setTime = 0; // Variables used to set actual time and date
bool settingTime = FALSE;
uint8_t setIndex = 0;
uint8_t setNewVal = 255;
bool setTimeNext = FALSE;
uint16_t setTimeBlink = 0;
bool setTimeBlinkB = FALSE;
bool setTimeUpdateLCD = FALSE;
uint8_t setTimeIncrement = 0;
bool setTimeIncrementing = FALSE;
uint8_t incrementTime = 50;

bool error = FALSE;

main()
{
	// Initialization functions
	GPIO_setup();
	CLOCK_setup();
	I2C_setup();
	
	LCD_init(); // Initialize LCD
	LCD_clear_home();
	
	for (i = 0; i < 4; i++) // Blink LED 2 times when turning on
	{
		GPIO_WriteReverse(GPIOB, GPIO_PIN_2);
		delay_ms(100);
	}
	
	delay_ms(2000); // Wait 2 sec for DS3231 module to turn on
	
	error |= DS3231_Init(); // Initialize DS3231 (probably not required)
	delay_us(10);
	
	
	// Setting time and date in code
	//DS3231_SetTime(8, 9, 0);
	//delay_us(10);
	//DS3231_SetDate(10, 11, 12, 0); // Century - 0 for years <2100 or 1 for years >=2100
	//delay_us(10);
	
	
	// Read encoder status
	enk_a = GPIO_ReadInputPin(GPIOD, GPIO_PIN_0) > 0; // ReadInputPin returns bit state shifted by its position - convert it to TRUE or FALSE
	enk_a_prev = enk_a;
	enk_b = GPIO_ReadInputPin(GPIOD, GPIO_PIN_4) > 0;
	enk_b_prev = enk_b;
	enk_btn = GPIO_ReadInputPin(GPIOD, GPIO_PIN_7) > 0;
	enk_btn_prev = enk_btn;
	
	
	while (TRUE)
	{
		// Read actual encoder status
		enk_a = GPIO_ReadInputPin(GPIOD, GPIO_PIN_0) > 0;
		enk_btn = GPIO_ReadInputPin(GPIOD, GPIO_PIN_7) > 0;
		
		// Update LCD every ~1 sec or when setting time every ~40 ms (blinking)
		lcdUpdateTime = 1000;
		if ((settingTime == TRUE) && (enk_btn == FALSE)) lcdUpdateTime = 40;
		// Update LCD
		if ((lcdUpdate >= lcdUpdateTime) || (setTimeUpdateLCD == TRUE))
		{
			setTimeUpdateLCD = FALSE; // Reset forced LCD update
			GPIO_WriteReverse(GPIOB, GPIO_PIN_2); // Every LCD update blink LED, just for debugging
			
			if (settingTime == FALSE) error |= DS3231_ReadAll(); // If setting time is not active then read DS3231 data
			
			DS3231_GetTimeFull(time); // Convert data from DS3231_Data variable to char arrays to put on LCD
			DS3231_GetTemp(temp);
			DS3231_GetDateFull(date);
			
			// Send converted data to LCD
			LCD_goto(0, 0);
			LCD_putstr(time);
			
			LCD_goto(10, 0);
			LCD_putstr(temp);
			
			LCD_goto(0, 1);
			LCD_putstr(date);
			
			lcdUpdate = 0; // Reset LCD update interval
		}
		
		
		// Check if button for setting time is pressed
		if (enk_a != enk_a_prev) {
			if (settingTime == FALSE) setTime++;
			else setTimeNext = TRUE;
		}
		else if (settingTime == FALSE) setTime = 0;
		
		
		// Update LCD character blinking
		if (setTimeBlink >= 250)
		{
			setTimeBlinkB = !setTimeBlinkB;
			setTimeBlink = 0; // Reset interval for blinking LCD character
			setTimeUpdateLCD = TRUE; // Force LCD update
		}
		
		
		// Set actual time and date
		if ((setTime >= 2000) || (settingTime == TRUE))
		{
			enk_a_prev = enk_a; // Remember actual button state as previous
			settingTime = TRUE; // Remember that setting time and date is active
			DS3231_Data.TimeDate.Seconds = 0; // I don't want to set actual seconds so reset it
			
			// Simple state machine to sequentially set hours, minutes, day, month and year
			switch (setIndex)
			{
				case 0:
				{
					// SET HOUR
					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Hours; // Read previously set data from DS3231
					
					// Check if button is pressed or measured time for button holding passed
					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
					{
						// If value was incremented when characters on LCD was not showing then force it to show
						if (setTimeBlinkB == FALSE)
						{
							setTimeBlink = 0; // Reset blink timer
							setTimeBlinkB = FALSE; // Force LCD to show values
							setTimeUpdateLCD = TRUE; // Force LCD to update
						}
						setNewVal = (setNewVal + 1) % 24; // Increment new value for hours
						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
						setTimeIncrement = 0; // Reset time for button holding incrementing
					}
					
					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Hours = setNewVal; // Display new value
					else DS3231_Data.TimeDate.Hours = 199; // Display blank space (handled in DS3231_GetTimeFull())
					
					// Check if button for going to next state was pressed (traverse only when displaying actual value)
					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
					{
						setTimeNext = FALSE; // Reset state machine traverse time
						setNewVal = 255; // Reset new value
						setIndex = 1; // Traverse to next state
					}
					break;
				}
				case 1:
				{
					// SET MINUTES
					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Minutes; // Read previously set data from DS3231
					
					// Check if button is pressed or measured time for button holding passed
					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
					{
						// If value was incremented when characters on LCD was not showing then force it to show
						if (setTimeBlinkB == FALSE)
						{
							setTimeBlink = 0; // Reset blink timer
							setTimeBlinkB = FALSE; // Force LCD to show values
							setTimeUpdateLCD = TRUE; // Force LCD to update
						}
						setNewVal = (setNewVal + 1) % 60; // Increment new value for minutes
						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
						setTimeIncrement = 0; // Reset time for button holding incrementing
					}
					
					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Minutes = setNewVal; // Display new value
					else DS3231_Data.TimeDate.Minutes = 199; // Display blank space (handled in DS3231_GetTimeFull())
					
					// Check if button for going to next state was pressed (traverse only when displaying actual value)
					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
					{
						setTimeNext = FALSE; // Reset state machine traverse time
						setNewVal = 255; // Reset new value
						setIndex = 10; // Traverse to next state
					}
					break;
				}
				case 10:
				{
					// SET DAY
					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Day; // Read previously set data from DS3231
					
					// Check if button is pressed or measured time for button holding passed
					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
					{
						// If value was incremented when characters on LCD was not showing then force it to show
						if (setTimeBlinkB == FALSE)
						{
							setTimeBlink = 0; // Reset blink timer
							setTimeBlinkB = FALSE; // Force LCD to show values
							setTimeUpdateLCD = TRUE; // Force LCD to update
						}
						setNewVal++; // Increment new value for day
						if (setNewVal >= 32) setNewVal = 1; // When passing 31 days reset days couting to 1
						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
						setTimeIncrement = 0; // Reset time for button holding incrementing
					}
					
					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Day = setNewVal; // Display new value
					else DS3231_Data.TimeDate.Day = 199; // Display blank space (handled in DS3231_GetTimeFull())
					
					// Check if button for going to next state was pressed (traverse only when displaying actual value)
					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
					{
						setTimeNext = FALSE; // Reset state machine traverse time
						setNewVal = 255; // Reset new value
						setIndex = 11; // Traverse to next state
					}
					break;
				}
				case 11:
				{
					// SET MONTH
					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Month; // Read previously set data from DS3231
					
					// Check if button is pressed or measured time for button holding passed
					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
					{
						// If value was incremented when characters on LCD was not showing then force it to show
						if (setTimeBlinkB == FALSE)
						{
							setTimeBlink = 0; // Reset blink timer
							setTimeBlinkB = FALSE; // Force LCD to show values
							setTimeUpdateLCD = TRUE; // Force LCD to update
						}
						setNewVal++; // Increment new value for month
						if (setNewVal >= 13) setNewVal = 1; // If passed 12 months reset months counting to 1
						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
						setTimeIncrement = 0; // Reset time for button holding incrementing
					}
					
					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Month = setNewVal; // Display new value
					else DS3231_Data.TimeDate.Month = 199; // Display blank space (handled in DS3231_GetTimeFull())
					
					// Check if button for going to next state was pressed (traverse only when displaying actual value)
					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
					{
						setTimeNext = FALSE; // Reset state machine traverse time
						setNewVal = 255; // Reset new value
						setIndex = 12; // Traverse to next state
					}
					break;
				}
				case 12:
				{
					// SET YEAR
					if (setNewVal == 255) setNewVal = DS3231_Data.TimeDate.Year; // Read previously set data from DS3231
					
					// Check if button is pressed or measured time for button holding passed
					if (((enk_btn == TRUE) && (enk_btn_prev == FALSE)) || (setTimeIncrement >= incrementTime))
					{
						// If value was incremented when characters on LCD was not showing then force it to show
						if (setTimeBlinkB == FALSE)
						{
							setTimeBlink = 0; // Reset blink timer
							setTimeBlinkB = FALSE; // Force LCD to show values
							setTimeUpdateLCD = TRUE; // Force LCD to update
						}
						setNewVal++; // Increment new value for year
						if (setNewVal >= 100)
						{
							DS3231_Data.TimeDate.Century = !DS3231_Data.TimeDate.Century; // If passed 100 years change state of century bit
							setNewVal = 0; // If passed 100 years reset years counting
						}
						if (setTimeIncrement >= incrementTime) setTimeIncrementing = TRUE; // Increased value when holding the button
						setTimeIncrement = 0; // Reset time for button holding incrementing
					}
					
					if (setTimeBlinkB == FALSE) DS3231_Data.TimeDate.Year = setNewVal; // Display new value
					else DS3231_Data.TimeDate.Year = 199; // Display blank space (handled in DS3231_GetTimeFull())
					
					// Check if button for going to next state was pressed (traverse only when displaying actual value)
					if ((setTimeNext == TRUE) && (setTimeBlinkB == FALSE))
					{
						setTimeNext = FALSE; // Reset state machine traverse time
						setNewVal = 255; // Reset new value
						setIndex = 100; // Traverse to next state
					}
					break;
				}
				case 100:
				{
					// FIN
					// Send the set time and date to DS3231
					error |= DS3231_SetTime(DS3231_Data.TimeDate.Hours, DS3231_Data.TimeDate.Minutes, 0);
					delay_us(10);
					error |= DS3231_SetDate(DS3231_Data.TimeDate.Day, DS3231_Data.TimeDate.Month, DS3231_Data.TimeDate.Year, DS3231_Data.TimeDate.Century);
					delay_us(10);
					
					setIndex = 0; // Reset state machine
					settingTime = FALSE; // Reset remembered setting time variable
					break;
				}
			}
		}
		
		
		// Check if error was present
		if (error == TRUE) GPIO_WriteHigh(GPIOD, GPIO_PIN_3);
		else GPIO_WriteLow(GPIOD, GPIO_PIN_3);
		if (enk_btn == FALSE) error = FALSE; // Reset error state when button was pressed
		
		
		enk_btn_prev = enk_btn; // Remember actual button state as previous
		
		// Check if setting time is active
		if (settingTime == TRUE)
		{
			if (enk_btn == TRUE)
			{
				// Button is not pressed
				setTimeBlink++; // Increment LCD character blinking
				setTimeIncrementing = FALSE; // Reset flag for incrementing values while holding the button
			}
			if (enk_btn == FALSE)
			{
				// Button is pressed
				if (setTimeIncrementing == TRUE) enk_btn_prev = TRUE; // While incrementing by button holding is active force previus button state
				// to not pressed for not incrementing on button release
				setTimeBlinkB = FALSE; // Force new value display on LCD
				setTimeIncrement++; // Update button holding incrementing time
			}
			else setTimeIncrement = 0; // Reset button holding incrementing time
		}
		lcdUpdate++; // Update LCD update time
		delay_ms(1); // Delay whole loop - every cycle will take ~1 ms
	}
}

void GPIO_setup(void)
{
	GPIO_DeInit(GPIOB);
  GPIO_Init(GPIOB, GPIO_PIN_2, GPIO_MODE_OUT_PP_LOW_FAST); // DEBUGGING LED
	GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_OUT_OD_HIZ_FAST); // I2C_SCL (Open Drain)
	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_OD_HIZ_FAST); // I2C_SDA (Open Drain)
	
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
	
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE); // Enable I2C peripheral
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, DISABLE);
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
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