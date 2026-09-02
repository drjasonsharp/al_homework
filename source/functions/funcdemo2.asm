;;
;; funcdemo2.asm
;;
;; Demonstrates writing a function to mimic the following code:
;;
;; public static long sum(long a, long b)
;; {
;;    return a+b;
;; }
;;
;; We demonstrate stack-based parameters and register-based parameters.
;;
;; by Terry Sergeant
;; For AL
;;
%include "../iomacros.asm"
%include "../dumpregs.asm"

		section .data
enternum:		db	"Enter number: ",0
sumis:		db	"Sum is : ",0
endl		db	0AH,0


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


		; Clear RAX so we know this actually works.
		; The values entered by the user were put in rdi and rsi
		; in anticipation of those values being passed as parameters
		; so all we have to do is call the function.
		xor	rax,rax
		call	sum2

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

		mov	rax,[rbp+16]
		add	rax,[rbp+24]

		; pop registers we saved above (none in this case)

		pop	rbp
		ret

		; public static long sum(long a, long b)
		;
		; Here we demonstrate saving parameters in registers
		; according the the Linux calling convention in which
		; the first six parameters go in: RDI, RSI, RDX, RCX,
		; R8, and R9, respectively. Floating point arguments
		; go in XMM0, XMM1, etc. If more parameters are needed
		; they are placed on the stack.

sum2:		mov	rax,rdi
		add	rax,rsi
		ret
