
INCLUDE Irvine32.inc

; Descripcion del Programa:
; Autor:
; Dia:

.386
.model flat,stdcall
.stack 4096

ExitProcess PROTO, dwExitCode:DWORD

.data

msg0 BYTE "Digite el multiplicando: ",0 
msg1 BYTE "Digite el multiplicador: ",0
msg2 BYTE "Numero invalido",0
msg3 BYTE "Resultado: ",0

num1 BYTE ?
num2 BYTE ?

mascara byte 1


.code

main PROC

mov eax,0

mov edx, OFFSET msg0
call writeString
call readDec
mov num1, al


cmp eax, 0
jnge numeroInvalido
cmp eax, 255
jg numeroInvalido   
jle valido    


numeroInvalido:    
	mov edx, OFFSET msg2
	call writeString
	INVOKE ExitProcess,0

valido:
	mov eax,0
	
	
	mov edx, OFFSET msg1
	call writeString
	call ReadDec 
	mov num2, al

	cmp eax, 0  
	jnge numeroInvalido
	cmp eax, 255
	jg numeroInvalido    

	algoritmo:
		mov eax, 0
		mov ebx, 0
		mov ecx, 0
		mov edx, 0
		mov al, num1
		mov bl, num2
		mov cl, 8

		cicle1:
		mov mascara, 1
		and mascara, al
		jnz sum
		ror al, 1
		shl bx, 1
		loop cicle1

		mov eax, edx
		mov edx, OFFSET msg3
		call writestring
		call writedec

		INVOKE ExitProcess,0

		sum:
		add dx, bx
		ror al, 1
		shl bx, 1
		loop cicle1

		mov eax, edx
		mov edx, OFFSET msg3
		call writestring
		call writedec

		INVOKE ExitProcess,0
		

 INVOKE ExitProcess,0

main ENDP



END main