.section .text

/* Sub Routines */
// mainly regarding graphics

//---------------------//
.globl clearScreen
// clear screen
clearScreen:
    push {lr}
    push {r4}

    mov r2, #0
    mov r3, #1024
    mov r4, #768
    mov r1, #0
    mov r0, #0

    bl drawBlock
    pop {r4}
    pop {lr}
    mov pc, lr

//---------------------//


//---------------------//
.globl drawBlock
// draw block
drawBlock:
    push {lr}
    /*
    r1 = starting y
    r0 = starting x
    r2 = color
    r3 = x
    r4 = y
    */
    push {r5-r9}
    // set parameters
    mov r5, r1
    mov r6, r0
    mov r7, r2
    mov r8, r3
    mov r9, r4
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

    pop {r5-r9}
    pop {lr}
    mov pc, lr

//---------------------//



//---------------------//
.globl drawImage
// draw image to screen
drawImage:
    push {lr}
    push {r6, r7, r8}
    /*
    r4 = image address
    r3 = image height
    r2 = image width
    r1 = start y
    r0 = start x
    */
    // get width into r8
    mov r8, r2
    mov r7, r0
    mov r6, #0
di_drawOuter:
    cmp r6, r3
    beq di_end
    mov r0, r7
    push {r6}
    mov r6, #0
di_drawInner:
    cmp r6, r8
    beq di_endDraw
    ldrh r2, [r4]
    bl DrawPixel
    add r4, #2
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

    pop {r6, r7, r8}
    pop {lr}
    mov pc, lr

//----------------------------//


//---------------------------//
.globl clearLineScreen
// moves board graphics down by
// 32px
clearLineScreen:

    // takes r1 as row to start at
    push {lr}
    push {r5, r6}

    // must start at r1*32 (y) + 32*10
    // y
    add r1, #1
    lsl r1, #5
    mov r6, r1
    // x
    // set to 620 as default
drawY:
    // set x as far right 620
    mov r0, #300
    add r0, #320
    // use r5, r6
    mov r5, r0
    // check y
    cmp r6, #32
    // if y value is less than 0, finish
    blt finishShiftScreen
    // else, draw x
drawX:
    cmp r5, #300
    // if x is less than 300, move up one line
    blt finishX
    // must first get pixel above
    sub r6, #32
    mov r0, r5
    mov r1, r6
    bl GetPixel
    // now colour is in r2
    add r6, #32
    mov r0, r5
    mov r1, r6
    // now draw pixel above, but below
    bl DrawPixel
    // decrement x coord
    sub r5, #1
    b drawX

finishX:
    // move to next line
    sub r6, #1
    b drawY

finishShiftScreen:
    pop {r5, r6}
    pop {lr}
    mov pc, lr

//---------------------------//


//---------------------------//
.globl drawCurrentScore
// draws current score to scorebox
drawCurrentScore:
    push {lr}
    push {r4, r5, r7}
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
    /*
    r1 = starting y
    r0 = starting x
    r2 = color
    r3 = x
    r4 = y
    */
    mov r0, #100
    mov r1, #75
    mov r2, #0
    mov r3, #200
    mov r4, #200
    bl drawBlock

    ldr r0, =currentScoreAscii
    cmp r4, #48
    beq drawTwo
    mov r3, r0
    mov r7, #3
    b writeScore
drawTwo:
    cmp r5, #48
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

    pop {r4, r5, r7}
    pop {lr}
    mov pc, lr

//---------------------//


//---------------------//
.globl DrawPixel
// draws pixel color at x,y coordinate
DrawPixel:
   /*
    *  r0 - x
    *  r1 - y
    *  r2 - color
    */
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

//---------------------//



//---------------------//
.globl GetPixel
// returns pixel color at x,y coordinate
GetPixel:
   /*  r0 - x
    *  r1 - y
    */
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
