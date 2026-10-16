;;
;; hw07_start.asm
;;
;; by YOUR NAME
;; Fall 2026
;;
;; Reads information about sumo wrestlers (sumo.txt) where: 
;;     name (32 characters)
;;     length is the number of characters in name (4 bytes)
;;     age (4 bytes)
;;   };
;;
;; There are at most 100 names in people.txt.  The input file has one
;; field per line with entries separated by carriage return.
;; The format is:
;;   rank
;;   height
;;   weight
;;   name
;;   .
;;	 .  
;;   .
;;   .
;;   .
;;   .
;;   .
;;   .
;;   rank
;;   height
;;   weight
;;   name
;;
%include "iomacros.asm"
%include "dumpregs.asm"
; **** complete the %define statements by adding the appropriate values for each ****
%define NAMESIZE 20		; longest name is 19+NULL
%define RECSIZE 32		; 32 bytes (4+4+4+20)
%define MAXNAMES 100	; at most 1000 names in people.txt
%define RANK 0			; offset of rank
%define HEIGHT 4		; offset of height
%define WEIGHT 8		; offset of weight
%define NAME 12			; offset of name

		section .data
fname:		db	"sumo_short.txt",0
fileerror:	db	"There was an error opening your file.",0
debug:		db	"Made it here",10,0
endl:		db	0Ah,0

		section .bss
arr:	resq	MAXNAMES	; reserve 100 quadwords
n:		resd	1			; number of pointers the in array
f:		resq	1			; file pointer

		section .text
		global 		main
main:
		sub	rsp,8				; need for stack alignment

		fopenr	[f],fname		; open "sumo_short.txt" to read
		cmp	eax,0				; if eax equal to 0, read failed
		jne	successful
		jmp	failed

successful:
		xor ebx,ebx			; zero out ebx
readfile:
		;;;;;;;;;;;; dynamically allocate memory ;;;;;;;;;;;;

		mov	rax,9		; syscall mmap
		xor	rdi,rdi		; addr = NULL
		mov	rsi,RECSIZE	; # of bytes to reserve
		mov	rdx,0x3		; PROT_READ|PROT_WRITE
		mov	r10,0x22	; MAP_PRIVATE|MAP_ANONYMOUS
		mov	r8,-1		; fd=-1
		xor	r9,r9		; offset=0
		syscall			; issue system call for mmap, number 9	

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		
		;; write the code to put rax into an unused register
		;; recall, rax now holds the address of the dynamically
		;; allocated memory location just created

		;; ** INSERT CODE HERE **

		
		;; write the code to put the register used above into
		;; starting address of arr (declared in .bss) using
		;; Intel notation designating the scale and using
		;; rbx as the variable subscript (see line 66, zeroing out
		;; of ebx which is the lower 32-bits of rbx)

		;; ** INSERT CODE HERE **
		
		
		;; write the code to read the rank from the data file
		;; using appropriate offset bracket notation

		;; ** INSERT CODE HERE **
		

		cmp	eax,-1				; check for end of file
		je	endoffile
		
		;; write the code to read the height from the data file
		;; using appropriate offset bracket notation

		;; ** INSERT CODE HERE **
		

		;; write the code to read the weight from the data file
		;; using appropriate offset bracket notation

		;; ** INSERT CODE HERE **
		

		fget_ch[f], al			; discard newline between weight
								; and name (remember Java Scanner bug)

		;; write the code to read the name from the data file
		;; recall because name is a string, direct offset bracket
		;; notation is not allowed. you must move the register used
		;; above to store rax into another unused register and use
		;; add command to add the offset, then read the name into the
		;; new register

		;; ** INSERT CODE HERE **


endloop1:
		inc ebx			; increment ebx by 1
		jmp readfile	; go back through loop

endoffile:
		fclosem	[f]		; close file
		mov	[n],ebx		; n holds number of names in array
		xor ecx,ecx		; zero out ecx

display_loop:		
        cmp ecx,[n]			; compare ecx to n
        jge display_done	; ecx greater than or equal to n

        ;; get pointer to current record using Intel notation, putting
		;; that value into the register used to originally store rax

		;; ** INSERT CODE HERE **
  

        ;; display starting address of the addresses (pointers)
		
		;; ** INSERT CODE HERE **


        put_str endl

        ;; display rank using appropriate bracket offset notation

		;; ** INSERT CODE HERE **
 

        put_str endl

        ;; display height using appropriate bracket offset notation

		;; ** INSERT CODE HERE **


        put_str endl

        ;; display weight using appropriate bracket offset notation

		;; ** INSERT CODE HERE **
 

        put_str endl

		;; display name using appropriate approach
		;; recall bracket offset notation cannot be used
		;; works the same as reading name, but displays the new
		;; register used (move, add, display)

		;; ** INSERT CODE HERE **


        put_str endl
 
        inc ecx				; increment ecx
        jmp display_loop

display_done:
	jmp alldone

failed:	
		put_str	fileerror	; "error opening your file"
		put_ch	[endl]

alldone:
		add		rsp,8
		mov     rax, 60                 ; system call 60 is exit
		xor     rdi, rdi                ; exit code 0
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits