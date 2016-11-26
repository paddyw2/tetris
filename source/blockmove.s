/*

MOVE BLOCK

Processes SNES input and
determines which subroutines
to call. If rotation, calls
an outside file. If left,
right, or down, then handled
in file.

*/


//------------------------//
.globl moveCurrentBlock
// takes button input as r1
// checks it, and decides how
// to move the current, either
// side to side, or rotate
moveCurrentBlock:
    push {lr}
    push {r6, r9}
    mov r10, #23
    mov r9, r1
    cmp r9, #0
    beq noButtonsPressed
    mov r1, #1
    // check user pressed left
    lsl r1, #4
    tst r9, r1
    bne rotateBlock
    lsl r1, #1
    tst r9, r1
    bne moveBlockDown
    lsl r1, #1
    tst r9, r1
    bne moveBlockLeft
    lsl r1, #1
    tst r9, r1
    bne moveBlockRight
    b noButtonsPressed
rotateBlock:
    bl rotateBlock
    mov r0, #1
    b noButtonsPressed
moveBlockLeft:
    bl moveCurrentBlockLeft
    mov r0, #1
    b noButtonsPressed
moveBlockRight:
    bl moveCurrentBlockRight
    mov r0, #1
    b noButtonsPressed
moveBlockDown:
    mov r0, #0
    b noButtonsPressed
noButtonsPressed:
    pop {r6, r9}
    pop {lr}
    mov pc, lr
//------------------------//


//------------------------//
moveCurrentBlockLeft:
    // gets the current block
    // and updates its position
    // by moving it one to the
    // left
    push {lr}
    push {r6}
    // get offset
    ldr r0, =currentBlockLeftOffset
    ldrb r1, [r0]
    cmp r1, #0
    beq noMove
    // if move possible 

    // now check if move legal
    // first check that the block can
    // be moved to the left
    ldr r0, =gameState
    ldr r2, =currentLeftBorders
    ldrb r2, [r2]
    cmp r2, #255
    beq secondLeft
    // else increment to right
    // and check
    sub r2, #1
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove
secondLeft:
    ldr r2, =currentLeftBorders
    ldrb r2, [r2, #1]
    cmp r2, #255
    beq thirdLeft
    sub r2, #1
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove
thirdLeft:
    ldr r2, =currentLeftBorders
    ldrb r2, [r2, #2]
    cmp r2, #255
    beq fourthLeft
    sub r2, #1
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove
fourthLeft:
    ldr r2, =currentLeftBorders
    ldrb r2, [r2, #3]
    cmp r2, #255
    beq finishLeftCheck
    sub r2, #1
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge noMove

finishLeftCheck: 

    // else move legal 

    
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

    // update with new offset
    ldr r0, =currentBlockLeftOffset
    ldrb r1, [r0]
    // update with new offset
    sub r1, #1
    strb r1, [r0]

    // update state with new
    // block position
    ldr r1, =currentBlockType
    ldrb r1, [r1]
    ldr r3, =currentBlock1
    ldrb r2, [r3]
    sub r2, #1
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]
    mov r1, r2
    bl drawCurrentBlock


    ldr r1, =currentBlockType
    ldrb r1, [r1]
    ldr r3, =currentBlock2
    ldrb r2, [r3]
    sub r2, #1
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]

    ldr r3, =currentBlock3
    ldrb r2, [r3]
    sub r2, #1
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]

    ldr r3, =currentBlock4
    ldrb r2, [r3]
    sub r2, #1
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]

    // update border tiles

    mov r6, #0
    ldr r0, =currentBorders
incBordersLoop:
    cmp r6, #3
    beq finishIncBorderLoop
    ldrb r1, [r0]
    cmp r1, #255
    beq incSecond
    sub r1, #1
    strb r1, [r0]
incSecond:
    add r0, #1
    ldrb r1, [r0]
    cmp r1, #255
    beq incThird
    sub r1, #1
    strb r1, [r0]
incThird:
    add r0, #1
    ldrb r1, [r0]
    cmp r1, #255
    beq incFourth
    sub r1, #1
    strb r1, [r0]
incFourth:
    add r0, #1
    ldrb r1, [r0]
    cmp r1, #255
    beq finishInc
    sub r1, #1
    strb r1, [r0]
finishInc:
    add r6, #1
    add r0, #1
    b incBordersLoop
finishIncBorderLoop:

noMove:
    pop {r6}
    pop {lr}
    mov pc, lr



//------------------------//
moveCurrentBlockRight:
    // gets the current block
    // and updates its position
    // by moving it one to the
    // left
    push {lr}
    push {r6}
    mov r10, #123
    // get offset
    ldr r0, =currentBlockLeftOffset
    ldrb r1, [r0]
    ldr r0, =currentBlockWidth
    ldrb r0, [r0]
    add r1, r0
    cmp r1, #10
    bge r_noMove
    // if move possible 

    // now check if move legal
    // first check that the block can
    // be moved to the right
    ldr r0, =gameState
    ldr r2, =currentRightBorders
    ldrb r2, [r2]
    cmp r2, #255
    beq secondRight
    // else increment to right
    // and check
    add r2, #1
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge r_noMove
secondRight:
    ldr r2, =currentRightBorders
    ldrb r2, [r2, #1]
    cmp r2, #255
    beq thirdRight
    add r2, #1
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge r_noMove
thirdRight:
    ldr r2, =currentRightBorders
    ldrb r2, [r2, #2]
    cmp r2, #255
    beq fourthRight
    add r2, #1
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge r_noMove
fourthRight:
    ldr r2, =currentRightBorders
    ldrb r2, [r2, #3]
    cmp r2, #255
    beq finishRightCheck
    add r2, #1
    ldrb r1, [r0, r2]
    cmp r1, #1
    bge r_noMove

finishRightCheck: 
    // else legal move

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

    // update with new offset
    ldr r0, =currentBlockLeftOffset
    ldrb r1, [r0]
    // update with new offset
    add r1, #1
    strb r1, [r0]

    // update state with new
    // block position
    ldr r1, =currentBlockType
    ldrb r1, [r1]
    ldr r3, =currentBlock1
    ldrb r2, [r3]
    add r2, #1
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]
    mov r1, r2
    bl drawCurrentBlock


    ldr r1, =currentBlockType
    ldrb r1, [r1]
    ldr r3, =currentBlock2
    ldrb r2, [r3]
    add r2, #1
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]

    ldr r3, =currentBlock3
    ldrb r2, [r3]
    add r2, #1
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]

    ldr r3, =currentBlock4
    ldrb r2, [r3]
    add r2, #1
    strb r2, [r3]
    ldr r0, =gameState
    strb r1, [r0, r2]

    // update border tiles

    mov r6, #0
    ldr r0, =currentBorders
r_incBordersLoop:
    cmp r6, #3
    beq r_finishIncBorderLoop
    ldrb r1, [r0]
    cmp r1, #255
    beq r_incSecond
    add r1, #1
    strb r1, [r0]
r_incSecond:
    add r0, #1
    ldrb r1, [r0]
    cmp r1, #255
    beq r_incThird
    add r1, #1
    strb r1, [r0]
r_incThird:
    add r0, #1
    ldrb r1, [r0]
    cmp r1, #255
    beq r_incFourth
    add r1, #1
    strb r1, [r0]
r_incFourth:
    add r0, #1
    ldrb r1, [r0]
    cmp r1, #255
    beq r_finishInc
    add r1, #1
    strb r1, [r0]
r_finishInc:
    add r6, #1
    add r0, #1
    b r_incBordersLoop
r_finishIncBorderLoop:    

r_noMove:
    pop {r6}
    pop {lr}
    mov pc, lr


