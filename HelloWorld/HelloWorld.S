/**
 * FILE NAME : HelloWorld.S
 * AUTHOR    : DG
 * VERSION   : 1.0
 * DATE      : Feb 25, 2025
 * ABOUT     : Assembler program to print out "Hello World" using the Pico SDK
 *           : Tested on real hardware - Raspberry Pi Pico
 * NOTE      : R0 - the first parameter to printf
 *           : R1 - the second parameter to printf
 *           : R7 - index counter
 */

  .thumb_func         // Necessary because SDK uses BLX
  .global main        // Provide program starting address to linker

main:
  MOV R7, #0          // Initialize counter to 0
  BL stdio_init_all   // Initialize UART or USB

loop:
  LDR R0, =helloworld // Load address of string
  ADD R7, #1          // Increment counter
  MOV R1, R7          // Move the counter to second parameter
  BL printf           // Call the pico's printf
  B loop              // Loop forever ;)

  .data
  .align 4            // Necessary alignment

helloworld: .asciz "Hello World %d ;)\n"

