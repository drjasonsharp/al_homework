;;
;; macrodemo.asm
;;
;; Here we demonstrate using some macros to simplify some I/O issues.
;; NOTE: This is the same as firstinput.asm except that we wrote a
;; print_str macro to simplify some code. Notice the well-behaved
;; convention of saving and restoring registers that may be destroyed by
;; the macro.
;;
;; by Terry Sergeant
;; Fall 2014
;;


;; put_str str
;;-------------
;; Writes a null-terminated character string, str, to stdout
;;
;; str must be a 64-bit address (label, reg, etc.)
;;-----------------------------------------------------------
%macro	put_str	1			; 1 here specifies we expect 1 argument
		push	rdi		; we are using rdi ... also,
		push	rax		; rax and rcx can be modified by printf
		push	rcx		; so we save them on the stack ...

		mov	rdi,%1		; %1 is the name of the first argument
		xor	rax,rax		; clear rax
		call	printf

		pop	rcx		; then we pop them off afterwards
		pop	rax		; (in reverse order)
		pop	rdi
%endmacro


		global main
		extern printf,fflush,scanf

		section .data

name_prompt:	db	"Enter name: ",0
age_prompt:	db	"Enter age : ",0
gpa_prompt:	db	"Enter gpa : ",0
char_prompt:	db	"Enter char: ",0
readint:	db	"%d",0
readstr:	db	"%s",0
readdouble:	db	"%lf",0		; lf means long float (i.e., double)
readchar:	db	" %c",0		; the space in front of %c means skip leading whitespace
answer_str:	db	"%s, for a %d year-old with a gpa of %4.3f, your char '%c' is an interesting choice!",10,0
; in our answer string %f and %lf works with doubles equally well


		section .bss

age:		resd	1
name:		resb	80
gpa:		resq	1
char:		resb	1


		section .text

main:

		put_str	name_prompt		; printf("Enter name: ");

		mov	rdi,readstr		; scanf("%s",name)
		mov	rsi,name
		xor	rax,rax
		call	scanf

		put_str	age_prompt		; printf("Enter age: ");

		mov	rdi,readint		; scanf("%d",&age)
		mov	rsi,age
		xor	rax,rax
		call	scanf

		put_str	gpa_prompt		; printf("Enter gpa: ");

		mov	rdi,readdouble		; scanf("%f",&gpa)
		mov	rsi,gpa
		xor	rax,rax
		call	scanf

		put_str	char_prompt		; printf("Enter char: ");

		mov	rdi,readchar		; scanf("%c",&char)
		mov	rsi,char
		xor	rax,rax
		call	scanf

		sub	rsp,8			; stack needs to be 16-byte aligned
		movq	xmm0, qword [gpa]	; prior to call (b/c of floating point)
		mov	rdi,answer_str		; printf("... for a %d year-old ...");
		mov	rsi,name
		mov	rdx,[age]
		mov	rcx,[char]
		mov	rax,1			; rax is 1 now b/c we have 1 floating point parameter
		call	printf
		add	rsp,8

		mov     eax, 60                 ; exit 0
		xor     rdi, rdi
		syscall

