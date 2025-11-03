.include "m8535def.inc"
.def cuenta = r17
.def aux = r16

	ldi aux, low(ramend)
	out spl, aux
	ldi aux, high(ramend)
	out sph, aux
	ser aux
	out ddra, aux
	out portb, aux
	clr cuenta

loop:
	rcall mostrar

wait_press:
	sbic pinb, 7
	rjmp loop
	rcall delay
	inc cuenta
	cpi cuenta, 10
	brne wait_release
	clr cuenta

wait_release:
	rcall mostrar
	sbis pinb, 7
	rjmp wait_release
	rcall delay
	rjmp wait_press

mostrar:
	push zh
	push zl
	push aux
	ldi zh, high(tabla*2)
	ldi zl, low(tabla*2)
	mov aux, cuenta
	add zl, aux	
	ldi aux, 0
	adc zh, aux
	lpm aux, z
	out porta, aux
	pop aux
	pop zl
	pop zh
	ret

delay:
	push r18
	push r19
	ldi r18, 40
d1:
	ldi r19, 250
d2:
	dec r19
	brne d2
	dec r18
	brne d1
	pop r19
	pop r18
	ret

; Tabla para display 7
tabla:
	.db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
