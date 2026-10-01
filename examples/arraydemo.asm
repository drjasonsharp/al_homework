;;
;; arraydemo.asm
;;
;; Here we demonstrate some array concepts.
;;
;; by Terry Sergeant
;; Fall 2014
;;
%include "iomacros.asm"
%include "dumpregs.asm"
%define N 10

%macro	dumpintarray 2
		push	rbx			; save context
		push	rdi

		mov	rbx,%1
		xor	rdi,rdi
%%loop:		cmp	rdi,%2
		jge	%%done
		put_i	[rbx]
		put_str	comma
		inc	rdi
		add	rbx,4
		jmp	%%loop

%%done:		put_str	endl
		pop	rdi			; restore context
		pop	rbx
%endmacro

		global main
		extern printf,fflush,scanf

		section .data

n:		dd	N
hello:		db	"Hello",10,0
method:		db	"Method A (display message n times):",10,0
comma:		db	", ",0
endl:		db	10,0

		section .bss

front:		resd	1
a:		resd	N 	; array of N ints
back:		resd	1
d:		resq	N


		section .text

main:
		; in these demos I initialize the memory before and after the array so
		; I can make sure I'm not writing outside the bounds of the array.
		mov	[front], dword -1
		mov	[back], dword -1
		dumpintarray a-4,12

		; initialize elements of array to 1, 2, 3, etc.
		; address arithmetic method
		mov	rbx,a
		xor	rdi,rdi
loop1:		cmp	rdi,10
		jge	next1
		inc	rdi
		mov	[rbx],edi
		add	rbx,4
		jmp	loop1


next1:
		dumpintarray a-4,12


		; initialize elements of array to 0's
		; addressing mode method
		mov	rbx,a
		xor	rdi,rdi
loop2:		cmp	rdi,N
		jge	next2
		inc	rdi
		mov	[rbx+4*rdi-4], dword 0
		jmp	loop2

next2:		dumpintarray a-4,12


		; initialize elements of array to 1, 2, 3, etc.
		; short method
		mov	rdi,N
loop3:		mov	[a+4*rdi-4],edi
		dec	rdi
		jg	loop3

next3:		dumpintarray a-4,12


		; swap a[i] and a[j] (i=edi, j= esi)
		mov	edi,2
		mov	esi,6
		mov	eax,[a+4*edi]
		mov	ebx,[a+4*esi]
		mov	[a+4*edi],ebx
		mov	[a+4*esi],eax

		dumpintarray a-4,12

		; exit(0)
theend:		mov     eax, 60
		xor     rdi, rdi
		syscall

