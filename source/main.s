.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    mov     sp, #0x8000
    
    bl      EnableJTAG
    bl      InitFrameBuffer

    mov r7, #0x0000
    mov r8, #1024
    mov r9, #768
    bl clearScreen

    ldr r3, =game_screen
    mov r1, #0
    mov r0, #0
    mov r4, #1024
    mov r5, #768
    bl drawImage


    ldr r3, =green_test
    mov r1, #125
    mov r0, #380
    mov r4, #200
    mov r5, #200
    bl drawImage

b haltLoop$   
 
    ldr r3, =myString
    mov r7, #10
    mov r9, #600
    mov r6, #300
    mov r10, #0xF00
    bl drawString



   
haltLoop$:
    b       haltLoop$


.section .data

image2:         .include "image.txt"
game_screen:    .include "tetris_game_screen.txt"
game_block:     .include "s_block.txt"
green_test:     .include "green_test.txt"
myString:       .ascii "Hey there!"
