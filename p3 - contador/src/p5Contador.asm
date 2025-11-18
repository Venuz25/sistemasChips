.include "m8535def.inc"

.def aux       = r16
.def unidades  = r17
.def decenas   = r18
.def stopUni   = r19
.def stopDec   = r20
.def entrada   = r21
.def temp      = r22

ldi aux, low(RAMEND)
out SPL, aux
ldi aux, high(RAMEND)
out SPH, aux

; Configuración de puertos
ser aux
out DDRA, aux       ; Puerto A -> salida (decenas)
out DDRC, aux       ; Puerto C -> salida (unidades)
clr aux
out DDRB, aux       ; Puerto B -> entrada
ser aux
out PORTB, aux

Inicio:
    clr unidades
    clr decenas

LeerStop:
    in entrada, PINB
    mov temp, entrada
    andi temp, 0x0F
    mov stopUni, temp

    mov temp, entrada
    swap temp
    andi temp, 0x0F
    mov stopDec, temp

Contar:
    mov aux, decenas
    rcall MostrarA

    mov aux, unidades
    rcall MostrarC

    rcall Delay_250ms

    cp decenas, stopDec
    brne Incrementar
    cp unidades, stopUni
    brne Incrementar
    rjmp LeerStop 

Incrementar:
    inc unidades
    cpi unidades, 10
    brlo Contar

    clr unidades
    inc decenas
    cpi decenas, 10
    brlo Contar
    clr decenas
    rjmp Contar

; Mostrar en PORTA (decenas)
MostrarA:
    cpi aux, 10
    brlo MA_OK
    clr aux
MA_OK:
    ldi ZH, high(tabla<<1)
    ldi ZL, low(tabla<<1)
    add ZL, aux
    lpm aux, Z
    out PORTA, aux
    ret

; Mostrar en PORTC (unidades)
MostrarC:
    cpi aux, 10
    brlo MC_OK
    clr aux
MC_OK:
    ldi ZH, high(tabla<<1)
    ldi ZL, low(tabla<<1)
    add ZL, aux
    lpm aux, Z
    out PORTC, aux
    ret

; Delay de 250ms exactos para 4MHz
Delay_250ms:
    ldi r23, 5
D1:
    ldi r24, 100
L0:
    ldi r25, 150
L1:
    dec r25
    brne L1
    dec r24
    brne L0
    dec r23
    brne D1
    ret

; Tabla de valores para display 7 segmentos (cátodo común)
.cseg
.org 0x0100
tabla:
    .db $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F
