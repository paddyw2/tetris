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

    // draw intro screen
    bl drawIntroScreen


    // delay to show start screen
    mov r5, #1000
    bl Wait
    mov r5, #1000
    bl Wait


StartGame:
    // clear on game
    // start
    mov r7, #0x0000
    bl clearScreen

InsertNewBlock:
    // initializes new ibeam
    // at 0,0
    bl insertNewIBeam 
    // set initial coords
    mov r1, #0
    mov r0, #300
    // draws intial block position
    bl drawCurrentBlock

    // moves current block down
    // until it cannot move further 
    bl moveBlockDown
    
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
    mov r3, lr
    push {r3}

moveBlockLoop:
    
    bl CheckBlockMove
    cmp r5, #0
    beq NoMove
    // clear game state
    mov r1, #0
    ldr r2, =currentBlock1
    ldrb r2, [r2] 
    ldr r0, =gameState
    strb r1, [r0, r2] 

    // commented out for debugging
    // draw black image
    // divide coordinate by 10
    // to get y
    mov r7, r2
    mov r6, #0
modLoop:
    subs r2, #10
    blt endMod
    add r6, #1
    mov r7, r2
    b modLoop
endMod:
    // counter is division
    // r7 is remainder

    mov r1, #0
    lsl r6, #5
    add r1, r6
    // now calc x

    mov r0, #300
    lsl r7, #5
    add r1, r7

    bl eraseCurrentBlock

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
    mov r1, #1
    ldr r3, =currentBlock1
    ldrb r2, [r3] 
    add r2, #10
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2] 

    // draw regular image
    // divide coordinate by 10
    // to get y
    mov r7, r2
    mov r6, #0
modLoop2:
    subs r2, #10
    blt endMod2
    add r6, #1
    mov r7, r2
    b modLoop2
endMod2:
    // counter is division
    // r7 is remainder

    mov r1, #0
    lsl r6, #5
    add r1, r6
    // now calc x

    mov r0, #300
    lsl r7, #5
    add r1, r7

    bl drawCurrentBlock


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

    // delay after each block draw
    mov r5, #1000
    bl Wait
    mov r5, #1000
    bl Wait
    mov r5, #1000
    bl Wait
    mov r5, #1000
    bl Wait
    // end delay

    b moveBlockLoop 

NoMove:
    bl CheckGameOver
    pop {r3}
    mov pc, r3

//----------------------------


// checks if a block can move
// down, returns true false
// in r1
CheckBlockMove:
    mov r3, lr
    push {r3}
    
    ldr r3, =currentBlock1
    ldrb r2, [r3] 
    add r2, #10
    cmp r2, #200
    bge bottomOfGrid
    ldr r0, =gameState
    ldrb r1, [r0, r2]
    cmp r1, #1
    beq hitOtherBlock

    ldr r3, =currentBlock2
    ldrb r2, [r3] 
    add r2, #10
    cmp r2, #200
    bge bottomOfGrid
    ldr r0, =gameState
    ldrb r1, [r0, r2]
    cmp r1, #1
    beq hitOtherBlock

    ldr r3, =currentBlock3
    ldrb r2, [r3] 
    add r2, #10
    cmp r2, #200
    bge bottomOfGrid
    ldr r0, =gameState
    ldrb r1, [r0, r2]
    cmp r1, #1
    beq hitOtherBlock

    ldr r3, =currentBlock4
    ldrb r2, [r3] 
    add r2, #10
    cmp r2, #200
    bge bottomOfGrid
    ldr r0, =gameState
    ldrb r1, [r0, r2]
    cmp r1, #1
    beq hitOtherBlock
    
    b CanMove

hitOtherBlock:
bottomOfGrid:
    mov r5, #0
    b endCheckBlock
CanMove:
    mov r5, #1
endCheckBlock:
    pop {r3}
    mov pc, r3

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
    ldr r3, =i_block
    mov r1, #0
    mov r0, #300
    mov r4, #128
    mov r5, #32
    bl drawImage

    ldr r3, =i_block
    mov r1, #32
    mov r0, #300
    mov r4, #128
    mov r5, #32
    bl drawImage

    mov r6, #1 
    lsl r6, #5
    mov r11, r6

    b haltLoop$
FinishCheckGameOver:
    pop {r3}
    mov pc, r3

//----------------------------


// draws the current block
// to screen
drawCurrentBlock:
    /*
    takes coordinates
    as parameters
    */
    mov r3, lr
    push {r3}
    // get block width
    ldr r3, =currentBlockSizeX
    ldrb r3, [r3]
    mov r4, r3
    // get block height
    ldr r3, =currentBlockSizeY
    ldrb r3, [r3]
    mov r5, r3
    // load pointer to image 
    // address 
    ldr r3, =currentBlockImage
    ldr r3, [r3]
    bl drawImage
    pop {r3}
    mov pc, r3


// draws the black version
// of the current block
eraseCurrentBlock:
    /*
    takes coordinates
    as parameters
    */
    mov r3, lr
    push {r3}
    // get block width
    ldr r3, =currentBlockSizeX
    ldrb r3, [r3]
    mov r4, r3
    // get block height
    ldr r3, =currentBlockSizeY
    ldrb r3, [r3]
    mov r5, r3
    // load pointer to image 
    // address 
    ldr r3, =currentBlockImageBlack
    ldr r3, [r3]
    bl drawImage
    pop {r3}
    mov pc, r3

//----------------------------



// initializes a new ibeam
// block at 0,0 on the screen
// and game state
insertNewIBeam:
    mov r4, lr
    push {r4}
    // first coords are
    // 0, 1, 2, 3
    
    ldr r0, =currentBlock1
    mov r1, #0
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #1
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #2
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #3
    strb r1, [r0]
    // update game state
    // with block at initial
    // position
    mov r1, #1
    ldr r2, =currentBlock1
    ldrb r2, [r2] 
    ldr r0, =gameState
    strb r1, [r0, r2] 

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
 
    // update current block image
    // pointer, and size
    ldr r3, =i_block
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =i_block_black
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #128
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #32
    ldr r5, =currentBlockSizeY
    strb r3, [r5]

    pop {r4}
    mov pc, r4

//----------------------------




// sets up intial screen
drawIntroScreen:
    mov r3, lr
    push {r3}
    ldr r3, =start_screen
    mov r1, #0
    mov r0, #0
    mov r4, #1024
    mov r5, #768
    bl drawImage
    pop {r3}
    mov pc, r3

//----------------------------


haltLoop$:
    b       haltLoop$



.section .data

game_block:     .include "images/s_block.txt"
start_screen:   .include "images/start_screen.txt"
myString:       .ascii "Hey there!"
test:           .ascii "\3407"
i_block:        .include "images/i_block.txt"
i_block_black:  .include "images/i_block_black.txt"

// game state has 1 values for blocks, and 0 for
// empty space
gameState:
    .rept   200 
    .byte   0
    .endr

currentBlock1:
    .byte   0
currentBlock2:
    .byte   0
currentBlock3:
    .byte   0
currentBlock4:
    .byte   0
currentBlockImage:
    .word   0
currentBlockImageBlack:
    .word   0
currentBlockSizeX:
    .byte   0
currentBlockSizeY:
    .byte   0
