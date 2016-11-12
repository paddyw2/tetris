.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    mov     sp, #0x8000
    
    bl      EnableJTAG
    bl      InitFrameBuffer

// clear screen

    mov r7, #0x0000
    bl clearScreen


// sets up intial screen
Game_Screen:
    ldr r3, =game_screen
    mov r1, #0
    mov r0, #0
    mov r4, #1024
    mov r5, #768
    bl drawImage


// print ugly green/blue
// image and show off the
// green screen abilities
    ldr r3, =green_test
    mov r1, #125
    mov r0, #380
    mov r4, #200
    mov r5, #200
    bl drawImage
   

// after screen set up, waits
// for snes input and if
// received, clears screen
// with black and prints image 
// quits if joy up pressed
Move_Image:
    button_reg  .req    r9
    bl Set_Lines
    mov button_reg, #0
Loop_SNES_Input:
    push {button_reg}
    bl Read_Data
    pop {r3}
    cmp r3, button_reg
    beq Loop_SNES_Input
    // pass address of routine
    // to Check_Buttons
    ldr r2, =printImage
    bl Check_Buttons
    b Loop_SNES_Input


 
haltLoop$:
    b       haltLoop$



// routine to reprint image
// to screen
.globl printImage
printImage:
    mov r3, lr
    push {r3}
    // check start button
    cmp r6, #4
    // if pressed, haltloop
    beq haltLoop$
    // else refresh screen
    mov r7, #0x0000
    bl clearScreen
    ldr r3, =green_test
    mov r1, #125
    mov r0, #380
    mov r4, #200
    mov r5, #200
    bl drawImage
    mov r12, #99
    pop {r3}
    mov pc, r3


    


.section .data

image2:         .include "images/image.txt"
game_screen:    .include "images/tetris_game_screen.txt"
game_block:     .include "images/s_block.txt"
green_test:     .include "images/green_test.txt"
myString:       .ascii "Hey there!"
test:           .ascii "\3407"
