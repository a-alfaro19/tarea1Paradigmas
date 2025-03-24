.DATA
    ; ==============================================
    ; Constantes
    ; ==============================================
    BUFFER_SIZE EQU 12 ; Tamaño del buffer de entrada/salida
    MAX_ENTEROS EQU 4 ; Máximo de dígitos enteros permitidos
    MAX_DECIMALES EQU 2 ; Máximo de decimales permitidos
    ESPACIADOR DB ' $' ; Espaciador
    SALTO_LINEA DB 0DH, 0AH, '$' ; Salto de línea
    SEPARADOR DB '----------------------------------------', 0DH, 0AH, '$' ; Separador
    ; Tabla de unidades
    tabla_unidades DB 'Celsius', 0DH, 0AH, '$'       ; 1. Fahrenheit a Celsius
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


    ; ==============================================
    ; Mensajes de texto
    ; ==============================================
    mensaje_inicio DB 'Bienvenido al programa ConverTec', 0DH, 0AH, '$'                     ; Mensaje de bienvenida
    menu_principal DB 'Por favor indique que tipo de conversion desea realizar:', 0DH, 0AH  ; Mensaje de menu principal
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
    mensaje_entrada DB 'Por favor ingrese el valor a convertir:', 0DH, 0AH, '$'             ; Mensaje de entrada
    mensaje_resultado DB 'El resultado es:', '$'                                            ; Mensaje de resultado
    menu_secundario DB 'Porfavor presione: ', 0DH, 0AH                                      ; Mensaje de menu secundario
                    DB '1. Para continuar', 0DH, 0AH
                    DB '2. Para salir', 0DH, 0AH, '$' 
    mensaje_final DB 'Gracias por usar ConverTec', 0DH, 0AH, '$'                            ; Mensaje de despedida
    mensaje_error DB 'Error: Opción inválida. Por favor intente de nuevo.', 0DH, 0AH, '$'   ; Mensaje de error

    ; ==============================================
    ; Variables
    ; ==============================================
    parte_entera DW ?               ; Parte entera del número
    parte_decimal DW ?              ; Parte decimal del número
    buffer_entrada DB 12 DUP(?)     ; Espacio para almacenar la entrada del usuario
    buffer_salida DB 12 DUP(?)      ; Espacio para almacenar la salida
    opcion_seleccionada DB ?        ; Opción seleccionada por el usuario
    unidades DB '$'                 ; Unidades de medida


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
; Macro: limpiar_buffer
; Descripción : Limpia el buffer de entrada.
; Parámetros  : BUFFER (dirección del buffer), SIZE (tamaño del buffer)
; Registros modificados: CX, DI
; ==============================================
LIMPIAR_BUFFER MACRO BUFFER, SIZE
    LOCAL limpiar_loop              ; Etiqueta para el bucle de limpieza

    ; Guardar registros
    PUSH CX
    PUSH DI

    MOV CX, SIZE                    ; Tamaño del buffer
    MOV DI, OFFSET BUFFER           ; Apuntar al inicio del buffer

limpiar_loop:
    MOV BYTE PTR [DI], 0            ; Limpiar byte actual
    INC DI                          ; Mover al siguiente byte
    LOOP limpiar_loop               ; Repetir hasta que CX sea 0

    ; Restaurar registros
    POP DI
    POP CX
ENDM


; ==============================================
; Procedimiento: capturar_entrada
; Descripción : Captura la entrada del usuario.
; Parámetros  : Ninguno
; Registros modificados: AX
; ==============================================
capturar_entrada PROC far
    ; Limpiar el buffer de entrada
    LIMPIAR_BUFFER buffer_entrada, BUFFER_SIZE

    ; Inicializar el buffer de entrada
    MOV BYTE PTR buffer_entrada, 11     ; Tamaño máximo permitido (11 caracteres)
    MOV BYTE PTR buffer_entrada + 1, 0  ; Número de caracteres ingresados inicialmente en 0

    MOV DX, OFFSET buffer_entrada       ; Cargar la dirección del buffer de entrada en DX
    MOV AH, 0AH                         ; Función DOS 0AH: leer una cadena de texto
    INT 21H                             ; Llamar a la interrupción para leer un carácter

    IMPRIMIR SALTO_LINEA                ; Agregar un salto de línea después de la entrada

    RET    
capturar_entrada ENDP

; ==============================================
; Procedimiento: guardar_opcion_seleccionada
; Descripción : Guarda la opción seleccionada por el usuario.
; Parámetros  : Ninguno
; Registros modificados: AX, DX
; ==============================================
guardar_opcion_seleccionada PROC far
    PUSH AX

    MOV AL, buffer_entrada[2]
    SUB AL, '0'
    MOV opcion_seleccionada, AL

    POP AX
    RET
guardar_opcion_seleccionada ENDP


; ==============================================
; Procedimiento: convertir_numero_a_cadena
; Descripción : Convierte un número a una cadena de texto.
; Parámetros  : Ninguno (parte_entera y parte_decimal deben estar inicializados)
; Registros modificados: AX, BX, CX, DX, SI
; ==============================================
convertir_numero_a_cadena PROC far
    ; Guardar registros
    PUSH CX
    PUSH DX
    PUSH SI

    ; Apuntar al final del buffer de salida
    MOV SI, OFFSET buffer_salida + BUFFER_SIZE - 1
    MOV BYTE PTR [SI], '$'                          ; Agregar el delimitador '$' al final de la cadena
    DEC SI                                          ; Mover el puntero a la izquierda

    ; Convertir la parte decimal (parte decimal en DX)
    MOV AX, parte_decimal                           ; Mover la parte decimal a AX
    MOV CX, MAX_DECIMALES                           ; Máximo de 2 decimales
convertir_parte_decimal:
    XOR DX, DX                                      ; Limpiar DX
    MOV BX, 10                                      ; Divisor
    DIV BX                                          ; AX / BX -> AX = cociente, DX = residuo
    ADD DL, '0'                                     ; Convertir residuo a ASCII
    MOV [SI], DL                                    ; Guardar el dígito en el buffer
    DEC SI                                          ; Mover el puntero hacia atrás
    CMP AX, 0                                       ; Verificar si se ha convertido toda la parte decimal
    LOOP convertir_parte_decimal

    ; Agregar el punto decimal
    MOV BYTE PTR [SI], '.'                          ; Colocar el punto decimal
    DEC SI

    ; Convertir la parte entera (parte entera en AX)
    MOV AX, parte_entera                            ; Mover la parte entera a AX
    MOV CX, MAX_ENTEROS                             ; Máximo de 4 dígitos enteros
convertir_parte_entera:
    XOR DX, DX                                      ; Limpiar DX
    MOV BX, 10                                      ; Divisor
    DIV BX                                          ; AX / BX -> AX = cociente, DX = residuo
    ADD DL, '0'                                     ; Convertir residuo a ASCII
    MOV [SI], DL                                    ; Guardar el dígito en el buffer
    DEC SI                                          ; Mover el puntero hacia atrás
    CMP AX, 0                                       ; ¿Quedan más dígitos?
    JNE convertir_parte_entera                      ; Si sí, continuar


    ; Ajustar el puntero SI al inicio del número convertido
    INC SI                                          ; Mover al inicio del número

    ; Restaurar registros
    POP SI
    POP DX
    POP CX

    RET     
convertir_numero_a_cadena ENDP


; ==============================================
; Procedimiento: obtener_unidades
; Descripción : Obtiene el nombre de las unidades.
; Parámetros  : Ninguno
; Registros modificados: AX, BX, SI
; ==============================================
obtener_unidades PROC far
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
    MOV DX, SI      ; Cargar la dirección apuntada por SI en DX
    MOV AH, 09H     ; Función DOS para imprimir cadena
    INT 21H         ; Llamar a la interrupción

    POP SI
    POP BX
    RET
obtener_unidades ENDP


; ==============================================
; Procedimiento: mostrar_resultado
; Descripción : Muestra el resultado de la conversión.
; Parámetros  : Ninguno
; Registros modificados: AX, DX
; ==============================================
mostrar_resultado PROC far
    ; Limpiar el buffer de salida
    LIMPIAR_BUFFER buffer_salida, BUFFER_SIZE

    ; Llamar a la función de conversión
    CALL convertir_numero_a_cadena

    ; Mostrar el mensaje "El resultado es: "
    IMPRIMIR mensaje_resultado

    ; Mostrar el número convertido
    IMPRIMIR buffer_salida

    ; Imprimir espacio
    IMPRIMIR ESPACIADOR

    ; Mostrar las unidades
    CALL obtener_unidades

    ; Imprimir salto de línea
    IMPRIMIR SALTO_LINEA

    RET     
mostrar_resultado ENDP