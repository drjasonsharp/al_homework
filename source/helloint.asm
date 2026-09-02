;; 
;; helloint.asm
;;
;; Let's try to print an integer with a system call!
;;
;; by Terry Sergeant
;; Fall 2014
;;

		global _start

		section .data

;message:	dd	0x21686f64
message:        dd      560492388
message_len:	equ	$-message


		section .text

_start:
		; write(stdout,message,length)
		mov     rax, 1			; system call 1 is write
		mov     rdi, 1			; file handle 1 is stdout
		mov     rsi, message		; address of string to output
		mov     rdx, message_len	; number of bytes in string
		syscall

		; exit(0)
		mov     eax, 60                 ; system call 60 is exit
		xor     rdi, rdi                ; exit code 0
		syscall
