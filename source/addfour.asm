;;
;; Starter code for writing a function that accepts four 64-bit integers
;; as parameters and returning their sum.
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		section	.data
answer_is:	db	"Answer is: ",0
endl:		db	10,0

		section	.bss
answer:		resq	1


		section	.text
		global	main
main:
		align_stack

		; put parameters on stack to call addfour(1,2,3,4)

		call	addfour

		; restore the stack pointer

		mov	[answer],rax	; save answer
		put_str	answer_is	; and print it
		put_i	eax
		put_str	endl


theend:		mov     eax, 60
		xor     rdi, rdi
		syscall


;
; Given four 64-bit integers as parameters calculate and return their sum.
;
; function addfour(long a, long b, long c, long d)
;   return a+b+c+d;
;
addfour:
		xor	rax,rax
		ret