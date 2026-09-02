;; 
;; firstinput.asm
;;
;; Here we demonstrate using scanf and printf with various data types.
;;
;; by Terry Sergeant
;; Fall 2014
;;
;; NOTE: The data types we demonstrate are: int, double, string, and char. Each 
;; 	type has its own idiosyncrasies (which is why each is demonstrated).
;;
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
		
		mov	rdi,name_prompt		; printf("Enter name: ");
		xor	rax,rax
		call	printf

		mov	rdi,readstr		; scanf("%s",name)
		mov	rsi,name
		xor	rax,rax
		call	scanf

		mov	rdi,age_prompt		; printf("Enter age: ");
		xor	rax,rax
		call	printf

		mov	rdi,readint		; scanf("%d",&age)
		mov	rsi,age			
		xor	rax,rax
		call	scanf

		mov	rdi,gpa_prompt		; printf("Enter gpa: ");
		xor	rax,rax
		call	printf

		mov	rdi,readdouble		; scanf("%f",&gpa)
		mov	rsi,gpa
		xor	rax,rax
		call	scanf

		mov	rdi,char_prompt		; printf("Enter char: ");
		xor	rax,rax
		call	printf

		mov	rdi,readchar		; scanf("%c",&char)
		mov	rsi,char
		xor	rax,rax
		call	scanf

		sub	rsp,8			; stack needs to be 16-byte aligned
		movq	xmm0, qword [gpa]	; prior to call
		mov	rdi,answer_str		; printf("... for a %d year-old ...");
		mov	rsi,name
		mov	rdx,[age]
		mov	rcx,[char]
		mov	rax,1
		call	printf
		add	rsp,8

		mov     eax, 60                 ; exit 0
		xor     rdi, rdi
		syscall

