	.include "m8535def.inc"

	.def HEX = R16
	.def ASC = R17	

	ser R16
	out DDRA, R16
	out PORTB, R16

ciclo:
	in ASC, PINB
	ldi HEX, $30
	add HEX, ASC

	cpi HEX, $3A 
	brsh letra

guar:
	out PORTA, HEX
	rjmp ciclo

letra:
	ldi ASC, 7
	add HEX, ASC
	rjmp guar
