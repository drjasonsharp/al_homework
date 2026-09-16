;;
;; simple_if_start.asm
;;
;; Provides an example of a simple if
;;
;; @author  INSERT YOUR NAME HERE
;; @version Fall 2026
;;
%include "iomacros.asm" ; functions for i/0
;%include "dumpregs.asm" ; functions for diplaying register values

		global 		main

		section .data
endl:		db	10,0
msg1:       db  "Value of x: ",0
msg2:       db  "Value of y: ",0
x:          dd  5

		section .bss ; uninitialized variables
y:	    resd	1    ; reserve a doubleword 32-bits/4-bytes

        section .text

main:
		; If your iomacros.asm macros use printf or scanf,
		; then under the System V AMD64 ABI the stack must be
		; 16-byte aligned before every C library call.

        push rbp
        mov rbp, rsp
        sub rsp, 16

        ;; idea #1 (put answer into eax then move to [y])

        ; INSERT CODE FROM IDEA #1 IN SLIDES - jlt should be jl

        ; call put_str function to create new line
        put_str endl

         ; call put_str to display message
        put_str msg1

        ; call put_i for 32-bit register or memory value
        put_i   [x]; put_i eax

        ; call put_str function to create new line
        put_str endl	     

        ; call put_str to display message
        put_str msg2

        ; call put_i for 32-bit register or memory value
        put_i [y] ; put_i eax

        ; call put_str function to create new line
        put_str endl

        ;; idea #2 (factor out mov [y], eax)

        ; INSERT CODE FROM IDEA #2 IN SLIDES - jlt should be jl

       ; call put_str function to create new line
;        put_str endl

         ; call put_str to display message
;        put_str msg1

        ; call put_i for 32-bit register or memory value
;        put_i   [x]; put_i eax

        ; call put_str function to create new line
;        put_str endl	     

        ; call put_str to display message
;        put_str msg2

        ; call put_i for 32-bit register or memory value
;        put_i [y] ; put_i eax

        ; call put_str function to create new line
;        put_str endl

        ;; idea #3 (branch to else instead of to if)

        ; INSERT CODE FROM IDEA #3 IN SLIDES

       ; call put_str function to create new line
;        put_str endl

         ; call put_str to display message
;        put_str msg1

        ; call put_i for 32-bit register or memory value
;        put_i   [x]; put_i eax

        ; call put_str function to create new line
;        put_str endl	     

        ; call put_str to display message
;        put_str msg2

        ; call put_i for 32-bit register or memory value
;        put_i [y] ; put_i eax

        ; call put_str function to create new line
;        put_str endl


        ; call dump_regs function to show values of 64-bit registers
		;dump_regs

		;needed for 16-bit alignment
		add rsp, 16
        pop rbp

        ; exit program
		mov     eax, 60                 ; system call 60 is exit
		xor     rdi, rdi                ; exit code 0
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits