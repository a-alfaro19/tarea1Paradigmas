data segment
    pkey db "Press any key...$"
    resultado dd ?    ; Variable de 32 bits para almacenar el resultado
ends

stack segment
    dw   128 dup(0)
ends

code segment
start:
; ============================================================================ 
; Macro: YARDAS_A_CENTIMETROS
; Descripcion: Convierte una longitud en yardas a centímetros.
; Parametros:
;  - ENTRADA: Variable de entrada (longitud en yardas)
;  - SALIDA: Variable de salida (longitud en centímetros)
; ============================================================================

    ; Inicializar valores
    MOV AX, 9999      ; Cargar valor de yardas en AX (ejemplo)
    MOV BX, 99        ; Decimales de la entrada (ejemplo, Yardas = 9999.99)
    MOV CX, 100       ; Factor de conversión para trabajar con enteros (multiplicar por 100)

    ; Multiplicar AX (9999) por 100 (para obtener el valor en centésimas)
    IMUL CX            ; AX = parte baja, DX = parte alta
    
    ; Multiplicar el valor de entrada por 91.44 (en formato entero 9144)
    MOV DX, 9144       ; Cargar 91.44 en DX (9144 representando 91.44)
    IMUL DX            ; AX = parte baja, DX = parte alta
    
    ; --- Manejo del signo antes de la división ---
    PUSH DX            ; Guardar DX para verificar signo después
    
    ; Verificar si el número es negativo (comprobar bit de signo en DX)
    TEST DX, DX
    JNS Positivo      ; Si no es negativo (SF=0), saltar a división
    
    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
Positivo:
    ; Dividir entre 100 (para deshacer el factor de conversión)
    MOV CX, 100
    CALL Div32x16     ; Llamar a rutina de división 32x16 bits
    
    ; Recuperar el signo original
    POP BX            ; Recuperar DX original para verificar el signo
    
    ; Verificar si el número original era negativo
    TEST BX, BX
    JNS SumarFinal    ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR DX, 0FFFFh
    NEG AX

SumarFinal:
    ; Guardar el resultado en variable de 32 bits
    MOV WORD PTR [resultado], AX
    MOV WORD PTR [resultado+2], DX

    ; Terminar programa
    MOV AX, 4C00h
    INT 21h

; ============================================================================

; Rutina: Mul32x16
; Multiplica un número de 32 bits (DX:AX) por un número de 16 bits (CX)
; Entrada:
;   DX:AX = multiplicando (32 bits)
;   CX    = multiplicador (16 bits)
; Salida:
;   DX:AX = resultado (32 bits)
; Modifica: BX
; ============================================================================

Mul32x16 PROC
    PUSH BP
    MOV BP, SP
    PUSH BX
    PUSH SI
    PUSH DI
    
    ; Guardar los componentes
    MOV SI, AX  ; SI = parte baja
    MOV DI, DX  ; DI = parte alta
    
    ; 1. Multiplicar parte baja (SI * CX)
    MOV AX, CX
    MOV DX, 0
    MUL SI      ; DX:AX = CX * SI (parte baja)
    MOV BX, AX  ; BX = resultado bajo
    MOV SI, DX  ; SI = resultado alto
    
    ; 2. Multiplicar parte alta (DI * CX)
    MOV AX, CX
    MOV DX, 0
    MUL DI      ; DX:AX = CX * DI (parte alta)
    
    ; 3. Sumar componentes cruzados
    ADD SI, AX  ; Sumar parte baja de la multiplicación alta
    ADC DX, 0   ; Ajustar acarreo
    
    ; 4. Preparar resultado final
    MOV AX, BX  ; Parte baja del resultado
    MOV DX, SI  ; Parte alta del resultado
    
    POP DI
    POP SI
    POP BX
    POP BP
    RET
Mul32x16 ENDP

; ============================================================================

; Rutina: Div32x16
; Divide un número de 32 bits (DX:AX) por un número de 16 bits (CX)
; Entrada:
;   DX:AX = dividendo (32 bits)
;   CX    = divisor (16 bits, no cero)
; Salida:
;   DX:AX = cociente (DX=parte alta, AX=parte baja)
;   BX    = resto
; Modifica: BX
; ============================================================================

Div32x16 PROC
    PUSH SI           ; Guardar registros que usaremos
    PUSH DI
    
    ; 1. Verificar división por cero
    TEST CX, CX
    JZ DivisionError  ; Saltar si divisor es cero
    
    ; 2. Guardar el divisor
    MOV SI, CX        ; SI = divisor
    
    ; 3. Dividir parte alta (DX)
    MOV BX, AX        ; Guardar parte baja temporalmente
    MOV AX, DX        ; AX = parte alta
    MOV DX, 0         ; DX = 0
    DIV SI            ; AX = cociente parte alta, DX = resto
    
    ; 4. Guardar cociente parcial (parte alta)
    MOV DI, AX        ; DI = cociente (parte alta)
    
    ; 5. Dividir parte baja (BX) con resto anterior (DX)
    MOV AX, BX        ; Recuperar parte baja
    ; DX ya contiene el resto de la división anterior
    DIV SI            ; AX = cociente parte baja, DX = resto
    
    ; 6. Preparar resultado final
    MOV BX, DX        ; BX = resto
    MOV DX, DI        ; DX = cociente (parte alta)
    ; AX ya contiene cociente (parte baja)
    
    POP DI            ; Restaurar registros
    POP SI
    RET
    
DivisionError:
    MOV AX, 0FFFFh    ; Retornar valores de error
    MOV DX, 0FFFFh
    MOV BX, 0FFFFh
    POP DI
    POP SI
    RET
Div32x16 ENDP

ends

end start