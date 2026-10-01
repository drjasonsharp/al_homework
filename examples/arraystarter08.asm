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
fp:			resq	1					; reserve 1 quadword for file pointer (handle)
newarray:	resd	100					; create an array big enough to hold 100 doublewords

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

		; add a loop so that you read 10 numbers from the file and display them as they are read.

		; modify your loop so that values you read from the file are stored into the new array.

		; see declaration of newarray in section .bss

	mov edi,1			; move 1 into edi to use as counter
	mov ecx,newarray	; move address of newarray into ecx

	fopenr	[fp],numfile
	cmp	rax, 0
	je	filenotfound

while1:
	fget_i	[fp],ebx	; while not eof
	cmp	eax,-1
	je	eof
	put_i ebx
	put_str endl	
	mov [ecx],ebx
	add ebx,4
	add ecx,4
	jmp	while1
eof:
	fclosem	[fp]
	mov ecx,newarray
	put_str endl
	jmp printloop

filenotfound:
	put_str	filenf

		; after the file is closed, write a separate loop that will traverse the array and
		; display the numbers.

printloop:
	cmp	edi, 10
	jg	alldone
	put_i	[ecx]
	put_str	endl
	add	ecx, 4
	inc	edi
	jmp	printloop

		; exit

alldone: 	mov	ebx,0		; return 0
			mov	eax,1		; on
			int	80h			; exit

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits