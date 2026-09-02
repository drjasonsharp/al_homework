;
; Demonstrates calling a function in C.
;
; To compile/run:
;   nasm -f elf64 regdemo3.asm
;   gcc -c mycalc.c
;   gcc regdemo3.o mycalc.o
;   ./a.out
;

%include "../../iomacros.asm"
%include "../../dumpregs.asm"

		section .data
enternum:		db	"Enter X: ",0
sumis:		db	"Sum is : ",0
endl		db	10,0


		extern mycalc

		section .text
		global 		main
main:

		mov	rdi,1	; conventions say to use these
		mov	rsi,2	; six registers in this order
		mov	rdx,3
		mov	rcx,4
		mov	r8,5
		mov	r9,6

		push	qword 8	; the 7th and 8th parameters go on the
		push	qword 7 ; stack (why reverse order?)

		call	mycalc	; call the function

		add	rsp,16	; why add rsp and not pop twice?


		put_str	sumis	; print "sum is: ",RAX
		put_i	eax
		put_str	endl


theend:		mov     eax, 60
		xor     rdi, rdi
		syscall

