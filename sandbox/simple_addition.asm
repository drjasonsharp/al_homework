;; add.asm
;; NASM x86-64 Linux
;; Add two 32-bit integers and display the result

%include "iomacros.asm"

                global main
                section .data

num1:   dd      25                  ;define doubleword 32-bit integer of value 25
num2:   dd      17                  ;define doubleword 32-bit integer of value 17
endl:   db      10,0                ;define byte to store newline

                section .bss
result  resd    1                  ; enough for 32-bit integer text

                section .text
 
main:
        ; load and add the two integers
        mov eax, [num1]                 ; assign value of num1, 25, to register eax, 32-bit
        add eax, [num2]                 ; eax=eax+num2, where eax = 25, eax is now = 42

        put_i eax                     ; macro in iomacro - 32-bit integer
        put_str endl                    ; macro in iomacro 

        ; exit(0)
        mov     eax, 60                 ; system call 60 is exit
        xor     rdi, rdi                ; exit code 0
        syscall

        section .note.GNU-stack noalloc noexec nowrite progbits