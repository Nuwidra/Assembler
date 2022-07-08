INCLUDE ac_atan2.inc		;Include the ac_atan2 include file with the declaration of the function

; Program description: The code seen in the project allows the execution of a mathematical problem using an arctan
;					   method that avoid the floating point and use the fixed point through shifts to solve it.
; Authors:
; Alejandro José Loaiza Alvarado
; Jonathan Quesada Salas
; Valeria Calderon Charpentier
; Last day of modification 29/01/2021 at 8:00pm

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

; Strings that are used to show the user messages on the terminal
resultadoStr BYTE "Resultado: ", 0
indefinidoStr BYTE "Indefinido", 0
octanteStr BYTE "Octante: ", 0
espacioStr BYTE ", ", 0

; Numbers that are used to calculate the arctan function
num1 DWORD 0
num2 DWORD 0

; Variables that stores if a number is negative
negativo1 BYTE 0
negativo2 BYTE 0

; Variables that store the square value of each number
realCuadrado DWORD ?
imagCuadrado DWORD ?

; 
dividendo DWORD	?

; Store the octant in which the angle is located
octante DWORD ?

; 
producto DWORD ?

; Stores the final result
resultado DWORD 0


; Constants
PIQ15              DWORD 102944
PI_2_Q15           DWORD 51472
PI_2_Q15_NEG       DWORD -51472
PI_4_Q15           DWORD 25736
PI_3_4_Q15         DWORD 77208


.code
main PROC

 ; Clean registers before starting all the process
 mov eax, 0
 mov edx, 0

 ; Move both numbers to the following registers
 mov edx, num1
 mov eax, num2
 cmp edx, 0			 ; Compares num1 with 0 and if it is equal it jumps to "xIgualCero" segment
 je xIgualCero
 cmp eax, 0			 ; Compares num2 with 0 and if it is equal it jumps to "yIgualCero" segment
 je yIgualCero
 jmp Formula		 ; Jumps to "Formula" segment if neither of both numbers are equal to 0

 ; This segment does jumps to predefined results
 xIgualCero:
 cmp eax, 0
 je ambosCero
 jg resultadoPI_2
 jl resultadoPI_2_Negativo

 ; This segment does jumps to predefined results
 yIgualCero:
 cmp edx, 0
 jg resultado_0
 jl resultadoPI

 ; This segment does jumps to predefined results
 ambosCero:
 mov edx, OFFSET indefinidoStr
 call writestring
 INVOKE ExitProcess, 0

 ; Shows predefined results to the user
 resultado_0:
 mov edx, OFFSET resultadoStr
 call writeString
 mov eax, 0
 call writeint
 mov edx, OFFSET espacioStr
 call writeString
 mov edx, OFFSET octanteStr
 mov eax, 0
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 ; Shows predefined results to the user
 resultadoPI:
 mov edx, OFFSET resultadoStr
 call writeString
 mov eax, PIQ15
 call writeint
 mov edx, OFFSET espacioStr
 call writeString
 mov edx, OFFSET octanteStr
 mov eax, 0
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 ; Shows predefined results to the user
 resultadoPI_2:
 mov edx, OFFSET resultadoStr
 call writeString
 mov eax, PI_2_Q15
 call writeint
 mov edx, OFFSET espacioStr
 call writeString
 mov edx, OFFSET octanteStr
 mov eax, 0
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 ; Shows predefined results to the user
 resultadoPI_2_Negativo:
 mov edx, OFFSET resultadoStr
 call writeString
 mov eax, PI_2_Q15
 neg eax
 call writeint
 mov edx, OFFSET espacioStr
 call writeString
 mov edx, OFFSET octanteStr
 mov eax, 0
 call writestring
 call writeint
 INVOKE ExitProcess, 0
 
 ; This segment solves the arctan using the fixed point solution
 Formula:
 INVOKE ac_atan2, num1, num2 
 mov resultado, eax				 ; Stores the final result in the "resultado" variable

 ; Compares num1 with 0 and jumps if the number is negative
 cmp num1, 0
 jl numNegativo1

 L1:
 ; Compares num2 with 0 and jumps if the number is negative
 cmp num2, 0
 jl numNegativo2
 
 jmp octantes					 ; When finished jumps to the "octantes" segment

 ; This segment switch the number from negative to positive and stores a 1 in the "negativo1" variable
 numNegativo1:
 neg num1
 mov negativo1, 1
 mov eax, 0
 mov eax, num1
 jmp L1

 ; This segment switch the number from negative to positive and stores a 1 in the "negativo2" variable
 numNegativo2:
 neg num2
 mov negativo2, 1
 mov eax, 0
 mov eax, num2
 jmp octantes

 ; This segments determine the octant in which the angle is located
 octantes:
 mov edx, 0
 mov eax, 0
 mov edx, num1
 mov eax, num2
 cmp edx, eax					 ; Compares both numbers
 jg xMayor						 ; Jumps if num1 is greater than num2
 jmp yMayor						 ; Jumps if num2 is greater than num1

 ; This segment determines if the angle is in the octants: 1, 4, 5 or 8
 xMayor:
 cmp negativo1, 0
 je octante8_o_1
 jmp octante5_o_4

 octante8_o_1:
 ; Writes the result on the terminal
 mov edx, OFFSET resultadoStr
 call writeString
 mov eax, resultado
 call writeint
 mov edx, OFFSET espacioStr
 call writeString
 cmp negativo2, 0
 je octante1
 jmp octante8

 octante5_o_4:
 cmp negativo2, 0
 je octante4
 jmp octante5

 octante1:
 ; Writes octant on terminal
 mov edx, OFFSET octanteStr
 mov eax, 1
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 octante4:
 ; Writes the result and the octant on the terminal
 mov edx, OFFSET resultadoStr
 call writeString
 mov eax, PIQ15
 add eax, resultado
 call writeint
 mov edx, OFFSET espacioStr
 call writeString
 mov edx, OFFSET octanteStr
 mov eax, 4
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 octante5:
 ; Writes the result and the octant on the terminal
 mov edx, OFFSET resultadoStr
 call writeString
 mov eax, PIQ15
 neg eax
 add eax, resultado
 call writeint
 mov edx, OFFSET espacioStr
 call writeString
 mov edx, OFFSET octanteStr
 mov eax, 5
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 octante8:
 ; Writes octant on terminal
 mov edx, OFFSET octanteStr
 mov eax, 8
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 ; This segment determines if the angle is in the octants: 2, 3, 6 or 7
 yMayor:
 cmp negativo2, 0
 je octante3_o_2
 jmp octante6_o_7
 
 octante3_o_2:
 ; Writes the result on the terminal
 mov edx, OFFSET resultadoStr
 call writeString
 mov eax, PI_2_Q15
 sub eax, resultado
 call writeint
 mov edx, OFFSET espacioStr
 call writeString
 cmp negativo1, 0
 je octante2
 jmp octante3

 octante2:
 ; Writes octant on terminal
 mov edx, OFFSET octanteStr
 mov eax, 2
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 octante3:
 ; Writes octant on terminal
 mov edx, OFFSET octanteStr
 mov eax, 3
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 octante6_o_7:
 ; Writes the result on the terminal
 mov edx, OFFSET resultadoStr
 call writeString
 mov eax, PI_2_Q15
 neg eax
 sub eax, resultado
 call writeint
 mov edx, OFFSET espacioStr
 call writeString
 cmp negativo1, 0
 je octante7
 jmp octante6

 octante7:
 ; Writes octant on terminal
 mov edx, OFFSET octanteStr
 mov eax, 7
 call writestring
 call writeint
 INVOKE ExitProcess, 0

 octante6:
 ; Writes octant on terminal
 mov edx, OFFSET octanteStr
 mov eax, 6
 call writestring
 call writeint
 INVOKE ExitProcess, 0

main ENDP


END main
