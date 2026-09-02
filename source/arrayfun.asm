;; 
;; ifdemo.asm
;;
;; Here we demonstrate looping ... which is basically the same thing as 
;; if statements.
;;
;; by Terry Sergeant
;; Fall 2014
;;
%include "iomacros.asm"
%include "dumpregs.asm"
%define	MAXSIZE 100

		global main
		extern printf,fflush,scanf

		section .data

endl:		db	10,0
numfile:		db	"num.txt",0
method:		db	"Here are the numbers: ",10,0


		section .bss

fp:		resq	1
a:		resd	MAXSIZE
n:		resd	1

		section .text

main:
		align_stack

		fopenr	[fp],numfile	; open num.txt
		fget_i	[fp],r8d		; read int from num.txt
		put_i	r8d		; print to screen
		put_str	endl		
		fclosem	[fp]		; close num.txt

		xor	edi,edi
		fopenr	[fp],numfile	; open num.txt
while1:		cmp	edi,MAXSIZE
		jge	eof
		fget_i	[fp],[a+4*edi]
		cmp	eax,-1
		je	eof
		inc	edi
		jmp	while1

eof:
		fclosem	[fp]
		mov	[n],edi

		xor	edi,edi
while2:		cmp	edi,[n]
		jge	endwhile2

		put_i	[a+4*edi]
		put_str	endl
		inc	edi
		jmp	while2

endwhile2:
		; exit(0)
theend:		mov     eax, 60
		xor     rdi, rdi
		syscall

