;
; Demonstrates calling a C function:
;
; long mycalc(long a, long b, long c, long d, long e, long f, long g, long h)
; {
;    return (a+b*c+d) - (e+f*g+h);
; }
;
; nasm -f elf64 demo_mycalc.asm
; gcc -c mycalc.c
; gcc demo_mycalc.o mycalc.o
; ./a.out

%include "iomacros.asm"
%include "dumpregs.asm"

		extern mycalc	; mycalc is defined externally

		section .data
enternum:		db	"Enter X: ",0
sumis:		db	"Sum is : ",0
endl		db	10,0


		section .text
		global 		main
main:

		; we'll use 1,2,3,4,5,6,7,8 for a,b,c,d,e,f,g,h
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
