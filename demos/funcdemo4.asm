;; 
;; funcdemo3.asm
;;
;; Demonstrates writing a function to mimic the following code:
;;
;; long nfact(long n)
;; {
;;    if (n == 0)
;;      return 1;
;;    else
;;      return n * nfact(n-1);
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
enternum:		db	"Enter number: ",0
nfactis:		db	"Factorial is: ",0
endl		db	0AH,0


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

		; register-based parameters
		xor	rax,rax
		call	nfact2	

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

		; eax= nfact(n-1)
		push	r8		; push n
		dec	qword [rsp]	; n--
		call	nfact
		add	rsp,8
		
		imul	rax,r8		; eax= nfact(n-1)*n
		jmp	endnfact

basecondition:
		mov	rax,1

endnfact:
		pop	r8
		pop	rbp
		ret


		; long nfact(long n)
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

