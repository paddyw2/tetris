/* contains block insert code */
.section .text

//----------------------------//
.globl insertNewIBeam
// initializes a new ibeam
insertNewIBeam:
    push {lr}
    push {r5, r8}
    // first coords are
    // 0, 1, 2, 3


    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #0]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #1]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #2]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #3]
    cmp r1, #1
    beq quitProgram

    // max left shifted value
    // is 6
    mov r1, #6
    bl xorShift
    mov r8, r1
    // update offset value
    ldr r3, =currentBlockLeftOffset
    strb r8, [r3]

    ldr r0, =currentBlock1
    mov r1, #0
    // add offset
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #1
    // add offset
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #2
    // add offset
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #3
    // add offset
    add r1, r8
    strb r1, [r0]

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #0
    add r1, r8
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #1
    add r1, r8
    strb r1, [r0, #1]
    mov r1, #2
    add r1, r8
    strb r1, [r0, #2]
    mov r1, #3
    add r1, r8
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
    
    pop {r5, r8}
    pop {lr}
    mov pc, lr
//------------------------------//


//------------------------------//
.globl insertNewSBeam
// initializes a new sbeam
insertNewSBeam:
    push {lr}
    push {r5, r8}
    // first coords are // 1,2,10,11 // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #1]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #2]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #10]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #11]
    cmp r1, #1
    beq quitProgram

    // max left shifted value
    // is 6
    mov r1, #7
    bl xorShift
    mov r8, r1
    // update offset value
    ldr r3, =currentBlockLeftOffset
    strb r8, [r3]


    ldr r0, =currentBlock1
    mov r1, #1
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #2
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #10
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #11
    add r1, r8
    strb r1, [r0]

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #255
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #2
    add r1, r8
    strb r1, [r0, #1]
    mov r1, #10
    add r1, r8
    strb r1, [r0, #2]
    mov r1, #11
    add r1, r8
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
    
    pop {r5, r8}
    pop {lr}
    mov pc, lr

//----------------------------//


//----------------------------//
// initializes a new obeam
insertNewOBeam:
    push {lr}
    push {r5, r8}
    // first coords are
    // 0,1,10,11

    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #0]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #1]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #10]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #11]
    cmp r1, #1
    beq quitProgram

    // max left shifted value
    // is 8
    mov r1, #8
    bl xorShift
    mov r8, r1
    // update offset value
    ldr r3, =currentBlockLeftOffset
    strb r8, [r3]


    ldr r0, =currentBlock1
    mov r1, #0
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #1
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #10
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #11
    add r1, r8
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
    add r1, r8
    strb r1, [r0, #2]
    mov r1, #11
    add r1, r8
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

    pop {r5, r8}
    pop {lr}
    mov pc, lr

//----------------------------//


//----------------------------//
// initializes a new wbeam
insertNewWBeam:
    push {lr}
    push {r5, r8}
    // first coords are
    // 1,10,11,12

    // first check that new block can
    // be inserted
    ldr r0, =gameState
    ldrb r1, [r0, #1]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #10]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #11]
    cmp r1, #1
    beq quitProgram
    ldrb r1, [r0, #12]
    cmp r1, #1
    beq quitProgram

    // max left shifted value
    // is 7
    mov r1, #7
    bl xorShift
    mov r8, r1
    // update offset value
    ldr r3, =currentBlockLeftOffset
    strb r8, [r3]


    ldr r0, =currentBlock1
    mov r1, #1
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock2
    mov r1, #10
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock3
    mov r1, #11
    add r1, r8
    strb r1, [r0]
    ldr r0, =currentBlock4
    mov r1, #12
    add r1, r8
    strb r1, [r0]

    // update border tiles
    //
    ldr r0, =currentBorders
    mov r1, #255
    strb r1, [r0]
    // skip 2, as not border
    mov r1, #10
    add r1, r8
    strb r1, [r0, #1]
    mov r1, #11
    add r1, r8
    strb r1, [r0, #2]
    mov r1, #12
    add r1, r8
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
    
    pop {r4, r5}
    pop {lr}
    mov pc, lr

//----------------------------

