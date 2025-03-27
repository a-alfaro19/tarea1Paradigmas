; Programa principal ConverTec
; Interfaz completa para todas las conversiones

include 'emu8086.inc'

data segment
    ; Mensajes de la interfaz
    mensaje_inicio db "Bienvenido al programa ConverTec", 0Dh, 0Ah, "$"
    
    menu_principal db "Por favor indique que tipo de conversion desea realizar:", 0Dh, 0Ah 
                   db "Presione:", 0Dh, 0Ah
                   db "1.  Fahrenheit a Celsius", 0Dh, 0Ah
                   db "2.  Celsius a Kelvin", 0Dh, 0Ah
                   db "3.  Kelvin a Celsius", 0Dh, 0Ah
                   db "4.  Fahrenheit a Kelvin", 0Dh, 0Ah
                   db "5.  Pulgadas a Centimetros", 0Dh, 0Ah
                   db "6.  Pies a Centimetros", 0Dh, 0Ah
                   db "7.  Yardas a Centimetros", 0Dh, 0Ah
                   db "8.  Millas a Kilometros", 0Dh, 0Ah
                   db "9.  Centimetros a Pulgadas", 0Dh, 0Ah
                   db "10. Centimetros a Pies", 0Dh, 0Ah
                   db "11. Centimetros a Yardas", 0Dh, 0Ah
                   db "12. Kilometros a Millas", 0Dh, 0Ah
                   db "13. Onzas a Kilos", 0Dh, 0Ah
                   db "14. Libras a Kilos", 0Dh, 0Ah
                   db "15. Toneladas a Kilos", 0Dh, 0Ah
                   db "16. Kilos a Onzas", 0Dh, 0Ah
                   db "17. Kilos a Libras", 0Dh, 0Ah
                   db "18. Kilos a Toneladas", 0Dh, 0Ah, "$"
    
    mensaje_entrada db 0Dh, 0Ah, "Por favor seleccione una opcion: $"
    mensaje_valor   db 0Dh, 0Ah, "Por favor ingrese el valor a convertir (ej. -12,34 o 1234,56): $"
    mensaje_error   db 0Dh, 0Ah, "Error: Valor no valido. Debe ser entre -999,99 y 9999,99", 0Dh, 0Ah, "$"
    mensaje_resultado db 0Dh, 0Ah, "El resultado es: $"
    mensaje_continuar db 0Dh, 0Ah, "Por favor presione:", 0Dh, 0Ah
                     db "1. Para Continuar", 0Dh, 0Ah
                     db "2. Para Salir", 0Dh, 0Ah, "$"
    mensaje_final db 0Dh, 0Ah, "Gracias por usar ConverTec", 0Dh, 0Ah, "$"
    
    ; Mensajes específicos para cada conversión
    msg_fahr_cel db " grados Fahrenheit corresponden a $"
    msg_cel_kel  db " grados Celsius corresponden a $"
    msg_kel_cel  db " grados Kelvin corresponden a $"
    msg_fahr_kel db " grados Fahrenheit corresponden a $"
    msg_pulg_cm  db " pulgadas corresponden a $"
    msg_pies_cm  db " pies corresponden a $"
    msg_yard_cm  db " yardas corresponden a $"
    msg_millas_km db " millas corresponden a $"
    msg_cm_pulg  db " centimetros corresponden a $"
    msg_cm_pies  db " centimetros corresponden a $"
    msg_cm_yard  db " centimetros corresponden a $"
    msg_km_millas db " kilometros corresponden a $"
    msg_onz_kg   db " onzas corresponden a $"
    msg_lib_kg   db " libras corresponden a $"
    msg_ton_kg   db " toneladas corresponden a $"
    msg_kg_onz   db " kilogramos corresponden a $"
    msg_kg_lib   db " kilogramos corresponden a $"
    msg_kg_ton   db " kilogramos corresponden a $"
    
    ; Unidades de medida
    msg_fahrenheit db " Fahrenheit$"
    msg_celsius    db " Celsius$"
    msg_kelvin     db " Kelvin$"
    msg_centimetros db " centimetros$"
    msg_pulgadas   db " pulgadas$"
    msg_pies       db " pies$"
    msg_yardas     db " yardas$"
    msg_kilometros db " kilometros$"
    msg_millas     db " millas$"
    msg_kilogramos db " kilogramos$"
    msg_onzas      db " onzas$"
    msg_libras     db " libras$"
    msg_toneladas  db " toneladas$"   
    
    ; Variables de programa
    entrada_usuario db 12, 0, 12 dup(0)   ; Buffer para entrada
    valor_entrada_high dw ?             ; Parte alta del valor (DX)
    valor_entrada_low  dw ?             ; Parte baja del valor (AX)
    opcion          db ?
    continuar       db ?
    signo           db ?                ; 0 = positivo, 1 = negativo
    tiene_decimal   db ?                ; 0 = no, 1 = si
    parte_entera    dw ?
    parte_decimal   dw ?  
    resultado_h dw ?
    resultado_l dw ? 
   

ends

stack segment stack
    dw 128 dup(?)
stack ends

code segment public 'CODE'
    assume cs:code, ds:data, ss:stack
start:
    ; Set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
inicio_programa:
    ; Limpiar pantalla
    call CLEAR_SCREEN
    
    ; Mostrar mensaje de bienvenida
    mov dx, offset mensaje_inicio
    mov ah, 09h
    int 21h
    
mostrar_menu:
    ; Mostrar menú principal
    mov dx, offset menu_principal
    mov ah, 09h
    int 21h
    
    ; Mostrar mensaje de solicitud de entrada
    mov dx, offset mensaje_entrada
    mov ah, 09h
    int 21h
    
    ; Leer la opción del usuario
    mov dx, offset entrada_usuario
    mov ah, 0Ah
    int 21h
    
    ; Convertir la entrada a número
    mov si, offset entrada_usuario + 2
    call STRING_TO_NUMBER
    mov opcion, al  
    
    ; Validar la opción
    cmp al, 1
    jl mostrar_menu
    cmp al, 18
    jg mostrar_menu
    
pedir_valor:
    ; Limpiar buffer de entrada
    mov di, offset entrada_usuario + 2
    mov cx, 10
    mov al, 0
    rep stosb
    
    ; Mostrar mensaje
    mov dx, offset mensaje_valor
    mov ah, 09h
    int 21h
    
    ; Configurar buffer para lectura
    mov byte ptr [entrada_usuario], 10
    mov byte ptr [entrada_usuario+1], 0
    
    ; Leer entrada del usuario
    mov dx, offset entrada_usuario
    mov ah, 0Ah
    int 21h
    
    ; Añadir terminador nulo
    mov bl, [entrada_usuario+1]
    mov bh, 0
    mov si, offset entrada_usuario + 2
    add si, bx
    mov byte ptr [si], 0
    
guardar_valor:
    ; Procesar la entrada del usuario
    mov si, offset entrada_usuario + 2
    call PROCESAR_ENTRADA
    jc error_entrada
    
    ; Guardar el valor procesado
    mov valor_entrada_high, dx 
    mov valor_entrada_low, ax   

    
    ; Realizar la conversión según la opción seleccionada
    mov al, opcion
    cmp al, 1
    je conv_fahr_cel
    cmp al, 2
    je conv_cel_kel
    cmp al, 3
    je conv_kel_cel
    cmp al, 4
    je conv_fahr_kel
    cmp al, 5
    je conv_pulg_cm
    cmp al, 6
    je conv_pies_cm
    cmp al, 7
    je conv_yard_cm
    cmp al, 8
    je conv_millas_km
    cmp al, 9
    je conv_cm_pulg
    cmp al, 10
    je conv_cm_pies
    cmp al, 11
    je conv_cm_yard
    cmp al, 12
    je conv_km_millas
    cmp al, 13
    je conv_onz_kg
    cmp al, 14
    je conv_lib_kg
    cmp al, 15
    je conv_ton_kg
    cmp al, 16
    je conv_kg_onz
    cmp al, 17
    je conv_kg_lib
    cmp al, 18
    je conv_kg_ton
    
error_entrada:
    ; Mostrar mensaje de error
    mov dx, offset mensaje_error
    mov ah, 09h
    int 21h
    jmp pedir_valor

; Llamadas a las rutinas de conversión (simuladas)
conv_fahr_cel:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    ; Simular conversión (solo para interfaz)
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_temp

conv_cel_kel:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL CELSIUS_A_KELVIN
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_temp

conv_kel_cel:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL KELVIN_A_CELSIUS
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_temp

conv_fahr_kel:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    call FAHRENHEIT_A_KELVIN
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_temp

conv_pulg_cm:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    ; Simular conversión
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_long

conv_pies_cm:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL PIES_A_CENTIMETROS
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_long

conv_yard_cm:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL YARDAS_A_CENTIMETROS
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_long

conv_millas_km:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    ; Simular conversión
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_long

conv_cm_pulg:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    ; Simular conversión
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_long

conv_cm_pies:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL CENTIMETROS_A_PIES
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_long

conv_cm_yard:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL CENTIMETROS_A_YARDAS 
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_long

conv_km_millas:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL KILOMETROS_A_MILLAS
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_long

conv_onz_kg:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    ; Simular conversión
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_peso

conv_lib_kg:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL LIBRAS_A_KILOGRAMOS
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_peso

conv_ton_kg:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL TONELADAS_A_KILOS
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_peso

conv_kg_onz:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    ; Simular conversión
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_peso

conv_kg_lib:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL KILOGRAMOS_A_LIBRAS
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_peso

conv_kg_ton:
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    CALL KILOS_A_TONELADAS
    mov resultado_h, dx
    mov resultado_l, ax
    jmp mostrar_resultado_peso

; Mostrar resultados según el tipo de conversión
mostrar_resultado_temp:
    ; Mostrar mensaje de resultado
    mov dx, offset mensaje_resultado
    mov ah, 09h
    int 21h
    
    ; Mostrar valor original  
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    call MOSTRAR_RESULTADO_DECIMAL
    
    ; Mostrar mensaje específico según la opción  
    
    cmp opcion, 1
    je mostrar_msg_fahr_cel
    cmp opcion, 2
    je mostrar_msg_cel_kel
    cmp opcion, 3
    je mostrar_msg_kel_cel
    cmp opcion, 4
    je mostrar_msg_fahr_kel
    
mostrar_msg_fahr_cel:
    mov dx, offset msg_fahr_cel
    jmp mostrar_resultado_comun_temp

mostrar_msg_cel_kel:
    mov dx, offset msg_cel_kel
    jmp mostrar_resultado_comun_temp

mostrar_msg_kel_cel:
    mov dx, offset msg_kel_cel
    jmp mostrar_resultado_comun_temp

mostrar_msg_fahr_kel:
    mov dx, offset msg_fahr_kel

mostrar_resultado_comun_temp:
    mov ah, 09h
    int 21h
    
    ; Mostrar resultado
    mov dx, resultado_h
    mov ax, resultado_l
    call MOSTRAR_RESULTADO_DECIMAL
    
    ; Mostrar unidad de resultado
    cmp opcion, 1
    je mostrar_cel_res
    cmp opcion, 2
    je mostrar_kel_res
    cmp opcion, 3
    je mostrar_cel_res
    cmp opcion, 4
    je mostrar_kel_res
    
mostrar_cel_res:
    mov dx, offset msg_celsius
    jmp mostrar_unidad_res

mostrar_kel_res:
    mov dx, offset msg_kelvin

mostrar_unidad_res:
    mov ah, 09h
    int 21h
    jmp preguntar_continuar

mostrar_resultado_long:
    ; Mostrar mensaje de resultado
    mov dx, offset mensaje_resultado
    mov ah, 09h
    int 21h
    
    ; Mostrar valor original  
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    call MOSTRAR_RESULTADO_DECIMAL
    
    ; Mostrar mensaje específico según la opción
    cmp opcion, 5
    je mostrar_msg_pulg_cm
    cmp opcion, 6
    je mostrar_msg_pies_cm
    cmp opcion, 7
    je mostrar_msg_yard_cm
    cmp opcion, 8
    je mostrar_msg_millas_km
    cmp opcion, 9
    je mostrar_msg_cm_pulg
    cmp opcion, 10
    je mostrar_msg_cm_pies
    cmp opcion, 11
    je mostrar_msg_cm_yard
    cmp opcion, 12
    je mostrar_msg_km_millas
    
mostrar_msg_pulg_cm:
    mov dx, offset msg_pulg_cm
    jmp mostrar_resultado_comun_long

mostrar_msg_pies_cm:
    mov dx, offset msg_pies_cm
    jmp mostrar_resultado_comun_long

mostrar_msg_yard_cm:
    mov dx, offset msg_yard_cm
    jmp mostrar_resultado_comun_long

mostrar_msg_millas_km:
    mov dx, offset msg_millas_km
    jmp mostrar_resultado_comun_long

mostrar_msg_cm_pulg:
    mov dx, offset msg_cm_pulg
    jmp mostrar_resultado_comun_long

mostrar_msg_cm_pies:
    mov dx, offset msg_cm_pies
    jmp mostrar_resultado_comun_long

mostrar_msg_cm_yard:
    mov dx, offset msg_cm_yard
    jmp mostrar_resultado_comun_long

mostrar_msg_km_millas:
    mov dx, offset msg_km_millas

mostrar_resultado_comun_long:
    mov ah, 09h
    int 21h
    
    ; Mostrar resultado
    mov dx, resultado_h
    mov ax, resultado_l
    call MOSTRAR_RESULTADO_DECIMAL
    
    ; Mostrar unidad de resultado
    cmp opcion, 5
    je mostrar_cm_res
    cmp opcion, 6
    je mostrar_cm_res
    cmp opcion, 7
    je mostrar_cm_res
    cmp opcion, 8
    je mostrar_km_res
    cmp opcion, 9
    je mostrar_pulg_res
    cmp opcion, 10
    je mostrar_pies_res
    cmp opcion, 11
    je mostrar_yard_res
    cmp opcion, 12
    je mostrar_millas_res
    
mostrar_cm_res:
    mov dx, offset msg_centimetros
    jmp mostrar_unidad_res_long

mostrar_km_res:
    mov dx, offset msg_kilometros
    jmp mostrar_unidad_res_long

mostrar_pulg_res:
    mov dx, offset msg_pulgadas
    jmp mostrar_unidad_res_long

mostrar_pies_res:
    mov dx, offset msg_pies
    jmp mostrar_unidad_res_long

mostrar_yard_res:
    mov dx, offset msg_yardas
    jmp mostrar_unidad_res_long

mostrar_millas_res:
    mov dx, offset msg_millas

mostrar_unidad_res_long:
    mov ah, 09h
    int 21h
    jmp preguntar_continuar

mostrar_resultado_peso:
    ; Mostrar mensaje de resultado
    mov dx, offset mensaje_resultado
    mov ah, 09h
    int 21h
    
    ; Mostrar valor original  
    mov dx, valor_entrada_high
    mov ax, valor_entrada_low
    call MOSTRAR_RESULTADO_DECIMAL
    
    ; Mostrar mensaje específico según la opción
    cmp opcion, 13
    je mostrar_msg_onz_kg
    cmp opcion, 14
    je mostrar_msg_lib_kg
    cmp opcion, 15
    je mostrar_msg_ton_kg
    cmp opcion, 16
    je mostrar_msg_kg_onz
    cmp opcion, 17
    je mostrar_msg_kg_lib
    cmp opcion, 18
    je mostrar_msg_kg_ton
    
mostrar_msg_onz_kg:
    mov dx, offset msg_onz_kg
    jmp mostrar_resultado_comun_peso

mostrar_msg_lib_kg:
    mov dx, offset msg_lib_kg
    jmp mostrar_resultado_comun_peso

mostrar_msg_ton_kg:
    mov dx, offset msg_ton_kg
    jmp mostrar_resultado_comun_peso

mostrar_msg_kg_onz:
    mov dx, offset msg_kg_onz
    jmp mostrar_resultado_comun_peso

mostrar_msg_kg_lib:
    mov dx, offset msg_kg_lib
    jmp mostrar_resultado_comun_peso

mostrar_msg_kg_ton:
    mov dx, offset msg_kg_ton

mostrar_resultado_comun_peso:
    mov ah, 09h
    int 21h
    
    ; Mostrar resultado
    mov dx, resultado_h
    mov ax, resultado_l
    call MOSTRAR_RESULTADO_DECIMAL
    
    ; Mostrar unidad de resultado
    cmp opcion, 13
    je mostrar_kg_res
    cmp opcion, 14
    je mostrar_kg_res
    cmp opcion, 15
    je mostrar_kg_res
    cmp opcion, 16
    je mostrar_onz_res
    cmp opcion, 17
    je mostrar_lib_res
    cmp opcion, 18
    je mostrar_ton_res
    
mostrar_kg_res:
    mov dx, offset msg_kilogramos
    jmp mostrar_unidad_res_peso

mostrar_onz_res:
    mov dx, offset msg_onzas
    jmp mostrar_unidad_res_peso

mostrar_lib_res:
    mov dx, offset msg_libras
    jmp mostrar_unidad_res_peso

mostrar_ton_res:
    mov dx, offset msg_toneladas

mostrar_unidad_res_peso:
    mov ah, 09h
    int 21h
    jmp preguntar_continuar

preguntar_continuar:
    ; Mostrar mensaje para continuar o salir
    mov dx, offset mensaje_continuar
    mov ah, 09h
    int 21h
    
    ; Leer la opción del usuario
    mov dx, offset entrada_usuario
    mov ah, 0Ah
    int 21h
    
    ; Convertir la entrada a número
    mov si, offset entrada_usuario + 2
    call STRING_TO_NUMBER
    mov continuar, al
    
    ; Decidir qué hacer
    cmp continuar, 1
    je inicio_programa
    
    ; Salir del programa
    mov dx, offset mensaje_final
    mov ah, 09h
    int 21h
    
    mov ax, 4C00h
    int 21h

; Rutinas auxiliares
PROCESAR_ENTRADA proc near
    ; Inicializar variables
    mov signo, 0
    mov tiene_decimal, 0
    mov parte_entera, 0
    mov parte_decimal, 0
    
    ; Saltar espacios iniciales
    mov al, [si]
    cmp al, ' '
    jne check_sign
    inc si
    
check_sign:
    ; Verificar signo
    mov al, [si]
    cmp al, '-'
    jne check_positive
    mov signo, 1
    inc si
    jmp process_integer
    
check_positive:
    cmp al, '+'
    jne process_integer
    inc si
    
process_integer:
    xor bx, bx          ; bx = parte entera
    
integer_loop:
    mov al, [si]
    ; Verificar fin de cadena
    cmp al, 0
    je process_done
    cmp al, 0Dh
    je process_done
    ; Verificar separador decimal
    cmp al, '.'
    je found_decimal
    cmp al, ','
    je found_decimal
    ; Validar dígito
    cmp al, '0'
    jb invalid_input
    cmp al, '9'
    ja invalid_input
    
    ; Convertir y acumular
    mov ax, bx
    mov dx, 10
    mul dx
    mov bx, ax
    mov al, [si]
    sub al, '0'
    add bl, al
    adc bh, 0
    inc si
    jmp integer_loop
    
found_decimal:
    mov tiene_decimal, 1
    inc si
    xor cx, cx          ; cx = parte decimal
    mov di, 0           ; contador de dígitos
    
decimal_loop:
    mov al, [si]
    cmp al, 0
    je decimal_done
    cmp al, 0Dh
    je decimal_done
    cmp al, '0'
    jb invalid_input
    cmp al, '9'
    ja invalid_input
    
    ; cx = cx * 10 + al
    mov ax, cx
    mov dx, 10
    mul dx
    mov cx, ax
    mov al, [si]
    sub al, '0'
    add cl, al
    adc ch, 0
    inc si
    inc di
    cmp di, 2
    jb decimal_loop
    
decimal_done:
    mov parte_decimal, cx
    
process_done:
    mov parte_entera, bx
    
    ; Validar rangos
    cmp signo, 1
    je check_negative
    
    ; Positivo: 0 a 9999,99
    cmp bx, 9999
    ja invalid_input
    jmp check_decimal
    
check_negative:
    ; Negativo: -999,99 a 0
    cmp bx, 999
    ja invalid_input
    
check_decimal:
    cmp tiene_decimal, 1
    jne no_decimal
    cmp parte_decimal, 99
    ja invalid_input
no_decimal:
    
    ; Convertir a valor x100 (DX:AX)
    mov ax, parte_entera
    mov dx, 100
    mul dx              ; DX:AX = parte_entera * 100
    add ax, parte_decimal
    adc dx, 0
    
    ; Aplicar signo
    cmp signo, 1
    jne store_result
    neg dx
    neg ax
    sbb dx, 0
    
store_result:
    clc
    ret
    
invalid_input:
    stc
    ret
PROCESAR_ENTRADA endp

MOSTRAR_NUMERO_CON_DECIMALES proc near
    ; Muestra un número con decimales (DX:AX contiene el número * 100)
    ; Primero divide por 100 para separar parte entera y decimal
    
    ; Determinar si es negativo
    test dx, dx
    jns positivo
    neg dx
    neg ax
    sbb dx, 0
    
    ; Mostrar signo negativo
    push ax
    push dx
    mov ah, 02h
    mov dl, '-'
    int 21h
    pop dx
    pop ax
    
positivo:
    ; Dividir DX:AX por 100 (manejo de 32 bits)
    mov bx, 100
    push ax            ; Guardar AX (parte baja)
    
    ; Primero dividir la parte alta (DX)
    mov ax, dx
    xor dx, dx
    div bx             ; AX = DX / 100, DX = residuo
    
    ; Ahora DX contiene el residuo de la división alta
    ; Convertirlo a la parte baja para la siguiente división
    mov cx, dx         ; Guardar residuo alto
    pop dx             ; Recuperar parte baja original
    push ax            ; Guardar cociente alto
    
    ; Dividir (residuo_alto << 16 + parte_baja) / 100
    mov ax, dx
    mov dx, cx         ; DX:AX = (residuo anterior << 16) | AX_original
    div bx             ; AX = cociente bajo, DX = residuo (parte decimal)
    
    ; Combinar resultados
    mov cx, dx         ; CX = parte decimal
    pop dx             ; DX = cociente alto
    ; Ahora DX:AX contiene el valor dividido, pero solo usamos AX (pues DX debería ser 0)
    ; CX contiene la parte decimal
    
    ; Mostrar parte entera
    push cx            ; Guardar parte decimal
    
    ; Mostrar punto decimal
    mov ah, 02h
    mov dl, ','
    int 21h
    
    ; Mostrar parte decimal (2 dígitos)
    pop ax             ; Recuperar parte decimal
    cmp ax, 10
    push ax
    mov ah, 02h
    mov dl, '0'
    int 21h
    pop ax
    
    ret
    
MOSTRAR_NUMERO_CON_DECIMALES endp

STRING_TO_NUMBER proc near
    ; Converts ASCIIZ string to number in AX
    ; Input: SI = pointer to string
    mov ax, 0          ; Clear AX (result)
    mov bx, 0          ; Clear BX
    mov cx, 0          ; Clear CX
    mov dx, 0          ; Clear DX
    
convert_loop:
    mov bl, [si]        ; Get next character
    cmp bl, 0Dh         ; Check for carriage return
    je end_convert      ; Done if end of string
    cmp bl, '0'         ; Validate digit
    jb end_convert
    cmp bl, '9'
    ja end_convert
    
    sub bl, '0'         ; Convert ASCII to digit
    
    ; Multiply current result by 10 (correct 8086 IMUL)
    mov cx, ax          ; Save current value
    shl ax, 1           ; AX = AX * 2
    shl ax, 1           ; AX = AX * 4
    add ax, cx          ; AX = AX * 5
    shl ax, 1           ; AX = AX * 10
    
    add ax, bx          ; Add new digit
    inc si              ; Move to next character
    jmp convert_loop
    
end_convert:
    ret
STRING_TO_NUMBER endp

CLEAR_SCREEN proc near
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    mov ah, 02h
    mov bh, 00h
    mov dx, 0000h
    int 10h
    ret
CLEAR_SCREEN endp 
; ============================================================================
; MOSTRAR_RESULTADO_DECIMAL
; Descripción: Muestra números decimales manejando correctamente la parte fraccionaria
; Entrada:
;   - resultado_h:resultado_l = número en formato x100 (32 bits con signo)
; ============================================================================
MOSTRAR_RESULTADO_DECIMAL proc near
    pusha                   ; Guardamos todos los registros
    
    ; Verificar si es negativo
    test dx, dx
    jns positivo_rd_fix
    
    ; Mostrar signo negativo y convertir a positivo
    push ax
    push dx
    mov ah, 02h
    mov dl, '-'
    int 21h
    pop dx
    pop ax
    
    xor dx, 0FFFFh
    neg ax
    sbb dx, 0
    
positivo_rd_fix:
    ; Separar parte entera y decimal (dividir por 100)
    mov bx, 100
    push ax          ; Guardar parte baja
    
    ; Primero dividir la parte alta (DX)
    mov ax, dx
    xor dx, dx       ; DX:AX = parte alta extendida a 32 bits
    div bx           ; AX = cociente alto, DX = residuo alto
    
    ; Combinar residuo alto (DX) con parte baja (AX)
    mov cx, dx       ; Guardar residuo alto
    pop dx           ; Recuperar parte baja original
    push ax          ; Guardar cociente alto
    
    ; Dividir (residuo alto:parte baja) / 100
    mov ax, dx
    mov dx, cx
    div bx           ; AX = cociente bajo, DX = parte decimal (0-99)
    
    ; Combinar resultados
    mov cx, dx       ; CX = parte decimal
    pop dx           ; DX = cociente alto
    
    ; Mostrar parte entera (DX:AX)
    or dx, dx
    jz mostrar_parte_baja
    
    ; Si DX > 0, mostrar primero la parte alta
    call MOSTRAR_NUMERO_GRANDE  ; Mostrar DX
    mov ax, dx
    call MOSTRAR_NUMERO_GRANDE  ; Mostrar AX
    
mostrar_parte_baja:
    call MOSTRAR_NUMERO_GRANDE  ; Mostrar AX (parte baja)
    
    ; Mostrar punto decimal
    mov ah, 02h
    mov dl, ','
    int 21h
    
    ; Mostrar parte decimal (siempre 2 dígitos)
    mov ax, cx       ; Parte decimal (0-99)
    cmp ax, 10
    jae mostrar_decimal_fix
    
    ; Si es menor que 10, mostrar un 0 primero
    push ax
    mov ah, 02h
    mov dl, '0'
    int 21h
    pop ax
    
mostrar_decimal_fix:
    call MOSTRAR_NUMERO_ENTERO  ; Mostrar los 2 dígitos decimales
    
fin_mostrar_rd_fix:
    popa                    ; Restaurar todos los registros
    ret
MOSTRAR_RESULTADO_DECIMAL endp

; ============================================================================
; MOSTRAR_NUMERO_GRANDE (optimizada)
; Descripción: Muestra números de 16 bits (0-65535)
; Entrada: AX = número a mostrar
; ============================================================================
MOSTRAR_NUMERO_GRANDE proc near
    push ax
    push bx
    push cx
    push dx
    
    ; Caso especial para cero
    or ax, ax
    jnz no_cero_grande
    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp fin_num_grande
    
no_cero_grande:
    ; Extraer dígitos
    mov cx, 0          ; Contador de dígitos
    mov bx, 10
    
extraer_digitos_grande:
    mov dx, 0
    div bx              ; AX = cociente, DX = dígito
    push dx             ; Guardar dígito
    inc cx
    or ax, ax           ; ¿Terminamos?
    jnz extraer_digitos_grande
    
    ; Mostrar dígitos
mostrar_digitos_grande:
    pop dx
    add dl, '0'         ; Convertir a ASCII
    mov ah, 02h
    int 21h
    loop mostrar_digitos_grande
    
fin_num_grande:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
MOSTRAR_NUMERO_GRANDE endp

; ============================================================================
; MOSTRAR_NUMERO_ENTERO (para 2 dígitos)
; Descripción: Muestra números de 0-99 optimizado
; Entrada: AX = número (0-99)
; ============================================================================
MOSTRAR_NUMERO_ENTERO proc near
    push ax
    push dx
    
    cmp ax, 10
    jb un_digito
    
    ; Dos dígitos
    mov dl, 10
    div dl          ; AL = decenas, AH = unidades
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    mov al, ah      ; Unidades
    
un_digito:          ; AH = unidades
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    mov al, ah 
    
    pop dx
    pop ax
    ret
MOSTRAR_NUMERO_ENTERO endp

; ============================================================================
; Macro: FAHRENHEIT_A_KELVIN
; Descripcion: Convierte una temperatura en Fahrenheit a Kelvin.
; Parametros:
;  - ENTRADA: Variable de entrada (temperatura en Fahrenheit)
;  - SALIDA: Variable de salida (temperatura en Kelvin)
; ============================================================================

FAHRENHEIT_A_KELVIN proc near 
    
    ; Restar 3200 (DX:AX - 3200) 
    SUB AX, 3200     ; Restar la parte baja
    SBB DX, 0         ; Ajustar parte alta  
    
    ; --- Manejo del signo antes de la división ---
    PUSH DX          ; Guardar DX (parte alta) para verificar signo despues
    
    ; Verificar si el numero es negativo (comprobar bit de signo en DX)
    TEST DX, DX
    JNS Positivo1  ; Si no es negativo (SF=0), saltar a division
    
    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
    Positivo1:
    
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

    ret                   
FAHRENHEIT_A_KELVIN endp 

; ============================================================================
; Macro: KELVIN_A_FAHRENHEIT
; Descripción: Convierte una temperatura en Kelvin a Fahrenheit.
; Parámetros:
;  - ENTRADA: Variable de entrada (temperatura en Kelvin)
;  - SALIDA: Variable de salida (temperatura en Fahrenheit)
; ============================================================================
KELVIN_A_FAHRENHEIT proc near 
    ; Restar 27315 (DX:AX - 27315) 
    SUB AX, 27315     ; Restar la parte baja
    SBB DX, 0         ; Ajustar parte alta si hay préstamo

    ; Multiplicar por 18 (DX:AX * 18) 
    MOV CX, 18
    CALL Mul32x16     ; Llamar a rutina de multiplicación 32x16 bits
    
    ; Sumar 32000 (DX:AX + 32,000)
    ADD AX, 32000     ; Sumar la parte baja
    ADC DX, 0         ; Ajustar parte alta si hay acarreo                       
    ret
KELVIN_A_FAHRENHEIT endp   

; ============================================================================
; Macro: CENTIMETROS_A_PIES
; Descripcion: Convierte una distancia en centimetros a pies.
; Parametros:
;  - ENTRADA: Variable de entrada (distancia en centimetros)
;  - SALIDA: Variable de salida (distancia en pies)
; ============================================================================
CENTIMETROS_A_PIES proc near 
    ; --- Manejo del signo antes de la división ---
    PUSH DX          ; Guardar DX (parte alta) para verificar signo despues
    
    ; Verificar si el numero es negativo (comprobar bit de signo en DX)
    TEST DX, DX
    JNS Positivo_c  ; Si no es negativo (SF=0), saltar a division
    
    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
    Positivo_c:
    
    MOV CX, 100
    CALL Mul32x16
             
    
    ; Dividir entre 3048 (DX:AX / 3048)
    MOV CX, 3048 
    CALL Div32x16 
                             
                
    MOV BX, DX
    ; Recuperar el signo original
    POP DX           ; Recuperar DX original para verificar el signo
    
    ; Verificar si el numero original era negativo
    TEST DX, DX
    JNS Finalc   ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR BX, 0FFFFh  
    NEG AX
    
    Finalc:
    MOV DX, BX
    ret
CENTIMETROS_A_PIES endp   
; ============================================================================
; Macro: PIES_A_CENTIMETROS
; Descripcion: Convierte una distancia en pies a centimetros.
; Parametros:
;  - ENTRADA: Variable de entrada (temperatura en Kelvin)
;  - SALIDA: Variable de salida (temperatura en Fahrenheit)
; ============================================================================
PIES_A_CENTIMETROS proc near
    ; --- Manejo del signo antes de la división ---
    PUSH DX          ; Guardar DX (parte alta) para verificar signo despues
    
    ; Verificar si el numero es negativo (comprobar bit de signo en DX)
    TEST DX, DX
    JNS Positivo_p  ; Si no es negativo (SF=0), saltar a division
    
    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
    Positivo_p:
    
    MOV CX,  3048; Multiplicar por 3048 (DX:AX / 3048)
    CALL Mul32x16
             
    MOV CX, 100 
    CALL Div32x16  
    
    MOV BX, DX
    ; Recuperar el signo original
    POP DX           ; Recuperar DX original para verificar el signo
    
    ; Verificar si el numero original era negativo
    TEST DX, DX
    JNS Finalp   ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR BX, 0FFFFh  
    NEG AX
    
    Finalp:
    MOV DX, BX
    ret
PIES_A_CENTIMETROS endp  
; ============================================================================
; Macro: KILOGRAMOS_A_LIBRAS
; Descripcion: Convierte una masa en kilogramos a libras.
; Parametros:
;  - ENTRADA: Variable de entrada (masa en kilogramos)
;  - SALIDA: Variable de salida (masa en libras)
; ============================================================================ 
KILOGRAMOS_A_LIBRAS proc near
    ; --- Manejo del signo antes de la división ---
    PUSH DX          ; Guardar DX (parte alta) para verificar signo despues
    
    ; Verificar si el numero es negativo (comprobar bit de signo en DX)
    TEST DX, DX
    JNS Positivo_kg  ; Si no es negativo (SF=0), saltar a division
    
    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
    Positivo_kg: 
    
    MOV CX, 50 
    CALL Div32x16
     
    MOV CX, 11023 
    CALL Mul32x16
    
    MOV CX, 100 
    CALL Div32x16
   
    
    
    MOV BX, DX
    ; Recuperar el signo original
    POP DX           ; Recuperar DX original para verificar el signo
    
    ; Verificar si el numero original era negativo
    TEST DX, DX
    JNS Final_kg   ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR BX, 0FFFFh  
    NEG AX
    
    Final_kg:
    MOV DX, BX
    ret
KILOGRAMOS_A_LIBRAS endp 
; ============================================================================
; Macro: LIBRAS_A_KILOGRAMOS
; Descripcion: Convierte una masa en libras a kilogramos.
; Parametros:
;  - ENTRADA: Variable de entrada (masa en libras)
;  - SALIDA: Variable de salida (masa en kilogramos)
; ============================================================================
LIBRAS_A_KILOGRAMOS proc near
    ; --- Manejo del signo antes de la división ---
    PUSH DX          ; Guardar DX (parte alta) para verificar signo despues
    
    ; Verificar si el numero es negativo (comprobar bit de signo en DX)
    TEST DX, DX
    JNS Positivo_lb  ; Si no es negativo (SF=0), saltar a division
    
    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
    Positivo_lb:  ;Factor de conversion  
    
    MOV CX, 100 
    CALL Div32x16
     
    MOV CX, 45404 
    CALL Mul32x16  
    
    MOV CX, 1000 
    CALL Div32x16
    
    
    MOV BX, DX
    ; Recuperar el signo original
    POP DX           ; Recuperar DX original para verificar el signo
    
    ; Verificar si el numero original era negativo
    TEST DX, DX
    JNS Final_lb   ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR BX, 0FFFFh  
    NEG AX
    
    Final_lb:
    MOV DX, BX
    ret
LIBRAS_A_KILOGRAMOS endp 


; ============================================================================ 
; Macro: CELSIUS_A_KELVIN
; Descripcion: Convierte una temperatura en Celsius a Kelvin.
; Parametros:
;  - ENTRADA: Variable de entrada (temperatura en Celsius)
;  - SALIDA: Variable de salida (temperatura en Kelvin)
; ============================================================================
CELSIUS_A_KELVIN proc near 
 ; Sumar 27315 (273.15 en formato entero) al resultado (DX:AX + 27315)
    ADD AX, 27315      ; Sumar la parte baja
    ADC DX, 0          ; Ajustar parte alta si hay acarreo
    ret
CELSIUS_A_KELVIN endp  

; ============================================================================ 
; Macro: KELVIN_A_CELSIUS
; Descripcion: Convierte una temperatura en Kelvin a Celsius.
; Parametros:
;  - ENTRADA: Variable de entrada (temperatura en Kelvin)
;  - SALIDA: Variable de salida (temperatura en Celsius)
; ============================================================================
KELVIN_A_CELSIUS proc near 
 ; RESTAR 27315 (273.15 en formato entero) al resultado (DX:AX - 27315)
    SUB AX, 27315      ; Restar la parte baja
    SBB DX, 0          ; Ajustar parte alta si hay préstamo
    ret
KELVIN_A_CELSIUS endp

; ============================================================================ 
; Macro: YARDAS_A_CENTIMETROS
; Descripcion: Convierte una longitud en yardas a centímetros.
; Parametros:
;  - ENTRADA: Variable de entrada (longitud en yardas)
;  - SALIDA: Variable de salida (longitud en centímetros)
; ============================================================================

YARDAS_A_CENTIMETROS proc near 
     ; Multiplicar el valor de entrada por 91.44 (en formato entero 9144)
    MOV DX, 9144       ; Cargar 91.44 en DX (9144 representando 91.44)
    IMUL DX            ; AX = parte baja, DX = parte alta
    
    ; --- Manejo del signo antes de la división ---
    PUSH DX            ; Guardar DX para verificar signo después
    
    ; Verificar si el número es negativo (comprobar bit de signo en DX)
    TEST DX, DX
    JNS Positivo_y      ; Si no es negativo (SF=0), saltar a división
    
    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
Positivo_y:
    ; Dividir entre 10000 (para deshacer el factor de conversión)
    MOV CX, 10000
    CALL Div32x16     ; Llamar a rutina de división 32x16 bits
    
    MOV BX, DX
    ; Recuperar el signo original
    POP DX           ; Recuperar DX original para verificar el signo
    
    ; Verificar si el número original era negativo
    TEST DX, DX
    JNS Final_y    ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR DX, 0FFFFh
    NEG AX

Final_y:
    MOV DX, BX  
    ret
YARDAS_A_CENTIMETROS endp

; ============================================================================ 
; Macro: CENTIMETROS_A_YARDAS
; Descripción: Convierte una distancia en centímetros a yardas.
; Parámetros:
;  - ENTRADA: Valor en centímetros con dos decimales.
;  - SALIDA: Valor en yardas con dos decimales.
; ============================================================================ 
CENTIMETROS_A_YARDAS proc near
        ; --- Manejo del signo antes de la división ---
    PUSH DX           ; Guardar DX para restaurar signo después
    
    ; Verificar si el número es negativo
    TEST DX, DX
    JNS Positivo_cm    ; Si no es negativo, proceder a la división

    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
Positivo_cm:
    MOV CX, 100       ; Factor de precisión
    CALL Mul32x16     ; Multiplicar por 100 para manejar decimales
    
    ; Dividir entre 9144 (DX:AX / 9144) ya que 1 yarda = 91.44 cm
    MOV CX, 9144
    CALL Div32x16

    MOV BX, DX        ; Almacenar parte alta del cociente
    
    ; Recuperar el signo original
    POP DX            ; Restaurar DX original para verificar el signo
    
    ; Verificar si el número original era negativo
    TEST DX, DX
    JNS Final_cm        ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR BX, 0FFFFh  
    NEG AX
    
Final_cm:
    MOV DX, BX        ; Restaurar DX con el signo correcto 
    ret
CENTIMETROS_A_YARDAS endp    

; ============================================================================ 
; Macro: KILOMETROS_A_MILLAS
; Descripción: Convierte una distancia en kilómetros a millas.
; Parámetros:
;  - ENTRADA: Valor en kilómetros con dos decimales.
;  - SALIDA: Valor en millas con dos decimales.
; ============================================================================ 
KILOMETROS_A_MILLAS proc near
     ; --- Manejo del signo antes de la división ---
    PUSH DX           ; Guardar DX para restaurar signo después
    
    ; Verificar si el número es negativo
    TEST DX, DX
    JNS Positivo_km    ; Si no es negativo, proceder a la división

    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
Positivo_km:  

    MOV CX, 1000       ; Factor de precisión
    CALL Mul32x16     ; Multiplicar por 100 para manejar decimales
    
    ; Dividir entre 16129 (DX:AX / 16129) ya que 1 kilómetro = 0.621371 millas
    MOV CX, 16129     ; 0.621371 como número entero (para mayor precisión, usamos 16129)
    CALL Div32x16  
    
    MOV CX, 10       ; Factor de precisión
    CALL Mul32x16     ; Multiplicar por 100 para manejar decimales

    MOV BX, DX        ; Almacenar parte alta del cociente
    
    ; Recuperar el signo original
    POP DX            ; Restaurar DX original para verificar el signo
    
    ; Verificar si el número original era negativo
    TEST DX, DX
    JNS Final_km        ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR BX, 0FFFFh  
    NEG AX
    
Final_km:
    MOV DX, BX        ; Restaurar DX con el signo correcto 
    ret
KILOMETROS_A_MILLAS endp  

; ============================================================================ 
; Macro: TONELADAS_A_KILOS
; Descripción: Convierte una distancia en toneladas a kilogramos.
; Parámetros:
;  - ENTRADA: Valor en toneladas con dos decimales.
;  - SALIDA: Valor en kilogramos con dos decimales.
; ============================================================================ 
TONELADAS_A_KILOS proc near 
        ; --- Manejo del signo antes de la división ---
    PUSH DX           ; Guardar DX para restaurar signo después
    
    ; Verificar si el número es negativo
    TEST DX, DX
    JNS Positivo_ton    ; Si no es negativo, proceder a la división

    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
Positivo_ton:
    
    ;Multiplicar por 1000 (DX:AX / 1000) para convertir toneladas a kilogramos
    MOV CX, 1000      ; 1 tonelada = 1000 kilogramos
    CALL Mul32x16

    MOV BX, DX        ; Almacenar parte alta del cociente
    
    ; Recuperar el signo original
    POP DX            ; Restaurar DX original para verificar el signo
    
    ; Verificar si el número original era negativo
    TEST DX, DX
    JNS Final_ton        ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR BX, 0FFFFh  
    NEG AX
    
Final_ton:
    MOV DX, BX        ; Restaurar DX con el signo correcto
    ret
TONELADAS_A_KILOS endp           


; ============================================================================ 
; Macro: KILOS_A_TONELADAS
; Descripción: Convierte una distancia en kilogramos a toneladas.
; Parámetros:
;  - ENTRADA: Valor en kilogramos con dos decimales.
;  - SALIDA: Valor en toneladas con dos decimales.
; ============================================================================ 
KILOS_A_TONELADAS proc near 
    
    ; --- Manejo del signo antes de la división ---
    PUSH DX           ; Guardar DX para restaurar signo después
    
    ; Verificar si el número es negativo
    TEST DX, DX
    JNS Positivo_kgs    ; Si no es negativo, proceder a la división

    ; Si es negativo, convertir a positivo (complemento a 2)
    XOR DX, 0FFFFh
    NEG AX
    
Positivo_kgs:
    ; Dividir entre 1000 (DX:AX / 1000) para convertir kilogramos a toneladas
    MOV CX, 1000      ; 1000 kilogramos = 1 tonelada
    CALL Div32x16

    MOV BX, DX        ; Almacenar parte alta del cociente
    
    ; Recuperar el signo original
    POP DX            ; Restaurar DX original para verificar el signo
    
    ; Verificar si el número original era negativo
    TEST DX, DX
    JNS Final_kgs        ; Si no era negativo, saltar a la suma final
    
    ; Si era negativo, negar el resultado
    XOR BX, 0FFFFh  
    NEG AX
    
Final_kgs:
    MOV DX, BX        ; Restaurar DX con el signo correcto
    ret
KILOS_A_TONELADAS endp 

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

end start