;
; We demonstrate writing a macro to calculate the length of a string.
;
; @author  T.Sergeant
; @version 3
;
; In this version we fix the issue of having registers as parameters to macros
; and introduce the problem of ... well, problem displacement.
;

%include "iomacros.asm"
%include "dumpregs.asm"

; given an address of a string we traverse the string one character at a time
; looking for a 0-byte counting as we go.
%macro	strlen 1			; 1 here specifies we expect 1 argument
		xor	rax,rax
%%strlenloop:	cmp	byte [%1+rax],0
		je	%%endstrlen
		inc	rax
		jmp	%%strlenloop
%%endstrlen:
%endmacro


		global main
		section .data

str1:		db	"Here's a string",0
str2:		db	"Another",0
str3:		db	0
str4:		db	"So fun"
str5:		db	"and funny"
length_str:	db	"Length of string: ",0
hereisedi:	db	"Here is the glorious value of edi: ",0
endl:		db	10,0


		section .text

main:

		mov	edi,-1
		put_str	hereisedi
		put_i	edi
		put_str	endl

		; what if we put the address of the string in a register?
		; predict results ...
		mov	rbx,str1
		strlen	rbx
		put_str	length_str
		put_i	eax
		put_str	endl

		put_str	hereisedi
		put_i	edi
		put_str	endl

		; what if we put the address in rdi? Why might this be a problem?
		mov	rdi,str2
		strlen	rdi
		put_str	length_str
		put_i	eax
		put_str	endl

		; but did we really solve anything?
		mov	rax,str1
		strlen	rax
		put_str	length_str
		put_i	eax
		put_str	endl

		mov     rax, 60                 ; exit 0
		xor     rdi, rdi
		syscall

