;
; We demonstrate writing a macro to calculate the length of a string.
;
; @author  T.Sergeant
; @version 3
;
; In this version we take another stab at having a parameter match one of
; our working variables. One possible solution is to announce in the documentation
; that rax cannot be used to hold the address of a string. Or ...
;

%include "iomacros.asm"
%include "dumpregs.asm"

; given an address of a string we traverse the string one character at a time
; looking for a 0-byte counting as we go.
; IMPORTANT NOTE:
;   * These conditional statements do not get executed when the program runs.
;     Rather, they are executed by the assembler (NASM) when the program is being
;     assembled. That is the assembler replaces "strlen rdx" with:
;                    xor rax,rax
; %%strlenloop1_xyz: cmp byte [rdx+rax],0
;                    je  %%endstrlen_xyz
;                    inc rax
;                    jmp %%strlenloop1_xyz
; %%endstrlen_xyz:
;
; conversely "strlen rax" is replaced by:
;
;                    push rdi
;                    mov  rdi,rax
;                    xor rax,rax
; %%strlenloop2_xyz: cmp byte [rdi+rax],0
;                    je  %%endstrlen_xyz
;                    inc rax
;                    jmp %%strlenloop2_xyz
; %%endstrlen_xyz:
;                    pop rdi

%macro	strlen 1			; 1 here specifies we expect 1 argument
%ifidni		%1,rax			; if they are calling with address of
		push	rdi		; string in rax we'll copy address to rdi
		mov	rdi,%1		; and then use rdi as base address
		xor	rax,rax
%%strlenloop1:	cmp	byte [rdi+rax],0
		je	%%endstrlen
		inc	rax
		jmp	%%strlenloop1
%else
		xor	rax,rax         ; otherwise we proceed as we normally would
%%strlenloop2:	cmp	byte [%1+rax],0
		je	%%endstrlen
		inc	rax
		jmp	%%strlenloop2
%endif

%%endstrlen:

%ifidni		%1,rax			; restore rdi if necessary
		pop	rdi
%endif
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

		mov	rax,str2
		strlen	rax
		put_str	length_str
		put_i	eax
		put_str	endl

		put_str	hereisedi
		put_i	edi
		put_str	endl

		mov     rax, 60                 ; exit 0
		xor     rdi, rdi
		syscall

