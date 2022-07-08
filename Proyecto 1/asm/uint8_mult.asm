TITLE Procedimiento uint8_mult (uint8_mult.asm)

; include irvine32
INCLUDE uint8_mult.inc 

.code
; process declaration and parameter definition
uint8_mult PROC,
num1:BYTE, 
num2:BYTE,
resultado:PTR DWORD

; Initialize registers
 mov eax,0
 mov ebx,0
 mov edx,0
 mov ecx,0
 ; move numbers to 8-bit registers
 mov bl, num1
 mov dl, num2
 ; move number 1 to ah, this will work as the mask
 mov ah, 1
 ; move 8 to cl, this will work as the loop counter
 mov cl, 8
 ; move "resultado" pointer to esi register
 mov esi,0
 mov esi, resultado

 ; In this segment the progra will do the shiftments to both numbers
 ; It will do the jump to "sum" segment if there is a 1 as the least significant value
 L1:
 ; initiliaze mask every time it runs "L1" segment
 mov ah, 1
 and ah, bl
 ; does the comparison and the jump depending of the result
 jnz sum
 ; does a shiftment to the right
 ror bl, 1
 ; does a shiftmento to the left
 shl dx, 1
 ; does a jump to "L1" and subtract 1 for cl register
 loop L1

 ; move the final result to the pointer
 mov [esi], ax
 ; return to the line where the PROC was invoked
 ret

 ; This segment adds to the 16-bit register ax the number stored in bx
 ; And continues doing the shiftments
 sum:
 ; add the number with the shiftments done to the left to the ax register
 add ax, dx
 ; does a shiftment to the right
 ror bl, 1
 ; does a shiftmento to the left
 shl dx, 1
 ; does a jump to "L1" and subtract 1 for cl register
 loop L1

 ; move the final result to the pointer
 mov [esi], ax
 ; return to the line where the PROC was invoked
 ret

 ; end of process
uint8_mult ENDP

END uint8_mult