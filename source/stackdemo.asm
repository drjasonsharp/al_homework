;
; stackdemo.asm
;
; Playing around with the stack.
;
; by T.Sergeant
;

%include "iomacros.asm"
%include "dumpregs.asm"

		global main
		section .data

format_str:	db	"Here is your number: ",0
myint:		dd	123
endl:		db	10,0
funint:		dq	-1
otherint:	dq	0

		section	.bss
fun:		resq	1

		section .text

main:
		; study this code and then run it paying close attention
		; to r8, r9, and rsp
		mov	r8,-1
		dump_regs
		put_str	endl

		push	qword [funint]
		pop	qword [otherint]

		put_i	[otherint]
		put_str	endl
		;mov	r10,rsp
		;put_i	[r10]
		;put_str	endl
		;push	r8
		;dump_regs
		;put_str	endl
		;pop	r9
		;dump_regs
		;put_str	endl
		;mov	r9,[rsp]
		;dump_regs
		;put_i	r8d
		;put_str	endl


		mov     eax, 60                 ; system call 60 is exit
		xor     rdi, rdi                ; exit code 0
		syscall
