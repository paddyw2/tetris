.section .text

/* Sub Routines */

// clear screen
.globl clearScreen
clearScreen:
    mov r3, lr
    push {r3}

    /*
    r7 = color
    */
    mov r8, #1024
    mov r9, #768
    mov r5, #0
    mov r6, #0
    bl drawBlock
    pop {r3}
    mov pc, r3


// draw block
.globl drawBlock
drawBlock:
    mov r3, lr
    push {r3}
    /*
    r5 = starting y
    r6 = starting x
    r7 = color
    r8 = x
    r9 = y
    */
    // add height of image
    // to starting y coord
    add r9, r5
cs_drawHeight:
    cmp r5, r9
    beq cs_totalEnd
    push {r6}
cs_drawLoop:   
    cmp r6, r8
    beq cs_endLoop
    mov r0, r6
    mov r1, r5
    mov r2, r7
    bl DrawPixel
    add r6, #1
    b cs_drawLoop
cs_endLoop:
    add r5, #1
    pop {r6}
    b cs_drawHeight
cs_totalEnd:
    pop {r3}
    mov pc, r3



// draw image to screen

.globl drawImage
drawImage:
    mov r6, lr
    push {r6}
    /*
    r5 = image height
    r4 = image width
    r3 = image address
    r1 = start y
    r0 = start x
    */
    mov r7, r0
    mov r6, #0
di_drawOuter:
    cmp r6, r5
    beq di_end 
    mov r0, r7
    push {r6}
    mov r6, #0
di_drawInner:
    cmp r6, r4
    beq di_endDraw
    ldrh r2, [r3]
    bl DrawPixel
    add r3, #2
    add r6, #1
    mov r0, r6
    add r0, r7
    b di_drawInner
di_endDraw:
    pop {r6}
    add r1, #1
    add r6, #1
    b di_drawOuter
di_end:

    mov r12, r2
    pop {r6}
    mov pc, r6


//----------------------------//


.globl clearLineScreen
clearLineScreen:
    
    // takes r1 as row to start at
    mov r3, lr
    push {r3}
    
    // must start at r1*32 (y) + 32*10
    // y
    add r1, #1
    lsl r1, #5
    // x
drawY:
    // set x as far right 620
    mov r0, #300
    add r0, #320
    // check y
    cmp r1, #32
    // if y value is less than 0, finish
    blt finishShiftScreen
    // else, draw x
drawX:
    cmp r0, #300
    // if x is less than 300, move up one line
    blt finishX
    // must first get pixel above
    sub r1, #32
    push {r1}
    push {r0}
    bl GetPixel
    pop {r0}
    pop {r1}
    // now colour is in r2
    add r1, #32
    push {r0}
    push {r1}
    // now draw pixel above, but below
    bl DrawPixel
    pop {r1}
    pop {r0}
    // decrement x coord
    sub r0, #1
    b drawX

finishX:
    // move to next line
    sub r1, #1
    b drawY
    
finishShiftScreen:
    pop {r3}
    mov pc, r3

//---------------------------//

.globl drawCurrentScore
drawCurrentScore:
    mov r3, pc
    push {r3}
    // score value in r1
    ldr r0, =currentScoreAscii
    // convert to ascii
    mov r4, #0
    mov r5, #0
getFirstDigit:
    cmp r1, #100
    blt getSecondDigit
    sub r1, #100
    add r4, #1
    b getFirstDigit
getSecondDigit:
    cmp r1, #10
    blt getThirdDigit
    sub r1, #10
    add r5, #1
    b getSecondDigit
getThirdDigit:
    // r1 = third digit  

    // update address with
    // ascii value
    add r4, #48
    add r5, #48
    add r1, #48
    strb r4, [r0]
    strb r5, [r0, #1]
    strb r1, [r0, #2]
    // clear score area



   
    ldr r0, =currentScoreAscii
    cmp r4, #0
    beq drawTwo
    mov r3, r0
    mov r7, #3
    b writeScore
drawTwo:
    cmp r5, #0
    beq drawOne
    add r0, #1
    mov r3, r0
    mov r7, #2
    b writeScore
drawOne:
    add r0, #2
    mov r3, r0
    mov r7, #1
writeScore:
    mov r9, #100
    mov r6, #100
    mov r10, #0xff
    bl drawString
    
    pop {r3}
    mov pc, r3
   

/* Draw Pixel
 *  r0 - x
 *  r1 - y
 *  r2 - color
 */ 
.globl DrawPixel
DrawPixel:
    push    {r4}
    push    {r3}
    offset  .req    r4

    // offset = (y * 1024) + x = x + (y << 10)

    // check if pixel part of green
    // screen
    ldr r3, =greenScreen
    ldrh r3, [r3]
    cmp r2, r3
    // if it is, do not print anything
    beq dp_skipPrint

    add     offset, r0, r1, lsl #10
    // offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)

    lsl     offset, #1
    // store the colour (half word) at framebuffer pointer + offset

    ldr r0, =FrameBufferPointer
    ldr r0, [r0]
    strh    r2, [r0, offset]

dp_skipPrint:
    pop     {r3}
    pop     {r4}
    bx      lr


.globl GetPixel
GetPixel:
    // copy of drawPixel
    // that gets the current color value
    // at an x,y coordinate
    push    {r4}
    offset  .req    r4

    // offset = (y * 1024) + x = x + (y << 10)

    add     offset, r0, r1, lsl #10
    // offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)

    lsl     offset, #1
    // load the colour (half word) at framebuffer pointer + offset
    // into r2

    ldr r0, =FrameBufferPointer
    ldr r0, [r0]

    // now instead of storing our r2 value in the buffer
    // location, we instead load the buffer location value
    // into r2, and return it
    ldrh    r2, [r0, offset]

    // now we will print the r2 value to drawPixel, only
    // at coordinates -10 on the y axis, and within 300 to
    // 620 on the x (stopping at the top of the game grid)
    // and this will shift our game visuals down a block
    pop     {r4}
    bx      lr


.section .data

greenScreen:    .ascii "\3407"
currentScoreAscii:   .ascii ""
