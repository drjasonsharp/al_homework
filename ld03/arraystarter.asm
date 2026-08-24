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

		section .text
		global 		main
main:
		; before running this guess what the output will be ... THEN run it.
		put_i	[myarray]
		put_str	endl

		; write the necessary statements, without using a loop, to display all elements of myarray





		; now display myarray using a loop




		; bring a printout of your completed source code to labday

alldone: 	mov	ebx,0		; return 0
		mov	eax,1		; on
		int	80h		; exit

