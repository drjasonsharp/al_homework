; IMPORTANT NOTE: This code is seg faulting on the call to readCodes ...
; I played with it quite a while but can't get anything to work. Most of my
; playing involved using -no-pie with gcc commands. This same code works on
; the csci server ... but unfortunately I will be grading it on josephus.
;
; After further exploration I have found that if the fget_i command
; appears in a function (i.e., reached from a call statement) it will
; crash. Otherwise, it works as expected!
;
; So, my lame-o solution is to write the fget code in "main" in assembly.
; But I abandoned that b/c the assignment asks them to read the nerd
; file in a function. So ... I'll just grade on csci.hstux.edu
;
; After a night's rest I realized it is the fscanf function that is
; crashing ... not sure why ... but fgets will likely work.
; @author  Terry Sergeant
; @version Fall 2020
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


%include "../iomacros.asm"
%include "../dumpregs.asm"
%define RECSIZE 264
%define ID 0
%define SCORE 4
%define DESCRIPTION 8
%define DESC_SIZE 256
%define NERDLEN 88
%define NAMELEN 80
%define NAME 0
%define CODE 80

		extern readCodes
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


		; nerdn= readNerds(data)
		mov	rdi,nerds
		call	readNerds
		mov	[nerdn],rax

		; displayNerds(nerds,n)
		mov	rdi,nerds
		mov	rsi,[nerdn]
		call	displayNerds

		; displayCommon(codes,nerds,n)
		mov	rdi,codes
		mov	rsi,nerds
		mov	rdx,[nerdn]
		call	displayCommon

		; displayElusive(codes,nerds,n)
		mov	rdi,codes
		mov	rsi,nerds
		mov	rdx,[nerdn]
		call	displayElusive

theend:
		mov     eax, 60
		xor     rdi, rdi
		syscall


;--------------------------------------------------------------------------------
; interpretCode(codes, bitstring)
;              (rdi      , rsi      )
;---------------------------------
; given a bit-string, display the achievements represented by it

interpretCode:
		xor	rcx,rcx
		mov	r8,1

showCodeLoop:
		cmp	rcx,[coden]
		jge	endInterpret

		test	rsi,r8		; bit-wise AND of rsi & r8
		je	skip
		put_i	ecx
		put_ch	[space]
		mov	r9,[rdi+8*rcx]
		add	r9,DESCRIPTION
		put_str	r9
		put_str	endl
skip:
		inc	rcx
		shl	r8,1
		jmp	showCodeLoop

endInterpret:
		ret


;--------------------------------------------------------------------------------
; displayElusive(codeindex, data, num )
;              (rdi      , rsi , rdx)
;---------------------------------
; displays achievements that everyone has accomplished
displayElusive:
		xor	rcx,rcx
		xor	r8,r8

calcCodeLoop2:
		cmp	rcx,rdx
		jge	showCode2

		or	r8,[rsi+CODE]
		add	rsi,NERDLEN
		inc	rcx
		jmp	calcCodeLoop2

showCode2:
		not	r8
		put_str	endl
		put_str	endl
		put_str	line
		put_str	elusiveHeader
		put_str	line
		mov	rsi,r8
		call	interpretCode
		ret


;--------------------------------------------------------------------------------
; displayCommon(codes, nerds, num )
;              (rdi      , rsi , rdx)
;---------------------------------
; displays achievements that everyone has accomplished
displayCommon:
		xor	rcx,rcx
		mov	r8,-1		; r8=1111111111

calcCodeLoop:
		cmp	rcx,rdx
		jge	showCode

		and	r8,[rsi+CODE]
		add	rsi,NERDLEN
		inc	rcx
		jmp	calcCodeLoop

showCode:
		put_str	endl
		put_str	endl
		put_str	line
		put_str	commonHeader
		put_str	line
		mov	rsi,r8
		call	interpretCode
		ret


;--------------------------------------------------------------------------------
; displayCodes(code,n)
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


;--------------------------------------------------------------------------------
; int readNerds(nerds)
;---------------------------
; load data from nerd file
; returns number of nerds read
;
readNerds:
		; rdi= nerd array
		xor	rsi,rsi		; rsi= # of elements we have read

		fopenr	rbx,nerdfile
		cmp	eax,-1
		je	endReadNerd

readNerdLoop:
		fget_str	rbx,rdi,NAMELEN
		cmp	eax,-1
		je	endReadNerd

		xor	rdx,rdx		; rdx= bit string we are building
readCodeList:
		fget_i	rbx,ecx		; read ecx
		cmp	eax,-1
		je	nextNerd

		; insert rsi into set (rdx)
		mov	r8,1
		shl	r8,cl		; shl requires use of cl
		or	rdx,r8
		jmp	readCodeList

nextNerd:
		mov	[rdi+CODE],rdx	; store bit string in array
		add	rdi,NERDLEN
		inc	rsi
		jmp	readNerdLoop

endReadNerd:
		fclosem	rbx
		mov	rax,rsi
		ret


;--------------------------------------------------------------------------------
; displayNerd(nerd,n)
;---------------------------
; display nerds along with id numbers
;
displayNerds:
		xor	rcx,rcx

displayNerdLoop:
		cmp	rcx,rsi
		jge	endDisplayNerd
		put_i	ecx
		put_ch	[space]
		put_str	rdi
		put_ch	[space]
		put_i	[rdi+CODE]
		;_p_reg	dword[rdi+CODE]
		put_str	endl
		add	rdi,NERDLEN
		inc	rcx
		jmp	displayNerdLoop

endDisplayNerd:
		mov	rax,rcx
		ret
