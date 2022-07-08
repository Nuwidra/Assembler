INCLUDE Irvine32.inc ; include irvine library, needed for the program to work
;INCLUDE uint8_mult.inc

; Program description: This algorithm does a two-digit multiplication using logical left shifts
; Authors:
; Alejandro José Loaisa Alvarado
; Jonathan Quesada Salas
; Valeria Calderon Charpentier
; Last day of modification 11/12/20 at 11:47 pm

.386
.model flat,stdcall
.stack 4096


ExitProcess PROTO, dwExitCode:DWORD

; Messages used to interact with the user
.data
menu BYTE "----------------- Multiplicacion a base de corrimientos logicos -------------------",0
msg0 BYTE "Digite el multiplicando: ",0 
msg1 BYTE "Digite el multiplicador: ",0
msg2 BYTE "Numero invalido",0
msg3 BYTE "El resultado es 0",0
msg4 BYTE "Resultado: ",0

; Variables where the numbers are going to be stored
num1 BYTE ?
num2 BYTE ?


.code

main PROC
;Initialize eax register
mov eax,0

;Print title in console
mov edx, OFFSET menu
call writeString
call readDec

; Ask the user por one number
mov edx, OFFSET msg0
call writeString
call readDec
mov num1, al

; Compare number with 0
cmp eax, 0
; Jumps to segment if the number is below 0
jnge numeroInvalido
; Compare number with 255
cmp eax, 255
; Jumps to segment if the number is above 255
jg numeroInvalido
; Final jump, it indicates that is a valid 8-bit number
jle valido    


numeroInvalido:    
	; Prints a message indicating that the number given is invalid
	mov edx, OFFSET msg2
	call writeString
	INVOKE ExitProcess,0

valido:
	; Initialize register
	mov eax,0
	
	; Asks for second number
	mov edx, OFFSET msg1
	call writeString
	call ReadDec 
	mov num2, al

	; Compare number with 0
	cmp eax, 0
	; Jumps to segment if the number is below 0
	jnge numeroInvalido
	; Compare number with 255
	cmp eax, 255
	; Jumps to segment if the number is above 255
	jg numeroInvalido
	; Final jump, it indicates that is a valid 8-bit number and start with the algorithm
	jle algoritmo

	
	algoritmo:
	 ;Initialize registers
	 mov eax,0
	 mov ebx,0
	 mov ecx, 0
	 mov edx, 0

	 ; Move numbers to the defined 8-bit registers
	 mov al, num1
	 mov bl, num2
	 ; Move the number 8 to cl register, this will count how many times the loop is going to be executed
	 mov cl, 8

	; This first cicle does the right shifts to the number and compares it with the mask
	; If the least significant value is equal to 1 it will jump to the sum segment
	; If the least significant value is equal to 0 it will continue doing shifts until it is equal to 1 or cl = 0
	cicle1:
	 mov ah, 1
	 and ah, al
	 jnz sum
	 ror al, 1
	 shl bx, 1
	 loop cicle1

	 ; Jump to printResult segment
	 jmp printResult 

	 ; adds the shifted number value to the dx register which stores the result
	 sum:
	 add dx, bx
	 ror al, 1
	 shl bx, 1
	 loop cicle1

	 ; Prints the final result
	 printResult:
	 mov eax, 0
	 mov ax,dx
	 mov edx, OFFSET msg4
	 call writeString
	 call writeDec
		
; Finish process
 INVOKE ExitProcess,0

main ENDP



END main