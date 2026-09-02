;
; Demonstrates writing a function to mimic the following code:
;
; long calc(long a, long b, long c, long d, long e, long f, long g, long h)
; {
;    return (a+b*c+d) - (e+f*g+h);
; }
;
; We demonstrate stack-based calling conventions.
;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
enternum:		db	"Enter X: ",0
sumis:		db	"Sum is : ",0
endl		db	10,0


		section .text
		global 		main
main:
		; stack-based parameters
		push	qword 8
		push	qword 7
		push	qword 6
		push	qword 5
		push	qword 4
		push	qword 3
		push	qword 2
		push	qword 1
		call	calc
		add	rsp,64

		put_str	sumis	; print "sum is: ",RAX
		put_i	eax
		put_str	endl

theend:		mov     eax, 60
		xor     rdi, rdi
		syscall


	; long calc(long a, long b, long c, long d, long e, long f, long g, long h)
	;    return (a+b*c+d) - (e+f*g+h);
	; we destroy R12 and put answer in RAX
calc:
		push	rbp
		mov	rbp,rsp
		push	r12		; we use r12 for temp value

		mov	rax,[rbp+24]	; rax= b
		imul	rax,[rbp+32]	; rax= b*c
		add	rax,[rbp+16]	; rax= a+b*c
		add	rax,[rbp+40]	; rax= a+b*c+d
		mov	r12,[rbp+56]	; r12= f
		imul	r12,[rbp+64]	; r12= f*g
		add	r12,[rbp+48]	; r12= e+f*g
		add	r12,[rbp+72]	; r12= e+f*g+h
		sub	rax,r12		; rax= rax-r12

		pop	r12		; restore r12
		pop	rbp		; restore rbp
		ret
