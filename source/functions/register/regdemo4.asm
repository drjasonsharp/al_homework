;
; regdemo4.asm
;
; Demonstrates writing a recursive function using the classic n-factorial problem.
;
; long nfact(long n)
; {
;    if (n == 0)
;      return 1;
;    else
;      return n * nfact(n-1);
; }
;
; We register-based calling conventions.
;

%include "../../iomacros.asm"
%include "../../dumpregs.asm"

		section .data
enternum:		db	"Enter number: ",0
nfactis:		db	"Factorial is: ",0
endl		db	10,0


		section .text
		global 		main
main:

		xor	rdi,rdi
		put_str	enternum
		get_i	edi


		call	nfact2

		put_str	nfactis	; print "nfactorial is: ",RAX
		put_i	eax
		put_str	endl

theend:		mov     eax, 60
		xor     rdi, rdi
		syscall



; long nfact2(long n)
; {
;    if (n == 0)
;      return 1;
;    else
;      return n * nfact(n-1);
; }

nfact2:
		cmp	rdi,0
		je	basecondition2

		push	rdi		; save n
		dec	rdi		; rdi= n-1
		call	nfact2		; rax= nfact2(n-1)
		pop	rdi		; rdi= n
		imul	rax,rdi		; rax= n*fact2(n-1)
		jmp	endnfact2

basecondition2:
		mov	rax,1

endnfact2:
		ret

