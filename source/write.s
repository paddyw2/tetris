.section .text



.globl drawString
drawString:
    mov r1, lr
    push {r1}
    // string in r3
    // length in r7
    // r9=startx
    // r6=y
    // r10=color
    mov r8, #0
ds_drawStrLoop:
    cmp r8, r7
    beq ds_endDrawLoop
    ldrb r0, [r3]
    bl DrawChar
    add r3, #1
    add r8, #1
    add r9, #20
    b ds_drawStrLoop
ds_endDrawLoop:
    pop {r1}
    mov pc, r1






/* Draw the character 'B' to (0,0)
 */
DrawChar:
    push    {r4-r8, lr}

    chAdr   .req    r4
    px      .req    r5
    py      .req    r6
    row     .req    r7
    mask    .req    r8
    startx  .req    r9
    color   .req    r10

    ldr     chAdr,  =font       // load the address of the font map
    //mov     r0,     #'B'        // load the character into r0
    add     chAdr,  r0, lsl #4  // char address = font base + (char * 16)

    //mov     py,     #0          // init the Y coordinate (pixel coordinate)

charLoop$:
    mov     px,     startx         // init the X coordinate

    mov     mask,   #0x01       // set the bitmask to 1 in the LSB

    ldrb    row,    [chAdr], #1 // load the row byte, post increment chAdr

rowLoop$:
    tst     row,    mask        // test row byte against the bitmask
    beq     noPixel$

    mov     r0,     px
    mov     r1,     py
    mov     r2,     color       // red
    bl      DrawPixel           // draw red pixel at (px, py)

noPixel$:
    add     px,     #2         // increment x coordinate by 1
    lsl     mask,   #1          // shift bitmask left by 1

    tst     mask,   #0x100      // test if the bitmask has shifted 8 times (test 9th bit)
    beq     rowLoop$

    add     py,     #2        // increment y coordinate by 1

    tst     chAdr,  #0xF
    bne     charLoop$           // loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

    .unreq  chAdr
    .unreq  px
    .unreq  py
    .unreq  row
    .unreq  mask

    pop     {r4-r8, pc}

.section .data

.align 4
font:       .incbin "font.bin"
