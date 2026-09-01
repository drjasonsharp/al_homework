;;
;; demo_dumpregs.asm
;;
;; We demonstrate various uses of the macros in dumpregs
;;
;; by TSergeant
;;

%include "../lib/dumpregs.asm"

		global main

		section .text

main:
		dump_regs
		put_rflags

		mov     eax, 60                 ; exit 0
		xor     rdi, rdi
		syscall

