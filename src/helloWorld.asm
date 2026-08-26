section .data
    message db "Hello, x86-64 Assembly!", 10
    length equ $ - message

section .text
    global _start

_start:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, message
    mov rdx, length
    syscall

    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall