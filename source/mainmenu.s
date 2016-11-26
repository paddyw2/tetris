//-----------------------------//
.globl runMainMenu
// draws main start menu screen
// with default start selected
// if user presses up/down it
// changes selection
// if the user presses a, then
// the current selection is
// activated
runMainMenu:
    push {lr}
    // draw state1 image
    bl menuState1
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
    bl menuState1
    b getNextInput
checkDown:
    lsl r1, #1
    tst r0, r1
    beq getNextInput
    bl menuState2
checkStart:
    mov r1, #1
    lsl r1, #3
    beq restoreCurrentGame 

getNextInput:
    b startUserInputLoop

//-----------------------------//

//-----------------------------//
menuState1:
    // draws an image showing that the
    // 'start game' option is selected
    // and updates the variable
    push {lr}
    push {r4}

    // clear area and draw
    // new selection
    ldr r1, =menustate1
    bl drawState

    // update user selection
    ldr r0, =currentMenuChoice
    mov r1, #0
    strb r1, [r0]

    pop {r4}
    pop {lr}
    mov pc, lr
//-----------------------------//

//-----------------------------//
menuState2:
    // draws an image showing that the
    // 'start game' option is selected
    // and updates the variable
    push {lr}

    // clear area and draw
    // new selection
    ldr r1, =menustate2
    bl drawState

    // update user selection
    ldr r0, =currentMenuChoice
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
    ldr r2, =#306
    ldr r3, =#79
    bl drawImage
    pop {r4}
    pop {lr}
    mov pc, lr
//-----------------------------//

//-----------------------------//
executeChosenOption:
    // gets the current user choice
    // and executes it
    // load user choice
    ldr r0, =currentMenuChoice
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


//-----------------------------//
restoreCurrentGame:
    push {lr}
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
    ldr r0, =gameState
    mov r1, #0
restoreLoop:
    cmp r1, #200
    beq finishRestore
    ldr r2, [r0, r1]
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
    mov r3, =blackSquare
    bl drawSquare
    b continueRestore
drawLightBlue:
    mov r3, =lBlueSquare
    bl drawSquare
    b continueRestore
drawGreen:
    mov r3, =greenSquare
    bl drawSquare
    b continueRestore
drawRed:
    mov r3, =redSquare
    bl drawSquare
    b continueRestore
drawYellow:
    mov r3, =yellowSquare
    bl drawSquare
    b continueRestore
drawPurple:
    mov r3, =purpleSquare
    bl drawSquare
    b continueRestore
drawBlue:
    mov r3, =blueSquare
    bl drawSquare
    b continueRestore
drawOrange:
    mov r3, =orangeSquare
    bl drawSquare
    b continueRestore

continueRestore:
    add r1, #1
    b restoreLoop

finishRestore:
    pop {lr}
    mov pc, lr
//--------------------------//



//--------------------------//
drawSquare:
    // draws chosen square
    // image to gamestate
    // offset location
    push {lr}
    push {r4-r9}
    mov r9, r0
    mov r8, r1
    // image address in r3
    // offset in r1
    mov r5, r1
    mov r6, #0
modLoop: 
    cmp r5, #10
    blt finishMod 
    sub r5, #10
    add r6, #1
    b modLoop
finishMod:
    // x offset in r5 (remainder)
    // y offset in r6 (divisions)
    // x32 to get pixels
    lsl r5, #5
    lsl r6, #5
    // then add base coordinates
    add r5, #384
    add r6, #100
    // set up draw parameters
    mov r4, r3
    mov r3, #32
    mov r2, #32
    mov r1, r6
    mov r0, r5
    bl drawImage

    mov r0, r9
    mov r1, r8
    pop {r4-r9}
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
// menu choice variable
currentMenuChoice:
    .byte 0
