;;
;; simple_if.asm
;;
;; Provides an example of a simple if
;;
;; @author  Jason Sharp
;; @version Fall 2026
;;
%include "iomacros.asm" ; functions for i/0
;%include "dumpregs.asm" ; functions for diplaying register values

		global 		main

		section .data
endl:		db	10,0
;prompt1:	db	"Enter 32-bit integer: ",0
;prompt2:   db  "Enter 64-bit integer: ",0
msg1:       db  "Value of x: ",0
msg2:       db  "Value of y: ",0
x:          dd  5

		section .bss
y:	    resd	1

        section .text

main:
		; If your iomacros.asm macros use printf or scanf,
		; then under the System V AMD64 ABI the stack must be
		; 16-byte aligned before every C library call.

        push rbp
        mov rbp, rsp
        sub rsp, 16

        ;; idea #1 (put answer into eax then move to [y])
        cmp     dword [x],0
        jl      less
                mov eax,[x]
                mov [y],eax
                jmp endif ; unconditional jump, "exit" if

less:   xor     eax,eax ; clears out register, xor results in 0
        mov     [y],eax ; could have used dword[y],0

endif:
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

;        cmp     dword[x],0
;        jl      less
;                mov eax,[x]
;                jmp endif
;less:   xor     eax,eax
;endif:  mov     [y],eax

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

;        cmp     dword[x],0
;        jge     else
;                xor eax,eax
;                jmp endif
;else:   mov     eax,[x]
;endif:  mov     [y],eax

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