;
; arrayofrecordsexercise.asm
;
; Array of Records exercise.
;
; @author  Jason Sharp
; @version Fall 2026
;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
endl	db	10,0
;name	db	"Jason",0
										
		section .bss
people:		resb	40*10000		; reserve 10000 (0-9999) records of 40 bytes each
									; could be 400000 bytes or 10000 doublewords (10000*4)
i:			resd	1				; reserve 1 doubleword (4 bytes) for an index
n:			resd	1				; reserve 1 doubleword (4 bytes) for number of useful entries

		section .text
		global 		main
main:
		align_stack

	xor	rbx, rbx	; clear rbx register using bitwise or results in 0

	; populate people array

	mov rbx, people
	mov byte [rbx], 'J'
	mov byte [rbx+1], 'a'
	mov byte [rbx+2], 's'
	mov byte [rbx+3], 'o'
	mov byte [rbx+4], 'n'
	mov byte [rbx+5], 0		
	mov [rbx+32],dword 5
	mov [rbx+36],dword 56
	;put_ch 10

	mov rbx, people+40
	mov byte [rbx], 'J'
	mov byte [rbx+1], 'i'
	mov byte [rbx+2], 'm'
	mov byte [rbx+3], 0		
	mov [rbx+32],dword 3
	mov [rbx+36],dword 61
	;put_ch 10

	mov rbx, people+80
	mov byte [rbx], 'L'
	mov byte [rbx+1], 'a'
	mov byte [rbx+2], 'u'
	mov byte [rbx+3], 'r'
	mov byte [rbx+4], 'i'
	mov byte [rbx+5], 'e'
	mov byte [rbx+6], 0		
	mov [rbx+32],dword 6
	mov [rbx+36],dword 51
	;put_ch 10
	
	put_i	[i]
	put_str endl

;	mov [i],dword 2

	; display people[i]

;	mov	ebx, [i]	; put value of i (the index) into ebx register lower 32-bits
;	imul ebx, 40	; multiple ebx by 40, skipping over 40 bytes for each record
;	add	rbx, people	; add address of people to rbx starting at the beginning of the array
					; to my offset that i have calculated that moves down to people[i]
					; at this point, rbx is the address of the record at position i
					; once we have the address of the record in the array it works just
					; like a record
;	put_str	rbx		; display whatever is stored at rbx, the name as a string
;	put_str endl
;	put_i	[rbx+32]; display the value stored at rbx+32, the offset for length
;	put_str endl
;	put_i	[rbx+36]; display the value stored at rbx+36, the offset for age
;	put_str endl

	; display all people (loop up to n, where n represents the number of useful entries in the array)
	xor	rbx, rbx	; clear rbx register using bitwise or results in 0
	mov	rbx, people	; put the address of people into the rbx register
	mov	edi, 0		; put 0 into edi register for counter
	mov [n], dword 3; there are 3 useful records
loop:
	cmp	edi,[n]		; compare edi to value of n, which is 2
	jge	done		; if edi is greater than or equal to 0 jump to done
	put_str	rbx		; print name, contained at the address of rbx
	put_str endl
	put_i	[rbx+32]; print len, contained in the value of rbx+32 (offset for length)
	put_str endl
	put_i	[rbx+36]; print age, contained in the value of rbx+36 (offset for age)
	put_str endl
	put_str endl
	add	rbx, 40		; skip to next record, add 40 bytes to the address at rbx
	inc	edi			; increment edi by 1
	jmp	loop		; unconditional jump to loop
done:
	mov     eax, 60
	xor     rdi, rdi
	syscall

	mov	ebx,0		; return 0
	mov	eax,1		; on
	int	80h			; exit

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits