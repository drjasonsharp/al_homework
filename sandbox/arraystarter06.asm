;
; arraystarter.asm
;
; Set up a simple array of ints in memory and then play around with it.
;
; @author  Terry Sergeant
; @version Fall 2016
;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
myarray:	dd	0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0xAA
endl		db	10,0
numfile:	db	"numbers.txt",0			; create label for text file
filenf:		db	"File not found!",10,0	; create label for file not found

		section .bss
fp:		resq	1						; reserve 1 quadword for file pointer (handle)
										; create an array big enough to hold 100 doublewords

		section .text
		global 		main
main:
		align_stack

		; before running this guess what the output will be ... THEN run it.
		;put_i	[myarray]
		;put_str	endl

		; write the necessary statements, without using a loop, to display all elements of myarray
	
		; now display myarray using a loop

		; open and close the text file

		; open the text file and display value of first number and then close the text file

		; see declaration of numfile in section .data and fp in section .bss

		; add a loop so that you read 10 numbers from the file and display them as they are read.

		; see declaration of filenf in section .data

		fopenr	[fp],numfile	; open numbers.txt, place address of numfile into value of fp
		cmp	rax, 0				; compare rax to 0, 0 placed in rax if open fails
		je	filenotfound			; if rax is equal to 0 jump to file

while1:
		fget_i	[fp],ebx	; while not eof
		cmp	eax,-1
		je	eof
		put_i ebx
		put_str endl	
		add ebx,4
		jmp	while1
eof:
		fclosem	[fp]
		jmp	alldone

filenotfound:
	put_str	filenf


		; modify your loop so that values you read from the file are stored into the new array.





		; after the file is closed, write a separate loop that will traverse the array and
		; display the numbers.

		



		; exit

alldone: 	mov	ebx,0		; return 0
			mov	eax,1		; on
			int	80h			; exit

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits