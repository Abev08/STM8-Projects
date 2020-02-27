///////////////////////////////////////////////////////////////////////////////////////////////////
// LCD HD44780 library for STM8S MCU
// Library defines every HD44780 register and functions for parallel communication.
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"

// External needed functions
extern void delay_ms(unsigned int);
extern void uint8_to_string(uint8_t val, char *ret);

#define LCD_PORT              GPIOC

#define LCD_RS                GPIO_PIN_1
#define LCD_RW								GPIO_PIN_2
#define LCD_EN                GPIO_PIN_3
#define LCD_DB4               GPIO_PIN_4
#define LCD_DB5               GPIO_PIN_5
#define LCD_DB6               GPIO_PIN_6
#define LCD_DB7               GPIO_PIN_7

#define clear_display         0x01
#define goto_home             0x02
#define cursor_direction_inc	(0x04 | 0x02)
#define cursor_direction_dec  (0x04 | 0x00)
#define display_shift         (0x04 | 0x01)
#define display_no_shift      (0x04 | 0x00)

#define display_on            (0x08 | 0x04)
#define display_off           (0x08 | 0x02)
#define cursor_on             (0x08 | 0x02)
#define cursor_off            (0x08 | 0x00)
#define blink_on              (0x08 | 0x01)
#define blink_off             (0x08 | 0x00)

#define _8_pin_interface      (0x20 | 0x10)
#define _4_pin_interface      (0x20 | 0x00)
#define _2_row_display        (0x20 | 0x08)
#define _1_row_display        (0x20 | 0x00)
#define _5x10_dots            (0x20 | 0x40)
#define _5x7_dots             (0x20 | 0x00)

#define DAT                   1
#define CMD                   0


void LCD_GPIO_init(void);
void LCD_init(void);
void LCD_send(unsigned char value, unsigned char mode);
void LCD_4bit_send(unsigned char lcd_data);
void LCD_putstr(char *lcd_string);
void LCD_putchar(char char_data);
void LCD_putint8(uint8_t number);
void LCD_clear_home(void);
void LCD_goto(unsigned char  x_pos, unsigned char  y_pos);
void toggle_EN_pin(void);
void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num);


// Initialize GPIO pins
void LCD_GPIO_init(void)
{
	GPIO_Init(LCD_PORT, LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
	GPIO_Init(LCD_PORT, LCD_RW, GPIO_MODE_OUT_PP_HIGH_FAST);
	GPIO_Init(LCD_PORT, LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
	GPIO_Init(LCD_PORT, LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
	GPIO_Init(LCD_PORT, LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
	GPIO_Init(LCD_PORT, LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
	GPIO_Init(LCD_PORT, LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
	delay_ms(10);
	
	GPIO_WriteLow(LCD_PORT, LCD_RW);
}

// Initialize LCD
void LCD_init(void)
{
	LCD_GPIO_init();
	toggle_EN_pin();
	
	GPIO_WriteLow(LCD_PORT, LCD_RS);
	GPIO_WriteLow(LCD_PORT, LCD_DB7);
	GPIO_WriteLow(LCD_PORT, LCD_DB6);
	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
	GPIO_WriteHigh(LCD_PORT, LCD_DB4);
	toggle_EN_pin();
	
	GPIO_WriteLow(LCD_PORT, LCD_DB7);
	GPIO_WriteLow(LCD_PORT, LCD_DB6);
	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
	GPIO_WriteHigh(LCD_PORT, LCD_DB4);
	toggle_EN_pin();
	
	GPIO_WriteLow(LCD_PORT, LCD_DB7);
	GPIO_WriteLow(LCD_PORT, LCD_DB6);
	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
	GPIO_WriteHigh(LCD_PORT, LCD_DB4);
	toggle_EN_pin();
	
	GPIO_WriteLow(LCD_PORT, LCD_DB7);
	GPIO_WriteLow(LCD_PORT, LCD_DB6);
	GPIO_WriteHigh(LCD_PORT, LCD_DB5);
	GPIO_WriteLow(LCD_PORT, LCD_DB4);
	toggle_EN_pin();
	
	LCD_send((_4_pin_interface | _2_row_display | _5x7_dots), CMD);
	LCD_send((display_on | cursor_off | blink_off), CMD);
	LCD_send(clear_display, CMD);
	LCD_send((cursor_direction_inc | display_no_shift), CMD);
}

// Send data or command to LCD (change state of RS pin then send data)
void LCD_send(unsigned char value, unsigned char mode)
{
	switch(mode)
	{
		case DAT:
		{
			GPIO_WriteHigh(LCD_PORT, LCD_RS);
			break;
		}
		case CMD:
		{
			GPIO_WriteLow(LCD_PORT, LCD_RS);
			break;
		}
	}
	
	LCD_4bit_send(value);
}

// Send 4 bit data
void LCD_4bit_send(unsigned char lcd_data)       
{
	toggle_io(lcd_data, 7, LCD_DB7);
	toggle_io(lcd_data, 6, LCD_DB6);
	toggle_io(lcd_data, 5, LCD_DB5);
	toggle_io(lcd_data, 4, LCD_DB4);
	toggle_EN_pin();
	toggle_io(lcd_data, 3, LCD_DB7);
	toggle_io(lcd_data, 2, LCD_DB6);
	toggle_io(lcd_data, 1, LCD_DB5);
	toggle_io(lcd_data, 0, LCD_DB4);
	toggle_EN_pin();
}

// Send string to LCD
void LCD_putstr(char *lcd_string)
{
	do
	{
		LCD_send(*lcd_string++, DAT);
	} while(*lcd_string != '\0');
}

// Send char to LCD
void LCD_putchar(char char_data)
{
	LCD_send(char_data, DAT);
}

// Clear LCD screen and change cursor position to home
void LCD_clear_home(void)
{
	LCD_send(clear_display, CMD);
	LCD_send(goto_home, CMD);
}

// Change cursor position
void LCD_goto(unsigned char x_pos, unsigned char y_pos)
{
	if(y_pos == 0) LCD_send((0x80 | x_pos), CMD);
	else LCD_send((0x80 | 0x40 | x_pos), CMD);
}

// Toggle enable pin
void toggle_EN_pin(void)
{
	GPIO_WriteHigh(LCD_PORT, LCD_EN);
	delay_ms(2);
	GPIO_WriteLow(LCD_PORT, LCD_EN);
}

// Set / reset IO pin
void toggle_io(unsigned char lcd_data, unsigned char bit_pos, unsigned char pin_num)
{
	bool temp = FALSE;
	
	temp = (0x01 & (lcd_data >> bit_pos));
	
	switch(temp)
	{
		case TRUE:
		{
			GPIO_WriteHigh(LCD_PORT, pin_num);
			break;
		}
		default:
		{
			GPIO_WriteLow(LCD_PORT, pin_num);
			break;
		}
	}
}

// Send uint8_t value to LCD (convert to string and send)
void LCD_putint8(uint8_t number)
{
	char temp[4];
	uint8_to_string(number, temp);
	
	LCD_putstr(temp);
}