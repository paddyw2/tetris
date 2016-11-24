
//------------------------//
.globl moveCurrentBlock
// takes button input as r1
// checks it, and decides how
// to move the current, either
// side to side, or rotate
moveCurrentBlock:
    push {lr}
    push {r9}
    mov r9, r1
    cmp r9, #0
    beq noButtonsPressed
    mov r1, #1
    // check user pressed left
    lsl r1, #6
    tst r9, r1
    bne moveBlockLeft
    lsl r1, #1
    tst r9, r1
    bne moveBlockRight
    // include code for rotation
    // here later
moveBlockLeft:
    bl moveCurrentBlockLeft
    b noButtonsPressed
moveBlockRight:
    bl moveCurrentBlockRight
    b noButtonsPressed
// include code for rotation
// here later
noButtonsPressed:
    pop {r9}
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
    // get offset
    ldr r0, =currentBlockLeftOffset
    ldrb r1, [r0]
    cmp r1, #0
    beq noMove
    // delete old block
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    // draws black block
    bl eraseCurrentBlock

    // update with new offset
    sub r1, #1
    strb r1, [r0]
    // update position in game state

    // update border tiles


    // update first coord
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    // subtract one, to move
    // left
    sub r1, #1
    strb r1, [r0]
    // update second coord
    ldr r0, =currentBlock2
    ldrb r1, [r0]
    sub r1, #1
    strb r1, [r0]
    // update third coord
    ldr r0, =currentBlock3
    ldrb r1, [r1]
    sub r1, #1
    strb r1, [r0]
    // update fourth coord
    ldr r0, =currentBlock4
    ldrb r1, [r0]
    sub r1, #1
    strb r1, [r0]

    // update border tiles
    ldr r0, =currentBorders
    ldrb r1, [r0]
    cmp r1, #255
    beq secondBorder
    sub r1, #1
    strb r1, [r0]
secondBorder:
    ldrb r1, [r0, #1]
    cmp r1, #255
    beq thirdBorder 
    sub r1, #1
    strb r1, [r0, #1]
thirdBorder:
    ldrb r1, [r0, #2]
    cmp r1, #255
    beq fourthBorder 
    sub r1, #1
    strb r1, [r0, #2]
fourthBorder:
    ldrb r1, [r0, #3]
    cmp r1, #255
    beq finishBorders 
    sub r1, #1
    strb r1, [r0, #3]
finishBorders:

    // update game state
    // with block at new
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

    // draw new image to screen
    ldr r0, =currentBlock1
    ldrb r1, [r0]
    // draws black block
    bl drawCurrentBlock

noMove:
    pop {lr}
    mov pc, lr
