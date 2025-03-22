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

    ; Tabla de unidades
    tabla_unidades DB 'Celsius', 0DH, 0AH, '$'          ; 1. Fahrenheit a Celsius
                   DB 'Kelvin', 0DH, 0AH, '$'           ; 2. Celsius a Kelvin
                   DB 'Celsius', 0DH, 0AH, '$'          ; 3. Kelvin a Celsius
                   DB 'Kelvin', 0DH, 0AH, '$'           ; 4. Fahrenheit a Kelvin
                   DB 'Centimetros', 0DH, 0AH, '$'      ; 5. Pulgadas a Centimetros
                   DB 'Centimetros', 0DH, 0AH, '$'      ; 6. Pies a Centimetros
                   DB 'Centimetros', 0DH, 0AH, '$'      ; 7. Yardas a Centimetros
                   DB 'Kilometros', 0DH, 0AH, '$'       ; 8. Millas a Kilometros
                   DB 'Pulgadas', 0DH, 0AH, '$'         ; 9. Centimetros a Pulgadas
                   DB 'Pies', 0DH, 0AH, '$'             ; 10. Centimetros a Pies
                   DB 'Yardas', 0DH, 0AH, '$'           ; 11. Centimetros a Yardas
                   DB 'Millas', 0DH, 0AH, '$'           ; 12. Kilometros a Millas
                   DB 'Kilos', 0DH, 0AH, '$'            ; 13. Onzas a Kilos
                   DB 'Kilos', 0DH, 0AH, '$'            ; 14. Libras a Kilos
                   DB 'Kilos', 0DH, 0AH, '$'            ; 15. Toneladas a Kilos
                   DB 'Onzas', 0DH, 0AH, '$'            ; 16. Kilos a Onzas
                   DB 'Libras', 0DH, 0AH, '$'           ; 17. Kilos a Libras
                   DB 'Toneladas', 0DH, 0AH, '$'        ; 18. Kilos a Toneladas

    ; Variables
    unidades DB '$'
    buffer_entrada DB 9 ; Tamaño del buffer de entrada
                   DB ? ; Número de caracteres leídos
                   DB 9 DUP(?) ; Espacio para almacenar la entrada del usuario
    opcion_seleccionada DB ? ; Opción seleccionada por el usuario

    ; Separador con salto de línea
    nueva_linea DB 0DH, 0AH, '$' ; Salto de línea
    separador DB 0DH, 0AH ; Separador para mejorar la legibilidad
              DB '----------------------------------------', 0DH, 0AH, '$'
    espacio DB ' $' ; Cadena que contiene un espacio



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


guardar_opcion_seleccionada PROC far
    PUSH AX
    PUSH DX

    MOV AL, buffer_entrada[2]
    SUB AL, '0'
    MOV opcion_seleccionada, AL

    POP DX
    POP AX
    RET
guardar_opcion_seleccionada ENDP


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

    ; Agregar el delimitador '$' al final de la cadena
    MOV BYTE PTR [buffer_entrada + 7], '$'

    POP SI  ; Restaurar registros
    POP DX
    POP CX
    POP BX
    POP AX
    RET     
convertir_numero_a_cadena ENDP


; ==============================================
; Procedimiento: obtener_unidades
; Descripción : Obtiene el nombre de las unidades.
; Parámetros  : Ninguno
; Registros modificados: AX, BX, SI
; ==============================================

obtener_unidades PROC far
    PUSH AX
    PUSH BX
    PUSH SI

    ; Calcular la posición de la cadena de unidades
    XOR BX, BX
    MOV BL, opcion_seleccionada
    DEC BX
    MOV SI, OFFSET tabla_unidades

buscar_unidades:
    CMP BX, 0
    JE imprimir_unidades
    ; Avanzar al siguiente nombre de unidades
    MOV AL, [SI]
    INC SI
    CMP AL, '$'
    JNE buscar_unidades
    DEC BX
    JMP buscar_unidades

imprimir_unidades:
    ; Imprimir el nombre de las unidades
    MOV DX, SI  ; Cargar la dirección apuntada por SI en DX
    MOV AH, 09H ; Función DOS para imprimir cadena
    INT 21H     ; Llamar a la interrupción

    POP SI
    POP BX
    POP AX
    RET
obtener_unidades ENDP


; ==============================================
; Procedimiento: mostrar_resultado
; Descripción : Muestra el resultado de la conversión.
; Parámetros  : Ninguno
; Registros modificados: AX, DX
; ==============================================

mostrar_resultado PROC far
    ; Llamar a la función de conversión
    CALL convertir_numero_a_cadena

    ; Mostrar el mensaje "El resultado es: "
    IMPRIMIR mensaje_resultado

    ; Mostrar el número convertido
    IMPRIMIR buffer_entrada

    ; Imprimir espacio
    IMPRIMIR espacio

    ; Mostrar las unidades
    CALL obtener_unidades

    ; Imprimir salto de línea
    IMPRIMIR nueva_linea

    RET     
mostrar_resultado ENDP