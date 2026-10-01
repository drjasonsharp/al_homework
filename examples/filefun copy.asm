;;
;; filefun.asm
;;
;; Here we demonstrate reading integers from a text file using iomacros.asm.
;;
;; by Terry Sergeant
;;
%include "iomacros.asm"
%define	MAXSIZE 100

		global main
		section .data

endl:		db	10,0
numfile:	db	"numbers.txt",0
sumis:		db	"The sum is: ",0
filenf:		db	"File not found!",10,0


		section .bss

fp:		resq	1
a:		resd	MAXSIZE
n:		resd	1

		section .text

main:
		align_stack

		; here we read 1 int from the file and print it out
		fopenr	[fp],numfile	; open numbers.txt
		cmp	rax, 0
		je	filenotfound
		fget_i	[fp],r8d	; read int from numbers.txt
		put_i	r8d		; print to screen
		put_str	endl
		fclosem	[fp]		; close numbers.txt



		; here we read all the ints from the file and add them up
		; sum will go in r8d
		xor	r8d, r8d
		fopenr	[fp],numfile
		cmp	rax, 0
		je	filenotfound

while1:
		fget_i	[fp],ebx	; while not eof
		cmp	eax,-1
		je	eof
		add	r8d, ebx	; add value to total
		jmp	while1

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

