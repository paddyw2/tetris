.section .text

//-----------------------------//
.globl runStartMenu
// draws main start menu screen
// with default start selected
// if user presses up/down it
// changes selection
// if the user presses a, then
// the current selection is
// activated
runStartMenu:
    push {lr}
    // draw initial image
    bl drawIntroScreen
    // draw state1 image
    bl startState1
startUserInputLoop:
    // read snes input data
    bl Read_Data
    // button data in r0
    // setup mask
    mov r1, #1
    // isolate button a
    lsl r1, #8
    // if not zero, then a
    // pressed
    tst r0, r1
    bne executeChosenOption
    // else check if up or down pressed
    mov r1, #1
checkUp:
    lsl r1, #4
    tst r0, r1
    beq checkDown
    bl startState1
    b getNextInput
checkDown:
    lsl r1, #1
    tst r0, r1
    beq getNextInput
    bl startState2

getNextInput:
    b startUserInputLoop

//-----------------------------//


//-----------------------------//
startState1:
    // draws an image showing that the
    // 'start game' option is selected
    // and updates the variable
    push {lr}
    push {r4}

    // clear area and draw
    // new selection
    @bl clearState
    ldr r1, =state1
    bl drawState

    // update user selection
    ldr r0, =currentChoice
    mov r1, #0
    strb r1, [r0]

    pop {r4}
    pop {lr}
    mov pc, lr
//-----------------------------//


//-----------------------------//
startState2:
    // draws an image showing that the
    // 'start game' option is selected
    // and updates the variable
    push {lr}

    // clear area and draw
    // new selection
    @bl clearState
    ldr r1, =state2
    bl drawState

    // update user selection
    ldr r0, =currentChoice
    mov r1, #1
    strb r1, [r0]

    pop {lr}
    mov pc, lr
//-----------------------------//


//-----------------------------//
drawState:
    // draws a state image address
    // r1 = image address
    @r1 = start y
    @r0 = start x
    push {lr}
    push {r4}
    mov r4, r1
    mov r0, #320
    mov r1, #352
    mov r2, #400
    mov r3, #200
    bl drawImage
    pop {r4}
    pop {lr}
    mov pc, lr
//-----------------------------//



//-----------------------------//
@clearState:
@    // clears selection choices
@    push {lr}
@    push {r4}
@    ldr r4, =blankState
@    mov r3, #200
@    mov r2, #400
@    mov r1, #300
@    mov r1, #400
@    bl drawImage
@    pop {r4}
@    pop {lr}
@    mov pc, lr
//-----------------------------//


//-----------------------------//
executeChosenOption:
    // gets the current user choice
    // and executes it
    // load user choice
    ldr r0, =currentChoice
    ldrb r0, [r0]
    cmp r0, #0
    beq startGame
    b quitGame

quitGame:
    // go to game over screen
    b quitProgram
startGame:
    // clear state, and start game
    bl resetGameState
    bl clearScreen
    bl drawGameArea
    bl InsertNewBlock

//-----------------------------//

.section .data
state1:
    .include "images/state1.txt"
state2:
    .include "images/state2.txt"

currentChoice:
    .byte 0
