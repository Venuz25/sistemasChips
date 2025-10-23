	.include"m8535def.inc"
	.def aux = R16

	ser aux
	out DDRA, aux
	out PORTB, aux

	ldi R20, $3F
	ldi R21, $06
	ldi R22, $5b
	ldi R23, $4f
	ldi R24, $66
	ldi R25, $6d
	ldi R26, $7d
	ldi R27, $27
	ldi R28, $7f
	ldi R29, $6f

	clr zh

NVO:
	ldi zl, 20
	in aux, PINB
	add zl, aux
	ld aux, z
	out PORTA, aux
	rjmp NVO
