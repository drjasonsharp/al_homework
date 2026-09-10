;; simple_division.asm
;; NASM x86-64 Linux
;; divide two 32-bit integers and display the result

%include "iomacros.asm"

                global main
                section .data

endl:   db      10,0               ;define byte to store newline

                section .bss
result  resd    1                  ; enough for 32-bit integer text

                section .text
 
main:
        ; load and divide the two integers
        mov     r9d,76              ; move 76 into r9d
        mov     r10d,12             ; move 12 into r10d
        mov	eax, r9d            ; copy r9d into eax
        cdq			    ; extend eax into edx:eax
        idiv	r10d		    ; eax= edx:eax / r10
        mov	r11d, eax	    ; copy answer into r11d

        put_i r11d                  ; display value in r11d using put_i function
        put_str endl                ; macro in iomacro to create new line
        put_i edx                   ; display value in edx using put_i function     
        put_str endl                ; macro in iomacro to create new line

        ; exit(0)
        mov     eax, 60             ; system call 60 is exit
        xor     rdi, rdi            ; exit code 0
        syscall

        section .note.GNU-stack noalloc noexec nowrite progbits