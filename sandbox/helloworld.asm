;;
;; helloworld.asm
;;
;; Class "hello world" in x86_64 assembly using NASM and Linux system
;; calls for I/O.
;;
;; by Jason Sharp
;; Fall 2026
;;
;; tab space set to 4, using two tabs between columns
    
                global _start
                section.data

message:        db      "Hello, World!",10
message_len:    equ     $-message


                section .text

_start:
                ; write(stdout,message,lenght)
                mov     rax, 1                  ; system call 1 is write
                mov     rdi, 1                  ; file handle 1 is stdout
                mov     rsi, message            ; address of string to output
                mov     rdx, message_len        ; number of bytes in string
                syscall

                ; exit(0)
                mov     eax, 60                 ; system call 60 is exit
                xor     rdi, rdi                ; exit code 0
                syscall