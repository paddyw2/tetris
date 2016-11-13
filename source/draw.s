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


.section .data

greenScreen:    .ascii "\3407"
