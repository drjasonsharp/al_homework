;; 
;; stringcompare.asm
;;
;; Demonstrates a string compare macro.
;;
;; by Terry Sergeant
;; Fall 2014
;;
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		global main

		section .data

prompt_a:	db	"Enter value for string A: ",0
prompt_b:	db	"Enter value for string B: ",0

equal_msg:	db	" is equal to ",0
less_msg:	db	" is less than ",0
greater_msg:	db	" is greather than ",0

endl		db	10,0


		section .bss

A:		resb	120
B:		resb	120


		section .text


main:
		mov	rax,9		; syscall mmap
		xor	rdi,rdi		; addr = NULL
		mov	rsi,36		; # of bytes to reserve
		mov	rdx,3		; PROT_READ|PROT_WRITE
		mov	r10,0x22	; MAP_PRIVATE|MAP_ANONYMOUS
		mov	r8,-1		; fd=-1
		xor	r9,r9		; offset=0
		syscall
		;neg	rax
		dump_regs


		;mov	rdi,rax
		;mov	dword [rdi],100;
		;put_i	[rdi]
		;put_str	endl
		;dump_regs


		mov     eax, 60                 ; exit 0
		xor     rdi, rdi
		syscall

