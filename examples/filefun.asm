;;
;; filefun.asm
;;
;; Here we demonstrate reading integers from a text file using iomacros.asm.
;;
;; by Terry Sergeant
;;
%include "iomacros.asm"
%define	MAXSIZE 100					; NASM directive for a named constant

		global main
		section .data

endl:		db	10,0
numfile:	db	"numbers.txt",0		; the address of numfile and the string are the same
sumis:		db	"The sum is: ",0
filenf:		db	"File not found!",10,0


		section .bss

fp:		resq	1					; reserve 1 quadword (64-bits) for the file pointer (handle)
a:		resd	MAXSIZE				; reserve 100 doublewords
n:		resd	1

		section .text

main:
		align_stack

		; here we read 1 int from the file and print it out
		fopenr	[fp],numfile	; open numbers.txt, placing address of numfile into value of fp
		cmp	rax, 0				; compare rax to 0; rax is assigned 0 if open fails
		je	filenotfound		; if rax is equal to 0 jump to filenotfound
		fget_i	[fp],r8d		; read int from numbers.txt
		put_i	r8d				; print to screen
		put_str	endl			; display blank line
		fclosem	[fp]			; close numbers.txt; close the address stored in fp

		; here we read all the ints from the file and add them up
		; sum will go in r8d
		xor	r8d, r8d			; zero out r8d for use as accumulator
		fopenr	[fp],numfile	
		cmp	rax, 0				
		je	filenotfound

while1:
		fget_i	[fp],ebx	; while not eof
		cmp	eax,-1			; compare eax (rax) to -1, if eax is -1 read failed, end of file 
		je	eof				; if eax is equal to -1 jump to eof
		add	r8d, ebx		; add value to total (accumulation)
		jmp	while1			; unconditional jump to while1

eof:
		fclosem	[fp]
		put_str	sumis
		put_i	r8d
		put_str	endl
		jmp	theend

filenotfound:
		put_str	filenf

theend:		mov     eax, 60
			xor     rdi, rdi
			syscall

section .note.GNU-stack noalloc noexec nowrite progbits