/**
 * File Name : blink_ringosc.s
 * Author    : DG
 * Version   : 1.0
 * Date      : Mar 20, 2025
 * About     : Assembler program to blink LED connected to the
 *           : Raspberry Pi PICO GPIO 25 (internal one)
 *           : NO SDK
 * Note      : Bare metal Assembly Clocks Default ROSC (Ring Oscillator)
 *           : clk_sys and clk_ref running about 6.5MHz (section 2.7)
 *           : The SECOND method of installing the oscillator
 */

  .section .reset, "ax"
  .global start

start:
  // Sets up FREQa and FREQB
  ldr r0, =rosc_base      // Ring oscillator base
  ldr r1, =rosc_powr      // Load password and values for FREQA and FREQB
  str r1, [r0, #0x04]     // Store password and values into FREQA register (2.17.8)
  str r1, [r0, #0x08]     // Store password and values into FREQB register (2.17.8)

  // This sets up the ROSC clock divider
  mov r1, #0xaa           // Load 10101010 into r1
  lsl r1, r1, #4          // Move to 101010100000
  add r1, r1, #16         // Divider equals 16 (Low Speed)
  str r1, [r0, #0x10]     // Store in div register

  // This sets up the ROSC speed
  ldr r1, =rosc_freq      // Load base frequency range and ROSC enable
  add r1, r1, #4          // Select "low" speed (4=low, 5=med, 6=toohigh) 2.17.8
  str r1, [r0, #0]        // Store in ROSC control register

  // Releases the peripheral reset for iobank_0
  ldr r0, =rst_clr        // Atomic register for clearing reset controller (0x4000c000+0x3000)
  mov r1, #32             // Load a 1 into bit 5
  str r1, [r0, #0]        // Store the bitmask into the atomic register to clear register

rst:
  // Check if reset is DONE
  ldr r0, =rst_base       // Base address for reset controller
  ldr r1, [r0, #8]        // Offset to get to the reset_done register
  mov r2, #32             // Load 1 in bit 5 of register 2 (0000000000100000)
  and r1, r1, r2          // Isolate bit 5
  beq rst                 // If bit five is 0 then check again, if not, reset is done

  // Set the control
  ldr r0, =ctrl_gpio25    // Control register for GPIO25
  mov r1, #5              // Function 5, select SIO for GPIO25 2.19.2
  str r1, [r0]            // Store function_5 in GPIO04 control register

  // Shifts over "1" the number of bits of GPIO pin
  mov r1, #1              // Load a 1 into register 1
  lsl r1, r1, #25         // Move the bit over to align with GPIO25 or #4 for GPIO4
  ldr r0, =sio_base       // SIO base
  str r1, [r0, #36]       // 0x20 GPIO output enable

led_loop:
  str r1, [r0, #20]       // 0x14 GPIO output value set
  ldr r3, =big_num        // Load countdown number
  bl delay                // Branch to subroutine delay

  str r1, [r0, #24]       // 0x18 GPIO output value clear
  ldr r3, =big_num        // Load countdown number
  bl delay                // Branch to subroutine delay

  b led_loop              // Do the loop again

delay:
  sub r3, #1              // Subtract 1 from register 3
  bne delay               // Loop back to delay if not zero
  bx lr                   // Return from subroutine

  .align 4                // Necessary alignment

  .data
  .equ rosc_base,   0x40060000  // Ring oscillator base (2.17.8)
  .equ rosc_powr,   0x96967777  // Full strength for rosc FREQA and FREQB (2.17.8)
  .equ rosc_freq,   0x00fabfa0  // Base for rosc frequency range, add 4 through 8
  .equ rst_clr,     0x4000f000  // Atomic register for clearing reset controller (2.1.2)
  .equ rst_base,    0x4000c000  // Reset controller base (2.14.3)
  .equ ctrl_gpio25, 0x400140cc  // GPIO25_CTRL (2.19.6.1)
  .equ sio_base,    0xd0000000  // SIO base (2.3.1.7)
  .equ big_num,     0x000f0000  // Large number for the delay loop

