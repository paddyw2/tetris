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
    b StartGame

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
    bl setSeed


InsertNewBlock:
    // initializes new ibeam
    // at 0,0

    // L orange block not stacking properly
    //s red block not working?
    bl insertRandomBlock
   // bl insertNewLOBeam

    // set initial coords

    mov r1, #0
    mov r0, #300
    // draws intial block position
    bl drawCurrentBlock

    // moves current block down
    // until it cannot move further
    bl moveBlockDown

    // loops until moveBlockDown
    // detects end of game stat

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
 //   add r1, r7

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
//    add r1, r7


    bl drawCurrentBlock


    mov r1, #1
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

    ldr r0, =currentBorders
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
    // delay after each block draw
    mov r5, #1000
    lsl r5, #6
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
    beq hitOtherBlock

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
    beq hitOtherBlock

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
    beq hitOtherBlock

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

    ldr r3, =topLeftBlock
    ldrb r3, [r3]
    cmp r3, #0
    b noCoordChange
coordChange:
    subs r1, #32
    blt topOfGrid
    b noCoordChange
topOfGrid:
    add r1, #32
noCoordChange: 
    ldr r3, =topLeftBlock
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
    ldr r3, =topLeftBlock
    ldrb r3, [r3]
    cmp r3, #0
    b eraseNoCoordChange
eraseCoordChange:
    subs r1, #32
    blt eraseTopOfGrid
    b eraseNoCoordChange
eraseTopOfGrid:
    add r1, #32
eraseNoCoordChange:


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

    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #0]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #1]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #2]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #3]
    cmp r1, #1
    beq haltLoop$



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

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #0
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #1
    strb r1, [r0, #1]
    mov r1, #2
    strb r1, [r0, #2]
    mov r1, #3
    strb r1, [r0, #3]


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

    // indicate that top left is filled
    mov r5, #0
    ldr r3, =topLeftBlock
    strb r5, [r3]


    pop {r4}
    mov pc, r4

//----------------------------


// initializes a new ibeam
// block at 0,0 on the screen
// and game state
insertNewSBeam:
    mov r4, lr
    push {r4}
    // first coords are
    // 1,2,10,11

    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #1]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #2]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #10]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #11]
    cmp r1, #1
    beq haltLoop$


    ldr r0, =currentBlock1
    mov r1, #1
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #2
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #10
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #11
    strb r1, [r0]

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #255
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #2
    strb r1, [r0, #1]
    mov r1, #10
    strb r1, [r0, #2]
    mov r1, #11
    strb r1, [r0, #3]

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
    ldr r3, =s_block_green
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =s_block_green_black
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #96
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #64
    ldr r5, =currentBlockSizeY
    strb r3, [r5]
    // add flag indicating top left
    // position is blank
    mov r5, #1
    ldr r3, =topLeftBlock
    strb r5, [r3]

    pop {r4}
    mov pc, r4

//----------------------------

//edit n0v 26



// initializes a new obeam
// block at 0,0 on the screen
// and game state
insertNewOBeam:
    mov r4, lr
    push {r4}
    // first coords are
    // 0,1,11,12

    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #0]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #1]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #10]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #11]
    cmp r1, #1
    beq haltLoop$


    ldr r0, =currentBlock1
    mov r1, #0
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #1
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #10
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #11
    strb r1, [r0]

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #255
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #255
    strb r1, [r0, #1]
    mov r1, #10
    strb r1, [r0, #2]
    mov r1, #11
    strb r1, [r0, #3]

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
    ldr r3, =o_block_yellow
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =o_block_yellow_black
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #64
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #64
    ldr r5, =currentBlockSizeY
    strb r3, [r5]

    // indicate that top left is filled
    mov r5, #0
    ldr r3, =topLeftBlock
    strb r5, [r3]


    pop {r4}
    mov pc, r4

//----------------------------






// initializes a new obeam
// block at 0,0 on the screen
// and game state
insertNewWBeam:
    mov r4, lr
    push {r4}
    // first coords are
    // 0,1,11,12

    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #1]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #10]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #11]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #12]
    cmp r1, #1
    beq haltLoop$


    ldr r0, =currentBlock1
    mov r1, #1
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #10
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #11
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #12
    strb r1, [r0]

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #255
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #10
    strb r1, [r0, #1]
    mov r1, #11
    strb r1, [r0, #2]
    mov r1, #12
    strb r1, [r0, #3]

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
    ldr r3, =w_block
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =w_block_black
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #96
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #64
    ldr r5, =currentBlockSizeY
    strb r3, [r5]
    // indicate that top left is filled
    mov r5, #1
    ldr r3, =topLeftBlock
    strb r5, [r3]


    pop {r4}
    mov pc, r4

//----------------------------


// initializes a new obeam
// block at 0,0 on the screen
// and game state
insertNewLBBeam:
    mov r4, lr
    push {r4}
    // first coords are
    // 0,1,11,12

    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #0]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #10]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #11]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #12]
    cmp r1, #1
    beq haltLoop$


    ldr r0, =currentBlock1
    mov r1, #0
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #10
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #11
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #12
    strb r1, [r0]

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #255
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #10
    strb r1, [r0, #1]
    mov r1, #11
    strb r1, [r0, #2]
    mov r1, #12
    strb r1, [r0, #3]

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
    ldr r3, =l_block_blue
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =l_block_blue_black
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #96
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #64
    ldr r5, =currentBlockSizeY
    strb r3, [r5]
    // indicate that top left is filled
    mov r5, #0
    ldr r3, =topLeftBlock
    strb r5, [r3]


    pop {r4}
    mov pc, r4

//----------------------------




// initializes a new obeam
// block at 0,0 on the screen
// and game state
insertNewLOBeam:
    mov r4, lr
    push {r4}
    // first coords are
    // 0,1,11,12

    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #2]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #10]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #11]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #12]
    cmp r1, #1
    beq haltLoop$



    ldr r0, =currentBlock1
    mov r1, #2
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #10
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #11
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #12
    strb r1, [r0]

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #255
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #10
    strb r1, [r0, #1]
    mov r1, #11
    strb r1, [r0, #2]
    mov r1, #12
    strb r1, [r0, #3]

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
    ldr r3, =l_block_orange
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =l_block_orange_black
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #96
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #64
    ldr r5, =currentBlockSizeY
    strb r3, [r5]
    // add flag indicating top left
    // position is blank
    mov r5, #1
    ldr r3, =topLeftBlock
    strb r5, [r3]

    pop {r4}
    mov pc, r4

//----------------------------






// initializes a new obeam
// block at 0,0 on the screen
// and game state
insertNewSRBeam:
    mov r4, lr
    push {r4}
    // first coords are
    // 0,1,11,12

    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #0]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #1]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #11]
    cmp r1, #1
    beq haltLoop$
    ldrb r1, [r0, #12]
    cmp r1, #1
    beq haltLoop$

    // if it can, continue

    ldr r0, =currentBlock1
    mov r1, #0
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #1
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #11
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #12
    strb r1, [r0]

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #0
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #255
    strb r1, [r0, #1]
    mov r1, #11
    strb r1, [r0, #2]
    mov r1, #12
    strb r1, [r0, #3]

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
    ldr r3, =s_block_red
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =s_block_red_black
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #96
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #64
    ldr r5, =currentBlockSizeY
    strb r3, [r5]
    // indicate that top left is filled
    mov r5, #0
    ldr r3, =topLeftBlock
    strb r5, [r3]


    pop {r4}
    mov pc, r4

//----------------------------


//edit n0v 26




// basic concept referenced from:
// http://www.arklyffe.com/main/2010/08/29/xorshift-pseudorandom-number-generator/
xorShift:
    // takes single parameter as
    // r8 which defines the largest
    // value allowed
    // note: this will never return
    // 0, so to achieve this 1 is
    // added to the range and then
    // 1 is subbed from the return
    // value
    // if range is r8=8
    // will generate 0-8 inclusive
    mov r5, lr
    push {r5}
    // range max in r8
    // add 1 to allow for zero
    // values
    add r8, #1
    // seed value
    ldr r0, =randSeedVal
    ldrb r0, [r0]
    mov r1, r0
    // shift seed value by 
    lsl r0, #7
    eor r1, r0
    mov r2, r1
    lsr r1, #5
    eor r1, r2
    mov r2, r1
    lsl r2, #3
    eor r1, r2
    
    ldr r0, =randSeedVal
    strb r1, [r0]

// to get a number within range
// simply modulo until value
// within range
randModLoop:
    cmp r1, r8
    ble finishRand
    sub r1, r8
    b randModLoop
finishRand:
    // to allow for zero values
    sub r1, #1
    // return random value in r1
    pop {r5}
    mov pc, r5



setSeed:
    // sets the seed value
    // to the system time after
    // clear screen executed, in
    // theory different each time
    // to ensure different sequences
    mov r5, lr
    push {r5}


    ldr r1, =randSeedVal
    ldr r0, =0x3F003000                                 // base clock address
    ldrh r2, [r0, #4]                                    // get current time
    strh r2, [r1]
    pop {r5}
    mov pc, r5


insertRandomBlock:
    mov r5, lr
    push {r5}

    mov r8, #7
    bl xorShift
    mov r11, r1
    
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
    cmp r1, #7
    beq block7


block0:
    bl insertNewSRBeam
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
block7:
    bl insertNewOBeam
    b finishRandInsert




finishRandInsert:
    pop {r5}
    mov pc, r5







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
s_block_green:        .include "images/s_block_green.txt"
s_block_green_black:  .include "images/s_block_green_black.txt"
s_block_red:    .include "images/s_block_red.txt"
s_block_red_black: .include "images/s_block_red_black.txt"

o_block_yellow: .include "images/o_block_yellow.txt"
o_block_yellow_black: .include "images/o_block_yellow_black.txt"

w_block: .include "images/w_block.txt"
w_block_black: .include "images/w_block_black.txt"

l_block_blue: .include "images/l_block_blue.txt"
l_block_blue_black: .include "images/l_block_blue_black.txt"


l_block_orange: .include "images/l_block_orange2.txt"
l_block_orange_black: .include "images/l_block_orange_black2.txt"


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
currentBorders:
    .byte   0,0,0,0
currentBlockImage:
    .word   0
currentBlockImageBlack:
    .word   0
currentBlockSizeX:
    .byte   0
currentBlockSizeY:
    .byte   0
currentBlockLeftOffset:
    .byte   300
topLeftBlock:
    .byte   0
randSeedVal:
    .word   2008                                           // originally 37, now set with setSeed
