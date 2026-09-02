;
; callc.asm
;
; Demonstrate calling a C-language function.
;
; @author  Terry Sergeant
; @version Fall 2016
;
; To complile this code:
;   gcc -c display.c               # produces display.o
;   nasm -f elf64 callc.asm        # produces callc.o
;   gcc callc.o display.o          # produces a.out

%include "iomacros.asm"

		extern displayNums	; tells nasm that displayNums is defined externally

		section .data
ints:		dd	68,-9,23,45,67,78,32,31,525,123 ; an array of 10 ints
n:		dd	10	; number of ints in the array


section .text
		global 		main
main:
		align_stack

		mov	rdi,ints	; rdi= param 1 which is address of array
		xor	rsi,rsi		; rsi= second params which is num of array elems
		mov	esi,[n]
		call	displayNums	; call externally defined displayNums


alldone: 	mov	ebx,0		; return 0
		mov	eax,1		; on
		int	80h		; exit