data segment
    pkey db "press any key...$" 
    resultado dd ?    ; Variable de 32 bits para almacenar el resultado
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:    
; ============================================================================ 
; Macro: KILOS_A_TONELADAS
; Descripción: Convierte una distancia en kilogramos a toneladas.
; Parámetros:
;  - ENTRADA: Valor en kilogramos con dos decimales.
;  - SALIDA: Valor en toneladas con dos decimales.
; ============================================================================ 

    ; Inicializar valores de ejemplo
    MOV AX, 2000      ; Parte entera de los kilogramos
    MOV BX, 500       ; Parte decimal de los kilogramos (centésimas)
    MOV CX, 100       ; Factor de multiplicación para manejar los decimales (100)

    ; Multiplicar AX (kilogramos enteros) por CX (100) para convertir en centésimas
    IMUL CX           ; AX = parte baja, DX = parte alta (resultado de la multiplicación)

    ; Sumar BX al resultado (DX:AX + BX) con manejo de signo
    TEST DX, DX       ; Verificar si el número es negativo
    JNS sumar_bxc     ; Si es positivo, saltar a sumar

    ; Si es negativo, restar BX
    SUB AX, BX        
    SBB DX, 0         ; Ajustar parte alta si hay acarreo negativo
    JMP continuar_c  
    
sumar_bxc:
    ADD AX, BX        ; Sumar BX (parte decimal) a la parte baja
    ADC DX, 0         ; Ajustar parte alta si hay acarreo positivo
    
continuar_c:

    ; --- Manejo del signo antes de la división ---
    PUSH DX           ; Guardar DX para restaurar signo después
    
    ; Verificar si el número es negativo
    TEST DX, DX
    JNS Positivo_c    ; Si no es negativo, proceder a la división

    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
Positivo_c:
    MOV CX, 100       ; Factor de precisión
    CALL Mul32x16     ; Multiplicar por 100 para manejar decimales
    
    ; Dividir entre 1000 (DX:AX / 1000) para convertir kilogramos a toneladas
    MOV CX, 1000      ; 1000 kilogramos = 1 tonelada
    CALL Div32x16

    MOV BX, DX        ; Almacenar parte alta del cociente
    
    ; Recuperar el signo original
    POP DX            ; Restaurar DX original para verificar el signo
    
    ; Verificar si el número original era negativo
    TEST DX, DX
    JNS Finalc        ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR BX, 0FFFFh  
    NEG AX
    
Finalc:
    MOV DX, BX        ; Restaurar DX con el signo correcto

    ; Guardar el resultado en variable de 32 bits
    MOV WORD PTR [resultado], AX
    MOV WORD PTR [resultado+2], DX

    ; Terminar programa
    MOV AX, 4c00h
    INT 21h
             
; ============================================================================ 
; Rutina: Div32x16
; Divide un número 32-bit (DX:AX) por un número 16-bit (CX)
; Entrada:
;   DX:AX = dividendo (32 bits)
;   CX    = divisor (16 bits, no cero)
; Salida:
;   DX:AX = cociente (DX=parte alta, AX=parte baja)
;   BX    = resto
; Modifica: BX
; ============================================================================ 
Div32x16 PROC
    PUSH SI           ; Guardar registros
    PUSH DI
    
    TEST CX, CX       ; Verificar división por cero
    JZ DivisionError  
    
    MOV SI, CX        ; Guardar divisor en SI
    MOV BX, AX        ; Guardar parte baja
    MOV AX, DX        ; Mover parte alta a AX
    MOV DX, 0         ; Resetear DX
    DIV SI            ; División parte alta (AX / SI)
    
    MOV DI, AX        ; Guardar cociente parte alta
    
    MOV AX, BX        ; Recuperar parte baja
    DIV SI            ; División parte baja (AX / SI)
    
    MOV BX, DX        ; Guardar el resto
    MOV DX, DI        ; Guardar parte alta del cociente
    
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
  
; ============================================================================ 
; Rutina: Mul32x16
; Multiplica un número 32-bit (DX:AX) por un número 16-bit (CX)
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
    
    MOV SI, AX  ; Guardar parte baja
    MOV DI, DX  ; Guardar parte alta
    
    ; Multiplicar parte baja
    MOV AX, CX
    MOV DX, 0
    MUL SI
    MOV BX, AX  ; Guardar resultado bajo
    MOV SI, DX  ; Guardar resultado alto
    
    ; Multiplicar parte alta
    MOV AX, CX
    MOV DX, 0
    MUL DI  
    
    ADD SI, AX  ; Sumar parte baja del resultado alto
    ADC DX, 0   ; Ajustar acarreo
    
    MOV AX, BX  ; Cargar parte baja final
    MOV DX, SI  ; Cargar parte alta final
    
    POP DI
    POP SI
    POP BX
    POP BP
    RET
Mul32x16 ENDP    

ends

end start



