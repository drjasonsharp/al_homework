;;
;; memorymapping.asm
;;
;; Class "memorymapping" in x86_64 assembly using NASM.
;;
;; by Jason Sharp
;; Fall 2026
;;
;; tab space set to 4, using two tabs between columns
    
                global _start
                section.data

;labels     instructions    operands            comments
int:        dd              68,-9
floaty:     dd              -68.125
char:       db              "Greetings!",10,0
bighex:     dq              10h
mediumbin:  dw              10b

                section.bss                     ;uninitialized memory
somememory: resd            2

                section.data                    ;can have multiple sections
nightnight  db              "ZZZZZZZZ"

                section .text                   ;Assembly code

_start:                                         ;use main if
                                                ;using iomacros.asm
                                                ;for input/output 
 
 ;labels        instructions    operands        comments                                           
                mov             eax, 60         ; system call 60 is exit
                xor             rdi, rdi        ; exit code 0
                syscall