.include "m8535def.inc"

	.def temp = r16
	.def unidades = r17
	.def decenas = r18
	.def limite = r19
	.def modo = r20        ; 0 = manual, 1 = automático
	.def pausa = r26       ; 0 = corriendo, 1 = pausado

	.org 0x0000
	    rjmp RESET
	.org INT0addr
	    rjmp ISR_INT0
	.org INT1addr
	    rjmp ISR_INT1
	.org 0x0020

RESET:
    clr r1
    ldi temp, LOW(RAMEND)
    out SPL, temp
    ldi temp, HIGH(RAMEND)
    out SPH, temp

    ; PORTA = salida (decenas)
    ldi temp, 0xFF
    out DDRA, temp

    ; PORTC = salida (unidades)
    ldi temp, 0xFF
    out DDRC, temp

    ; PD2 (INT0) y PD3 (INT1) entradas con pull-up
    cbi DDRD, PD2
    cbi DDRD, PD3
    sbi PORTD, PD2
    sbi PORTD, PD3

    ; Configurar interrupciones externas (flanco descendente)
    ldi temp, (1 << ISC01) | (1 << ISC11)
    out MCUCR, temp
    ldi temp, (1 << INT0) | (1 << INT1)
    out GICR, temp

    clr unidades
    clr decenas
    clr limite
    clr modo
    clr pausa

    sei

TABLA7SEG:
    .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

MAIN:
    rcall MOSTRAR

    tst modo
    breq MAIN

    rjmp AUTO

AUTO:
    clr unidades
    clr decenas

AUTO_LOOP:
    rcall MOSTRAR

PAUSA_CHECK:
    tst pausa
    breq CONTAR
    rcall MOSTRAR
    rjmp PAUSA_CHECK

CONTAR:
    rcall RETARDO_1S

    inc unidades
    cpi unidades, 10
    brne CONT_AUTO
    clr unidades
    inc decenas
CONT_AUTO:
    mov temp, decenas
    ldi r24, 10
    mul temp, r24
    add r0, unidades
    mov r25, r0
    clr r1

    cp r25, limite
    breq AUTO_LOOP
    brlo AUTO_LOOP

    rjmp AUTO

MOSTRAR:
    mov temp, decenas
    rcall TABLA
    out PORTA, temp
    rcall RETARDO_CORTO

    mov temp, unidades
    rcall TABLA
    out PORTC, temp
    rcall RETARDO_CORTO
    ret

TABLA:
    push ZH
    push ZL
    ldi ZH, HIGH(TABLA7SEG*2)
    ldi ZL, LOW(TABLA7SEG*2)
    add ZL, temp
    adc ZH, r1
    lpm temp, Z
    pop ZL
    pop ZH
    ret

RETARDO_CORTO:
    ldi temp, 80
RC1: dec temp
     brne RC1
     ret

RETARDO_1S:
    ldi r21, 10
RET1S_LOOP:
    rcall RETARDO_100MS
    dec r21
    brne RET1S_LOOP
    ret

RETARDO_100MS:
    ldi r22, 100
RET100_LOOP1:
    ldi r23, 250
RET100_LOOP2:
    dec r23
    brne RET100_LOOP2
    dec r22
    brne RET100_LOOP1
    ret

ISR_INT0:
    tst modo
    brne FIN_INT0
    inc unidades
    cpi unidades, 10
    brne FIN_INT0
    clr unidades
    inc decenas
    cpi decenas, 10
    brne FIN_INT0
    clr decenas
FIN_INT0:
    reti

ISR_INT1:
    tst modo
    breq INICIAR_AUTO

    tst pausa
    breq PON_PAUSA
    clr pausa
    rjmp FIN_INT1
PON_PAUSA:
    ldi pausa, 1
    rjmp FIN_INT1

INICIAR_AUTO:
    mov temp, decenas
    ldi r24, 10
    mul temp, r24
    add r0, unidades
    mov limite, r0
    clr r1
    ldi modo, 1
    clr pausa
FIN_INT1:
    reti

.exit
