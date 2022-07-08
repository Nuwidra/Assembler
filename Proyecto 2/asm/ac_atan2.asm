TITLE Procedimiento ac_atan2 (ac_atan2.asm)

; Include irvine32
INCLUDE ac_atan2.inc

; Defines every variable used in all the process
.data
producto DWORD	?
dividendo DWORD	?

realCuadrado DWORD ?
imagCuadrado DWORD ?

resultado DWORD	?

.code
; Defines the process and all the parameters
ac_atan2 PROC,
num1:DWORD,
num2:DWORD

 ; This segment does a multiplication between num1 and num2
 ; Stores the result in the "producto" variable
 productoProcess:
 mov eax, num1
 mov edx, num2
 imul eax, edx
 mov producto, eax

 ; This segment does a multiplication and takes the square of num1
 realPartCuadrado:
 mov eax, 0
 mov eax, num1
 imul eax, num1
 mov realCuadrado, eax

 ; This segment does a multiplication and takes the square of num2
 imagPartCuadrado:
 mov eax, 0
 mov eax, num2
 imul eax, num2
 mov imagCuadrado, eax

 ; Compares the square of num1 and the square of num2 to know which formula uses
 cmp realCuadrado, eax
 jg formula1_4_5_8
 jl formula2_3_6_7

 ; This segment does:
 ;_____________QxI_______________
 ;(I^2 + (Q^2>>2) + (Q^2>>5))>>15

 formula1_4_5_8:
 mov eax, imagCuadrado
 mov ebx, imagCuadrado
 shr eax, 2
 shr ebx, 5
 add eax, ebx
 add eax, realCuadrado
 shr eax, 15
 mov dividendo, eax

 mov eax, producto
 cdq

 mov ebx, 0
 mov ebx, dividendo
 idiv ebx

 RET

 ;This segment does:
 ;_____________QxI_______________
 ;(Q^2 + (I^2>>2) + (I^2>>5))>>15
 formula2_3_6_7:
 mov eax, realCuadrado
 mov ebx, realCuadrado
 shr eax, 2
 shr ebx, 5
 add eax, ebx
 add eax, imagCuadrado
 shr eax, 15
 mov dividendo, eax	

 mov eax, producto
 cdq

 mov ebx, 0
 mov ebx, dividendo
 idiv ebx

 RET

 ac_atan2 ENDP

 END