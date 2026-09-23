;;
;; addresses_vs_values_exercise.asm
;;
;; Provides a running example of the Address vs Values exercise.
;;
;; @author  Jason Sharp
;; @version Fall 2026
;;
%include "iomacros.asm" ; functions for i/0
;%include "dumpregs.asm" ; functions for diplaying register values

		global 		main

		section .data
endl:		        db	10,0
a:                  dd  5;00,11,22,33
b:                  db  44,55,66,77
aaddresslabel:      db  "a address: ",0
avaluelabel:        db  "a value: ",0
movraxa:            db  "mov rax, a",0
movraxa2:           db  "mov rax, [a]",0
movarax:            db  "move [a], rax",0
movarax2:           db  "mov a, rax",0
raxaddresslabel:    db  "rax address: ",0
raxvaluelabel:      db  "rax value: ",0  

		section .bss


        section .text

main:
		; If your iomacros.asm macros use printf or scanf,
		; then under the System V AMD64 ABI the stack must be
		; 16-byte aligned before every C library call.

        align_stack 

        ; display new line

        put_str endl

        ; call put_str function to display prompt

		put_str	aaddresslabel

        ; display a address

        put_i   a

        ; display new line

        put_str endl

        ; call put_str function to display prompt

		put_str	avaluelabel

        ; display a value

        put_i   [a]

        ; display new line

        put_str endl
        put_str endl

        put_str	raxaddresslabel

        ; display rax address

        put_i64   rax

        ; display new line

        put_str endl

        ; call put_str function to display prompt

		put_str	raxvaluelabel

        ; display rax value
        mov    rax, 0
        ; xor rax,rax
        put_i64 rax

        ; display new line

        put_str endl
        put_str endl

        ; move address of a into rax register 

        mov     rax, a

        ; call put_str function to display prompt

        put_str movraxa

        ; display new line

        put_str endl

		; call put_str function to display prompt

		put_str	raxaddresslabel

        ; display rax address

        put_i64   rax

        ; display new line

        put_str endl             

        ; call put_str to display message

        put_str raxvaluelabel

        ; display rax value

        put_i64 [rax]

        ; call put_str function to create new line

        put_str endl
        put_str endl

	    ; call put_str function to display prompt

		put_str	movraxa2

        ; move value of a into rax register

        mov rax, [a]

        ; call put_str function to create new line

        put_str endl 

        ; call put_str function to display prompt

        put_str raxaddresslabel

        ; display rax address

        put_i64 rax

        ; call put_str function to create new line

        put_str endl 

        put_str raxvaluelabel
        
        ;put_i [rax]

        ; call put_str function to create new line

        put_str endl 
        put_str endl

        ; call put_str function to display prompt

        put_str movarax

        ; move rax address into value of a

        mov [a], rax

       ; call put_str function to create new line

        put_str endl

        ; call put_str function to display prompt

        put_str aaddresslabel

        put_i a

        ; call put_str function to create new line

        put_str endl

        ; call put_str function to display prompt

        put_str avaluelabel

        ; display value of a

        put_i [a]

        ; call put_str function to create new line

        put_str endl 
        put_str endl

        ; call put_str function to display prompt

        ;put_str movarax2

        ; call put_str function to create new line

        put_str endl

        ; move rax into a

        ;mov a, rax

        ; display a

        ;put_i a

        ; call put_str function to create new line

        ;put_str endl

        ;call dump_regs function to show values of 64-bit registers
		;dump_regs

        ; exit program
		mov     eax, 60                 ; system call 60 is exit
		xor     rdi, rdi                ; exit code 0
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits