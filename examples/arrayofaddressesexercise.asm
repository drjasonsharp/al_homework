;;
;; arrayofaddressesexercise.asm
;;
;; by Jason Sharp
;; Fall 2026
;;
;; Reads information about people people.txt where: 
;;     name (32 characters)
;;     length is the number of characters in name (4 bytes)
;;     age (4 bytes)
;;   };
;;
;; There are at most 100 names in people.txt.  The input file has one
;; field per line with entries separated by carriage return.
;; The format is:
;;   name
;;   length
;;   age
;;   .
;;   .
;;	 .  
;;   .
;;   .
;;   .
;;   name
;;   length
;;   age
;;
%include "iomacros.asm"
%include "dumpregs.asm"
; **** complete the %define statements by adding the appropriate values for each ****
%define NAMESIZE 32		; longest name is 31+NULL
%define RECSIZE 40		; 40 bytes (32+4+4)
%define MAXNAMES 1000	; at most 1000 names in people.txt
%define NAME 0			; offset of name
%define LENGTH 32		; offset of length
%define AGE 36			; offset of age

		section .data
fname:		db	"people.txt",0
fileerror:	db	"There was an error opening your file.",0
debug:		db	"Made it here",10,0
endl:		db	0Ah,0

		section .bss
arr:	resq	MAXNAMES	; reserve 1000 quadwords
n:		resd	1			; number of pointers the in array
f:		resq	1			; file pointer

		section .text
		global 		main
main:
		sub	rsp,8	; need for stack alignment

		fopenr	[f],fname		; open "people.txt" to read
		cmp	eax,0				; if eax equal to 0, read failed
		jne	successful
		jmp	failed

successful:
		xor ebx,ebx			; zero out ebx
readfile:
		;;;;;;;;;;;; dynamically allocate memory ;;;;;;;;;;;;

		mov	rax,9		; syscall mmap
		xor	rdi,rdi		; addr = NULL
		mov	rsi,RECSIZE	; # of bytes to reserve
		mov	rdx,0x3		; PROT_READ|PROT_WRITE
		mov	r10,0x22	; MAP_PRIVATE|MAP_ANONYMOUS
		mov	r8,-1		; fd=-1
		xor	r9,r9		; offset=0
		syscall			; issue system call for mmap, number 9	

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		
		mov r12,rax				; mov rax into r12
		mov [arr+8*rbx],r12		; mov r12 into array offset
		fget_str [f],r12+NAME	; read name

		cmp	eax,-1				; check for end of file
		je	endoffile
		
		fget_i [f],[r12+LENGTH]	; read length	
		fget_i [f],[r12+AGE]	; read age
		;fget_ch [f], al ; don't actually need this			; discard newline

endloop1:
		inc ebx			; increment ebx by 1
		jmp readfile	; go back through loop

endoffile:
		fclosem	[f]		; close file
		mov	[n],ebx		; n holds number of names in array
		xor ecx,ecx		; zero out ecx

display_loop:		
        cmp ecx,[n]			; compare ecx to n
        jge display_done	; ecx greater than or equal to n

        ; get pointer to current record
        mov r12,[arr + 8*rcx]

        ; display address of record        
		put_i64 r12
        put_str endl

        ; display name
        put_str r12+NAME
        put_str endl

        ; display length
        put_i [r12 + LENGTH]
        put_str endl

        ; display age
        put_i [r12 + AGE]
        put_str endl
 
        inc ecx				; increment ecx
        jmp display_loop

display_done:
	jmp alldone

failed:	
		put_str	fileerror	; "error opening your file"
		put_ch	[endl]

alldone:
		add		rsp,8
		mov     rax, 60                 ; system call 60 is exit
		xor     rdi, rdi                ; exit code 0
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits