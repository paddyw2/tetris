/*

BLOCK ROTATION

This file determines
which rotation subroutine
to call

*/


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
    cmp r1, #0
    beq block0
    b noRotate
block0:
    bl rotateIBlock


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
state1:
    bl rotate0_BC
state2:
    bl rotate0_CD
state3:
    bl rotate0_DA
finishIRotation:
    pop {lr}
    mov pc, lr

//-----------------------//
