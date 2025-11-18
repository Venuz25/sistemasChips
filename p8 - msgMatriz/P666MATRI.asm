	.include"m8535def.inc"
	.def aux =r16
	.def col=r17
	.def cero=r19
	.def point=r20

.macro txt
	ldi zh,high(@0<<1)
	ldi zl,low(@0<<1)
	clr yh
	ldi yl,$60
etq1:
	lpm aux,z+
	st y+,aux
	cpi yl,$68
	brne etq1

	ldi zh,high(@1<<1)
	ldi zl,low(@1<<1)
etq2:
	lpm aux,z+
	st y+,aux
	cpi yl,$68+$08
	brne etq2

	ldi zh,high(@2<<1)
	ldi zl,low(@2<<1)
etq3:
	lpm aux,z+
	st y+,aux
	cpi yl,$68+$08+$08
	brne etq3

	ldi zh,high(@3<<1)
	ldi zl,low(@3<<1)
etq4:
	lpm aux,z+
	st y+,aux
	cpi yl,$68+$08+$08+$08
	brne etq4

	; AGREGAR QUINTA LETRA
	ldi zh,high(@4<<1)
	ldi zl,low(@4<<1)
etq5:
	lpm aux,z+
	st y+,aux
	cpi yl,$68+$08+$08+$08+$08  ; Nueva dirección final
	brne etq5
	.endm

reset:
	rjmp main
	rjmp texto1
	rjmp texto2
	.org $008
	rjmp corre
	rjmp barre
	.org $012
	rjmp stop
main:
	ldi aux,low(ramend)
	out spl,aux
	ldi aux,high(ramend)
	out sph, aux
	clr cero
	rcall config_io
	rcall texto0
	clr zh
	ldi point,$60
	mov zl,point
	ldi col,1
	com col
	out portc,col
	com col
	ld aux,z
	out porta,aux
uno:nop
	nop
	rjmp uno
config_io:
	ser aux
	out ddra,aux
	out portb,aux
	out ddrc,aux
	out portd,aux
	ldi aux,2
	out tccr0,aux
	ldi aux,2
	out tccr1b,aux
	ldi aux,$01
	out timsk,aux
	ldi r18,193
	ldi aux,$0a
	out mcucr,aux
	ldi aux,$e0
	out gicr,aux
	sei
	ret

texto0:
	txt S,U,N,E,M  ; Agregar quinta letra
	ret
texto1:
	txt A,R,E,L,I  ; Agregar quinta letra
	clr zh
	mov zl,point
	reti
texto2:
	txt M,A,Ye,Dp,Dp  ; Agregar quinta letra
	clr zh
	mov zl,point
	reti

barre:
	out tcnt0,r18
	out porta,cero
	inc zl
	lsl col
	brne dos
	ldi col,1
	mov zl,point
dos:
	com col
	out portc,col
	com col
	ld aux,z
	out porta,aux
	reti
corre:
	inc point
	; MODIFICAR LÍMITE PARA 5 LETRAS
	cpi point,$68+$08+$08+$08+$08  ; Nueva dirección final
	brne ok
	ldi point,$60
ok:
	reti
stop:
	push aux
	push col
	in aux,timsk
	ldi col,$04
	eor aux,col
	out timsk,aux
	pop col
	pop aux
	reti
S: .db $00,$4c,$92,$92,$92,$92,$92,$64
U: .db $00,$7e,$80,$80,$80,$80,$80,$7e
N: .db $00,$fe,$04,$08,$10,$20,$40,$fe
E: .db $00,$fe,$92,$92,$92,$92,$92,$82
M: .db $00,$fe,$04,$08,$10,$08,$04,$fe
A: .db $00,$f8,$24,$22,$22,$22,$24,$f8
R: .db $00,$fc,$12,$12,$32,$72,$d2,$8c
I: .db $00,$00,$82,$82,$fe,$82,$82,$00
L: .db $00,$fe,$80,$80,$80,$80,$80,$80
Ye: .db $00,$02,$04,$08,$f0,$08,$04,$02
Dp: .db $c0,$c0,$00,$c0,$c0,$00,$c0,$c0
