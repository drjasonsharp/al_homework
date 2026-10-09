;;
;; hw06_start.asm
;;
;; by YOUR NAME
;; Fall 2026
;;
;; Reads stats about sumo wrestlers from sumo.txt and puts it into
;; a struct as follows:
;;   struct sumoStruct {
;;     int  rank;        // 1 is best rank ... up to n
;;     int  height;      // in cm
;;     int  weight;      // in kg
;;     char name[20];    // Last name is first
;;   };
;;
;; There are at most 100 names in sumo.txt.  The input file has one
;; record per line with entries separated by spaces.  The format is:
;;   rank height weight name
;;    .     .      .     .
;;    .     .      .     .
;;   rank height weight name
;;
;;
%include "iomacros.asm"
%include "dumpregs.asm"
; ** complete the %define statements by adding the appropriate values for each **
%define NAMESIZE ??		; ** insert the size of name string **
%define RECSIZE  ??		; ** insert the size of the entire record (three numbers and a string) **
%define MAXNAMES ??		; ** insert the most number of names in sumo.txt file **
%define RANK 	 ??		; ** insert the offset of the rank field within sumoStruct **
%define HEIGHT 	 ??		; ** insert the offset of the height field within sumoStruct **
%define WEIGHT 	 ??		; ** insert the offset of the weight field within sumoStruct **
%define NAME 	 ??		; ** insert the offset of the name field within sumoStruct **

		section .data
fname:		db	"sumo.txt",0
fileerror:	db	"There was an error opening your file.",0
debug:		db	"Made it here",10,0
endl:		db	0Ah,0

		section .bss
sumo:	resb	??					; ** insert code to reserve space for an array
									; big enough to hold 100 sumo records (100 * record size)
									; using constants declared previously  **
n:		resd	1					; number of names in array
f:		resd	1					; file pointer

		section .text
		global 		main
main:
		sub	rsp,8

		fopenr	[f],fname		; open "sumo.txt" to read
		cmp	eax,0
		jne	successful
		jmp	failed

successful:
		mov	rdi,sumo			; RDI holds addr of next struct
		mov	rsi,0				; ESI holds counter

readfile:		
		fget_i	[f], ??			 ; ** insert code attempt to read rank from the file using [] notation and offset **
		cmp	eax,-1				 ; check for end of file
  		je	endoffile
		; next record exists, so we read remaining fields ...
		fget_i	[f], ??			 ; ** insert code to read height from the file using [] notation and offset **
		fget_i	[f], ??			 ; ** insert code to read weight from the file using [] notation and offset **
		fget_ch	[f],bl			 ; skip space before name
		mov	??				 	 ; ** insert code to move address of rdi into r10 **
		add	??					 ; ** insert code to add NAME offset to r10 **
		fget_str [f], ??		 ; ** insert code to read name stored in r10 **

		; display record placing a blank in between each field

		put_i	??				; ** insert code to display rank using the value of rdi plus offset **
		put_ch	bl				; place a blank between rank and height
		put_i	??				; ** insert code to display height using the value of rdi plus offset **
		put_ch	bl				; place a blank between height and weight
		put_i	??				; ** insert code to display rank weight the value of rdi plus offset **
		put_ch	bl				; place a blank between weight and name
		put_str	??				; ** insert code to display name using r10 **
		put_str endl

endloop1:
		inc	rsi					; i++
		add	rdi,RECSIZE			; EDI is addr of next sumo[i]
		jmp	readfile			; go back through loop

endoffile:
		fclosem	[f]				; close file
		mov	[n],esi				; n holds number of names in array
		jmp alldone

failed:	
		put_str	fileerror		; "error opening your file"
		put_ch	[endl]

alldone:
		add		rsp,8
		mov     rax, 60          ; system call 60 is exit
		xor     rdi, rdi         ; exit code 0
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits