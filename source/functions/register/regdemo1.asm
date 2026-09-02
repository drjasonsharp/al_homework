;
; Demonstrates writing a function to mimic the following code:
;
; public static long sum(long a, long b)
; {
;    return a+b;
; }
;
; We demonstrate register-based parameters.
;
;
%include "../../iomacros.asm"
%include "../../dumpregs.asm"

		section .data
enternum:		db	"Enter number: ",0
sumis:		db	"Sum is : ",0
endl		db	10,0
fun:		dq	21312312334


		section .text
		global 		main
main:
		xor	rdi,rdi
		xor	rsi,rsi
		put_str	enternum
		get_i	edi
		put_str	enternum
		get_i	esi

		; The values entered by the user were put in rdi and rsi
		; in anticipation of those values being passed as parameters
		; so all we have to do is call the function.
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
		; Here we demonstrate saving parameters in registers
		; according the the Linux calling convention in which
		; the first six parameters go in: RDI, RSI, RDX, RCX,
		; R8, and R9, respectively. Floating point arguments
		; go in XMM0, XMM1, etc. If more parameters are needed
		; they are placed on the stack.

sum2:		mov	rax,rdi
		add	rax,rsi
		ret
