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
;; For AL
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
enternum:	db	"Enter X: ",0
sumis:		db	"Sum is : ",0
endl		db	0AH,0


		section .text
		global 		main
main:
	align_stack

		; register-based parameters
		xor	rax,rax
		mov	rdi,1
		mov	rsi,2
		mov	rdx,3
		mov	rcx,4
		mov	r8,5
		mov	r9,6
		push qword 8
		push qword 7
		call calc2
		add rsp,16

		put_str	sumis	; print "sum is: ",RAX
		put_i	eax
		put_str	endl

theend:	mov     eax, 60
		xor     rdi, rdi
		syscall

	; long calc(long a, long b, long c, long d, long e, long f, long g, long h)
	;    return (a+b*c+d) - (e+f*g+h);
	; we destroy R12 and put answer in RAX
calc2:
		mov		rax,rsi			; rax= b
		imul	rax,rdx			; rax= b*c
		add		rax,rdi			; rax= a+b*c
		add		rax,rcx			; rax= a+b*c+d
		mov		r12,r9			; r12= f
		imul	r12,[rsp+8]		; r12= f*g
		add		r12,r8			; r12= e+f*g
		add		r12,[rsp+16]	; r12= e+f*g+h
		sub		rax,r12			; rax= rax-r12
		ret

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits