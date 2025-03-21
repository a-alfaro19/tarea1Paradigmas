.DATA
    ; Mensajes de texto
    separador DB 0DH, 0AH ; Separador para mejorar la legibilidad
              DB '----------------------------------------', 0DH, 0AH, '$'
    mensaje_inicio DB 'Bienvenido al programa ConverTec', 0DH, 0AH, '$' ; Mensaje de bienvenida
    menu_principal DB 'Por favor indique que tipo de conversion desea realizar:', 0DH, 0AH, '$' ; Mensaje de menu principal
    opciones_conversion DB 'Presione:', 0DH, 0AH
                        DB '1.  Fahrenheit a Celsius', 0DH, 0AH
                        DB '2.  Celsius a Kelvin', 0DH, 0AH
                        DB '3.  Kelvin a Celsius', 0DH, 0AH
                        DB '4.  Fahrenheit a Kelvin', 0DH, 0AH
                        DB '5.  Pulgadas a Centimetros', 0DH, 0AH
                        DB '6.  Pies a Centimetros', 0DH, 0AH
                        DB '7.  Yardas a Centimetros', 0DH, 0AH
                        DB '8.  Millas a Kilometros', 0DH, 0AH
                        DB '9.  Centimetros a Pulgadas', 0DH, 0AH
                        DB '10. Centimetros a Pies', 0DH, 0AH
                        DB '11. Centimetros a Yardas', 0DH, 0AH
                        DB '12. Kilometros a Millas', 0DH, 0AH
                        DB '13. Onzas a Kilos', 0DH, 0AH
                        DB '14. Libras a Kilos', 0DH, 0AH
                        DB '15. Toneladas a Kilos', 0DH, 0AH
                        DB '16. Kilos a Onzas', 0DH, 0AH
                        DB '17. Kilos a Libras', 0DH, 0AH
                        DB '18. Kilos a Toneladas', 0DH, 0AH, '$'
    mensaje_final DB 'Gracias por usar ConverTec', 0DH, 0AH, '$' ; Mensaje de despedida

    ; Variables
    entrada DB ? ; Variable para almacenar la entrada del usuario

.CODE

; ==============================================
; Procedimiento: mostrar_separador
; Descripción : Imprime un separador en pantalla.
; Parámetros  : Ninguno
; Registros modificados: AX, DX
; ==============================================

mostrar_separador PROC far
    PUSH DX      ; Guardamos el valor original de DX en la pila
    PUSH AX      ; Guardamos el valor original de AX en la pila

    MOV DX, OFFSET separador  ; Cargar la dirección del mensaje en DX
    MOV AH, 09H                    ; Función DOS 09H: imprimir cadena de texto
    INT 21H                         ; Llamar a la interrupción para mostrar el mensaje

    POP AX       ; Restauramos el valor original de AX
    POP DX       ; Restauramos el valor original de DX

    RET          ; Retornar al llamador
mostrar_separador ENDP


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
; Procedimiento: mostrar_menu
; Descripción : Imprime un menú de opciones en pantalla.
; Parámetros  : Ninguno
; Registros modificados: AX, DX
; ==============================================

mostrar_menu PROC far
    PUSH DX      ; Guardamos el valor original de DX en la pila
    PUSH AX      ; Guardamos el valor original de AX en la pila

    MOV DX, OFFSET menu_principal  ; Cargar la dirección del mensaje en DX
    MOV AH, 09H                    ; Función DOS 09H: imprimir cadena de texto
    INT 21H                         ; Llamar a la interrupción para mostrar el mensaje

    MOV DX, OFFSET opciones_conversion  ; Cargar la dirección del mensaje en DX
    MOV AH, 09H                    ; Función DOS 09H: imprimir cadena de texto
    INT 21H                         ; Llamar a la interrupción para mostrar el mensaje

    POP AX       ; Restauramos el valor original de AX
    POP DX       ; Restauramos el valor original de DX

    RET          ; Retornar al llamador
mostrar_menu ENDP


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


; ==============================================
; Procedimiento: capturar_entrada
; Descripción : Captura la entrada del usuario.
; Parámetros  : Ninguno
; Registros modificados: AX
; ==============================================

capturar_entrada PROC far
    PUSH AX    ; Guardar el valor original de AX en la pila

    MOV AH, 01H ; Leer un carácter desde la entrada estándar
    INT 21H     ; Llamar a la interrupción para leer un carácter

    MOV entrada, AL ; Guardar el carácter leído en la variable entrada

    POP AX    ; Restaurar el valor original de AX

    RET      ; Retornar al llamador
capturar_entrada ENDP