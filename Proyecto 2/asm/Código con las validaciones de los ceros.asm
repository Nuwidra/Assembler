;include C:\Irvine\Irvine32.inc

;includelib C:\Irvine\Irvine32.lib

;includelib C:\Irvine\Kernel32.lib

;includelib C:\Irvine\user32.lib



; Descripcion del Programa:

; Autor:

; Dia:

include Irvine32.inc

.386

.model flat,stdcall

.stack 4096

ExitProcess PROTO, dwExitCode:DWORD


.data

resultadoStr       BYTE "Resultado: ", 0
octanteStr1        BYTE "Octante 1", 0
octanteStr2        BYTE "Octante 2", 0
octanteStr3        BYTE "Octante 3", 0
octanteStr4        BYTE "Octante 4", 0
octanteStr5        BYTE "Octante 5", 0
octanteStr6        BYTE "Octante 6", 0
octanteStr7        BYTE "Octante 7", 0
octanteStr8        BYTE "Octante 8", 0

real_part          DWORD ?
imag_part          DWORD ?

real_part_cuadrado DWORD ? 
imag_part_cuadrado DWORD ?

; Posibles resultados inmediatos
PIQ15              DWORD 102944
PI_2_Q15           DWORD 51472
PI_2_Q15_NEG       DWORD -51472
PI_4_Q15           DWORD 25736
PI_3_4_Q15         DWORD 77208
resultado_indef    DWORD 0
indeterminado      BYTE "Indefinido",0

denominador_I_Q    DWORD ? 
denominador_Q_I    DWORD ?

numerador          DWORD ? 

octant             DWORD ?
theta              DWORD ?

.code

; Bloque de I ** 2
mov eax, real_part
mov ebx, eax
mul ebx
mov real_part_cuadrado, eax

; Bloque Q ** 2
mov eax, imag_part
mov ebx, eax
mul ebx
mov imag_part_cuadrado, eax

; Bloque I * Q
mov eax, real_part
mov ebx, imag_part
mul ebx
mov numerador, edx

; Bloque (I ** 2 + (Q ** 2 >> 2) + (Q ** 2 >> 5)

; Para octantes 1, 8, 4, y 5 
mov eax, real_part_cuadrado
mov ebx, imag_part_cuadrado
shr ebx, 2
add eax, ebx
shr ebx, 5
add eax, ebx
shr eax, 15
mov denominador_I_Q, eax

; Bloque (Q ** 2 + (I ** 2 >> 2) + (I ** 2 >> 5))
; Para octantes 2, 3, 6 y 7
mov eax, real_part_cuadrado
mov ebx, imag_part_cuadrado
shr ebx, 2
add eax, ebx
shr ebx, 5
add eax, ebx
shr eax, 15
mov denominator_Q_I, eax

; Cuando I y Q son cero
mov ecx, imag_part
cmp ecx, 0

je comparacion_imag_part_0

ja imag_part_mayor_0 ; Caso si es mayor a 0
jb imag_part_menor_0 ; Caso si es menor a 0 

comparacion_imag_part_0:
	mov ebx, real_part
	cmp ebx, 0
	ja resultado_0          ; Si es mayor a 0
	je resultado_indefinido ; Se indefine ambos son 0
	jb resultado_PIQ15      ; Si es menor debe dar PIQ15
	
	resultado_0:

		mov eax, resultado_indef
		call writeint

	resultado_indefinido:
		
		mov eax, indeterminado
		call writeint

	resultado_PIQ15:

		mov eax, PIQ15
		call writeint

imag_part_mayor_0:

	mov ebx, real_part
	cmp ebx, 0

	; Imprimir el valor de PI_2_Q15
	mov eax, PI_2_Q15
	call writeint

imag_part_menor_0:

	mov ebx, real_part
	cmp ebx, 0

	; Imprimir el valor de -PI_2_Q15
	mov eax, PI_2_Q15_NEG
	call writeint

main PROC


 cmp num1, 0
 jl numNegativo1
 je resultado0

 L1:
 cmp num2, 0
 jl numNegativo2
 je resultado0
 
 jmp octantes

 numNegativo1:
 neg num1
 mov negativo1, 1
 mov eax, 0
 mov al, num1
 call writeint
 jmp L1

 numNegativo2:
 neg num2
 mov negativo2, 1
 mov eax, 0
 mov al, num2
 call writeint
 jmp octantes

 resultado0:
 mov edx, OFFSET resultado
 mov eax, 0
 mov resultado, 0
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 octantes:
 mov edx, 0
 mov eax, 0
 mov dl, num1
 mov al, num2
 cmp dx, ax
 jg xMayor
 jmp yMayor

 xMayor:
 cmp negativo1, 0
 je octante8_o_1
 jmp octante5_o_4

 octante8_o_1:
 cmp negativo2, 0
 je octante1
 jmp octante8

 octante5_o_4:
 cmp negativo2, 0
 je octante4
 jmp octante5

 octante1:
 mov edx, OFFSET octanteStr1
 call writestring
 INVOKE ExitProcess, 0

 octante4:
 mov edx, OFFSET octanteStr4
 call writestring
 INVOKE ExitProcess, 0

 octante5:
 mov edx, OFFSET octanteStr5
 call writestring
 INVOKE ExitProcess, 0

 octante8:
 mov edx, OFFSET octanteStr8
 call writestring
 INVOKE ExitProcess, 0

 yMayor:

 cmp negativo2, 0
 je octante3_o_2
 jmp octante6_o_7
 
 octante3_o_2:
 cmp negativo1, 0
 je octante2
 jmp octante3

 octante2:
 mov edx, OFFSET octanteStr2
 call writestring
 INVOKE ExitProcess, 0

 octante3:
 mov edx, OFFSET octanteStr3
 call writestring
 INVOKE ExitProcess, 0

 octante6_o_7:
 cmp negativo1, 0
 je octante7
 jmp octante6

 octante7:
 mov edx, OFFSET octanteStr7
 call writestring
 INVOKE ExitProcess, 0

 octante6:
 mov edx, OFFSET octanteStr6
 call writestring
 INVOKE ExitProcess, 0

main ENDP



; (insertar procesos adicionales aqui)



END main