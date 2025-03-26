; multi-segment executable file template.

data segment
    pkey db "press any key...$"
    resultado dd ?    ; Variable de 32 bits para almacenar el resultado
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
    ; Inicializar valores
    MOV AX, -179      ; Cargar valor en AX
    MOV BX, 99        ; Cargar valor en BX
    MOV CX, 100       ; Cargar 100 en CX

    ; Multiplicar AX (9999) por CX (100) 
    IMUL CX            ; AX = parte baja, DX = parte alta
    
    ; Sumar BX al resultado (DX:AX + BX) 
    ADD AX, BX        
    ADC DX, 0         ; Ajustar parte alta si hay acarreo

    ; Restar 27315 (DX:AX - 27315) 
    SUB AX, 27315     ; Restar la parte baja
    SBB DX, 0         ; Ajustar parte alta si hay préstamo

    ; Multiplicar por 18 (DX:AX * 18) 
    MOV CX, 18
    CALL Mul32x16     ; Llamar a rutina de multiplicación 32x16 bits
    
    ; Sumar 32000 (DX:AX + 32,000)
    ADD AX, 32000     ; Sumar la parte baja
    ADC DX, 0         ; Ajustar parte alta si hay acarreo

    ; Guardar el resultado en variable de 32 bits
    MOV WORD PTR [resultado], AX
    MOV WORD PTR [resultado+2], DX

    ; Terminar programa
    ;MOV AX, 4c00h
    INT 21h

; ------------------------------------------------------
; Rutina: Mul32x16
; Multiplica un número 32-bit (DX:AX) por un 16-bit (CX)
; Entrada:
;   DX:AX = multiplicando (32 bits)
;   CX    = multiplicador (16 bits)
; Salida:
;   DX:AX = resultado (32 bits)
; Modifica: BX
; ------------------------------------------------------

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
    XOR DX, DX
    MUL SI      ; DX:AX = CX * SI (parte baja)
    MOV BX, AX  ; BX = resultado bajo
    MOV SI, DX  ; SI = resultado alto
    
    ; 2. Multiplicar parte alta (DI * CX)
    MOV AX, CX
    XOR DX, DX
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

ends

end start