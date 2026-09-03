;; 
;; userinput-output.asm
;;
;; Demonstrates using C's printf and scanf functions to do I/O.
;;
;; by Jason Sharp
;; Fall 2026
;;
;; NOTE 1: C's scanf function requires an address of the destination
;;
;; NOTE 2: C's scanf treats a "%d" as a 32-bit signed integer, so we reserve
;;	4 bytes for it and we use 32-bit registers to handle it.
;;

		global main
		extern printf,fflush,scanf

		section .data

input_prompt:	db	"Enter an integer value: ",0
readint:		db	"%d",0
output_str:		db	"The integer value doubled is: %d",10,0

		section .bss

integervalue:		resd	1
integerdoubled:		resd	1

section .text

	main:		
				
		;under the System V AMD64 ABI (Linux x86-64), the stack
		;pointer (rsp) must be 16-byte aligned before calling
		;C library functions such as printf.
    	push rbp
    	mov rbp, rsp
		sub rsp, 8
	
		;commands to display prompt by calling printf
		mov	rdi,input_prompt		; printf("Enter an integer value: ");
		xor	rax,rax
		call	printf

		;see comment above in lines 33-35
		add rsp, 8

		;commands to read input by calling scanf
		mov	rdi,readint		 	; scanf("%d",&integervalue)
		mov	rsi,integervalue			
		xor	rax,rax
		call	scanf

		;commands to perform calculation
		mov	ecx,[integervalue]			; integerdoubled= integervalue * 2
		imul	ecx,2			; (which in C deals w/ 32-bit signed ints)
		mov	[integerdoubled],ecx

        mov	rdi,output_str		; printf("The integer value doubled is: %d",integerdoubled);
		mov	rsi,[integerdoubled]
		xor	rax,rax
		call	printf

		;commands to exit
		mov     eax, 60         ; exit 0
		xor     rdi, rdi
		syscall


section .note.GNU-stack noalloc noexec nowrite progbits