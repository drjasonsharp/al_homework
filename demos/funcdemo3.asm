;; 
;; funcdemo3.asm
;;
;; Demonstrates writing a function to mimic the following code:
;;
;; long calc(long a, long b, long c, long d, long e, long f, long g, long h) 
;; {
;;    return (a+b*c+d) - (e+f*g+h);
;; }
;;
;; We demonstrate stack-based and register-based calling conventions.
;;
;; by Terry Sergeant
;; Fall 2014
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
enternum:		db	"Enter X: ",0
sumis:		db	"Sum is : ",0
endl		db	0AH,0


		section .text
		global 		main
main:
		
		;mov	byte [enternum+6],'A'
		;put_str	enternum
		;get_i	edi
		;mov	byte [enternum+6],'B'
		;put_str	enternum
		;get_i	esi
		;mov	byte [enternum+6],'C'
		;put_str	enternum
		;get_i	edx
		;mov	byte [enternum+6],'D'
		;put_str	enternum
		;get_i	ecx
		;mov	byte [enternum+6],'E'
		;put_str	enternum
		;get_i	r8d
		;mov	byte [enternum+6],'F'
		;put_str	enternum
		;get_i	r9d
		;mov	byte [enternum+6],'G'
		;put_str	enternum
		;get_i	r10d
		;mov	byte [enternum+6],'H'
		;put_str	enternum
		;get_i	r11d

		mov	rdi,1
		mov	rsi,2
		mov	rdx,3
		mov	rcx,4
		mov	r8,5
		mov	r9,6
		mov	r12,7
		mov	r13,8



		; stack-based parameters
		push	r13
		push	r12
		push	r9
		push	r8
		push	rcx
		push	rdx
		push	rsi
		push	rdi
		call	calc
		add	rsp,64

		put_str	sumis	; print "sum is: ",RAX
		put_i	eax
		put_str	endl


		; register-based parameters
		xor	rax,rax	
		push	r12	; calc2 destroys r12, so we save it

		push	r13	; 7th and 8th args go on stack
		push	r12
		call	calc2
		add	rsp,16

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


	; long calc(long a, long b, long c, long d, long e, long f, long g, long h) 
	;    return (a+b*c+d) - (e+f*g+h);
	; we destroy R12 and put answer in RAX
calc2:
		mov	rax,rsi		; rax= b
		imul	rax,rdx		; rax= b*c
		add	rax,rdi		; rax= a+b*c
		add	rax,rcx		; rax= a+b*c+d
		mov	r12,r9		; r12= f
		imul	r12,[rsp+8]	; r12= f*g
		add	r12,r8		; r12= e+f*g
		add	r12,[rsp+16]	; r12= e+f*g+h
		sub	rax,r12		; rax= rax-r12
		ret

