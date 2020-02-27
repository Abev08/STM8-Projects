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


// Declaration of interrupt functions
@far @interrupt void InterruptPortD(void);
@far @interrupt void InterruptTLI(void);


struct interrupt_vector const _vectab[] = {
	{0x82, (interrupt_handler_t)_stext}, /* reset */
	{0x82, NonHandledInterrupt}, /* trap  */
	{0x82, (interrupt_handler_t)InterruptTLI}, /* irq0  */ // Assign interrupt function to TLI interrupt
	{0x82, NonHandledInterrupt}, /* irq1  */
	{0x82, NonHandledInterrupt}, /* irq2  */
	{0x82, NonHandledInterrupt}, /* irq3  */
	{0x82, NonHandledInterrupt}, /* irq4  */
	{0x82, NonHandledInterrupt}, /* irq5  */
	{0x82, (interrupt_handler_t)InterruptPortD}, /* irq6  */ // Assign PortD interrupt function to PortD interrupt
	{0x82, NonHandledInterrupt}, /* irq7  */
	{0x82, NonHandledInterrupt}, /* irq8  */
	{0x82, NonHandledInterrupt}, /* irq9  */
	{0x82, NonHandledInterrupt}, /* irq10 */
	{0x82, NonHandledInterrupt}, /* irq11 */
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
extern uint8_t val;
extern bool enk_a, enk_a_prev, enk_b, enk_b_prev, counting;

void InterruptPortD(void)
{
	// External interrupt on PortD
	// Read state of encoder "buttons"
	enk_a = GPIO_ReadInputPin(GPIOD, GPIO_PIN_0) > 0; // Convert them to TRUE or FALSE
	enk_b = GPIO_ReadInputPin(GPIOD, GPIO_PIN_4) > 0;
	
	// Counting from Encoder project
	if ((enk_a != enk_a_prev) || (enk_b != enk_b_prev))
	{
		if (counting == TRUE) _asm("nop");
		else if (enk_a == enk_a_prev) val--;
		else if (enk_b == enk_b_prev) val++;
	
		enk_a_prev = enk_a;
		enk_b_prev = enk_b;
		
		counting = TRUE;
	}
	
	if (enk_a == enk_b) counting = FALSE; // Reset counting flag when encoder is in one of defined positions
}


// External variable used in function below
extern bool fastBlink;

void InterruptTLI(void)
{
	// External interrupt on TLI pin. Encoder button is connected there.
	fastBlink ^= 1; // Change state of fastBlink external variable
}