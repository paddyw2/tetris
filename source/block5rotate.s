/*

BLUE L ROTATION

This file contains the protocols
for each rotation of the I Block

*/

.section .text

//----------------------------//
.globl rotate5_AB
// moves I Block from initial
// state to vertical
// that is, it moves the I
// Block from state A to B
rotate5_AB:
    push {lr}
    // step1. check rotation
    // possible
    ldr r0, =gameState
    ldr r2, =currentBlock1
    ldrb r2, [r2]
    mov r1, r2
    add r2, #1
    bl checkIfDifferentLine
    cmp r3, #0
    bne noMove_AB
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_AB
    cmp r2, #0
    blt noMove_AB
    // check position is
    // not occupied
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_AB

    //as current block
    // check second coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock2
    ldrb r2, [r2]
    mov r1, r2
    sub r2, #10
    add r2, #2
    bl checkIfDifferentLine
    cmp r3, #0
    beq noMove_AB
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_AB
    cmp r2, #0
    blt noMove_AB
    // check position is
    // not occupied

    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_AB
    /*
    // check third coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock3
    ldrb r2, [r2]
    add r2, #10
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_AB
    cmp r2, #0
    blt noMove_AB
    // check position is
    // not occupied

    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_AB
    */
    // check fourth coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock4
    ldrb r2, [r2]
    mov r1, r2
    sub r2, #1
    add r2, #10
    bl checkIfDifferentLine
    cmp r3, #0
    beq noMove_AB
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_AB
    cmp r2, #0
    blt noMove_AB
    // check position is
    // not occupied

    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_AB

    // block can move

    // delete block on screen
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    bl eraseCurrentBlock

    // step2. clear game state
    ldr r0, =gameState
    ldr r2, =currentBlock1
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // second coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock2
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // third coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock3
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // fourth coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock4
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]

    // step3. update block coordinates
    ldr r0, =currentBlock1
    ldrb r2, [r0]
    add r2, #1
    strb r2, [r0]
    // update second coordinate
    ldr r0, =currentBlock2
    ldrb r2, [r0]
    sub r2, #10
    add r2, #2
    strb r2, [r0]
    // update third coordinate

    // no change
    // update fourth coordinate
    ldr r0, =currentBlock4
    ldrb r2, [r0]
    add r2, #10
    sub r2, #1
    strb r2, [r0]

    // step4. update game state with
    // new block position
    ldr r3, =currentBlockType
    ldr r3, [r3]
    ldr r2, =gameState
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update second
    ldr r0, =currentBlock2
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update third
    ldr r0, =currentBlock3
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update fourth
    ldr r0, =currentBlock4
    ldrb r1, [r0]
    strb r3, [r2, r1]

    // step5. update border tiles
    // main borders
    ldr r0, =currentBorders
    mov r1, #255
    strb r1, [r0]
    // second
    ldr r1, =currentBlock2
    ldrb r1, [r1]
    strb r1, [r0, #1]
    // third
    mov r1, #255
    strb r1, [r0, #2]
    // fourth
    ldr r1, =currentBlock4
    ldrb r1, [r1]
    strb r1, [r0, #3]

    // left borders
    // left and right borders are
    // same as block coordinates
    ldr r0, =currentLeftBorders
    // first
    ldr r1, =currentBlock1
    ldrb r1, [r1]
    strb r1, [r0]
    // second
    mov r1, #255
    strb r1, [r0, #1]
    // third
    ldr r1, =currentBlock3
    ldrb r1, [r1]
    strb r1, [r0, #2]
    // fourth
    ldr r1, =currentBlock4
    ldrb r1, [r1]
    strb r1, [r0, #3]

    // same for right coordinates
    ldr r0, =currentRightBorders
    // first
    mov r1, #255
    strb r1, [r0]
    // second
    ldr r1, =currentBlock2
    ldrb r1, [r1]
    strb r1, [r0, #1]
    // third
    ldr r1, =currentBlock3
    ldrb r1, [r1]
    strb r1, [r0, #2]
    // fourth
    ldr r1, =currentBlock4
    ldrb r1, [r1]
    strb r1, [r0, #3]

    // step6. update image files
    // and image x, y
    ldr r3, =l_block_blue_B
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =l_block_blue_black_B
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #64
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #96
    ldr r5, =currentBlockSizeY
    strb r3, [r5]

    // step7. update x offset
    ldr r0, =currentBlockLeftOffset
    ldrb r1, [r0]
    add r1, #1
    strb r1, [r0]

    // step8. update block width
    ldr r0, =currentBlockWidth
    mov r1, #2
    strb r1, [r0]

    // step9. update block state
    ldr r0, =currentBlockRotation
    mov r1, #1
    strb r1, [r0]

    // draw new block on screen
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    bl drawCurrentBlock
noMove_AB:

finishTester:
    pop {lr}
    mov pc, lr

//----------------------------//


//----------------------------//
.globl rotate5_BC
// moves I Block from vertical
// state to horizontal
// that is, it moves the I
// Block from state B to C
rotate5_BC:
    push {lr}
    // step1. check rotation
    // possible
    ldr r0, =gameState
    ldr r2, =currentBlock1
    ldrb r2, [r2]
    mov r1, r2
    add r2, #10
    sub r2, #1
    bl checkIfDifferentLine
    cmp r3, #0
    beq noMove_BC
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_BC
    cmp r2, #0
    blt noMove_BC
    // check value is not
    // occupied
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_BC
    /*
    // check second coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock2
    ldrb r2, [r2]
    add r2, #10
    sub r2, #1
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_BC
    cmp r2, #0
    blt noMove_BC
    // check position is
    // not occupied
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_BC
    */
    // check third coordinate

    ldr r0, =gameState
    ldr r2, =currentBlock3
    ldrb r2, [r2]
    mov r1, r2
    add r2, #1
    bl checkIfDifferentLine
    cmp r3, #0
    bne noMove_BC
    cmp r2, #199
    bgt noMove_BC
    cmp r2, #0
    blt noMove_BC
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_BC

    // check fourth coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock4
    ldrb r2, [r2]
    mov r1, r2
    add r2, #1
    bl checkIfDifferentLine
    cmp r3, #0
    bne noMove_BC
    cmp r2, #199
    bgt noMove_BC
    cmp r2, #0
    blt noMove_BC
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_BC

    // block can move

    // delete block on screen
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    bl eraseCurrentBlock

    // step2. clear game state
    ldr r0, =gameState
    ldr r2, =currentBlock1
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // second coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock2
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // third coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock3
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // fourth coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock4
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]

    // step3. update block coordinates
    ldr r0, =currentBlock1
    ldrb r2, [r0]
    add r2, #10
    sub r2, #1
    strb r2, [r0]
    // update second coordinate
    ldr r0, =currentBlock2
    ldrb r2, [r0]
    add r2, #10
    sub r2, #1
    strb r2, [r0]
    // update third coordinate
    ldr r0, =currentBlock3
    ldrb r2, [r0]
    add r2, #1
    strb r2, [r0]
    // update fourth coordinate
    ldr r0, =currentBlock4
    ldrb r2, [r0]
    add r2, #1
    strb r2, [r0]

    // step4. update game state with
    // new block position
    ldr r3, =currentBlockType
    ldrb r3, [r3]
    ldr r2, =gameState
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update second
    ldr r0, =currentBlock2
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update third
    ldr r0, =currentBlock3
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update fourth
    ldr r0, =currentBlock4
    ldrb r1, [r0]
    strb r3, [r2, r1]

    // step5. update border tiles
    // main borders
    ldr r0, =currentBorders
    // each bottom border is
    // same as all coordinates
    ldr r3, =currentBlock1
    ldrb r1, [r3]
    strb r1, [r0]
    ldr r3, =currentBlock2
    ldrb r1, [r3]
    strb r1, [r0, #1]
    mov r1, #255
    strb r1, [r0, #2]
    ldr r3, =currentBlock4
    ldrb r1, [r3]
    strb r1, [r0, #3]

    // left borders
    // left and right borders are
    // same as block coordinates
    ldr r0, =currentLeftBorders
    ldr r3, =currentBlock1
    ldrb r1, [r3]
    strb r1, [r0]
    mov r1, #255
    strb r1, [r0, #1]
    mov r1, #255
    strb r1, [r0, #2]
    ldr r3, =currentBlock4
    ldrb r1, [r3]
    strb r1, [r0, #3]

    // same for right coordinates
    ldr r0, =currentRightBorders
    // first
    ldr r3, =currentBlock3
    ldrb r1, [r3]
    strb r1, [r0]
    mov r1, #255
    strb r1, [r0, #1]
    mov r1, #255
    strb r1, [r0, #2]
    ldr r3, =currentBlock4
    ldrb r1, [r3]
    strb r1, [r0, #3]

    // step6. update image files
    // and image x, y
    ldr r3, =l_block_blue_C
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =l_block_blue_black_C
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #96
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #64
    ldr r5, =currentBlockSizeY
    strb r3, [r5]

    // step7. update x offset
    ldr r0, =currentBlockLeftOffset
    ldrb r1, [r0]
    sub r1, #1
    strb r1, [r0]

    // step8. update block width
    ldr r0, =currentBlockWidth
    mov r1, #3
    strb r1, [r0]

    // step9. update block state
    ldr r0, =currentBlockRotation
    mov r1, #2
    strb r1, [r0]

    // draw new block on screen
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    bl drawCurrentBlock

noMove_BC:
    pop {lr}
    mov pc, lr

//----------------------------//


//----------------------------//
.globl rotate5_CD
// moves I Block from horizontal
// state to vertical
// that is, it moves the I
// Block from state C to D
rotate5_CD:
    push {lr}

    // step1. check rotation
    // possible
    ldr r0, =gameState
    ldr r2, =currentBlock1
    ldrb r2, [r2]
    mov r1, r2
    sub r2, #10
    add r2, #1
    bl checkIfDifferentLine
    cmp r3, #0
    beq noMove_AB
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_CD
    cmp r2, #0
    blt noMove_CD
    // check value is not
    // occupied
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_CD
    // check second coordinate
      /*
    ldr r0, =gameState
    ldr r2, =currentBlock2
    ldrb r2, [r2]
    sub r2, #10
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_CD
    cmp r2, #0
    blt noMove_CD
    // check position is
    // not occupied
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_CD
    */
    // check third coordinate

    ldr r0, =gameState
    ldr r2, =currentBlock3
    ldrb r2, [r2]
    mov r1, r2
    add r2, #10
    sub r2, #2
    bl checkIfDifferentLine
    cmp r3, #0
    beq noMove_AB
    cmp r2, #199
    bgt noMove_CD
    cmp r2, #0
    blt noMove_CD
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_CD

    // check fourth coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock4
    ldrb r2, [r2]
    mov r1, r2
    sub r2, #1
    bl checkIfDifferentLine
    cmp r3, #0
    bne noMove_AB
    cmp r2, #199
    bgt noMove_CD
    cmp r2, #0
    blt noMove_CD
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_CD

    // block can move

    // delete block on screen
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    bl eraseCurrentBlock

    // step2. clear game state
    ldr r0, =gameState
    ldr r2, =currentBlock1
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // second coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock2
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // third coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock3
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // fourth coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock4
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]

    // step3. update block coordinates
    ldr r0, =currentBlock1
    ldrb r2, [r0]
    add r2, #1
    sub r2, #10
    strb r2, [r0]
    // update second coordinate
    ldr r0, =currentBlock2
    ldrb r2, [r0]
    // no change
    // update third coordinate
    ldr r0, =currentBlock3
    ldrb r2, [r0]
    add r2, #10
    sub r2, #2
    strb r2, [r0]
    // update fourth coordinate
    ldr r0, =currentBlock4
    ldrb r2, [r0]
    sub r2, #1
    strb r2, [r0]

    // step4. update game state with
    // new block position
    ldr r3, =currentBlockType
    ldrb r3, [r3]
    ldr r2, =gameState
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update second
    ldr r0, =currentBlock2
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update third
    ldr r0, =currentBlock3
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update fourth
    ldr r0, =currentBlock4
    ldrb r1, [r0]
    strb r3, [r2, r1]

    // step5. update border tiles
    // main borders
    ldr r0, =currentBorders
    mov r1, #255
    strb r1, [r0]
    mov r1, #255
    strb r1, [r0, #1]
    ldr r3, =currentBlock3
    ldrb r1, [r3]
    strb r1, [r0, #2]
    ldr r3, =currentBlock4
    ldrb r1, [r3]
    strb r1, [r0, #3]
    // left borders
    // left and right borders are
    // same as block coordinates
    ldr r0, =currentLeftBorders
    ldr r3, =currentBlock1
    ldr r1, [r3]
    strb r1, [r0]
    ldr r3, =currentBlock2
    ldrb r1, [r3]
    strb r1, [r0, #1]
    ldr r3, =currentBlock3
    ldrb r1, [r3]
    strb r1, [r0, #2]
    mov r1, #255
    strb r1, [r0, #3]

    // same for right coordinates
    ldr r0, =currentRightBorders
    ldr r3, =currentBlock1
    ldrb r1, [r3]
    strb r1, [r0]
    ldr r3, =currentBlock2
    ldrb r1, [r3]
    strb r1, [r0, #1]
    mov r1, #255
    strb r1, [r0, #2]
    ldr r3, =currentBlock4
    ldrb r1, [r3]
    strb r1, [r0, #3]

    // step6. update image files
    // and image x, y
    ldr r3, =l_block_blue_D
    ldr r2, =currentBlockImage
    str r3, [r2]
    ldr r3, =l_block_blue_black_D
    ldr r2, =currentBlockImageBlack
    str r3, [r2]
    mov r3, #64
    ldr r2, =currentBlockSizeX
    strb r3, [r2]
    mov r3, #96
    ldr r5, =currentBlockSizeY
    strb r3, [r5]

    // step7. update x offset
    ldr r0, =currentBlockLeftOffset
    ldrb r1, [r0]
    // no change

    // step8. update block width
    ldr r0, =currentBlockWidth
    mov r1, #2
    strb r1, [r0]

    // step9. update block state
    ldr r0, =currentBlockRotation
    mov r1, #3
    strb r1, [r0]

    // draw new block on screen
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    bl drawCurrentBlock

noMove_CD:
    pop {lr}
    mov pc, lr

//----------------------------//


//----------------------------//
.globl rotate5_DA
// moves I Block from vertical
// state to initial
// that is, it moves the I
// Block from state C to D
rotate5_DA:
    push {lr}

    // step1. check rotation
    // possible
    ldr r0, =gameState
    ldr r2, =currentBlock1
    ldrb r2, [r2]
    mov r1, r2
    sub r2, #1
    bl checkIfDifferentLine
    cmp r3, #0
    bne noMove_AB
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_DA
    cmp r2, #0
    blt noMove_DA
    // check value is not
    // occupied
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_DA
    // check second coordinate

    ldr r0, =gameState
    ldr r2, =currentBlock2
    ldrb r2, [r2]
    mov r1, r2
    sub r2, #1
    bl checkIfDifferentLine
    cmp r3, #0
    bne noMove_AB
    // check value is not
    // out of bounds
    cmp r2, #199
    bgt noMove_DA
    cmp r2, #0
    blt noMove_DA
    // check position is
    // not occupied
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_DA
    /*
    // check third coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock3
    ldrb r2, [r2]
    sub r2, #10
    add r2, #1
    cmp r2, #199
    bgt noMove_DA
    cmp r2, #0
    blt noMove_DA
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_DA
    */
    // check fourth coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock4
    ldrb r2, [r2]
    mov r1, r2
    sub r2, #10
    add r2, #1
    bl checkIfDifferentLine
    cmp r3, #0
    beq noMove_AB
    cmp r2, #199
    bgt noMove_DA
    cmp r2, #0
    blt noMove_DA
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove_DA

    // block can move

    // delete block on screen
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    bl eraseCurrentBlock

    // step2. clear game state
    ldr r0, =gameState
    ldr r2, =currentBlock1
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // second coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock2
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // third coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock3
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]
    // fourth coordinate
    ldr r0, =gameState
    ldr r2, =currentBlock4
    ldrb r2, [r2]
    mov r1, #0
    strb r1, [r0, r2]

    // step3. update block coordinates
    ldr r0, =currentBlock1
    ldrb r2, [r0]
    sub r2, #1
    strb r2, [r0]
    // update second coordinate
    ldr r0, =currentBlock2
    ldrb r2, [r0]
    sub r2, #1
    strb r2, [r0]
    // update third coordinate
    ldr r0, =currentBlock3
    ldrb r2, [r0]
    sub r2, #10
    add r2, #1
    strb r2, [r0]
    // update fourth coordinate
    ldr r0, =currentBlock4
    ldrb r2, [r0]
    sub r2, #10
    add r2, #1
    strb r2, [r0]

    // step4. update game state with
    // new block position
    ldr r3, =currentBlockType
    ldrb r3, [r3]
    ldr r2, =gameState
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update second
    ldr r0, =currentBlock2
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update third
    ldr r0, =currentBlock3
    ldrb r1, [r0]
    strb r3, [r2, r1]
    // update fourth
    ldr r0, =currentBlock4
    ldrb r1, [r0]
    strb r3, [r2, r1]

    // step5. update border tiles
    // main borders
    ldr r0, =currentBorders
    // bottom borders are all
    // coordinates
    mov r1, #255
    strb r1, [r0]
    ldr r3, =currentBlock2
    ldrb r1, [r3]
    strb r1, [r0, #1]
    ldr r3, =currentBlock3
    ldrb r1, [r3]
    strb r1, [r0, #2]
    ldr r3, =currentBlock4
    ldrb r1, [r3]
    strb r1, [r0, #3]



    // left borders
    ldr r0, =currentLeftBorders
    ldr r3, =currentBlock1
    ldrb r1, [r3]
    strb r1, [r0]
    ldr r3, =currentBlock2
    ldrb r1, [r3]
    strb r1, [r0, #1]
    mov r1, #255
    strb r1, [r0, #2]
    mov r1, #255
    strb r1, [r0, #3]

    // right borders
    ldr r0, =currentRightBorders
    ldr r3, =currentBlock1
    ldrb r1, [r3]
    strb r1, [r0]
    ldr r3, =currentBlock4
    ldrb r1, [r3]
    strb r1, [r0, #1]
    mov r1, #255
    strb r1, [r0, #2]
    mov r1, #255
    strb r1, [r0, #3]

    // step6. update image files
    // and image x, y
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

    // step7. update x offset
    ldr r0, =currentBlockLeftOffset
    ldrb r1, [r0]
    // no change

    // step8. update block width
    ldr r0, =currentBlockWidth
    mov r1, #3
    strb r1, [r0]

    // step9. update block state
    ldr r0, =currentBlockRotation
    mov r1, #0
    strb r1, [r0]

    // draw new block on screen
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    bl drawCurrentBlock

noMove_DA:
    pop {lr}
    mov pc, lr

//----------------------------//
