.DATA
    ; Mensajes de texto
    mensaje_inicio DB 'Bienvenido al programa ConverTec', 0DH, 0AH, '$' ; Mensaje de bienvenida
    menu_principal DB 'Por favor indique que tipo de conversion desea realizar:', 0DH, 0AH ; Mensaje de menu principal
                   DB 'Presione:', 0DH, 0AH
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
    mensaje_entrada DB 'Por favor ingrese el valor a convertir:', 0DH, 0AH, '$' ; Mensaje de entrada
    mensaje_resultado DB 'El resultado es: ', '$' ; Mensaje de resultado
    menu_secundario DB 'Porfavor presione: ', 0DH, 0AH ; Mensaje de menu secundario
                    DB '1. Para continuar', 0DH, 0AH
                    DB '2. Para salir', 0DH, 0AH, '$' 
    mensaje_final DB 'Gracias por usar ConverTec', 0DH, 0AH, '$' ; Mensaje de despedida

    ; Variables
    buffer_entrada DB 9 ; Tamaño del buffer de entrada
                   DB ? ; Número de caracteres leídos
                   DB 9 DUP(?) ; Espacio para almacenar la entrada del usuario

    ; Separador con salto de línea
    nueva_linea DB 0DH, 0AH, '$' ; Salto de línea
    separador DB 0DH, 0AH ; Separador para mejorar la legibilidad
              DB '----------------------------------------', 0DH, 0AH, '$'



.CODE

; ==============================================
; Macro: imprimir_mensaje
; Descripción : Imprime un mensaje en pantalla.
; Parámetros  : MENSAJE (cadena de texto)
; Registros modificados: AX, DX
; ==============================================

IMPRIMIR MACRO MENSAJE
    MOV DX, OFFSET MENSAJE
    MOV AH, 09H
    INT 21H
ENDM


; ==============================================
; Procedimiento: capturar_entrada
; Descripción : Captura la entrada del usuario.
; Parámetros  : Ninguno
; Registros modificados: AX
; ==============================================

capturar_entrada PROC far
    PUSH AX    ; Guardar el valor original de AX en la pila
    PUSH DX    ; Guardar el valor original de DX en la pila

    MOV DX, OFFSET buffer_entrada ; Cargar la dirección del buffer de entrada en DX
    MOV AH, 0AH ; Función DOS 0AH: leer una cadena de texto
    INT 21H     ; Llamar a la interrupción para leer un carácter

    IMPRIMIR nueva_linea ; Agregar un salto de línea después de la entrada

    POP DX    ; Restaurar el valor original de DX
    POP AX    ; Restaurar el valor original de AX

    RET      ; Retornar al llamador
capturar_entrada ENDP


; ==============================================
; Procedimiento: mostrar_resultado
; Descripción : Muestra el resultado de la conversión.
; Parámetros  : Ninguno
; Registros modificados: AX, DX
; ==============================================

convertir_numero_a_cadena PROC far
    ; Guardar registros
    PUSH AX  
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV SI, OFFSET buffer_entrada + 6  ; Posición del punto decimal
    MOV BYTE PTR [SI], '.'             ; Colocar punto decimal
    MOV CX, 2                           ; Contador para los decimales

convertir_decimales:
    MOV DX, 0               ; Limpiar DX para división
    MOV BX, 10              ; Divisor
    DIV BX                  ; AX / 10 -> AL tiene el cociente, DL el residuo
    ADD DL, '0'             ; Convertir residuo a ASCII
    DEC SI
    MOV [SI], DL            ; Guardar el dígito
    LOOP convertir_decimales

    ; Convertir parte entera
    MOV CX, 5               ; Máximo de 5 dígitos
convertir_enteros:
    MOV DX, 0
    MOV BX, 10
    DIV BX
    ADD DL, '0'
    DEC SI
    MOV [SI], DL
    LOOP convertir_enteros

    POP SI  ; Restaurar registros
    POP DX
    POP CX
    POP BX
    POP AX
    RET     
convertir_numero_a_cadena ENDP


; ==============================================
; Procedimiento: mostrar_resultado
; Descripción : Muestra el resultado de la conversión.
; Parámetros  : Ninguno
; Registros modificados: AX, DX
; ==============================================

mostrar_resultado PROC far
    PUSH AX

    ; Llamar a la función de conversión
    CALL convertir_numero_a_cadena

    ; Mostrar el mensaje "El resultado es: "
    IMPRIMIR mensaje_resultado

    ; Mostrar el número convertido
    IMPRIMIR buffer_entrada

    ; Imprimir un salto de línea
    IMPRIMIR nueva_linea

    POP AX
    RET     
mostrar_resultado ENDP