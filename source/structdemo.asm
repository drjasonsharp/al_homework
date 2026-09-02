;; 
;; structdemo.asm
;;
;; Here we demonstrate some struct/record concepts.
;;
;; by Terry Sergeant
;; Fall 2014
;;
;; Imagine the following struct/record/class:
;; class Student {
;;    int id;
;;    String name; // 40 characters
;;    double gpa;
;; }
%include "iomacros.asm"
%include "dumpregs.asm"
%define N 10

		global main
		extern printf,fflush,scanf

		section .data

getid:		db	"Enter (int) id: ",0
getname:		db	"Enter name    : ",0
getgpa:		db	"Enter gpa     : ",0
putid:		db	"ID   : ",0
putname:		db	"NAME : ",0
putgpa:		db	"GPA  : ",0
endl:		db	10,0
studentfile:	db	"students.txt",0

		section .bss

student:		resb	52		; space for one student record
students:		resb	52*100		; space for 100 student records
junk:		resb	120
fp:		resq	1


		section .text

main:
		; to work with the struct we leave room for all parts 
		; and then access the parts via offsets
		put_str	getid
		get_i	[student]
		get_str	junk		; consume leftover \n

		put_str	getname
		get_str	student+4

		put_str	getgpa
		get_dbl	[student+44]

		put_str	putid
		put_i	[student]
		put_str	endl
		put_str	putname
		put_str	student+4
		put_str	endl
		put_str	putgpa
		put_dbl	[student+44]
		put_str	endl

		; it can be clearer to refer to offset via a named constant

		%define	ID 0
		%define	NAME 4
		%define	GPA 44

		put_str	putid
		put_i	[student+ID]
		put_str	endl
		put_str	putname
		put_str	student+NAME
		put_str	endl
		put_str	putgpa
		put_dbl	[student+GPA]
		put_str	endl

		; the following code demonstrates IO macros code to read from a data file
		; into an array of structs; then we have the user enter an id number to search
		; for ... when we find it we display the associated data.

		fopenr	[fp],studentfile
		mov	rbx,students
		xor	r8,r8
		fget_i	[fp],[rbx+ID]
while1:		
		cmp	eax,-1
		je	eof
		fget_dbl	[fp],[rbx+GPA]
		fget_ch	[fp],al
		mov	rcx,rbx		; calculate address of name
		add	rcx,NAME		; b/c IO macros to read string requires
		fget_str	[fp],rcx		; an address
		put_i	[rbx+ID]
		put_str	endl
		add	rbx,52
		inc	r8
		fget_i	[fp],[rbx+ID]
		jmp	while1

eof:
		fclosem	[fp]


		put_str	getid		; r8d is number of elements read from file
		mov	rbx,students	; rbx is address of the current student we are looking at
		get_i	r9d		; r9d is id to find
		xor	edi,edi		; edi is loop counter
while2:		cmp	edi,r9d
		jge	end2
		cmp	[rbx+ID],r9d
		je	foundit
		inc	edi
		add	rbx,52
		jmp	while2

foundit:		put_str	putid
		put_i	[rbx+ID]
		put_str	endl
		put_str	putname
		mov	rcx,rbx
		add	rcx,NAME
		put_str	rcx
		put_str	endl
		put_str	putgpa
		put_dbl	[rbx+GPA]
		put_str	endl


end2:
		; exit(0)
theend:		mov     eax, 60
		xor     rdi, rdi
		syscall


