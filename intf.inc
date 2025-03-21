.DATA
    mensaje_inicio DB 'Bienvenido al programa ConverTec', 0DH, 0AH, '$'
    mensaje_final DB 'Gracias por usar ConverTec', 0DH, 0AH, '$'

.CODE

; ==============================================
; Procedimiento: mostrar_bienvenida
; Descripción : Imprime un mensaje de bienvenida en pantalla.
; Parámetros  : Ninguno
; Registros modificados: AX, DX
; ==============================================

mostrar_bienvenida PROC far
    PUSH DX      ; Guardamos el valor original de DX en la pila
    PUSH AX      ; Guardamos el valor original de AX en la pila

    MOV DX, OFFSET mensaje_inicio  ; Cargar la dirección del mensaje en DX
    MOV AH, 09H                    ; Función DOS 09H: imprimir cadena de texto
    INT 21H                         ; Llamar a la interrupción para mostrar el mensaje

    POP AX       ; Restauramos el valor original de AX
    POP DX       ; Restauramos el valor original de DX

    RET          ; Retornar al llamador
mostrar_bienvenida ENDP


; ==============================================
; Procedimiento: mostrar_despedida
; Descripción : Imprime un mensaje de despedida en pantalla.
; Parámetros  : Ninguno
; Registros modificados: AX, DX
; ==============================================

mostrar_despedida PROC far
    PUSH DX      ; Guardamos el valor original de DX en la pila
    PUSH AX      ; Guardamos el valor original de AX en la pila

    MOV DX, OFFSET mensaje_final  ; Cargar la dirección del mensaje en DX
    MOV AH, 09H                    ; Función DOS 09H: imprimir cadena de texto
    INT 21H                         ; Llamar a la interrupción para mostrar el mensaje

    POP AX       ; Restauramos el valor original de AX
    POP DX       ; Restauramos el valor original de DX

    RET          ; Retornar al llamador
mostrar_despedida ENDP