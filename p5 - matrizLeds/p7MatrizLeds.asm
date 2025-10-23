.include"m8535def.inc"
	.def col = r17
	.def cont = r21
	.def cont2 = r22
	.def ocho = r23

	ldi r16, low(ramend)
	out spl, r16
	ldi r16, high(ramend)
	out sph, r16
	ldi ocho, 8

	ser r16
	out ddra, r16
	out ddrc, r16

tres:
	clr cont2

dos:
	clr cont

uno:
	ldi ZH, high(A<<1)
	ldi ZL, low(A<<1)
	add zl, cont2
	lpm r16, z+
	ldi col, $80

loop:
	rcall delay
	com r16
	out portc, col
	out porta, r16
	lpm r16, z+
	lsr col
	brcc loop
	inc cont
	cpi cont, 8
	brne uno
	add cont2, ocho
	cpi cont2, 32
	breq tres
	rjmp dos

delay:
	ldi r18, $39
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
