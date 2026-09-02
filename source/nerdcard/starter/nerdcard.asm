;
; Builds nerd cards and uses bit operations to perform various actions.
;
; To compile:
; gcc -c readcodes.c
; nasm -f elf64 nerdcard.asm
; gcc nerdcard.o readcodes.o
; ./a.out
;
; A code record looks like this:
;
; Code {
;	int id;
;	int score;
;	char description[256];
; };
;
;
; A nerd record will look like this:
;
; Nerd {
;	char name[80];
;	long code;
; };
;
%include "iomacros.asm"
%include "dumpregs.asm"
%define ID 0
%define SCORE 4
%define DESCRIPTION 8

		extern readCodes
		section .data
codefile:	db	"codes.txt",0
space:		db	" ",0
endl		db	10,0


		section .bss
codes:		resq	64		; up to 64 codes are supported
coden:		resq	1		; number of nerds we have

		section .text
		global 		main
main:

		; coden= readCodes(codes,codefile)
		mov	rdi,codes
		mov	rsi,codefile
		call	readCodes
		mov	[coden],rax

		put_i	[coden]
		put_str	endl


		; displayCodes(codes,n)
		mov	rdi,codes
		mov	rsi,[coden]
		call	displayCodes

theend:
		mov     eax, 60
		xor     rdi, rdi
		syscall


;--------------------------------------------------------------------------------
; displayCodes(codes,n)
;---------------------------
; display codes along with id numbers
;
displayCodes:
		xor	rcx,rcx

displayCodesLoop:
		cmp	rcx,rsi
		jge	endDisplayCodes
		mov	r8,[rdi+8*rcx]
		put_i	[r8+ID]
		put_ch	[space]
		put_i	[r8+SCORE]
		put_ch	[space]
		add	r8,DESCRIPTION
		put_str	r8
		put_str	endl
		inc	rcx
		jmp	displayCodesLoop

endDisplayCodes:
		mov	rax,rcx
		ret
