//-----------------------------//
.globl drawSquareBlock
drawSquareBlock:
    push {lr}
    push {r6}
    // loop through game state
    // if a position:
    // 0 = draw black
    // 1 = draw light blue
    // 2 = draw green
    // 3 = draw red
    // ...
    // using each color blocks
    // may need to redraw game
    // area too
    ldr r1, =currentBlock1
    ldr r0, =gameState
    mov r6, #0
restoreLoop:
    cmp r6, #4
    beq finishRestore
    ldr r1, =currentBlock1
    add r1, r6
    ldrb r3, [r1]
    mov r12, #400
    ldrb r2, [r0, r3]
    mov r1, r3
    cmp r2, #0
    beq drawBlack
    cmp r2, #1
    beq drawLightBlue
    cmp r2, #2
    beq drawGreen
    cmp r2, #3
    beq drawRed
    cmp r2, #4
    beq drawYellow
    cmp r2, #5
    beq drawPurple
    cmp r2, #6
    beq drawBlue
    cmp r2, #7
    beq drawOrange
    b finishRestore
drawBlack:
    ldr r3, =blackSquare
    bl drawSquare
    b continueRestore
drawLightBlue:
    ldr r3, =lBlueSquare
    bl drawSquare
    b continueRestore
drawGreen:
    ldr r3, =greenSquare
    bl drawSquare
    b continueRestore
drawRed:
    ldr r3, =redSquare
    bl drawSquare
    b continueRestore
drawYellow:
    ldr r3, =yellowSquare
    bl drawSquare
    b continueRestore
drawPurple:
    ldr r3, =purpleSquare
    bl drawSquare
    b continueRestore
drawBlue:
    ldr r3, =blueSquare
    bl drawSquare
    b continueRestore
drawOrange:
    ldr r3, =orangeSquare
    bl drawSquare
    b continueRestore

continueRestore:
    add r6, #1
    b restoreLoop

finishRestore:
    pop {r6}
    pop {lr}
    mov pc, lr
//--------------------------//

//--------------------------//
.section .data
menustate1:
    .include "images/mainmenu/menustate1.txt"
menustate2:
    .include "images/mainmenu/menustate2.txt"
// block squares
blackSquare:
    .include "images/squares/blackSquare.txt"
lBlueSquare:
    .include "images/squares/lblueSquare.txt"
greenSquare:
    .include "images/squares/greenSquare.txt"
redSquare:
    .include "images/squares/redSquare.txt"
yellowSquare:
    .include "images/squares/yellowSquare.txt"
purpleSquare:
    .include "images/squares/purpleSquare.txt"
blueSquare:
    .include "images/squares/blueSquare.txt"
orangeSquare:
    .include "images/squares/orangeSquare.txt"
