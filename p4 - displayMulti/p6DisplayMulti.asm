.include "m8535def.inc"

.equ B = $7C
.equ I = $30
.equ R = $50
.equ A  = $77

.macro ldb
	ldi r16, @1
	mov @0, r16
.endm

.def col  = r17
.def dato = r18

ldi dato, low(RAMEND)
out SPL, dato
ldi dato, high(RAMEND)
out SPH, dato

ser dato
out DDRB, dato
out DDRC, dato

ldb r0, B
ldb r1, I
ldb r2, R
ldb r3, R
ldb r4, I
ldb r5, A

clr ZH

dos:
	clr ZL
	ldi col, 4
uno:
	com col
	out PORTC, col
	com col
	ld dato, Z+
	out PORTB, dato
	rcall delay
	out PORTB, ZH
	lsl col
	cpi col, $00
	brne uno
	rjmp dos

delay:
	ldi R19, $0F
WGLOOP0:
	ldi R20, $2A
WGLOOP1:
	dec R20
	brne WGLOOP1
	dec R19
	brne WGLOOP0
	nop
	ret
