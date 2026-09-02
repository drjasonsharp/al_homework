;
; Demonstrates writing a function to mimic the following code:
;
; public static long sum(long a, long b)
; {
;    return a+b;
; }
;
; We demonstrate stack-based parameters.
;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
enternum:		db	"Enter number: ",0
sumis:		db	"Sum is : ",0
endl		db	10,0


		section .text
		global 		main
main:
		xor	rdi,rdi
		xor	rsi,rsi
		put_str	enternum
		get_i	edi
		put_str	enternum
		get_i	esi

		; rax= sum(rdi,rsi)
		push	rsi	; parameters go on stack
		push	rdi
		call	sum
		add	rsp,16	; restore stack pointer

		; print "sum is: ",EAX
		put_str	sumis
		put_i	eax
		put_str	endl

theend:		mov     eax, 60
		xor     rdi, rdi
		syscall


		; public static long sum(long a, long b)
		;
		; Here we demonstrate saving parameters on the stack and
		; using the base pointer, RBP, to save location of the
		; parameters so the offsets will be the same regardless
		; of what we do with the stack inside the function
sum:
		push	rbp
		mov	rbp,rsp

		; here we push/save any registers that we will be using
		; in this case we are only using RAX, which is where we
		; store the value to be returned, so no need to save anything
		; BUT, even if we had to save a lot of regs on the stack,
		; our parameters would always start at [rbp+16].

		mov	rax,[rbp+16]
		add	rax,[rbp+24]

		; pop registers we saved above (none in this case)

		pop	rbp
		ret
