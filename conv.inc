; ============================================================================
; Macro: CELCIUS_A_FARENHEIT
; Descripción: Convierte una temperatura en grados Celsius a Fahrenheit.
; Parámetros:
;   - ENTRADA: Variable de entrada (temperatura en Celsius)
;   - SALIDA: Variable de salida (temperatura en Fahrenheit)
; ============================================================================
CELCIUS_A_FARENHEIT MACRO ENTRADA, SALIDA
    MOV AX, ENTRADA        ; Cargar la temperatura en Celsius
    MOV BX, 9              ; Multiplicador para la conversión (C * 9)
    MUL BX                 ; AX = C * 9 (Multiplicación con BX)
    MOV CX, 5              ; Divisor para la conversión (C * 9 / 5)
    DIV CX                 ; AX = (C * 9) / 5
    ADD AX, 32             ; Sumar 32 para completar la conversión a Fahrenheit
    MOV SALIDA, AX         ; Guardar el resultado en la variable de salida
ENDM


; ============================================================================
; Macro: CELCIUS_A_FARENHEIT
; Descripción: Convierte una temperatura en grados Celsius a Fahrenheit.
; Parámetros:
;   - ENTRADA: Variable de entrada (temperatura en Celsius)
;   - SALIDA: Variable de salida (temperatura en Fahrenheit)
; ============================================================================
FARENHEIT_A_CELCIUS MACRO ENTRADA, SALIDA
    MOV AX, ENTRADA        ; Cargar la temperatura en Fahrenheit
    SUB AX, 32             ; Restar 32 para completar la conversión a Celsius
    MOV BX, 9              ; Multiplicador para la conversión (F - 32)
    MUL BX                 ; AX = (F - 32) * 9 (Multiplicación con BX)
    MOV CX, 5              ; Divisor para la conversión ((F - 32) * 9)
    DIV CX                 ; AX = ((F - 32) * 9) / 5
    MOV SALIDA, AX         ; Guardar el resultado en la variable de salida
ENDM


; ============================================================================
; Macro: PULGADAS_A_CENTIMETROS
; Descripción: Convierte una longitud en pulgadas a centímetros.
; Parámetros:
;   - ENTRADA: Variable de entrada (longitud en pulgadas)
;   - SALIDA: Variable de salida (longitud en centímetros)
; ============================================================================
PULGADAS_A_CENTIMETROS MACRO ENTRADA, SALIDA
    MOV AX, ENTRADA        ; Cargar la longitud en pulgadas
    MOV    BX, 254         ; Multiplicador para la conversión (P * 254)
    MUL    BX              ; AX = P * 254 (Multiplicación con BX)
    MOV    CX, 100         ; Divisor para la conversión (P * 254 / 100)
    DIV    CX              ; AX = (P * 254) / 100
    MOV SALIDA, AX         ; Guardar el resultado en la variable de salida
ENDM


; ============================================================================
; Macro: CENTIMETROS_A_PULGADAS
; Descripción: Convierte una longitud en centímetros a pulgadas.
; Parámetros:
;   - ENTRADA: Variable de entrada (longitud en centímetros)
;   - SALIDA: Variable de salida (longitud en pulgadas)
; ============================================================================
CENTIMETRO_A_PULGADAS MACRO ENTRADA, SALIDA
    MOV AX, ENTRADA        ; Cargar la longitud en centimetros
    MOV    BX, 100         ; Multiplicador para la conversión (C * 100)
    MUL    BX              ; AX = C * 100 (Multiplicación con BX)

    MOV    CX, 254         ; Divisor para la conversión (C * 100 / 254)
    DIV    CX              ; AX = (C * 100) / 254
    MOV SALIDA, AX         ; Guardar el resultado en la variable de salida
ENDM


; ============================================================================
; Macro: MILLAS_A_KILOMETROS
; Descripción: Convierte una distancia en millas a kilómetros.
; Parámetros:
;  - ENTRADA: Variable de entrada (distancia en millas)
;  - SALIDA: Variable de salida (distancia en kilómetros)
; ============================================================================
MILLAS_A_KILOMETROS MACRO ENTRADA, SALIDA
    MOV AX, ENTRADA       ; Cargar la distancia en millas
    MOV    BX, 161        ; Multiplicador para la conversión (M * 161)
    MUL    BX             ; AX = M * 161 (Multiplicación con BX)

    MOV    CX, 100        ; Divisor para la conversión (M * 161 / 100)
    DIV    CX             ; AX = (M * 161) / 100
    MOV SALIDA, AX        ; Guardar el resultado en la variable de salida
ENDM


; ============================================================================
; Macro: ONZAS_A_KILOGRAMOS
; Descripción: Convierte un peso en onzas a kilogramos.
; Parámetros:
;  - ENTRADA: Variable de entrada (peso en onzas)
;  - SALIDA: Variable de salida (peso en kilogramos)
; ============================================================================
ONZAS_A_KILOGRAMOS MACRO ENTRADA, SALIDA
    MOV AX, ENTRADA        ; Cargar el peso en onzas
    MOV    BX, 28          ; Multiplicador para la conversión (O * 28)
    MUL    BX              ; AX = O * 28 (Multiplicación con BX)
    MOV    CX, 1000        ; Divisor para la conversión (O * 28 / 1000)
    DIV    CX              ; AX = (O * 28) / 1000
    MOV SALIDA, AX         ; Guardar el resultado en la variable de salida
ENDM


; ============================================================================
; Macro: KILOGRAMOS_A_ONZAS
; Descripción: Convierte un peso en kilogramos a onzas.
; Parámetros:
;  - ENTRADA: Variable de entrada (peso en kilogramos)
;  - SALIDA: Variable de salida (peso en onzas)
; ============================================================================
KILOGRAMOS_A_ONZAS MACRO ENTRADA, SALIDA
    MOV AX, ENTRADA        ; Cargar el peso en kilogramos
    MOV    BX, 353         ; Multiplicador para la conversión (K * 353)
    MUL    BX              ; AX = K * 353 (Multiplicación con BX)

    MOV    CX, 10          ; Divisor para la conversión (K * 353 / 10)
    DIV    CX              ; AX = (K * 353) / 10
    MOV SALIDA, AX         ; Guardar el resultado en la variable de salida
ENDM