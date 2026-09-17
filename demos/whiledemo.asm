;; 
;; whiledemo.asm
;;
;; Here we demonstrate looping ... which is basically the same thing as 
;; if statements.
;;
;; by Terry Sergeant
;; Fall 2014
;;	1!=1
;;	2!=2×1=22! = 2 \times 1 = 22!=2×1=2
;;	3!=3×2×1=63! = 3 \times 2 \times 1 = 63!=3×2×1=6
;;	4!=4×3×2×1=244! = 4 \times 3 \times 2 \times 1 = 244!=4×3×2×1=24
;;	5!=5×4×3×2×1=1205! = 5 \times 4 \times 3 \times 2 \times 1 = 1205!=5×4×3×2×1=120

;;	So, 5 factorial equals 120.
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		global main
		extern printf,fflush,scanf

		section .data

endl:			db 10,0
n:		    	dd 5
startlabel		db	"Program starting . . .",10,0 ; 10 ASCII Decimal LF (line-feed), 0 (null)
loopstartlabel	db	"Loop starting . . .",0
loopendlabel	db	"Loop finished . . .",10,0
endlabel		db	"Program finished",10,0 
nlabel:			db	"n: ",0
r8dlabel:   	db	"r8d (count): ",0
r9dlabel:   	db	"r9d (nfact): ",0
countlabel:		db	"count: ",0
nfactlabel:		db	"nfact: ",0

		section .bss

count:			resd	1	; memory location
nfact:			resd	1	; memory location

		section .text

main:
		;; align_stack
		;;-----------
		;; In some programs, for reasons I cannot explain, the stack is not
		;; initially aligned on a 16-byte boundary, which causes some
		;; C-language function calls to crash. Calling this macro as the
		;; first line of the program will get things started on the right
		;; foot regardless of the initial state.
		;;-----------------------------------------------------------

        align_stack			; replaces code I provided; function is in iomacros.asm

		; call iomacros functions to display labels and values
		put_str startlabel
		put_str nlabel
		put_i [n]
		put_str endl
		put_str countlabel
		put_i [count]
		put_str endl
		put_str nfactlabel
		put_i [nfact]
		put_str endl

		put_str loopstartlabel
        
		; set values of r8d and r9d
        mov	r8d, 1 ; count= 1
		mov	r9d, 1 ; nfact = 1

; idea #1, slide 80, jle: jump if less than or equal
loop:	cmp	r8d, [n]
		jle	body ; if value of r8d (representing count) is less than or equal to n jump to body
		jmp	done ; otherwise jump to done
body:	imul	r9d, r8d
		put_str endl
		put_str r8dlabel
		put_i r8d
		put_str endl
		put_str r9dlabel
		put_i r9d		
		inc	r8d
		jmp	loop
done:	mov	[count], r8d
		mov	[nfact], r9d						
		put_str endl
		put_str loopendlabel
		put_str countlabel
		put_i [count]		         
		put_str endl     
		put_str nfactlabel
      	put_i [nfact]
		put_str endl
		put_str endlabel

; idea #2, slide 81, jg: jump if greater than
; this is the opposite or complimentary condition
;loop:	cmp	r8d, [n]
;		jg	done
;		imul	r9d, r8d
;		put_str endl
;		put_str r8dlabel
;		put_i r8d
;		put_str endl
;		put_str r9dlabel
;		put_i r9d		
;		inc	r8d
;		jmp	loop
;done:	mov	[count], r8d
;		mov	[count], r9d
;		put_str endl
;		put_str loopendlabel
;		put_str countlabel
;		put_i [count]		         
;		put_str endl     
;		put_str nfactlabel
;       put_i [nfact]
;		put_str endl
;		put_str endlabel

		; exit(0)
		mov     eax, 60
		xor     rdi, rdi
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits