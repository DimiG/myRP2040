/**
 * FILE NAME : blink_xosc_pll.s
 * AUTHOR    : DG
 * VERSION   : 1.0
 * DATE      : Apr 10, 2025
 * ABOUT     : Assembler program to blink LED connected to the
 *           : Raspberry Pi PICO GPIO 25 (internal one)
 *           : NO SDK - Tested on real MCU
 * Note      : Bare metal Assembly Clocks Default XOSC (Crystal Oscillator)
 *           : Using the Crystal Oscillator. Enabling the PLL
 */

  .section .reset, "ax"
  .global start

start:
  // Sets up the Crystal Oscillator
  ldr r0, =xosc_base    // Load XOSC base address
  mov r1, #0xaa         // Load 10101010 into r1
  lsl r1, r1, #4        // And shift to 101010100000
  str r1, [r0, #0]      // And store into XOSC:CNTL (2.16.7)
  mov r1, #47           // Load startup delay of "47" (2.16.3)
  str r1, [r0, #0xc]    // And store in XOSC:STARTUP (2.17.7)

  // Start the XOSC
  ldr r0, =xosc_aset    // Load in the XOSC atomic set register base address
  ldr r1, =xosc_en      // Load in XOSC enable word (2.16.7)
  str r1, [r0, #0]      // And store in the atomic set register for XOSC:CNTL (2.16.7)

  // Wait for the crystal to start up
  ldr r0, =xosc_base    // Load XOSC base address

xosc_rdy:
  ldr r1, [r0, #0x04]   // Load in XOSC:STATUS (2.16.7)
  lsr r1, r1, #31       // And shift over 31 bits to isolate STABLE bit
  beq xosc_rdy          // If not stable, check again

  // Now the crystal oscillator is running, switch clock sources
  ldr r0, =clck_base    // Load in clock registers base address
  mov r1, #2            // Selects the XOSC for the ref clock
  str r1, [r0, #0x30]   // Save it in CLOCKS: CLK_REF_CTRL (2.15.7)
  mov r1, #0            // Selects the ref clock for the system clock
  str r1, [r0, #0x3c]   // Save it in CLOCKS: CLK_SYS_CTRL (2.15.7)

  // Set up the PLL for XOSC
  // Bring pll out of reset
  // Releases the peripheral reset for pll_sys
  ldr r0, =rst_clr      // Atomic register for clearing reset controller (0x4000c000+0x3000)
  mov r1, #1            // Load a 1 into bit 1
  lsl r1, r1, #12       // Shift over 12 bits for pll_sys
  str r1, [r0, #0]      // Store the bitmask into the atomic register to clear register

  // Check if reset is DONE
pll_rst:
  ldr r0, =rst_base     // Base address for reset controller
  ldr r1, [r0, #8]      // Offset to get to the reset_done register
  mov r2, #1            // Load 1 in bit 1 of register 2
  lsl r2, r2, #12       // Shift over 12 bits for pll_sys
  and r1, r1, r2        // Isolate bit 12
  beq pll_rst           // If bit 12 is 0 then check again, if not, reset is DONE

  // Now enable pll_sys
  ldr r0, =pll_sys_base
  mov r1, #125          // Exact 125MHz lock at FBDIV=125, PD1=6, PD2=2 (2.18.2.1)
  str r1, [r0,#8]       // Store in PLL: FBDIV_INT (2.18.4)
  mov r1, #0x62         // PD1 = 6, PD2 = 2
  lsl r1, r1, #12       // And shift over 12 bits
  str r1, [r0, #0x0c]   // Store in PLL: PRIM (2.18.4)

  // Power up the pll
  ldr r0, =pll_sys_aclr
  mov r1, #0x21         // Clear PD, VCOPD in PLL: PWR
  str r1, [r0,#4]       // Store in PLL: PWR (2.18.4)

  // Wait for the pll to lock
  ldr r0, =pll_sys_base

pll_lock:
  ldr r1, [r0, #0]      // Load in the pll status register
  lsr r1, r1, #31       // Isolate the "pll locked" bit
  beq pll_lock          // If not locked, check again
  // Set the pll divisor here if desired

  // Now enable the pll_lock
  ldr r0, =pll_sys_aclr
  mov r1, #0x08         // Clear POSTDIVPD in PLL: PWR to power up
  str r1, [r0, #4]

  // Now switch from ref clock to pll (pll is the aux source default)
  ldr r0, =clck_base
  mov r1, #1            // Change to clksrc_clk_sys_aux in CLOCKS: CLK_SYS_CTRL (2.15.7)

  // clksrc_pll_sys is the default for clksrc_clk_sys_aux
  str r1, [r0, #0x3c]   // Store in CLOCKS: CLK_SYS_CTRL (2.15.7)

  // Releases the peripheral reset for iobank_0
  ldr r0, =rst_clr      // Atomic register for clearing reset controller (0x4000c000+0x3000)
  mov r1, #32           // Load a 1 into bit 5
  str r1, [r0, #0]      // Store the bitmask into the atomic register to clear register

  // Check if reset is DONE
rst:
  ldr r0, =rst_base     // Base address for reset controller
  ldr r1, [r0, #8]      // Offset to get to the reset_done register
  mov r2, #32           // Load 1 in bit 5 of register 2 (0000000000100000)
  and r1, r1, r2        // Isolate bit 5
  beq rst               // If bit five is 0 then check again, if not, reset is DONE

  // Set the control
  ldr r0, =ctrl_gpio25  // Control register for GPIO25
  mov r1, #5            // Function 5, select SIO for GPIO25 (2.19.2)
  str r1, [r0]          // Store function_5 in GPIO04 control register

  // Shifts over "1" the number of bits of GPIO pin
  mov r1, #1            // Load a 1 into register 1
  lsl r1, r1, #25       // Move the bit over to align with GPIO25
  ldr r0, =sio_base     // SIO base (2.3.1.7)
  str r1, [r0, #0x24]   // 0x24 GPIO output enable

led_loop:
  str r1, [r0, #20]     // 0x14 GPIO output value set
  ldr r3, =big_num      // Load countdown number
  bl delay              // Branch to subroutine delay

  str r1, [r0, #24]     // 0x18 GPIO output value clear
  ldr r3, =big_num      // Load countdown number
  bl delay              // Branch to subroutine delay

  b led_loop            // Do the loop again

delay:
  sub r3, #1            // Subtract 1 from register 3
  bne delay             // Loop back to delay if not zero
  bx lr                 // Return from subroutine

  .align 4              // Necessary alignment

  .data
  .equ xosc_base,    0x40024000  // XOSC Base address
  .equ xosc_aset,    0x40026000  // XOSC atomic set
  .equ xosc_en,      0x00fab000  // Enable for XOSC
  .equ clck_base,    0x40008000  // Clock register base address
  .equ clck_aset,    0x4000a000  // Clock atomic set
  .equ rst_clr,      0x4000f000  // Atomic register for clearing reset controller (2.1.2)
  .equ rst_base,     0x4000c000  // Reset controller base (2.14.3)
  .equ pll_sys_base, 0x40028000  // PLL system registers base address
  .equ pll_sys_aclr, 0x4002b000  // PLL system atomic clear base address
  .equ sio_base,     0xd0000000  // SIO base (2.3.1.7)
  .equ ctrl_gpio25,  0x400140cc  // GPIO25_CTRL (2.19.6.1)
  .equ big_num,      0x000f0000  // Large number for the delay loop

