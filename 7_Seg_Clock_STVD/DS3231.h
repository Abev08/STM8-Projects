///////////////////////////////////////////////////////////////////////////////////////////////////
// DS3231 library for STM8S MCU
// Library defines every DS3231 register, DS3231_Data variable and functions for communication
// with module and DS3231 data conversion.
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

#include "stm8s.h"

// DS3231 I2C address
#define DS3231_address		0xD0//0x68 << 1 // Adress have to be shifted 1 space to left
#define hourMode24						1 // 1 - active 24 hour mode, 0 - active 12 hour mode

// Address of every DS3231 register
#define adr_Seconds					0x00
#define adr_Minutes					0x01
#define adr_Hours							0x02
#define adr_DayOfWeek			0x03
#define adr_Day									0x04
#define adr_Month							0x05
#define adr_Year								0x06

#define adr_Alm1Sec					0x07
#define adr_Alm1Min					0x08
#define adr_Alm1Hours			0x09
#define adr_Alm1DayDate	0x0A

#define adr_Alm2Min					0x0B
#define adr_Alm2Hours			0x0C
#define adr_Alm2DayDate	0x0D

#define adr_Control					0x0E
#define adr_ControlStatus	0x0F
#define adr_Aging							0x10
#define adr_TempMSB					0x11
#define adr_TempLSB					0x12

// DS3231_Data structures
typedef struct
{
	uint8_t Seconds;
	uint8_t Minutes;
	uint8_t Hours;
	uint8_t HoursAM; // 0 - AM, 1 - PM
	uint8_t DayOfWeek;
	uint8_t Day;
	uint8_t Month;
	uint8_t Year;
	uint8_t Century; // 0 - <2100, 1 - >=2100
} DateTimeStruct; // Time and date structure

typedef struct
{
	uint8_t Alarm1_Seconds;
	uint8_t Alarm1_Minutes;
	uint8_t Alarm1_Hours;
	uint8_t Alarm1_DayOfWeek;
	uint8_t Alarm2_Minutes;
	uint8_t Alarm2_Hours;
	uint8_t Alarm2_DayOfWeek;
} AlarmsStruct; // Alarm structure

typedef struct
{
	uint8_t Control;
	uint8_t Status;
	int8_t Aging;
} ControlStruct; // Control structure

typedef struct
{
	int8_t cel; // whole degrees
	uint8_t frac; // fractions of whole degree in 0.25 increment
} TemperatureStruct; // Temperature structure

typedef struct
{
	DateTimeStruct TimeDate;
	AlarmsStruct Alarms;
	ControlStruct Control;
	TemperatureStruct Temperature;
} DS3231_DataStruct; // DS3231_Data structure

static DS3231_DataStruct DS3231_Data; // Global static variable holding DS3231 data

bool DS3231_Init(void); // Initialization function
bool DS3231_ReadAll(void); // Read all data from DS3231
bool DS3231_SetTime(uint8_t hours, uint8_t minutes, uint8_t seconds); // Set time on DS3231
bool DS3231_SetDate(uint8_t day, uint8_t month, uint8_t year, uint8_t century); // Set date on DS3231
void DS3231_GetTimeFull(char *time); // Convert time from DS3231_Data to output string
void DS3231_GetTemp(char *temp); // Convert temperature from DS3231_Data to output string
void DS3231_GetDateFull(char *date); // Convert date from DS3231_Data to output string

uint8_t dec2bcd(uint8_t dec); // DEC to BCD conversion
uint8_t bcd2dec(uint8_t bcd); // BCD to DEC conversion

// Turns on internal oscillator and changes square wave output to 1Hz
bool DS3231_Init(void)
{
	uint16_t error = 0; // Error counter
	
	I2C_AcknowledgeConfig(I2C_ACK_CURR); // Acknowledge every received byte
	
	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY)) // Wait for I2C bus
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_GenerateSTART(ENABLE); // Generate I2C start
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Check if start was generated
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_TX); // Send DS3231 address with transmit direction
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) // Wait for ACK
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData(adr_Control); // Send address of control register
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData((uint8_t)0); // Send register value
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_GenerateSTOP(ENABLE); // End transmission
	
	return FALSE;
}

// Reads all data from DS3231
bool DS3231_ReadAll(void)
{
	uint8_t numOfData = 19;
	uint8_t i = 0;
	uint16_t error = 0;
	
	I2C_AcknowledgeConfig(I2C_ACK_CURR); // Acknowledge every received byte
	
	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY)) // Wait for I2C bus
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_GenerateSTART(ENABLE); // Generate I2C start
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Check if start was generated
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_TX); // Send DS3231 address with transmit direction
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) // Wait for ACK
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData((uint8_t)adr_Seconds); // Send first data address
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for ACK
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_GenerateSTART(ENABLE); // Generate 2nd I2C start
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Check if start was generated
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_RX); // Send DS3231 address with receive direction
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED)) // Wait for ACK
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	// Receive whole data
	for (i = 0; i < numOfData; i++)
	{
		while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_RECEIVED)) // Wait for byte received
		{
			error++; // Increment error counter
			if (error >= 65000) return TRUE; // Return from function
		}
		error = 0;
		if (i == numOfData - 1) I2C_AcknowledgeConfig(I2C_ACK_NONE); // When receiving last byte change ACK mode
		
		// State machine to assign received bytes
		switch (i)
		{
			case 0:
			{
				DS3231_Data.TimeDate.Seconds = bcd2dec(I2C_ReceiveData()); // Receive seconds in BCD form
				break;
			}
			case 1:
			{
				DS3231_Data.TimeDate.Minutes = bcd2dec(I2C_ReceiveData()); // Receive minutes in BCD form
				break;
			}
			case 2:
			{
				if (hourMode24 == 0) // Check if 12 hour mode was selected
				{
					DS3231_Data.TimeDate.HoursAM = I2C_ReceiveData() & 0x3F; // Get AM indicator + hours
					DS3231_Data.TimeDate.Hours = bcd2dec(DS3231_Data.TimeDate.HoursAM & 0x1F); // From readed AM indicator + hours get hours and convert it to DEC
					DS3231_Data.TimeDate.HoursAM = DS3231_Data.TimeDate.HoursAM >> 5; // Shift AM indicator to contain only AM indicator
				}
				else DS3231_Data.TimeDate.Hours = bcd2dec(I2C_ReceiveData()); // 24 Hour mode selected, receive hours in BCD form
				break;
			}
			case 3:
			{
				DS3231_Data.TimeDate.DayOfWeek = bcd2dec(I2C_ReceiveData()); // Receive day of week (1-7) in BCD form
				break;
			}
			case 4:
			{
				DS3231_Data.TimeDate.Day = I2C_ReceiveData(); // Receive day of month in BCD form
				break;
			}
			case 5:
			{
				DS3231_Data.TimeDate.Century = I2C_ReceiveData(); // Get whole century + month
				DS3231_Data.TimeDate.Month = bcd2dec(DS3231_Data.TimeDate.Century & 0x1F); // Get rid of century bit
				DS3231_Data.TimeDate.Century = DS3231_Data.TimeDate.Century >> 7; // Shift century bit to 0 position
				break;
			}
			case 6:
			{
				DS3231_Data.TimeDate.Year = bcd2dec(I2C_ReceiveData()); // Receive year in BCD form
				break;
			}
			case 7:
			{
				DS3231_Data.Alarms.Alarm1_Seconds = bcd2dec(I2C_ReceiveData()); // Receive alarm 1 seconds in BCD form
				break;
			}
			case 8:
			{
				DS3231_Data.Alarms.Alarm1_Minutes = bcd2dec(I2C_ReceiveData()); // Receive alarm 1 minutes in BCD form
				break;
			}
			case 9:
			{
				DS3231_Data.Alarms.Alarm1_Hours = bcd2dec(I2C_ReceiveData()); // Receive alarm 1 hours in BCD form
				break;
			}
			case 10:
			{
				DS3231_Data.Alarms.Alarm1_DayOfWeek = bcd2dec(I2C_ReceiveData()); // Receive alarm 1 day of week in BCD form
				break;
			}
			case 11:
			{
				DS3231_Data.Alarms.Alarm2_Minutes = bcd2dec(I2C_ReceiveData()); // Receive alarm 2 minutes in BCD form
				break;
			}
			case 12:
			{
				DS3231_Data.Alarms.Alarm2_Hours = bcd2dec(I2C_ReceiveData()); // Receive alarm 2 hours in BCD form
				break;
			}
			case 13:
			{
				DS3231_Data.Alarms.Alarm2_DayOfWeek = bcd2dec(I2C_ReceiveData()); // Receive alarm 2 day of week in BCD form
				break;
			}
			case 14:
			{
				DS3231_Data.Control.Control = I2C_ReceiveData(); // Receive control register
				break;
			}
			case 15:
			{
				DS3231_Data.Control.Status = I2C_ReceiveData(); // Receive status register
				break;
			}
			case 16:
			{
				DS3231_Data.Control.Aging = I2C_ReceiveData(); // Receive aging register
				break;
			}
			case 17:
			{
				DS3231_Data.Temperature.cel = I2C_ReceiveData(); // Receive whole degrees of temperature sensor
				break;
			}
			case 18:
			{
				DS3231_Data.Temperature.frac = I2C_ReceiveData(); // Receive fractions of temperature sensor
				break;
			}
			default:
			{
				I2C_ReceiveData(); // Someting went wrong, just receive data
			}
		}
	}
	
	I2C_AcknowledgeConfig(I2C_ACK_NONE); // Change ACK mode
	I2C_GenerateSTOP(ENABLE); // End transmission
	
	return FALSE;
}

// Set time in DS3231
bool DS3231_SetTime(uint8_t hours, uint8_t minutes, uint8_t seconds)
{
	uint16_t error = 0;
	
	I2C_AcknowledgeConfig(I2C_ACK_CURR); // Acknowledge every received byte
	
	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY)) // Wait for I2C bus
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_GenerateSTART(ENABLE); // Generate start
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Wait for ACK
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_TX); // Send DS3231 address with transmit direction
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) // Wait for ACK
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData(adr_Seconds); // Send address of seconds register
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData(dec2bcd(seconds)); // Send new seconds value
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData(dec2bcd(minutes)); // Send new minutes value
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData(dec2bcd(hours)); // Send new hours value
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_GenerateSTOP(ENABLE); // End transmission
	
	return FALSE;
}

// Set date in DS3231
bool DS3231_SetDate(uint8_t day, uint8_t month, uint8_t year, uint8_t century)
{
	uint16_t error = 0;
	
	I2C_AcknowledgeConfig(I2C_ACK_CURR); // Acknowledge every received byte
	
	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY)) // Wait for I2C bus
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_GenerateSTART(ENABLE); // Generate start
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT)) // Wait for ACK
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_Send7bitAddress(DS3231_address, I2C_DIRECTION_TX); // Send DS3231 address with transmit direction
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED)) // Wait for ACK
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData(adr_Day); // Send address of day register
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData(day); // Send new day value
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData(dec2bcd(month) | (century << 7)); // Send new month + century value
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_SendData(dec2bcd(year)); // Send new year value
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED)) // Wait for byte transmitted
	{
		error++; // Increment error counter
		if (error >= 65000) return TRUE; // Return from function
	}
	error = 0;
	
	I2C_GenerateSTOP(ENABLE); // End transmission
	
	return FALSE;
}

// Converts previously readed data and returns time in HH:MM:SS format
// time input should be at least 9 bytes long - time[9]
void DS3231_GetTimeFull(char *time)
{
	// Hours conversion
	if (DS3231_Data.TimeDate.Hours == 199)
	{
		time[0] = 0x20;
		time[1] = 0x20;
	}
	else
	{
		time[0] = DS3231_Data.TimeDate.Hours / 10 + 0x30;
		time[1] = DS3231_Data.TimeDate.Hours % 10 + 0x30;
	}
	time[2] = ':';
	
	// Minutes conversion
	if (DS3231_Data.TimeDate.Minutes == 199)
	{
		time[3] = 0x20;
		time[4] = 0x20;
	}
	else
	{
		time[3] = DS3231_Data.TimeDate.Minutes / 10 + 0x30;
		time[4] = DS3231_Data.TimeDate.Minutes % 10 + 0x30;
	}
	time[5] = ':';
	
	// Seconds conversion
	time[6] = DS3231_Data.TimeDate.Seconds / 10 + 0x30;
	time[7] = DS3231_Data.TimeDate.Seconds % 10 + 0x30;
	time[8] = '\0';
}

// Converts previously readed data and returns temperature in CC.FF format
// temp input should be at least 7 bytes long - temp[7]
void DS3231_GetTemp(char *temp)
{
	int8_t t = DS3231_Data.Temperature.cel;
	uint8_t f = (DS3231_Data.Temperature.frac >> 6) * 25;
	
	// Sign conversion
	if (DS3231_Data.Temperature.cel < 0)
	{
		temp[0] = '-';
		t = DS3231_Data.Temperature.cel * -1;
	}
	else temp[0] = ' ';
	
	// Celcious conversion
	temp[1] = t / 10 + 0x30;
	temp[2] = t % 10 + 0x30;
	temp[3] = '.';
	
	// Fractions conversion
	temp[4] = f / 10 + 0x30;
	temp[5] = f % 10 + 0x30;
	temp[6] = '\0';
}

// Converts previously readed data and returns date in DD.MM.YYYY format
// date should be at least 11 bytes long - date[11]
void DS3231_GetDateFull(char *date)
{
	// Day conversion
	if (DS3231_Data.TimeDate.Day == 199)
	{
		date[0] = 0x20;
		date[1] = 0x20;
	}
	else
	{
		date[0] = DS3231_Data.TimeDate.Day / 10 + 0x30;
		date[1] = DS3231_Data.TimeDate.Day % 10 + 0x30;
	}
	date[2] = '.';
	
	// Month conversion
	if (DS3231_Data.TimeDate.Month == 199)
	{
		date[3] = 0x20;
		date[4] = 0x20;
	}
	else
	{
		date[3] = DS3231_Data.TimeDate.Month / 10 + 0x30;
		date[4] = DS3231_Data.TimeDate.Month % 10 + 0x30;
	}
	date[5] = '.';
	
	// Year conversion
	if (DS3231_Data.TimeDate.Year == 199)
	{
		date[6] = 0x20;
		date[7] = 0x20;
		date[8] = 0x20;
		date[9] = 0x20;
	}
	else
	{
		date[6] = '2';
		date[7] = DS3231_Data.TimeDate.Century % 10 + 0x30;
		date[8] = DS3231_Data.TimeDate.Year / 10 + 0x30;
		date[9] = DS3231_Data.TimeDate.Year % 10 + 0x30;
	}
	date[10] = '\0';
}

// DEC to BCD conversion
uint8_t dec2bcd(uint8_t dec)
{
	return ((dec / 10) << 4) | (dec % 10);
}

// BCD to DEC conversion
uint8_t bcd2dec(uint8_t bcd)
{
	return (((bcd >> 4) & 0x0F) * 10) + (bcd & 0x0F);
}