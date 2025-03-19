;------------------------------------------------------------
; Procedimiento: celcius_a_farenheit
; Descripción: Convierte una temperatura en grados Celsius a Fahrenheit.
; Parámetros de entrada:
;   - AX: Temperatura en Celsius
; Parámetros de salida:
;   - AX: Temperatura en Fahrenheit
;------------------------------------------------------------

celcius_a_farenheit PROC far
    MOV    BX, 9           ; Multiplicador para la conversión (C * 9)
    MUL    BX             ; AX = C * 9 (Multiplicación con BX)

    MOV    CX, 5           ; Divisor para la conversión (C * 9 / 5)
    DIV    CX             ; AX = (C * 9) / 5

    ADD    AX, 32         ; Sumar 32 para completar la conversión a Fahrenheit

    RET                    ; Retorna el resultado en AX
celcius_a_farenheit ENDP


;------------------------------------------------------------
; Procedimiento: farenheit_a_celcius
; Descripción: Convierte una temperatura en grados Fahrenheit a Celsius.
; Parámetros de entrada:
;   - AX: Temperatura en Fahrenheit
; Parámetros de salida:
;   - AX: Temperatura en Celsius
;------------------------------------------------------------

fahrenheit_a_celcius PROC far
    SUB    AX, 32         ; Restar 32 para completar la conversión a Celsius

    MOV    BX, 9           ; Multiplicador para la conversión (F - 32)
    MUL    BX             ; AX = (F - 32) * 9 (Multiplicación con BX)

    MOV    CX, 5           ; Divisor para la conversión ((F - 32) * 9)
    DIV    CX             ; AX = ((F - 32) * 9) / 5

    RET                    ; Retorna el resultado en AX
fahrenheit_a_celcius ENDP


;------------------------------------------------------------
; Procedimiento: pulgadas_a_centimetros
; Descripción: Convierte una longitud en pulgadas a centímetros.
; Parámetros de entrada:
;   - AX: Longitud en pulgadas
; Parámetros de salida:
;   - AX: Longitud en centímetros
;------------------------------------------------------------

pulgadas_a_centimetros PROC far
    MOV    BX, 254         ; Multiplicador para la conversión (P * 254)
    MUL    BX             ; AX = P * 254 (Multiplicación con BX)

    MOV    CX, 100         ; Divisor para la conversión (P * 254 / 100)
    DIV    CX             ; AX = (P * 254) / 100

    RET                    ; Retorna el resultado en AX
pulgadas_a_centimetros ENDP


;------------------------------------------------------------
; Procedimiento: centimetros_a_pulgadas
; Descripción: Convierte una longitud en centímetros a pulgadas.
; Parámetros de entrada:
;   - AX: Longitud en centímetros
; Parámetros de salida:
;   - AX: Longitud en pulgadas
;------------------------------------------------------------

centimetros_a_pulgadas PROC far
    MOV    BX, 100         ; Multiplicador para la conversión (C * 100)
    MUL    BX             ; AX = C * 100 (Multiplicación con BX)

    MOV    CX, 254         ; Divisor para la conversión (C * 100 / 254)
    DIV    CX             ; AX = (C * 100) / 254

    RET                    ; Retorna el resultado en AX
centimetros_a_pulgadas ENDP


;------------------------------------------------------------
; Procedimiento: millas_a_kilometros
; Descripción: Convierte una distancia en millas a kilómetros.
; Parámetros de entrada:
;   - AX: Distancia en millas
; Parámetros de salida:
;   - AX: Distancia en kilómetros
;------------------------------------------------------------

millas_a_kilometros PROC far
    MOV    BX, 160934        ; Multiplicador para la conversión (M * 160934)
    MUL    BX             ; AX = M * 160934 (Multiplicación con BX)

    MOV    CX, 100000        ; Divisor para la conversión (M * 1609 / 100000)
    DIV    CX             ; AX = (M * 160934) / 100000

    RET                    ; Retorna el resultado en AX
millas_a_kilometros ENDP


;------------------------------------------------------------
; Procedimiento: onzas_a_kilogramos
; Descripción: Convierte un peso en onzas a kilogramos.
; Parámetros de entrada:
;   - AX: Peso en onzas
; Parámetros de salida:
;   - AX: Peso en kilogramos
;------------------------------------------------------------

onzas_a_kilogramos PROC far
    MOV    BX, 2835         ; Multiplicador para la conversión (O * 2835)
    MUL    BX             ; AX = O * 2835 (Multiplicación con BX)

    MOV    CX, 100000        ; Divisor para la conversión (O * 2835 / 100000)
    DIV    CX             ; AX = (O * 2835) / 100000

    RET                    ; Retorna el resultado en AX
onzas_a_kilogramos ENDP


;------------------------------------------------------------
; Procedimiento: kilogramos_a_onzas
; Descripción: Convierte un peso en kilogramos a onzas.
; Parámetros de entrada:
;   - AX: Peso en kilogramos
; Parámetros de salida:
;   - AX: Peso en onzas
;------------------------------------------------------------

kilogramos_a_onzas PROC far
    MOV    BX, 100000        ; Multiplicador para la conversión (K * 100000)
    MUL    BX             ; AX = K * 100000 (Multiplicación con BX)

    MOV    CX, 2835         ; Divisor para la conversión (K * 100000 / 2835)
    DIV    CX             ; AX = (K * 100000) / 2835

    RET                    ; Retorna el resultado en AX
kilogramos_a_onzas ENDP