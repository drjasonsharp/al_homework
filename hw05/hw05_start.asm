;;
;; hw05_start.asm
;;
;; Read ints from a file into an array; from array calculate sum using Intel notation
;; Note comments surrounded by ;;;;;;;;;;;;;;;;;;;;;;;;;;;; throughout code and modify accordingly
;;
;; by YOUR NAME
;; Fall 2026
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data

infile:		db	"numbers.txt",0
n_label:	db	"n   : ",0
sum_label:	db	"Sum : ",0
avg_label:	db	"Avg : ",0
max_label:	db	"Max : ",0
min_label:	db	"Min : ",0
endl:		db	10,0

		section .bss
fp:		resq	1			; create memory location fp of size 1 quadword (64-bits)
arr:	resd	10000		; create memory location arr of size 10000 doublewords (32-bits)
n:		resd	1			; create memory location n of size 1 doubleword (32-bits)

		section .text

		global main

main:
		sub	rsp,8				; needed for stack alignment

		xor		edi,edi			; set edi to 0 for counter
		mov 	ecx,arr			; move address of arr (array) to ecx register
		fopenr	[fp],infile		; move address of infile (numbers.txt) into value of fp
readfile:
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;; modify call to fget_i to read value of fp into memory location using Intel notation
		fget_i	[fp],ebx		; read value of fp into ebx register
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		cmp	eax,-1				; compare eax to -1, -1 moved into eax if read fails
		je	donereading			; if eax is equal to -1 jump to donereading
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;; modify call to put_i to display using Intel notation
		put_i	ebx				; display ebx
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		put_str	endl			; display blank (new) line
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;; ask yourself if this mov and two add statements are needed to use Intel notation?
		mov [ecx],ebx			; move ebx register into value of ecx register
		add ebx, 4				; add 4-bytes to ebx register to move to next memory location
		add ecx, 4				; add 4-btyes to ecx register to move to next memory location
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		inc	edi					; increment edi by 1
		jmp	readfile			; unconditional jump to readfile

donereading:
		fclosem	[fp]				; close value stored in fp which is address of numfile (numbers.txt)
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;; ask yourself if moving address of arr to ecx is necessary with Intel notation?
		mov ecx, arr				; move address of arr into ecx
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		mov	[n],edi					; move edi into value of n, which represents number of values read
		xor	edi,edi					; clear edi, set to 0 for counter and eventually variable index, i
		xor	r8d,r8d					; sum (accumulator)
		put_str endl

forloop:
		cmp	edi,[n]					; compare edi to value of n
		jge	endloop					; if edi greater than or equal to n jump to endloop
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;; modify add command to use Intel notation		
		add	r8d,[ecx]				; accumulation (sum)
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		put_i r8d					; display r8d (sum)
		put_str endl
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;; ask yourself if this add command is necessary with Intel notation?
		add ecx, 4					; add 4-bytes to ecx to move to next memory location
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		inc edi						; increment edi by 1
		jmp forloop					; unconditional jump to forloop

endloop:
		put_str	endl			
		put_str	sum_label			; display sum_label
		put_i	r8d					; display r8d (sum)
		put_str	endl

theend:
		add		rsp,8
		mov     rax, 60
		xor     rdi, rdi
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits