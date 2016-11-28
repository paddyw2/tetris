/*

TETRIS - Main File

Creators: Patrick Withams and Michael Tretiak
Date: 20/11/16

*/

.section    .init
.globl     _start

_start:
    b       main

.section .text

main:
    mov     sp, #0x8000

    bl      EnableJTAG
    bl      InitFrameBuffer

    // Intialize SNES
    // set function codes of each line
    bl Set_Lines

    // clear screen
    b StartGame

StartGame:
    // clear on game
    // start
    bl clearScreen
    bl setSeed
    @b InsertNewBlock
    // draw main menu and wait
    // for user to choose an option
    bl runStartMenu
    bl drawGameArea
    bl drawCurrentScore
    @b InsertNewBlock

//---------------------------//
.globl InsertNewBlock
// main program loop
InsertNewBlock:
    // insert random block at a
    // random x coordinate on the
    // grid
    bl insertRandomBlock
    // add one to user score
    mov r1, #1
    bl updateScore

    // load current block array
    // position
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    // draws intial block position
    bl drawCurrentBlock

    // moves current block down
    // until it cannot move further
    bl moveBlockDown
    bl checkForCompleteLines

    // loops until moveBlockDown
    // detects end of game state
    b InsertNewBlock


//
//-------- SUB ROUTINES --------//
//


// moves current block down until
// either hits another, or game
// over
// it does this by drawing erasing
// at current position, then
// incrementing the coords, then
// drawing at new location, each
// time updating the game state
moveBlockDown:
    push {lr}
    push {r6}

moveBlockLoop:

    bl CheckBlockMove
    cmp r1, #0
    beq NoMove
    // clear game state
    mov r1, #0
    ldr r2, =currentBlock1
    ldrb r2, [r2]
    ldr r0, =gameState
    strb r1, [r0, r2]

    // send currentBlock1 value
    // to erase subroutine as
    // parameter in r1
    mov r1, r2

    bl eraseCurrentBlock


    mov r1, #0
    ldr r2, =currentBlock2
    ldrb r2, [r2]
    ldr r0, =gameState
    strb r1, [r0, r2]

    ldr r2, =currentBlock3
    ldrb r2, [r2]
    ldr r0, =gameState
    strb r1, [r0, r2]

    ldr r2, =currentBlock4
    ldrb r2, [r2]
    ldr r0, =gameState
    strb r1, [r0, r2]


    // update state with new
    // block position
    ldr r1, =currentBlockType
    ldrb r1, [r1]
    mov r1, #1
    ldr r3, =currentBlock1
    ldrb r2, [r3]
    add r2, #10
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]
    mov r1, r2
    bl drawCurrentBlock

    ldr r1, =currentBlockType
    ldrb r1, [r1]
    ldr r3, =currentBlock2
    ldrb r2, [r3]
    add r2, #10
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]

    ldr r3, =currentBlock3
    ldrb r2, [r3]
    add r2, #10
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]

    ldr r3, =currentBlock4
    ldrb r2, [r3]
    add r2, #10
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]

    mov r6, #0
    ldr r0, =currentBorders
incBordersLoop:
    cmp r6, #3
    beq finishIncBorderLoop
    ldrb r1, [r0]
    cmp r1, #255
    beq incSecond
    add r1, #10
    strb r1, [r0]
incSecond:
    add r0, #1
    ldrb r1, [r0]
    cmp r1, #255
    beq incThird
    add r1, #10
    strb r1, [r0]
incThird:
    add r0, #1
    ldrb r1, [r0]
    cmp r1, #255
    beq incFourth
    add r1, #10
    strb r1, [r0]
incFourth:
    add r0, #1
    ldrb r1, [r0]
    cmp r1, #255
    beq finishInc
    add r1, #10
    strb r1, [r0]
finishInc:
    add r6, #1
    add r0, #1
    b incBordersLoop
finishIncBorderLoop:

    // delay after each block draw
    bl WaitAndCheckSNES
    // end delay

    b moveBlockLoop

NoMove:
    bl CheckGameOver
    pop {r6}
    pop {lr}
    mov pc, lr

//----------------------------


// checks if a block can move
// down, returns true false
// in r1
CheckBlockMove:
    push {lr}

checkFirstCoord:
    ldr r3, =currentBorders
    ldrb r2, [r3]
    cmp r2, #255
    beq checkSecondCoord
    add r2, #10
    cmp r2, #200
    bge bottomOfGrid
    ldr r0, =gameState
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge hitOtherBlock

checkSecondCoord:
    ldr r3, =currentBorders
    ldrb r2, [r3, #1]
    cmp r2, #255
    beq checkThirdCoord
    add r2, #10
    cmp r2, #200
    bge bottomOfGrid
    ldr r0, =gameState
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge hitOtherBlock

checkThirdCoord:
    ldr r3, =currentBorders
    ldrb r2, [r3, #2]
    cmp r2, #255
    beq checkFourthCoord
    add r2, #10
    cmp r2, #200
    bge bottomOfGrid
    ldr r0, =gameState
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge hitOtherBlock

checkFourthCoord:
    ldr r3, =currentBorders
    ldrb r2, [r3, #3]
    cmp r2, #255
    beq CanMove
    add r2, #10
    cmp r2, #200
    bge bottomOfGrid
    ldr r0, =gameState
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge hitOtherBlock

    b CanMove

hitOtherBlock:
bottomOfGrid:
    mov r1, #0
    b endCheckBlock
CanMove:
    mov r1, #1
endCheckBlock:
    pop {lr}
    mov pc, lr

//----------------------------



// checks if block did not make
// it past first row
CheckGameOver:
    mov r3, lr
    push {r3}

    ldr r3, =currentBlock1
    ldrb r2, [r3]
    cmp r2, #10
    blt GameIsOver
    ldr r3, =currentBlock2
    ldrb r2, [r3]
    cmp r2, #10
    blt GameIsOver
    ldr r3, =currentBlock3
    ldrb r2, [r3]
    cmp r2, #10
    blt GameIsOver
    ldr r3, =currentBlock4
    ldrb r2, [r3]
    cmp r2, #10
    blt GameIsOver
    b FinishCheckGameOver
GameIsOver:
    // insert game over code here
    // commented out for debugging
    // draw image at 0,0
    b quitProgram
FinishCheckGameOver:
    pop {r3}
    mov pc, r3

//----------------------------//


//----------------------------//
.globl drawCurrentBlock
// draws the current block
// to screen
drawCurrentBlock:
    /*
    takes block array
    position as parameter
    in r1
    */
    push {lr}
    push {r4, r6, r7}
    // set parameters
    mov r2, r1
    // divide coordinate by 10
    // to get y
    mov r7, r2
    mov r6, #0
drawModLoop:
    subs r2, #10
    blt drawEndMod
    add r6, #1
    mov r7, r2
    b drawModLoop
drawEndMod:
    // counter is division
    // r7 is remainder

    // where 0 is the base
    // y coord
    mov r1, #100
    lsl r6, #5
    add r1, r6

    // now calc x
    ldr r0, =currentBlockLeftOffset
    ldrb r0, [r0]
    // x32 to get pixel value
    lsl r0, #5
    // add base offset
    // where 300 is the base
    // x coord
    add r0, #384

    // get block width
    ldr r3, =currentBlockSizeX
    ldrb r3, [r3]
    mov r2, r3
    // get block height
    ldr r3, =currentBlockSizeY
    ldrb r3, [r3]
    // load pointer to image
    // address
    ldr r4, =currentBlockImage
    ldr r4, [r4]

    bl drawImage
    pop {r4, r6, r7}
    pop {lr}
    mov pc, lr

//----------------------------//


//----------------------------//
.globl eraseCurrentBlock
// draws the black version
// of the current block
eraseCurrentBlock:
    /*
    takes block array
    position as parameter
    in r1
    */
    push {lr}
    push {r4}
    // set up parameter
    mov r2, r1
    // divide coordinate by 10
    // to get y
    mov r7, r2
    mov r6, #0
eraseModLoop:
    subs r2, #10
    blt eraseEndMod
    add r6, #1
    mov r7, r2
    b eraseModLoop
eraseEndMod:
    // counter is division
    // r7 is remainder

    // where 0 is the base
    // y coord
    mov r1, #100
    lsl r6, #5
    add r1, r6
    // now calc x
    ldr r0, =currentBlockLeftOffset
    ldrb r0, [r0]
    // x32 to get pixel value
    lsl r0, #5
    // add base offset
    // where 300 is base
    // x coord
    add r0, #384

    // get block width
    ldr r3, =currentBlockSizeX
    ldrb r3, [r3]
    mov r2, r3
    // get block height
    ldr r3, =currentBlockSizeY
    ldrb r3, [r3]
    // load pointer to image
    // address
    ldr r4, =currentBlockImageBlack
    ldr r4, [r4]

    bl drawImage
    pop {r4}
    pop {lr}
    mov pc, lr

//----------------------------//




//----------------------------//
.globl xorShift
// basic concept referenced from:
// http://www.arklyffe.com/main/2010/08/29/xorshift-pseudorandom-number-generator/
xorShift:
    // takes single parameter as
    // r1 which defines the largest
    // value allowed
    // note: this will never return
    // 0, so to achieve this 1 is
    // added to the range and then
    // 1 is subbed from the return
    // value
    // if range is r8=8
    // will generate 0-8 inclusive
    push {lr}
    push {r4}
    // range max in r8
    // add 1 to allow for zero
    // values
    add r1, #1
    // seed value
    ldr r0, =randSeedVal
    ldrb r0, [r0]
    mov r4, r0
    // shift seed value by
    lsl r0, #7
    eor r4, r0
    mov r2, r4
    lsr r4, #5
    eor r4, r2
    mov r2, r4
    lsl r2, #3
    eor r4, r2

    ldr r0, =randSeedVal
    strb r4, [r0]

// to get a number within range
// simply modulo until value
// within range
randModLoop:
    cmp r4, r1
    ble finishRand
    sub r4, r1
    b randModLoop
finishRand:
    // to allow for zero values
    sub r4, #1
    mov r1, r4
    // return random value in r1
    pop {r4}
    pop {lr}
    mov pc, lr


//---------------------------//
setSeed:
    // sets the seed value
    // to the system time after
    // clear screen executed, in
    // theory different each time
    // to ensure different sequences
    push {lr}
    ldr r1, =randSeedVal
    ldr r0, =0x3F003000                                 // base clock address
    ldr r2, [r0, #4]                                   // get current time
    // program crashing if more than
    // byte stored here
    str r2, [r1]
    pop {lr}
    mov pc, lr

//---------------------------//


//---------------------------//
insertRandomBlock:
    push {lr}

    mov r1, #6
    bl xorShift

    cmp r1, #0
    beq block0
    cmp r1, #1
    beq block1
    cmp r1, #2
    beq block2
    cmp r1, #3
    beq block3
    cmp r1, #4
    beq block4
    cmp r1, #5
    beq block5
    cmp r1, #6
    beq block6



block0:
    bl insertNewOBeam
    b finishRandInsert
block1:
    bl insertNewLOBeam
    b finishRandInsert
block2:
    bl insertNewLBBeam
    b finishRandInsert
block3:
    bl insertNewSRBeam
    b finishRandInsert
block4:
    bl insertNewWBeam
    b finishRandInsert
block5:
    bl insertNewSBeam
    b finishRandInsert
block6:
    bl insertNewIBeam
    b finishRandInsert


finishRandInsert:
    pop {lr}
    mov pc, lr


//---------------------------//


//---------------------------//

// sets up intial screen
.globl drawIntroScreen
drawIntroScreen:
    push {lr}
    push {r4, r5}
    ldr r4, =start_screen
    mov r1, #0
    mov r0, #0
    mov r2, #1024
    mov r3, #768

    bl drawImage
    pop {r4, r5}
    pop {lr}
    mov pc, lr

//---------------------------//

.globl drawGameArea
drawGameArea:
    push {lr}
    push {r4, r5}
    ldr r4, =game_area
    mov r1, #0
    mov r0, #0
    mov r2, #1024
    mov r3, #768

    bl drawImage
    pop {r4, r5}
    pop {lr}
    mov pc, lr




//---------------------------//
// sets up game over screen
drawGameOverScreen:
    push {lr}
    push {r4, r5}
    ldr r4, =game_over_screen
    mov r1, #0
    mov r0, #0
    mov r2, #1024
    mov r3, #768

    bl drawImage
    pop {r4, r5}
    pop {lr}
    mov pc, lr


//---------------------------//



//---------------------------//
// clears memory to avoid having
// to reload each time
.globl resetGameState
resetGameState:
    push {lr}
    ldr r0, =gameState
    mov r3, #0
    mov r1, #200
    mov r2, #0
resetStateLoop:
    cmp r2, r1
    beq finishStateReset
    strb r3, [r0], #1
    add r2, #1
    b resetStateLoop
finishStateReset:
    pop {lr}
    mov pc, lr

//----------------------------//



//----------------------------//
checkForCompleteLines:
    // start at bottom of array
    // and loop through backwards
    // checking each line for a 0
    // if a line has a 0, move to
    // next line
    // if a line has no 0s, then
    // trigger clearLine for that
    // line
    push {lr}
    push {r4, r5, r6, r7}

    ldr r4, =gameState
    // increment address to last
    // byte
    add r4, #199
    mov r5, #19
    mov r6, #0
lineLoop:
    cmp r6, #10
    // if checked whole line, must be cleared
    beq clearLine
    // load state address value
    // minus offset of loop counter
    ldrb r7, [r4, -r6]
    cmp r7, #0
    // if zero, move to next line
    beq nextLine
    // else, inc counter and
    // loop
    add r6, #1
    b lineLoop

clearLine:
    // clear current line in state
    // takes r1 as current line input
    mov r1, r5
    bl clearLineGameState
    // clear current line in visual
    // takes r1 as current line input
    mov r1, r5
    bl clearLineScreen

    // for every line cleared, update
    // user score by 10
    mov r1, #10
    bl updateScore
    // to account for dropped line
    add r5, #1
    add r4, #10

    // then move to next line

nextLine:
    cmp r5, #0
    beq finishCheckLines
    // restore loop counter
    mov r6, #0
    // decrement line number
    sub r5, #1
    // decrement address to next line
    sub r4, #10
    b lineLoop

finishCheckLines:
    pop {r4, r5, r6, r7}
    pop {lr}
    mov pc, lr

//---------------------------------------//



//---------------------------------------//
clearLineGameState:
// loops through game state and replaces
// each value with value from above
// takes parameter as r1
// which indicates the row to start at
    push {lr}
    push {r4}
    // r1 is line number, 0-19
    ldr r3, =gameState
    // set base offset
    mov r2, #0
    mov r0, #0
getLineLoop:
    cmp r0, r1
    beq clearLineValues
    // increment counter
    add r0, #1
    // increment address to next line
    add r2, #10
    b getLineLoop

clearLineValues:
    // now line address in r3
    // offset is in r2
    // loop over each
    // check if line to cleared is top
    cmp r2, #0
    beq finishClearValues
    // set counter
    mov r0, #0
    // get address of line above
    // for copying
    mov r1, r2
    sub r1, #10
clearValuesLoop:
    cmp r0, #10
    beq updateNextLine
    // value from line above
    ldrb r4, [r3, r1]
    // store in line below
    strb r4, [r3, r2]
    add r2, #1
    add r1, #1
    add r0, #1
    b clearValuesLoop

updateNextLine:
    // move address to next line
    // and loop
    sub r2, #20
    b clearLineValues

finishClearValues:
    pop {r4}
    pop {lr}
    mov pc, lr

//----------------------------------//



//----------------------------------//
updateScore:
// increments user score by r1 value
    push {lr}
    // r1 is value to increment
    // score by
    ldr r0, =currentScore
    ldr r2, [r0]
    add r2, r1
    str r2, [r0]
    mov r1, r2
    bl drawCurrentScore
scoreEnd:
    pop {lr}
    mov pc, lr

//----------------------------------//



//----------------------------------//
.globl quitProgram
quitProgram:
// if game is over
    bl resetGameState
    bl clearScreen
    //bl drawGameOverScreen
    b haltLoop$

//----------------------------------//



//----------------------------------//
haltLoop$:
    b       haltLoop$

//----------------------------------//

.section .data

.globl game_block
game_block:     .include "images/s_block.txt"
// Large Images
.globl start_screen
start_screen:   .include "images/empty.txt"//"images/start_screen_blank.txt"

.globl game_area
game_area: .include "images/tetris_game_area.txt" //"images/tetris_game_area.txt"

.globl game_over_screen
game_over_screen:   .include "images/empty.txt"//"images/game_over.txt"

// I Block
.globl i_block
i_block:        .include "images/i_block.txt"
.globl i_block_black
i_block_black:  .include "images/i_block_black.txt"
.globl i_block_B
i_block_B:       .include "images/rotation/i_block_B.txt"
.globl i_block_black_B
i_block_black_B:       .include "images/rotation/i_block_B_black.txt"
// Green Block
.globl s_block_green
s_block_green:        .include "images/s_block_green.txt"
.globl s_block_green_black
s_block_green_black:  .include "images/s_block_green_black.txt"
.globl s_block_green_B
s_block_green_B:        .include "images/s_block_green_B.txt"
.globl s_block_g_b_B
s_block_g_b_B:  .include "images/green_tester1.txt"
// Red Block
.globl s_block_red
s_block_red:    .include "images/s_block_saviour.txt"
.globl s_block_red_black
s_block_red_black: .include "images/s_block_red_black.txt"
.globl s_block_red_B
s_block_red_B:    .include "images/s_block_r_B.txt"
.globl s_block_red_black_B
s_block_red_black_B: .include "images/red_tester8.txt"
// O Block
.globl o_block_yellow
o_block_yellow: .include "images/o_block_yellow.txt"
.globl o_block_yellow_black
o_block_yellow_black: .include "images/o_block_yellow_black.txt"
// W Block
.globl w_block
w_block: .include "images/w_block.txt"
.globl w_block_black
w_block_black: .include "images/w_block_black.txt"
.globl w_block_B
w_block_B: .include "images/w_block_B.txt"
.globl w_block_black_B
w_block_black_B: .include "images/w_tester7.txt"
.globl w_block_C
w_block_C: .include "images/w_block_C.txt"
.globl w_block_black_C
w_block_black_C: .include "images/w_tester8.txt"
.globl w_block_D
w_block_D: .include "images/w_block_D.txt"
.globl w_block_black_D
w_block_black_D: .include "images/w_tester9.txt"
// L Block Blue
.globl l_block_blue
l_block_blue: .include "images/l_block_blue.txt"
.globl l_block_blue_black
l_block_blue_black: .include "images/l_block_blue_black.txt"
.globl l_block_blue_B
l_block_blue_B: .include "images/l_block_blue_B.txt"
.globl l_block_blue_black_B
l_block_blue_black_B: .include "images/l_block_blue_black_B.txt"
.globl l_block_blue_C
l_block_blue_C: .include "images/l_block_blue_C.txt"
.globl l_block_blue_black_C
l_block_blue_black_C: .include "images/l_block_blue_black_C.txt"
.globl l_block_blue_D
l_block_blue_D: .include "images/l_block_blue_D.txt"
.globl l_block_blue_black_D
l_block_blue_black_D: .include "images/l_block_blue_black_D.txt"
// L Block Orange
.globl l_block_orange
l_block_orange: .include "images/l_block_orange.txt"
.globl l_block_orange_black
l_block_orange_black: .include "images/l_block_orange_black2.txt"
.globl l_block_orange_B
l_block_orange_B: .include "images/l_block_orange_B.txt"
.globl l_block_orange_black_B
l_block_orange_black_B: .include "images/l_block_orange_black_B.txt"
.globl l_block_orange_C
l_block_orange_C: .include "images/l_block_orange_C2.txt"
.globl l_block_orange_black_C
l_block_orange_black_C: .include "images/l_block_orange_black_C.txt"
.globl l_block_orange_D
l_block_orange_D: .include "images/l_block_orange_D2.txt"
.globl l_block_orange_black_D
l_block_orange_black_D: .include "images/l_block_orange_black_D.txt"


// game state has 1 values for blocks, and 0 for
// empty space
.globl gameState
gameState:
    .rept   200
    .byte   0
    .endr
.globl currentBlock1
currentBlock1:
    .byte   0
.globl currentBlock2
currentBlock2:
    .byte   0
.globl currentBlock3
currentBlock3:
    .byte   0
.globl currentBlock4
currentBlock4:
    .byte   0
.globl currentBorders
currentBorders:
    .byte   0,0,0,0
.globl currentLeftBorders
currentLeftBorders:
    .byte   0,0,0,0
.globl currentRightBorders
currentRightBorders:
    .byte   0,0,0,0
.globl currentBlockImage
currentBlockImage:
    .word   0
.globl currentBlockImageBlack
currentBlockImageBlack:
    .word   0
.globl currentBlockSizeX
currentBlockSizeX:
    .byte   0
.globl currentBlockSizeY
currentBlockSizeY:
    .byte   0
.globl currentBlockLeftOffset
currentBlockLeftOffset:
    .byte   0
.globl currentBlockWidth
currentBlockWidth:
    .byte   0
.globl currentBlockType
currentBlockType:
    // 1 to 7
    .byte   0
.globl currentBlockRotation
currentBlockRotation:
    // 0 to 3
    .byte   0
.align
randSeedVal:
    .word   0                                           // originally 37, now set with setSeed
currentScore:
    .word   0
.align
