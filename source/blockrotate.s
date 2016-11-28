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
    bl rotateSRedBlock
    b noRotate
block4:
    // o block no rotate!
    b noRotate
block5:
    bl rotateWBlock
    b noRotate
block6:
    bl rotateLBBlock
    b noRotate
block7:
  bl rotateOBlock
    b noRotate
noRotate:
    pop {lr}
    mov pc, lr

//-----------------------//


//-----------------------//
.globl checkIfDifferentLine
checkIfDifferentLine:
    push {lr}
    // r1, r2 line values
    // returns in r0
    push {r5, r6, r7, r8, r9}
    mov r8, r1
    mov r9, r2
    mov r6, #0
subLoop:
  subs r1, #10
  blt finish1
  add r6, #1
  b subLoop
finish1:
  mov r7, r6

  mov r6, #0
subLoop2:
  subs r2, #10
  blt finish2
  add r6, #1
  b subLoop2
finish2:
  cmp r6, r7
  beq sameLine
  mov r3, #1
  b finishLineCheck
sameLine:
  mov r3, #0
finishLineCheck:
  mov r1, r8
  mov r2, r9
  pop {r5, r6, r7, r8, r9}
  pop {lr}
  mov pc, lr
//-----------------------//



//-----------------------//
.globl checkIfTwentyDiff
checkIfTwentyDiff:
    push {lr}
    // r1, r2 line values
    // returns in r0
    push {r5, r6, r7, r8, r9}
    mov r8, r1
    mov r9, r2
    mov r6, #0
subLoopT:
  subs r1, #10
  blt finish1T
  add r6, #1
  b subLoopT
finish1T:
  mov r7, r6

  mov r6, #0
subLoop2T:
  subs r2, #10
  blt finish2T
  add r6, #1
  b subLoop2T
finish2T:
  push {r6, r7}
  sub r6, r7
  cmp r6, #2
  beq twentyDiff1
  pop {r6, r7}
  sub r7, r6
  cmp r7, #2
  beq twentyDiff2
  mov r3, #0
  b finishLineCheckT
twentyDiff1:
  pop {r6, r7}
  mov r3, #1
  b finishLineCheckT
twentyDiff2:
  mov r3, #1
finishLineCheckT:
  mov r1, r8
  mov r2, r9
  pop {r5, r6, r7, r8, r9}
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

//-----------------------//
rotateSRedBlock:
    // now check current rotation
    // and execute relevant state
    // change
    push {lr}
    ldr r0, =currentBlockRotation
    ldrb r1, [r0]
    cmp r1, #0
    beq sr_state0
    cmp r1, #1
    beq sr_state1
    cmp r1, #2
    beq sr_state2
    cmp r1, #3
    beq sr_state3
    b sr_finishIRotation
sr_state0:
    bl rotate2_AB
    b sr_finishIRotation
sr_state1:
    bl rotate2_BC
    b sr_finishIRotation
sr_state2:
    bl rotate2_CD
    b sr_finishIRotation
sr_state3:
    bl rotate2_DA
    b sr_finishIRotation
sr_finishIRotation:
    pop {lr}
    mov pc, lr

//-----------------------//

//-----------------------//
rotateWBlock:
    // now check current rotation
    // and execute relevant state
    // change
    push {lr}
    ldr r0, =currentBlockRotation
    ldrb r1, [r0]
    cmp r1, #0
    beq w_state0
    cmp r1, #1
    beq w_state1
    cmp r1, #2
    beq w_state2
    cmp r1, #3
    beq w_state3
    b w_finishIRotation
w_state0:
    bl rotate4_AB
    b w_finishIRotation
w_state1:
    bl rotate4_BC
    b w_finishIRotation
w_state2:
    bl rotate4_CD
    b w_finishIRotation
w_state3:
    bl rotate4_DA
    b w_finishIRotation
w_finishIRotation:
    pop {lr}
    mov pc, lr

//-----------------------//

//-----------------------//
rotateLBBlock:
    // now check current rotation
    // and execute relevant state
    // change
    push {lr}
    ldr r0, =currentBlockRotation
    ldrb r1, [r0]
    cmp r1, #0
    beq lb_state0
    cmp r1, #1
    beq lb_state1
    cmp r1, #2
    beq lb_state2
    cmp r1, #3
    beq lb_state3
    b lb_finishIRotation
lb_state0:
    bl rotate5_AB
    b lb_finishIRotation
lb_state1:
    bl rotate5_BC
    b lb_finishIRotation
lb_state2:
    bl rotate5_CD
    b lb_finishIRotation
lb_state3:
    bl rotate5_DA
    b lb_finishIRotation
lb_finishIRotation:
    pop {lr}
    mov pc, lr

//-----------------------//

//-----------------------//

rotateOBlock:
    // now check current rotation
    // and execute relevant state
    // change
    push {lr}
    ldr r0, =currentBlockRotation
    ldrb r1, [r0]
    cmp r1, #0
    beq ob_state0
    cmp r1, #1
    beq ob_state1
    cmp r1, #2
    beq ob_state2
    cmp r1, #3
    beq ob_state3
    b ob_finishIRotation
ob_state0:
    bl rotate6_AB
    b ob_finishIRotation
ob_state1:
    bl rotate6_BC
    b ob_finishIRotation
ob_state2:
    bl rotate6_CD
    b ob_finishIRotation
ob_state3:
    bl rotate6_DA
    b ob_finishIRotation
ob_finishIRotation:
    pop {lr}
    mov pc, lr

//-----------------------//
