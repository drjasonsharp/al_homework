;
; Demonstrates writing a function to mimic the following code:
;
; long nfact(long n)
; {
;    if (n == 0)
;      return 1;
;    else
;      return n * nfact(n-1);
; }
;
; We demonstrate stack-based calling conventions.
;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
enternum:		db	"Enter number: ",0
nfactis:		db	"Factorial is: ",0
endl		db	10,0


		section .text
		global 		main
main:

		put_str	enternum
		get_i	edi

		; stack-based parameters
		push	rdi
		call	nfact
		add	rsp,8

		put_str	nfactis	; print "nfactorial is: ",RAX
		put_i	eax
		put_str	endl

theend:		mov     eax, 60
		xor     rdi, rdi
		syscall


; long nfact(long n)
; {
;    if (n == 0)
;      return 1;
;    else
;      return n * nfact(n-1);
; }
nfact:
		push	rbp
		mov	rbp,rsp
		push	r8

		mov	r8,[rbp+16]	; r8= n
		cmp	r8,0
		je	basecondition

		dec	r8
		push	r8		; push n-1
		call	nfact
		add	rsp,8
		imul	rax,[rbp+16]	; ans= n*nfact(n-1)
		jmp	endnfact

basecondition:
		mov	rax,1

endnfact:
		pop	r8
		pop	rbp
		ret
