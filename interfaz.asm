; multi-segment executable file template.

include 'emu8086.inc'

data segment
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
                   db "18. Kilos a Toneladas", 24H  ; Fin de la cadena con '$'

    
    mensaje_entrada db 0Dh, 0Ah, "Por favor seleccione una opcion: $"
    
    ; Buffer para la entrada del usuario
    ; Primer byte: tamaño máximo de la cadena (en este caso, 10 caracteres)
    ; Segundo byte: número de caracteres leídos
    entrada_usuario db 10, 0, 10 dup(0)  ; Buffer de entrada de 10 caracteres
    
    
    
    ;mensaje_resultado db 0Dh, 0Ah, "El resultado es: $" 
    ;menu_secundario db 0Dh, 0Ah, "Por favor presione:", 0Dh, 0Ah
    ;               db "1. Para continuar", 0Dh, 0Ah
    ;               db "2. Para salir", 24H  ; Fin de la cadena con '$'

    mensaje_final db 0Dh, 0Ah, "Gracias por usar ConverTec", 24H  ; Fin de la cadena con '$'
data ends

code segment
    assume cs:code, ds:data
    
    start:
        mov ax, data
        mov ds, ax  ; Cargar segmento de datos en DS

        ; Mostrar mensaje de bienvenida
        mov dx, offset mensaje_inicio
        mov ah, 09h
        int 21h  

        ; Mostrar menú principal
        mov dx, offset menu_principal
        mov ah, 09h
        int 21h               
        
        ; Mostrar mensaje de solicitud de entrada
        mov dx, offset mensaje_entrada
        mov ah, 09h
        int 21h  

        ; Leer la entrada del usuario (función 0Ah)
        mov dx, offset entrada_usuario  ; Dirección del buffer
        mov ah, 0Ah
        int 21h  ; Llama a DOS para leer una cadena

        ; Salida limpia del programa
        mov ah, 4Ch
        int 21h
code ends

end start

