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