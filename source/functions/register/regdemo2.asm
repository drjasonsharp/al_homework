;
; Demonstrates writing a function to mimic the following code:
;
; long calc(long a, long b, long c, long d, long e, long f, long g, long h)
; {
;    return (a+b*c+d) - (e+f*g+h);
; }
;
; We demonstrate register-based calling conventions.
;

%include "../../iomacros.asm"
%include "../../dumpregs.asm"
		section .data
enternum:		db	"Enter X: ",0
sumis:		db	"Sum is : ",0
endl		db	10,0


		section .text
		global 		main
main:

		push	r12	; calc2 destroys r12, so we save it
				; which would be necessary if we had
				; something we liked in r12 ... this
				; is an example of caller-saved
				; registers

		; we'll use 1,2,3,4,5,6,7,8 for a,b,c,d,e,f,g,h
		mov	rdi,1	; conventions say to use these
		mov	rsi,2	; six registers in this order
		mov	rdx,3
		mov	rcx,4
		mov	r8,5
		mov	r9,6

		push	qword 8	; the 7th and 8th parameters go on the
		push	qword 7 ; stack (why reverse order?)

		call	calc2	; call the function

		add	rsp,16	; why add rsp and not pop twice?


		pop	r12	; restore r12

		put_str	sumis	; print "sum is: ",RAX
		put_i	eax
		put_str	endl



theend:		mov     eax, 60
		xor     rdi, rdi
		syscall



	; long calc(long a, long b, long c, long d, long e, long f, long g, long h)
	;    return (a+b*c+d) - (e+f*g+h);
	; we destroy R12 and put answer in RAX
calc2:
		mov	rax,rsi		; rax= b
		imul	rax,rdx		; rax= b*c
		add	rax,rdi		; rax= a+b*c
		add	rax,rcx		; rax= a+b*c+d
		mov	r12,r9		; r12= f
		imul	r12,[rsp+8]	; r12= f*g	(why rsp+8 ???)
		add	r12,r8		; r12= e+f*g
		add	r12,[rsp+16]	; r12= e+f*g+h
		sub	rax,r12		; rax= rax-r12
		ret
