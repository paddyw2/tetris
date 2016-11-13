.section .text

//----------------------------------//
//           subroutines
//----------------------------------//

.globl Set_Lines
//----------- Set_Lines -----------//
//Parameters: NA
//Registers: r3,r4,r5,r9
//Uses: Init_GPIO
//--------------------------------//
Set_Lines:
    // sets our specific lines
    // to desired function codes
    // i.e. 9 and 11 to output
    // 10 to input
    mov r3, lr
    push {r3}
    mov r4, #9
    mov r5, #0b001
    bl Init_GPIO
    mov r4, #10
    mov r5, #0b000
    bl Init_GPIO
    mov r4, #11
    mov r5, #0b001
    bl Init_GPIO
    pop {r3}
    mov pc, r3


//----------- Init_GPIO -----------//
//Parameters: r4=pin, r5=code
//Registers: r3,r4,r6,r7,r9
//Creates: getModTen,finishedMod
//Uses: getModTen,finishedMod
//--------------------------------//
Init_GPIO:
    // r4 is pin number
    // r5 is function code
    mov r3, lr
    push {r3}
    mov r6, #0
    mov r7, r4                                          // get remainder before first iteration
  getModTen:
      subs r4, #10
      blt finishedMod
      add r6, #1                                          // increment number of times
      mov r7, r4                                          // get remainder each time
      b getModTen
  finishedMod:
      lsl r6, #2                                          // multply loop times by 4
      add r7, r7, lsl #1                                  // multply remainder by 3
      // set function of pin
      ldr r0, =0x3F200000
      add r0, r6                                          // if 40, then r6 = 16
      ldr r1, [r0]
      mov r2, #0b111                                      // set bit mask
      bic r1, r2, lsl r7                                  // clear bits
      mov r2, r5                                          // get  output code from r5
      orr r1, r2, lsl r7                                  // set output code
      str r1, [r0]                                        // store
      pop {r3}
      mov pc, r3


.globl Read_Data
//--------------- Read_Data -------------------//
//Parameters: NA
//Registers: r3,r5,r6,r9
//Creates: pulseLoop, endPulseLoop
//Uses: Write_Clock, Write_Latch, wait, Read_SNES
//      pulseLoop, endPulseLoop
//---------------------------------------------//
Read_Data:
    // store in one register, then shift bits one
    // by one
    mov r3, lr
    push {r3}
    // set up inital communication
    mov r9, #0                                          // button input register
    mov r5, #28
    bl Write_Clock                                      // set clock
    mov r5, #28
    bl Write_Latch                                      // set latch
    mov r5, #12
    bl Wait                                             // first cycle 12ms
    mov r5, #40
    bl Write_Latch                                      // clear latch

    // loop over each 16 inputs
    mov r6, #0                                          // set counter

pulseLoop:
    cmp r6, #16
    bge endPulseLoop
    mov r5, #6
    bl Wait                                             // wait 6ms
    mov r5, #40
    bl Write_Clock                                      // clear clock
    mov r5, #6
    bl Wait                                             // wait 6ms
    bl Read_SNES                                        // read input
    // if first loop, so B button
    // if r5=0000001, so B pressed
    // r9=0000000
    // or r5 and r9 equals last bit
    // set
    lsl r5, r6                                          // shift return value by loop times
    orr r9, r5                                          // or adjusted val with button reg
    add r6, #1                                          // increment counter
    // new cycle
    mov r5, #28
    bl Write_Clock                                       // set clock
    // loop
    b pulseLoop

endPulseLoop:
    pop {r3}
    mov pc, r3


.globl Check_Buttons
//--------------- Check_Buttons -------------//
//Parameters: r9=button register
//Registers: r3,r4,r5,r6,r9
//Creates: checkButtonLoop, continueButtonLoop,
//         finishButtonLoop
//Uses: Print_Button
//------------------------------------------//
Check_Buttons:
    // loop over each bit in the
    // button register
    // if bit is set, then button
    // corresponding to that bit
    // was pressed, so print
    // appropriate message
    /*
    r7= routine to call
        on button press
    */
    mov r3, lr
    push {r3}
    routine  .req    r2
    mov r4, r9                                          // get copy of button register
    mov r6, #0                                          // set button counter (B=0, Y=1 etc)
checkButtonLoop:
    cmp r6, #16                                         // check if all input looped over
    bge finishButtonLoop
    mov r5, #1                                          // get clear value
    lsl r5, r6                                          // shift clear value to target bit
    tst r4, r5                                          // and with target bit (0-15)
    beq continueButtonLoop                              // if bit not set, not pressed
    blx routine                              // if set, print appropriate button
continueButtonLoop:
    add r6, #1                                          // increment button counter
    b checkButtonLoop
finishButtonLoop:
    .unreq routine
    pop {r3}
    mov pc, r3

//--------------- Write_Clock -------------//
//Parameters: r5=set or clear (#40 or #28)
//Registers: r0,r3,r5
//Uses: stack
//-----------------------------------------//
Write_Clock:
    // set or clear defined by r5 value
    // either #40 or #28 (set)
    mov r3, lr
    push {r3}
    ldr r0, =0x3F200000
    add r0, r5
    mov r3, #1                                          // set code
    lsl r3, #11                                         // target pin
    str r3, [r0]                                        // update clock
    pop {r3}
    mov pc, r3


//--------------- Write_Latch -------------//
//Parameters: r5=set or clear (#40 or #28)
//Registers: r0,r3,r5
//Uses: stack
//-----------------------------------------//
Write_Latch:
    // set or clear defined by r5 value
    // either #40 or #28 (set)
    mov r3, lr
    push {r3}
    ldr r0, =0x3F200000
    add r0, r5
    mov r3, #1                    // set code
    lsl r3, #9                    // target latch
    str r3, [r0]                  // update latch
    pop {r3}
    mov pc, r3

.globl Wait
//--------------- Wait-------------//
//Parameters: r5=wait time
//Registers: r0,r3,r4,r5
//Creates: cycleLoop, cycleFinished
//Uses: stack
//--------------------------------//
Wait:
    // delay amount defined by r5
    // either #6 or #12
    mov r3, lr
    push {r3}
    ldr r0, =0x3F003000          // base clock address
    add r0, #4                   // get low counter
    ldr r3, [r0]                 // current time in r3
    add r4, r3, r5               // r4 = desired time
  cycleLoop:
      ldr r3, [r0]               // load new time
      cmp r3, r4
      bge cycleFinished
      b cycleLoop
  cycleFinished:
      pop {r3}
      mov pc, r3


//--------------- Read_SNES -------------//
//Parameters: NA
//Registers: r0,r3,r4,r5
//Uses: Stack
//-------------------------------------- //
Read_SNES:
    // output in r5
    mov r3, lr
    push {r3}
    ldr r0, =0x3F200000
    add r0, #52
    ldr r4, [r0]            // get the 32bit value of pins
    mov r3, #1
    lsl r3, #10             // so r3 = 00000100000 where 1 is 10th bit
    tst r3, r4              // and with r4, could be 11111101111
    moveq r5, #1            // if pin not set, then input (zero flag)
    movne r5, #0            // else no input, return 0 (no flag)
    pop {r3}
    mov pc, r3





//---------------Data Section-----------//
.section        .data

//------------ Variables ------------//

//----------------- End ---------------------//
