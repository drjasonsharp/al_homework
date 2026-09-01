global main
extern printf, scanf

section .data

number_prompt db "Enter number: ",0
readint       db "%d",0
answer_str    db "The result of the calculation is: %d",10,0

section .bss

number  resd 1
result  resd 1

section .text

main:
    push rbp
    mov rbp,rsp

    lea rdi,[rel number_prompt]
    xor eax,eax
    call printf

    lea rdi,[rel readint]
    lea rsi,[rel number]
    xor eax,eax
    call scanf

    mov ecx,[number]
    imul ecx,10
    mov [result],ecx

    lea rdi,[rel answer_str]
    mov esi,[result]
    xor eax,eax
    call printf

    xor eax,eax
    leave
    ret

section .note.GNU-stack noalloc noexec nowrite progbits