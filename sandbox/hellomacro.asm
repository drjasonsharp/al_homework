;;
;; hellomacro.asm
;;
;; Demonstrates rudimentary use of iomacros to display an int.
;;
;; by J.Sharp
;;
;; nasm -f elf64 hellomacro.asm
;; gcc hellomacro.o
;; # NOTE on some systems may need to do: gcc -no-pie hellomacro.o
;; ./a.out
;;

%include "iomacros.asm"

                global main
                section .data

format_str:     db      "Here is your number: ",0
myint:          dd      123
endl:           db      10,0


                section .text

main:
                put_str format_str      ; macro in iomacro
                put_i   [myint]         ; macro in iomacro - 32-bit integer
                put_str endl            ; macro in iomacro

                mov     rax, 60         ; system call 60 is exit
                xor     rdi,rdi         ; exit code 0
                syscall

                section .note.GNU-stack noalloc noexec nowrite progbits
