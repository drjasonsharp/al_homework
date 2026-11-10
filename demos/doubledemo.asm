;; 
;; doubledemo.asm
;;
;; Here we demonstrate the following calculations:
;;
;; int a;
;; double x,ans;
;; float y;
;;
;; ans= (2*y+x)-(a*3.1);
;;
;; by Terry Sergeant
;; Fall 2014
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		global main

		section .data

ans_str:		db	"Answer: ",0
endl:			db	10,0
a:				dd	10
x:				dq	5.0
y:				dd	3.0
threepointone:	dq	3.1

		section .bss

ans:			resq 1

		section .text

main:
	align_stack

		mov	rbx,2
		cvtsi2sd xmm0,rbx			 ; xmm0=2
		cvtss2sd xmm1,[y]			 ; xmm1=y
		mulsd	 xmm0,xmm1			 ; xmm0= 2*y
		addsd	 xmm0,[x]			 ; xmm0= 2*y+x

		cvtsi2sd xmm1,[a]			 ; xmm1= a
		mulsd	 xmm1,[threepointone]; xmm1= a*3.1

		subsd	 xmm0,xmm1			 ; xmm0= (2*y+x) - (a*3.1)

		cvtsd2si ebx,xmm0
		movsd	[ans],xmm0
		put_str	ans_str
		put_dbl	[ans]
		put_str endl
		put_str ans_str
		put_i	ebx
		put_str	endl

		; exit(0)
theend:	
		mov     eax, 60
		xor     rdi, rdi
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits
