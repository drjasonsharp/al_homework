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
;   gcc -no-pie callc.o display.o  # produces a.out
;	./a.out						   # run a.out

%include "iomacros.asm"
%include "dumpregs.asm"

		extern displayNums	; tells nasm that displayNums is defined externally
		extern findSuccPos  ; tells nasm that findSuccPos is defined externally
		section .data
ints:	dd	68,-9,23,45,67,78,32,31,525,123 ; an array of 10 ints
n:		dd	10	; number of ints in the array
endl:	db	10,0	

section .text
		global 		main
main:
	align_stack

		; put -1 into RAX, RBX, RCX, RDX, RSI, RDI,
		; 8, R9, R10, R11, R12, R13, R14, and R15

		; INSERT CODE HERE
		mov RAX,-1 ; for example

	; call dump_regs
	; INSERT CODE HERE	

		mov	rdi,ints	; rdi= param 1 which is address of array
		xor	rsi,rsi		; rsi= second params which is num of array elems
		mov	esi,[n]
		call displayNums; call externally defined displayNums

	; call dump_regs
	; INSERT CODE HERE

		; move the parameters to pass to findSuccPos
		; INSERT CODE HERE

		; call findSuccPos
		; INSERT CODE HERE
		
		; display eax
		; INSERT CODE HERE
		
		put_str endl

alldone:
	 	mov	ebx,0		; return 0
		mov	eax,1		; on
		int	80h			; exit

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits