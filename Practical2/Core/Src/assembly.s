/*
 * assembly.s
 *
 */
 
 @ DO NOT EDIT
	.syntax unified
    .text
    .global ASM_Main
    .thumb_func

@ DO NOT EDIT
vectors:
	.word 0x20002000
	.word ASM_Main + 1

@ DO NOT EDIT label ASM_Main
ASM_Main:

	@ Some code is given below for you to start with
	LDR R0, RCC_BASE  		@ Enable clock for GPIOA and B by setting bit 17 and 18 in RCC_AHBENR
	LDR R1, [R0, #0x14]
	LDR R2, AHBENR_GPIOAB	@ AHBENR_GPIOAB is defined under LITERALS at the end of the code
	ORRS R1, R1, R2
	STR R1, [R0, #0x14]

	LDR R0, GPIOA_BASE		@ Enable pull-up resistors for pushbuttons
	MOVS R1, #0b01010101
	STR R1, [R0, #0x0C]
	LDR R1, GPIOB_BASE  	@ Set pins connected to LEDs to outputs
	LDR R2, MODER_OUTPUT
	STR R2, [R1, #0]
	MOVS R2, #0         	@ NOTE: R2 will be dedicated to holding the value on the LEDs

@ TODO: Add code, labels and logic for button checks and LED patternsz
main_loop:
	LDR		R3, [R0, #0X10]       	@ Load IDR

	MOVS	R4, #1
	TST		R3, R4           		@ Checks if pb0 is pressed
	BEQ		pa0_pressed          	@ brunch since PB0 is pressed

	MOVS	R4, #2
	TST		R3, R4           		@ Checks if pb1 is pressed
	BEQ		pa1_pressed          	@ brunch since PB1 is pressed

	MOVS	R4, #4
	TST		R3, R4           		@ Checks if pb2 is pressed
	BEQ  	pa2_pressed          	@ brunch since PB2 is pressed

	MOVS	R4, #8
	TST 	R3, R4           		@ Checks if pb3 is pressed
	BEQ  	pa3_pressed          	@ brunch since PB3 is pressed

	ADDS 	R2, R2, #1				@ Increment the pattern
	LDR 	R4, =LONG_DELAY_CNT   	@ Load address of the constant
    LDR 	R4, [R4]              	@ Load actual value into R3
	B 		long_delay

long_delay:
	SUBS 	R4, R4, #1           	@ R3 = R3 - 1, updates flags
    BNE 	long_delay            	@ If not zero, keep looping
    B		write_leds

write_leds:
	MOVS 	R5, #0xFF         		@ Load mask into R5
	ANDS 	R2, R2, R5        		@ keep only PB0..PB7 by using the 0xFF mask instead of incrementing through out the whole width of ODR
	STR 	R2, [R1, #0x14]
	B 		main_loop

pa0_pressed:

pa1_pressed:

pa2_pressed:

pa3_pressed:



/*main_loop:
		LDR R3, =LONG_DELAY_CNT   @ Load address of the constant
    	LDR R3, [R3]              @ Load actual value into R3
    	LDR R5, [R0, #0X10]       @ Load IDR
    	ANDS R6, R5, #1
    	BEQ  pa0_pressed
    	ANDS R6, R5, #2
    	ANDS R6, R5, #4
    	ANDS R6, R5, #8

long_delay:
    SUBS R3, R3, #1           @ R3 = R3 - 1, updates flags
    BNE long_delay            @ If not zero, keep looping
    B   write_leds             @ When zero, go write LEDs

short_delay:
    SUBS R3, R3, #1           @ R3 = R3 - 1, updates flags
    BNE short_delay            @ If not zero, keep looping
    B   write_leds             @ When zero, go write LEDs

write_leds:
	ADDS R2, R2, #1
	MOVS R4, #0xFF         @ Load mask into R3
	ANDS R2, R2, R4        @ keep only PB0..PB7 by using the 0xFF mask instead of incrementing through out the whole width of ODR
	STR R2, [R1, #0x14]
	B main_loop*/


@ LITERALS; DO NOT EDIT
	.align
RCC_BASE: 			.word 0x40021000
AHBENR_GPIOAB: 		.word 0b1100000000000000000
GPIOA_BASE:  		.word 0x48000000
GPIOB_BASE:  		.word 0x48000400
MODER_OUTPUT: 		.word 0x5555

@ TODO: Add your own values for these delays
LONG_DELAY_CNT: 	.word 1500000
SHORT_DELAY_CNT: 	.word 642857
