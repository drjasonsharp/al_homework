;; 
;; funcdemo1.asm
;;
;; Demonstrates writing a function to mimic the following code:
;;
;; public static long sum(long a, long b)
;; {
;;    return a+b;
;; }
;;
;; by Terry Sergeant
;; Fall 2014
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
enternum:		db	"Enter number: ",0
sumis:		db	"Sum is : ",0
endmsg		db	"Goodbye.",10,0
endl		db	0AH,0


		section .text
		global 		main
main:
		put_str	enternum
		get_i	r8d
		put_str	enternum
		get_i	r9d

		;dump_regs
		;put_str	endl

		; rax= sum(r8,r9)
		push	r9
		push	r8
		call	sum
		add	rsp,16
		;dump_regs

		put_str	sumis
		put_i	eax
		put_str	endl

theend:		mov     eax, 60
		xor     rdi, rdi
		syscall

		; public static long sum(long a, long b)
sum:		
		push	rbp
		mov	rbp,rsp
		mov	rax,[rbp+16]
		add	rax,[rbp+24]
		pop	rbp
		ret
