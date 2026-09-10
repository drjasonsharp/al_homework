;; simple_division.asm
;; NASM x86-64 Linux
;; divide two 64-bit integers and display the result

%include "iomacros.asm"

                global main
                section .data

endl:   db      10,0               ;define byte to store newline

                section .bss
result  resd    2                  ; enough for 64-bit integer text

                section .text
 
main:
        ; load and divide the two integers
        mov     r9,76              ; move 76 into r9
        mov     r10,12             ; move 12 into r10
        mov	rax,r9             ; copy r9 into rax
        cqo			   ; extend rax into rdx:rax
        idiv	r10		   ; eax= edx:eax / r10
        mov	r11, rax	   ; copy answer into r11

        put_i64 r11                  ; display value in r11 using put_i64 function
        put_str endl               ; macro in iomacro to create new line
        put_i64 rdx                  ; display value in rdx using put_i64 function     
        put_str endl               ; macro in iomacro to create new line

        ; exit(0)
        mov     rax, 60             ; system call 60 is exit
        xor     rdi, rdi            ; exit code 0
        syscall

        section .note.GNU-stack noalloc noexec nowrite progbits