.include "m8535def.inc"
.def aux = r16

; Definición de la macro para generar PWM
.macro pulso
    sbi porta,0      ; Pone en alto el pin 0 del puerto A
    ldi aux,@0       ; Carga el primer valor (tiempo en alto)
uno:
    rcall medms      ; Llama a la rutina de retardo
    dec aux          ; Decrementa el contador
    brne uno         ; Si no es cero, repite
    cbi porta,0      ; Pone en bajo el pin 0 del puerto A
    ldi aux,@1       ; Carga el segundo valor (tiempo en bajo)
cta:
    rcall medms      ; Llama a la rutina de retardo
    dec aux          ; Decrementa el contador
    brne cta         ; Si no es cero, repite
.endm

    ldi aux,low(ramend)
    out spl,aux
    ldi aux,high(ramend)
    out sph,aux
    
    ser aux          ; Pone aux en 0xFF (todos unos)
    out ddra,aux     ; Configura Puerto A como Salida
    out portd,aux    ; Activa resistencias Pull-up en Puerto D

; Bucle principal de chequeo de botones
checa:
    sbis pind,5      ; Salta si el bit 5 del Puerto D está en 1 (botón no presionado)
    rcall cero       ; Si es 0 (presionado), llama a rutina 'cero'
    sbis pind,6      ; Checa bit 6
    rcall noventa    ; Si presionado, llama a 'noventa'
    sbis pind,7      ; Checa bit 7
    rcall cien80     ; Si presionado, llama a 'cien80'
    rjmp checa       ; Repite el ciclo

; Rutinas de posición del servo
cero:
    pulso 2,38       ; Macro con parámetros para 0 grados
    ret

noventa:
    pulso 3,37       ; Macro con parámetros para 90 grados
    ret

cien80:
    pulso 4,36       ; Macro con parámetros para 180 grados
    ret

; Rutina de retardo (Delay)
medms:
    ldi r18, 164
L1: dec r18
    brne L1
    nop
    ret
