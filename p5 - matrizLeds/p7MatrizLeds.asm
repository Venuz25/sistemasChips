.include"m8535def.inc"
	.def col = r17
	.def cont = r21
	.def cont2 = r22
	.def ocho = r23
	.def repeticiones = r24
	.def frame_actual = r25

	ldi r16, low(ramend)
	out spl, r16
	ldi r16, high(ramend)
	out sph, r16
	ldi ocho, 8
	ldi repeticiones, 20
	clr frame_actual

	ser r16
	out ddra, r16
	out ddrc, r16

main_loop:
	ldi repeticiones, 20

repetir_frame:
	clr cont2

mostrar_frame:
	clr cont

mostrar_columna:
	ldi ZH, high(A<<1)
	ldi ZL, low(A<<1)
	
	mov r16, frame_actual
	lsl r16
	lsl r16
	lsl r16
	add ZL, r16
	
	add ZL, cont2
	adc ZH, cero
	
	lpm r16, Z+
	ldi col, $80

scan_loop:
	rcall delay
	com r16
	out portc, col
	out porta, r16
	lpm r16, Z+
	lsr col
	brcc scan_loop
	
	inc cont
	cpi cont, 8
	brne mostrar_columna
	
	add cont2, ocho
	cpi cont2, 8
	brne mostrar_frame

	dec repeticiones
	brne repetir_frame

	inc frame_actual
	cpi frame_actual, 4 
	brne main_loop
	clr frame_actual
	rjmp main_loop

delay:
	ldi r18, $09
WGLOOP0:
	ldi r19, $6E
WGLOOP1:
	dec r19
	brne WGLOOP1
	dec r18
	brne WGLOOP0
	ldi r18, $01
WGLOOP2:
	dec r18
	brne WGLOOP2
	ret

.def cero = r20

A:
; Frame 1: Feliz
.db 0x3c, 0x42, 0xa5, 0x81, 0xa5, 0x99, 0x42, 0x3c

B:
; Frame 2: Seria  
.db 0x3c, 0x42, 0xa5, 0x81, 0xbd, 0x81, 0x42, 0x3c

C:
; Frame 3: Triste
.db 0x3c, 0x42, 0xa5, 0x81, 0x99, 0xa5, 0x42, 0x3c

D:
; Frame 4: Seria
.db 0x3c, 0x42, 0xa5, 0x81, 0xbd, 0x81, 0x42, 0x3c
