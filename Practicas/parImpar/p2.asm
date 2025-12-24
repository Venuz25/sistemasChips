.include"m8535def.inc"
	
	clr zh
	clr yh
	clr xh

	ldi zl, $60
	ldi yl, $67
	ldi xl, $6e

aqui:
	ld r16, z+
	ror r16
	brcc par

impar:
	rol r16
	st x+, r16
	rjmp alla

par:
	rol r16
	st y+, r16

alla:
	cpi zl, $67
	breq fin
	rjmp aqui

fin:
	rjmp fin
