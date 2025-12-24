.include "m8535def.inc"

.def adl = r17
.def adh = r16

.cseg
.org $0000
    rjmp Start

.org $000E
    rjmp CONV

.org $0015
Start:
    ldi r16, low(RAMEND)
    out SPL, r16
    ldi r16, high(RAMEND)
    out SPH, r16

    ser r16
    out DDRD, r16
    out DDRB, r16

    ldi r16, $ED
    out ADCSRA, r16

    ldi r16, $20
    out ADMUX, r16
    
    sei

Loop:
    out PORTD, adl
    out PORTB, adh
    rjmp Loop

CONV:
    in adl, ADCL
    in adh, ADCH
    reti
