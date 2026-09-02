; IMPORTANT NOTE: This code is seg faulting on the call to readCodes ...
; I played with it quite a while but can't get anything to work. Most of my
; playing involved using -no-pie with gcc commands. This same code works on
; the csci server ... but unfortunately I have been testing it on josephus.
; So, I'm going to rewrite the readCodes() function in assembly in hopes
; that the problem will be fixed ...
;
; Builds nerd cards and uses bit operations to perform various actions.
;
; @author  Terry Sergeant
; @version Fall 2016
;
;struct Code {
;	int id;
;	int score;
;	char description[256];
;};
;
;struct Nerd {
;	char name[80];
;	long code;
;};

default abs
%include "../iomacros.asm"
;%include "../dumpregs.asm"
%define RECSIZE 264
%define ID 0
%define SCORE 4
%define DESCRIPTION 8
%define DESC_SIZE 256
%define NERDLEN 88
%define NAMELEN 80
%define NAME 0
%define CODE 80

		section .data
codefile:	db	"codes.txt",0
nerdfile:	db	"nerds.txt",0
space:		db	" ",0
endl		db	10,0
elusiveHeader:	db	"Achievements Nobody Has ...",10,0
commonHeader:	db	"Achievements Everyone Has ...",10,0
line:		db	"------------------------------------------",10,0



		section .bss
codes:		resb	8*64		; up to 64 codes are supported
nerds:		resb	NERDLEN*1000	; up to 1000 people tracked
nerdn:		resq	1		; number of nerds we have
coden:		resq	1		; number of codes we have
fp:		resq	1
cools:		resb	200

		section .text
		global 		main
main:

		mov	rsi, codefile
		call	readCodes


		jmp	theend

readCodes:
		fopenr	[fp],codefile

readCodesLoop:
		fget_i	[fp],r9d
		cmp	eax,-1
		je	endReadCodes
		put_str	rsi
		put_str	endl
		fget_i	[fp],ecx
		fget_ch	[fp],al
		fget_str [fp],cools

		put_i	ebx
		put_ch	32
		put_i	ecx
		put_ch	32
		put_str	cools
		put_str	endl

		jmp	readCodesLoop

endReadCodes:
		fclosem	[fp]

		ret

theend:
		mov     eax, 60
		xor     rdi, rdi
		syscall
