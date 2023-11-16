#Adam Hanna-HW4

.text
    .set noreorder
    .globl main
    .ent main

#include <xc.h>

main:
    sw    zero, TRISA
    sw    zero, ANSELA
    not    t0, zero
    sw    t0, TRISB
    sw    zero, ANSELB
    sw    zero, TRISC
    sw    zero, ANSELC

    li    t0, _PORTA_RA0_MASK
    li    t1, _PORTC_RC9_MASK
    li    t5, _PORTB_RB7_MASK
    li    t6, _PORTB_RB13_MASK

    li    t7, 4
    la    t8, periods

pollS1:
    lw    t2, PORTB
    andi    t3, t2, _PORTB_RB7_MASK
    bne    t3, zero, copyS1
    nop
    beq    t3, t5, pollS2
    nop

    jal    delay
    nop

    lw    t2, PORTB
    andi    t3, t2, _PORTB_RB7_MASK 
    bne    t3, zero, copyS1
    nop

    sw    t0, LATAINV

copyS1:
    add    t5, t3, zero

pollS2:
    andi    t4, t2, _PORTB_RB13_MASK
    bne    t4, zero, copyS2
    nop
    beq    t4, t6, pollS1
    nop

    jal    delay
    nop

    lw    t2, PORTB
    andi    t4, t2, _PORTB_RB13_MASK 
    bne    t4, zero, copyS2
    nop

    sw    t1, LATCINV

copyS2:
    add    t6, t4, zero

    j    pollS1
    nop

updatePeriod:
    bne    t5, zero, decreasePeriod
    bne    t4, zero, increasePeriod
    j    spin
    nop

decreasePeriod:
    subi    t7, t7, 1
    bgtz    t7, spin
    li    t7, 0
    j    spin
    nop

increasePeriod:
    addi    t7, t7, 1
    bltz    t7, spin
    li    t7, 4
    j    spin
    nop

spin:
    lw    t9, 0(t8)
    jal    delay
    move    t9, t7
    j    spin
    nop

periods:
    .word    75000
    .word    50000
    .word    100000
    .word    125000

.ent delay
delay:
    add    t1, t9, zero
loop:
    addi    t1, t1, -1
    bne    t1, zero, loop
    nop
    jr    ra
    nop

.end delay

.end main
