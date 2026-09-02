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

		global main
		extern printf,fflush,scanf

		section .data

endl:		db	10,0
z:		dd	10
hello:		db	"Hello",10,0
method:		db	"Method A (display message n times):",10,0

		section .bss

x:		resd	1
n:		resd	1


		section .text

main:
		; x=1
		; n=1
		; while (n <= z)
		; {
		;    x= x*n
		;    n++
		;    print x
		; }

		; Method 1

		mov	r8d,1		; r8 is x
		mov	r9d,1		; r9 is n

loopentry:	cmp	r9d,[z]		; while (n <= z)
		jle	loopbody
		jmp	done

loopbody:	imul	r8d,r9d
		inc	r9d
		put_i	r8d
		put_str endl
		jmp	loopentry

done:		mov	[x],r8d
		mov	[n],r9d


		; Method 2

		mov	r8d,1		; r8 is x
		mov	r9d,1		; r9 is n

loopentry2:	cmp	r9d,[z]		; while (n <= z)
		jg	done2

		imul	r8d,r9d
		inc	r9d
		put_i	r8d
		put_str endl
		jmp	loopentry2

done2:		mov	[x],r8d
		mov	[n],r9d


		; use loop to display hello n times

		mov	dword [n],5

		; Method A
		mov	rdi,method
		mov	byte [rdi+7],65
		put_str	rdi		; print "Method A"

		xor	rax,rax
whileA:		cmp	eax,[n]
		jl	printitA
		jmp	doneA

printitA:	put_str	hello
		inc	rax
		jmp	whileA

doneA:


		; Method B
		mov	rdi,method
		mov	byte [rdi+7],66
		put_str	rdi		; print "Method B"

		xor	rax,rax
whileB:		cmp	eax,[n]
		jge	doneB

printitB:	put_str	hello
		inc	rax
		jmp	whileB

doneB:


		; Method C
		mov	rdi,method
		mov	byte [rdi+7],67
		put_str	rdi		; print "Method C"

		mov	eax,[n]
whileC:		cmp	eax,0
		jle	doneC

printitC:	put_str	hello
		dec	rax
		jmp	whileC

doneC:


		; Method D
		mov	rdi,method
		mov	byte [rdi+7],68
		put_str	rdi		; print "Method D"

		mov	eax,[n]
whileD:		jle	doneD		; NOTE: cmp has been removed!!

printitD:	put_str	hello
		dec	rax
		jmp	whileD

doneD:


		; exit(0)
theend:		mov     eax, 60
		xor     rdi, rdi
		syscall


