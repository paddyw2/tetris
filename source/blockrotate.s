/*

BLOCK ROTATION

This file determines
which rotation subroutine
to call

*/

.section .text

//-----------------------//
.globl rotateBlock
// detects what type the
// current block is, and
// what its current rotation
// position is
// then moves it to the
// next rotation position
rotateBlock:
    push {lr}
    ldr r0, =currentBlockType
    ldrb r1, [r0]
    // check for I Block
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
    b noRotate
block1:
    bl rotateIBlock
    b noRotate
block2:
    bl rotateSGreenBlock
    b noRotate
block3:
    // rotate Red S
    b noRotate
block4:
    // rotate O Block
    b noRotate
block5:
    // rotate W Block
    b noRotate
block6:
    // rotate Blue L
    b noRotate
block7:
    // rotate Orange L
    b noRotate
noRotate:
    pop {lr}
    mov pc, lr

//-----------------------//


//-----------------------//
rotateIBlock:
    // now check current rotation
    // and execute relevant state
    // change 
    push {lr}
    ldr r0, =currentBlockRotation
    ldrb r1, [r0]
    cmp r1, #0
    beq state0
    cmp r1, #1
    beq state1
    cmp r1, #2
    beq state2
    cmp r1, #3
    beq state3
    b finishIRotation
state0:
    bl rotate0_AB
    b finishIRotation
state1:
    bl rotate0_BC
    b finishIRotation
state2:
    bl rotate0_CD
    b finishIRotation
state3:
    bl rotate0_DA
    b finishIRotation
finishIRotation:
    pop {lr}
    mov pc, lr

//-----------------------//


//-----------------------//
rotateSGreenBlock:
    // now check current rotation
    // and execute relevant state
    // change 
    push {lr}
    ldr r0, =currentBlockRotation
    ldrb r1, [r0]
    cmp r1, #0
    beq sg_state0
    cmp r1, #1
    beq sg_state1
    cmp r1, #2
    beq sg_state2
    cmp r1, #3
    beq sg_state3
    b sg_finishIRotation
sg_state0:
    bl rotate1_AB
    b sg_finishIRotation
sg_state1:
    bl rotate1_BC
    b sg_finishIRotation
sg_state2:
    bl rotate1_CD
    b sg_finishIRotation
sg_state3:
    bl rotate1_DA
    b sg_finishIRotation
sg_finishIRotation:
    pop {lr}
    mov pc, lr

//-----------------------//
