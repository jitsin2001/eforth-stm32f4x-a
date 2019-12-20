
@ .global ENTRY &c.:
@ https://developer.arm.com/docs/100068/0611/migrating-from-armasm-to-the-armclang-integrated-assembler/miscellaneous-directives

.syntax unified
.cpu cortex-m4
@ https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/decoding-the-startup-file-for-arm-cortex-m4
@ PRESERVE8
.thumb
@ https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/decoding-the-startup-file-for-arm-cortex-m4
@ AREA RESET, DATA, READONLY

@ Available section flags include the following:

@ a specifies that the section is allocatable.
@ x specifies that the section is executable.
@ w specifies that the section is writable.
@ S specifies that the section contains null-terminated string

@ quote a here not quote x
.section .reset, "ax" @ AREA RESET, DATA, READONLY
.global __Vectors @ used as EXPORT
@ "w" would be writeable so "x" is readonly executable.
@ https://developer.arm.com/docs/dui0742/latest/migrating-from-armasm-to-the-armclang-integrated-assembler/sections

@ DCD is same as .word

__Vectors:
  .word 0x20001000
  .word Reset_Handler
  .balign

.section .mycode, "ax" @ AREA MYCODE, CODE, READONLY
.global Reset_Handler

Reset_Handler:
    .global __main

__main:
  ldr r0, set_gpio_dir
  blx r0
loop:
  ldr r0, clear_leds
  blx r0
  ldr r0, delay_some
  blx r0
  ldr r0, set_leds
  blx r0
  ldr r0, delay_some
  blx r0
  b loop

.equ RCC        ,   0x40023800

set_gpio_dir:
  ldr r0, = RCC
  ldr r1, [r0, #0x30] @ RCC_AHB1ENR
  orr r1, #4 @ GPIOCEN #8 for GPIOD, want GPIOC
  str r1, [r0, #0x30]

  ldr r0, = 0x40020800 @ GPIOC maybe
  ldr r1, [r0, #0x00] @ GPIOx_MODER
  bic r1, #0x0000000C @ Mask PORT_C_01
  orr r1, #0x00000004 @ Output
  str r1, [r0, #0x00]
  bx lr

@ want PORT_C_PIN_1:  aka D13
set_leds:
  ldr r0, =0x40020800
  ldr r1, [r0, #0x14]
  orr r1, #0x0002
  str r1, [r0, #0x14]
  bx lr

clear_leds:
  ldr r0, =0x40020800
  ldr r1, [r0, #0x14]
  bic r1, #0x0002
  str r1, [r0, #0x14]
  bx lr

delay_some:
  movw r3, #0x0000
  movt r3, #0x0004
__delay_loop:
  cbz r3, __delay_exit
  sub r3, r3, #1
  b __delay_loop
__delay_exit:
  bx lr
  .balign

.section .tomfool, "a"
  bx lr
  bx lr
  bx lr

@ END.
