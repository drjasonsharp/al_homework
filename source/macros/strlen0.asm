;
; We demonstrate writing a macro to calculate the length of a string.
;
; @author  T.Sergeant
; @version 0
;
; In this version we demonstrate a simple macro that has some shortcomings.
;

%include "iomacros.asm"
%include "dumpregs.asm"

; given an address of a string we traverse the string one character at a time
; looking for a 0-byte counting as we go.
%macro	strlen 1			; 1 here specifies we expect 1 argument
		xor	rdi,rdi
strlenloop:	cmp	byte [%1+rdi],0
		je	endstrlen
		inc	rdi
		jmp	strlenloop
endstrlen:	mov	rax,rdi
%endmacro


		global main
		section .data

str1:		db	"Here's a string",0
str2:		db	"Another",0
str3:		db	0
str4:		db	"So fun"
str5:		db	"and funny"
length_str:	db	"Length of string: ",0
endl:		db	10,0


		section .text

main:
		strlen	str1
		put_str	length_str
		put_i	eax
		put_str	endl

;		what happens when we uncomment these lines?
		strlen	str2
		put_str	length_str
		put_i	eax
		put_str	endl


		mov     rax, 60                 ; exit 0
		xor     rdi, rdi
		syscall

