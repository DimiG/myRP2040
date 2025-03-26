/**
 * File Name : blink.s
 * Author    : DG
 * Version   : 1.0
 * Date      : Feb 25, 2025
 * About     : Assembler program to flash LED connected to the
 *           : Raspberry Pi Pico GPIO (writing to the registers directly)
 */

  .global start

  // Bare Metal Assembly Blinking Routine
  // The internal LED is located on GPIO 25

start:
  // Releases the peripheral reset for iobank_0
  ldr r0, =rst_clr      // Atomic register for clearing reset controller (0x4000c000+0x3000)
  mov r1, #32           // Load a 1 into bit 5
  str r1, [r0, #0]      // Store the bitmask into the atomic register to clear register

rst:
  // Check if reset is DONE
  ldr r0, =rst_base     // Base address for reset controller
  ldr r1, [r0, #8]      // Offset to get to the reset_done register
  mov r2, #32           // Load 1 in bit 5 of register 2 (...0000000000100000)
  and r1, r1, r2        // Isolate bit 5
  beq rst               // If bit five is 0 then check again, if not, reset is done

  // Set the control
  ldr r0, =ctrl_gpio25  // Control register for GPIO25
  mov r1, #5            // Function 5, select SIO for GPIO25 (see RP2040 datasheet 2.19.2)
  str r1, [r0]          // Store function_5 in GPIO25 control register

  // Shifts over "1" the number of bits of GPIO pin
  mov r1, #1            // Load a 1 into register 1
  lsl r1, r1, #25       // Move the bit over to align with GPIO25
  ldr r0, =sio_base     // SIO base
  str r1, [r0, #36]     // 0x20 GPIO output enable

led_loop:
  // Blink loop
  str r1, [r0, #20]     // 0x14 GPIO output value set
  ldr r3, =big_num      // Load countdown number
  bl delay              // Branch to subroutine delay

  str r1, [r0, #24]     // 0x18 GPIO output value clear
  ldr r3, =big_num      // Load countdown number
  bl delay              // Branch to subroutine delay

  b led_loop            // Do the loop again

delay:
  // Delay function
  sub r3, #1            // Subtract 1 from register 3
  bne delay             // Loop back to delay if not zero
  bx lr                 // Return from subroutine

data:
  .equ big_num,     0x00f00000  // Large number for the delay loop function
  .equ ctrl_gpio25, 0x400140cc  // GPIO25_CTRL (see RP2040 datasheet 2.19.6.1)
  .equ rst_base,    0x4000c000  // Reset controller base (see RP2040 datasheet 2.14.3)
  .equ rst_clr,     0x4000f000  // Atomic register for clearing reset controller (see RP2040 datasheet 2.1.2)
  .equ sio_base,    0xd0000000  // SIO base (see RP2040 datasheet 2.3.1.7)

