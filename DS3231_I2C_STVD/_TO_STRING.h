///////////////////////////////////////////////////////////////////////////////////////////////////
// Convert uint8_t or uint16_t value to char array (string)
//
//
// Created: 02.2020, Abev
///////////////////////////////////////////////////////////////////////////////////////////////////

// Function converts 8-bit input intiger "val" to string "*ret".
// Maximum output string is "255\0" wihich means ret should be at least 4 items long.
// Function returns always the same array length - filled with numbers or empty spaces
void uint8_to_string(uint8_t val, char *ret)
{
	uint8_t len = 1; // Starting input value length
	
	ret[0] = 0x30; // Starting 0
	ret[1] = 0x20; // Empty space
	ret[2] = 0x20; // Empty space
	ret[3] = '\0'; // End of string
	
	// Check needed length
	if (val >= 100) len = 3;
	else if (val >= 10) len = 2;
	
	// Divide input value to separate char characters
	while (val > 0)
	{
		ret[len-1] = (val % 10) + 0x30;
		val -= (val % 10);
		val = val / 10;
		len--;
	}
}

// Function converts 16-bit input intiger "val" to string "*ret".
// Maximum output string is "65535\0" wihich means ret should be at least 6 items long.
// Function returns always the same array length - filled with numbers or empty spaces
void uint_to_string(uint16_t val, char *ret)
{
	uint8_t len = 1; // Starting input value length
	
	ret[0] = 0x30; // Starting 0
	ret[1] = 0x20; // Empty space
	ret[2] = 0x20; // Empty space
	ret[3] = 0x20; // Empty space
	ret[4] = 0x20; // Empty space
	ret[5] = '\0'; // End of string
	
	// Check needed length
	if (val >= 10000) len = 5;
	else if (val >= 1000) len = 4;
	else if (val >= 100) len = 3;
	else if (val >= 10) len = 2;
	
	// Divide input value to separate char characters
	while (val > 0)
	{
		ret[len-1] = (val % 10) + 0x30;
		val -= (val % 10);
		val = val / 10;
		len--;
	}
}