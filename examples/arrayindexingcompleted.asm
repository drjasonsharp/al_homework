;
; arrayindexingcompleted.asm
;
; Working with array indexing.
;
; @author  Jason Sharp
; @version Fall 2026
;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
;myarray:	dd	0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xAA
i:			dd	0
j:			dd	1
k:			dd	2
l:			dd	3
endl		db	10,0

		section .bss
arr:		resd	50	; reserve space for 50 32-bit signed integers

		section .text
		global 		main
main:
		align_stack
		
		; display the starting address of arr
		put_str	endl
		put_i	arr	
		put_str	endl

		; display the value of the starting address of arr
		put_i	[arr]
		put_str	endl
		put_str endl

		; display address of each element

		mov ecx, arr		
		put_i ecx
		put_str endl
		put_i [ecx]
		put_str	endl

		add ecx, 4
		put_i ecx
		put_str endl
		put_i [ecx]
		put_str	endl

		add ecx, 4
		put_i ecx
		put_str endl
		put_i [ecx]		
		put_str	endl

		add ecx, 4
		put_i ecx
		put_str endl
		put_i [ecx]
		put_str	endl

		add ecx, 4
		put_i ecx
		put_str endl
		put_i [ecx]		
		put_str	endl
		put_str endl

		; populate the arr array 1 to 50

		mov	edi, 1
		mov	rcx, arr
loop:	cmp	edi, 50
		jg	exitloop
		mov	[rcx], edi
		inc	edi
		add	rcx, 4
		jmp	loop

exitloop:
		mov	rcx, arr
		mov	edi, 1

;printloop:		; print contents of arr
;		cmp	edi, 5
;		jg	theend
;		put_i	[rcx]
;		put_str	endl
;		add	rcx, 4
;		inc	edi
;		jmp	printloop

		; display address of each element

		put_str endl
		put_i	arr+42*4		; display address of the element
		put_str endl
		put_i	[arr+42*4]		; display value at the address

		put_str	endl
		put_str endl

		mov ecx, arr		
		put_i ecx
		put_str endl
		put_i [ecx]
		put_str	endl

		add ecx, 4
		put_i ecx
		put_str endl
		put_i [ecx]
		put_str	endl

		add ecx, 4
		put_i ecx
		put_str endl
		put_i [ecx]		
		put_str	endl

		add ecx, 4
		put_i ecx
		put_str endl
		put_i [ecx]
		put_str	endl

		add ecx, 4
		put_i ecx
		put_str endl
		put_i [ecx]		
		put_str	endl
		put_str endl

; q: what is the address of integer arr[4]?
; a: arr + 4 * 4
; arr is the address of the beginning of the arry
; each array element consumbes 4 bytes of memory
; we have to skip over 4 integers to get to the one at position 4
; because indexes start at 0

put_str	endl;

put_i	arr+0*4		; display address of the element
put_str	endl
put_i	[arr+0*4]	; display value of the element
put_str	endl;

put_i	arr+1*4		; display address of the element
put_str	endl;
put_i	[arr+1*4]	; display value of the element
put_str	endl;

put_i	arr+2*4		; display address of the element
put_str	endl;
put_i	[arr+2*4]	; display value of the element
put_str	endl;

put_i	arr+3*4		; display address of the element
put_str	endl;
put_i	[arr+3*4]	; display value of the element
put_str	endl;

put_i	arr+4*4		; display address of the element
put_str	endl;
put_i	[arr+4*4]	; display value of the element
put_str	endl;

; using arr + index * 4

xor	rcx,rcx			; clear all 64-bits of rcx
mov r8,arr			; move address of arr into r8
mov ecx, [i]		; ecx = i or 0
imul ecx, 4			; ecx = i * 4 or ecx = 0 * 4
add r8,rcx			; r8 = addr of arr[i] or arr[0]

mov r9,arr			; put addr of arr in r9
mov ecx, [j]		; ecx = j or 1
imul ecx, 4			; ecx = j * 4 or ecx = 1 * 4
add r9, rcx			; r9 = addr of arr[j] or arr[0]

put_str endl
put_str	endl
put_i64 r8			; display r8
put_str endl
put_i64 [r8]		; display value in r8 = 1
put_str endl
put_i64 r9			; display r9
put_str endl
put_i64 [r9]		; display value in r9 = 2
put_str endl
put_str	endl

; swap

mov ecx, [r8]		; ecx = arr[i] or ecx = arr[0] = 1
mov edx, [r9]		; edx = arr[j] or edx = arr[1] = 2
mov [r8], edx		; r8 = edx or r8 = 2
mov [r9], ecx		; r9 = ecx or r9 = 1

put_str endl
put_str	endl

put_i64 r8			; display r8
put_str endl
put_i64 [r8]		; display value in r8 = 2
put_str endl
put_i64 r9			; display r9
put_str endl
put_i64 [r9]		; display value in r9 = 1
put_str endl
put_str	endl

mov	ecx, [k]				; ecx = i, ecx is the reg, a counter
mov	edx, [l]				; edx = j, edx is the reg, a counter

;put_i64 r8			 		; display r8
;put_str endl
put_i64 [arr + 4*ecx]		; display value in r8 = 3
put_str endl
;put_i64 r9					; display r9
;put_str endl
put_i64 [arr + 4*edx]		; display value in r9 = 1
put_str endl
;put_str endl

; swap using Intel notation

mov	r8d, [arr + 4*ecx]		; arr gets starting address of the array
							; add 4, the scale, multiplied by ecx
mov	r9d, [arr + 4*edx]
mov	[arr + 4*ecx], r9d		; move r9d into address of notation
mov	[arr + 4*edx], r8d		; move r8d into address of notation

;put_i64 r8			 		; display r8
put_str endl
put_i64 [arr + 4*ecx]		; display value in r8 = 3
put_str endl
;put_i64 r9					; display r9
;put_str endl
put_i64 [arr + 4*edx]		; display value in r9 = 1
put_str endl
put_str endl

; original loop

;printloop:		; print contents of arr
;		cmp	edi, 5
;		jg	theend
;		put_i	[rcx]
;		put_str	endl
;		add	rcx, 4
;		inc	edi
;		jmp	printloop

; simple loops using new notation

part2:
	mov edi, 0			; zero based counter
	mov ecx, 1			; counter that starts at 1
loop2:	cmp edi, 50		; compare edi to 50
	jge exitloop2		; jump to exitloop2 if greater than or equal to 50
	mov [arr + 4*edi], ecx	; move counter starting at 1 into this memory location
							; skip over what is in edi, first time edi is 0
	inc edi			; increment edi
	inc ecx			; increment ecx
	jmp loop2		; unconditional jump to loop2

exitloop2:
	mov edi,0		; move 0 to edi

printloop2:
	cmp edi, 50		; compare edi to 50
	jge theend		; if edi is greater than or equal to 50 jump to theend
	put_i [arr + 4*edi] ; display value at address
	put_str endl	; display blank (new) line
	inc edi			; increment edi
	jmp printloop2	; unconditional jump to printloop2

alldone: 	mov	ebx,0		; return 0
			mov	eax,1		; on
			int	80h			; exit

theend:		mov     eax, 60
			xor     rdi, rdi
			syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits