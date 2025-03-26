; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$" 
    resultado dd ?    ; Variable de 32 bits para almacenar el resultado
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:    
; ============================================================================
; Macro: FAHRENHEIT_A_KELVIN
; Descripcion: Convierte una temperatura en Fahrenheit a Kelvin.
; Parametros:
;  - ENTRADA: Variable de entrada (temperatura en Fahrenheit)
;  - SALIDA: Variable de salida (temperatura en Kelvin)
; ============================================================================
    ; Inicializar valores
    MOV AX, 9999      ; Cargar valor en AX
    MOV BX, 99        ; Cargar valor en BX
    MOV CX, 100       ; Cargar 100 en CX

    ; Multiplicar AX (9999) por CX (100) 
    IMUL CX            ; AX = parte baja, DX = parte alta
    
    ; Sumar BX al resultado (DX:AX + BX) con manejo de signo
    TEST AX, AX          ; Verificar el signo de AX
    JNS sumar_bxf         ; Si AX es positivo, saltar a sumar
    
    ; Si AX es negativo, restar BX
    SUB AX, BX           ; Restar BX 
    SBB DX, 0            ; Ajustar parte alta si hay borrow
    JMP continuar_restaf  ; Saltar a la resta de 27315
    
    sumar_bxf:
    ADD AX, BX           ; Sumar BX a la parte baja
    ADC DX, 0            ; Ajustar parte alta si hay acarreo 
    
    continuar_restaf:
    ; Restar 3200 (DX:AX - 3200) 
    SUB AX, 3200     ; Restar la parte baja
    SBB DX, 0         ; Ajustar parte alta  

    
    ; --- Manejo del signo antes de la división ---
    PUSH DX          ; Guardar DX (parte alta) para verificar signo despues
    
    ; Verificar si el numero es negativo (comprobar bit de signo en DX)
    TEST DX, DX
    JNS Positivo  ; Si no es negativo (SF=0), saltar a division
    
    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
    Positivo:
    
    ; Multiplicar por 5 (DX:AX * 5) 
    MOV CX, 5
    CALL Mul32x16     ; Llamar a rutina de multiplicacion 32x16 bits
    
    ; Dividir entre 9 (DX:AX / 9)
    MOV CX, 9 
    CALL Div32x16     ; Ahora dividimos un numero positivo
    
    ; Recuperar el signo original
    POP BX           ; Recuperar DX original para verificar el signo
    
    ; Verificar si el numero original era negativo
    TEST BX, BX
    JNS SumarFinal   ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR DX, 0FFFFh
    NEG AX


    
    SumarFinal:
    ; Sumar 27315 (DX:AX + 27315)
    ADD AX, 27315    ; Sumar la parte baja
    ADC DX, 0        ; Ajustar parte alta si hay acarreo

    ; Guardar el resultado en variable de 32 bits
    MOV WORD PTR [resultado], AX
    MOV WORD PTR [resultado+2], DX


    ; Terminar programa
    MOV AX, 4c00h
    INT 21h
             

; ============================================================================
; Rutina: Mul32x16
; Multiplica un numero 32-bit (DX:AX) por un 16-bit (CX)
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
    ADD SI, AX  ; Sumar parte baja de la multiplicacion alta
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
; Divide un numero 32-bit (DX:AX) por un 16-bit (CX)
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
    
    ; 1. Verificar division por cero
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
    ; DX ya contiene el resto de la division anterior
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

end start ; set entry point and stop the assembler.
