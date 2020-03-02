
#include "stm8s.h"

typedef void @far (*interrupt_handler_t)(void);

struct interrupt_vector {
	unsigned char interrupt_instruction;
	interrupt_handler_t interrupt_handler;
};

@far @interrupt void NonHandledInterrupt (void)
{
	/* in order to detect unexpected events during development, 
	   it is recommended to set a breakpoint on the following instruction
	*/
	return;
}

extern void _stext();     /* startup routine */


// Declaration of interrupt function
@far @interrupt void TIM1_Update_Interrupt(void);
@far @interrupt void TLI_Interrupt(void);


struct interrupt_vector const _vectab[] = {
	{0x82, (interrupt_handler_t)_stext}, /* reset */
	{0x82, NonHandledInterrupt}, /* trap  */
	{0x82, (interrupt_handler_t)TLI_Interrupt}, /* irq0  */ // Assign interrupt function to TLI interrupt
	{0x82, NonHandledInterrupt}, /* irq1  */
	{0x82, NonHandledInterrupt}, /* irq2  */
	{0x82, NonHandledInterrupt}, /* irq3  */
	{0x82, NonHandledInterrupt}, /* irq4  */
	{0x82, NonHandledInterrupt}, /* irq5  */
	{0x82, NonHandledInterrupt}, /* irq6  */
	{0x82, NonHandledInterrupt}, /* irq7  */
	{0x82, NonHandledInterrupt}, /* irq8  */
	{0x82, NonHandledInterrupt}, /* irq9  */
	{0x82, NonHandledInterrupt}, /* irq10 */
	{0x82, (interrupt_handler_t)TIM1_Update_Interrupt}, /* irq11 */ // Assign interrupt function to Timer1 overflow
	{0x82, NonHandledInterrupt}, /* irq12 */
	{0x82, NonHandledInterrupt}, /* irq13 */
	{0x82, NonHandledInterrupt}, /* irq14 */
	{0x82, NonHandledInterrupt}, /* irq15 */
	{0x82, NonHandledInterrupt}, /* irq16 */
	{0x82, NonHandledInterrupt}, /* irq17 */
	{0x82, NonHandledInterrupt}, /* irq18 */
	{0x82, NonHandledInterrupt}, /* irq19 */
	{0x82, NonHandledInterrupt}, /* irq20 */
	{0x82, NonHandledInterrupt}, /* irq21 */
	{0x82, NonHandledInterrupt}, /* irq22 */
	{0x82, NonHandledInterrupt}, /* irq23 */
	{0x82, NonHandledInterrupt}, /* irq24 */
	{0x82, NonHandledInterrupt}, /* irq25 */
	{0x82, NonHandledInterrupt}, /* irq26 */
	{0x82, NonHandledInterrupt}, /* irq27 */
	{0x82, NonHandledInterrupt}, /* irq28 */
	{0x82, NonHandledInterrupt}, /* irq29 */
};


// External variables used in functions below
extern uint16_t delayTime;
extern uint16_t onStateTime;
extern uint8_t LEDstate;

void TIM1_Update_Interrupt(void)
{
	// Interrupt on Timer1 overflow
	
	TIM1_ClearFlag(TIM1_FLAG_UPDATE); // Clear Timer1 overflow flag
	
	if (LEDstate == 0) // LED state not initialized
	{
		TIM1_Cmd(DISABLE); // Turn off Timer1
		return;
	}
	
	LEDstate++; // Increment LED state
	
	if (LEDstate == 3) // LED state on
	{
		GPIO_WriteHigh(GPIOD, GPIO_PIN_3); // Turn on LED
		TIM1_SetAutoreload(onStateTime); // Change overflow value
	}
	else
	{
		// Different LED state
		GPIO_WriteLow(GPIOD, GPIO_PIN_3); // Turn off LED
		LEDstate = 1; // Reset LED state
		TIM1_Cmd(DISABLE); // Turn off Timer1
		//TIM1_SetCounter((uint16_t)0); // Reset Timer1 counter value
	}
}

void TLI_Interrupt(void)
{
	// External interrupt on TLI pin. Encoder button is connected there.
	
	LEDstate = 2; // Start delay measurement
	
	TIM1_SetAutoreload(delayTime); // Change overflow value
	TIM1_Cmd(ENABLE); // Turn on Timer1
}