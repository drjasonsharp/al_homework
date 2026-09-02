;;
;; nerdcard.asm
;;
;; Builds nerd cards and uses bit operations to perform various actions.
;; Based on hw09 ...
;;
;; by Terry Sergeant
;; Fall 2014
;;

;; NOT DONE! in readData need to build codes
;; then need to add required actions
%include "iomacros.asm"
%include "dumpregs.asm"
%define CODELEN 80
%define NAMELEN 20
%define CODE 20
%define DATALEN 28

		section .data
codefile:		db	"codes.txt",0
datafile:		db	"nerdcard.txt",0
space:		db	" ",0
endl		db	10,0
whatever:		db	"aslkdfj laskdjf lask fj",0
elusiveHeader:	db	"Achievements Nobody Has ...",10,0
commonHeader:	db	"Achievements Everyone Has ...",10,0
line:		db	"------------------------------------------",10,0



		section .bss
codes:		resb	CODELEN*100	; up to 100 codes
codeindex:	resq	100		; traverse code with the index
coden:		resq	1		; number of codes we have
data:		resb	DATALEN*1000	; up to 1000 people tracked
datan:		resq	1		; number of people we have

		section .text
		global 		main
main:

		; coden= readCodes(code,codeindex)
		mov	rdi,codes
		mov	rsi,codeindex
		call	readCodes
		mov	[coden],rax

		; displayCode(codeindex,n)
		mov	rdi,codeindex
		mov	rsi,[coden]
		call	displayCodes

		; datan= readData(data)
		mov	rdi,data
		call	readData
		mov	[datan],rax

		; displayData(data,n)
		mov	rdi,data
		mov	rsi,[datan]
		call	displayData

		; displayCommon(codeindex,data,n)
		mov	rdi,codeindex
		mov	rsi,data
		mov	rdx,[datan]
		call	displayCommon

		; displayElusive(codeindex,data,n)
		mov	rdi,codeindex
		mov	rsi,data
		mov	rdx,[datan]
		call	displayElusive

theend:
		mov     eax, 60
		xor     rdi, rdi
		syscall


;--------------------------------------------------------------------------------
; interpretCode(codeindex, bitstring)
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
		put_str	[rdi+8*rcx]
		put_ch	[endl]
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

		or	r8,[rsi+NAMELEN]
		add	rsi,DATALEN
		inc	rcx
		jmp	calcCodeLoop2

showCode2:
		not	r8
		put_ch	[endl]
		put_ch	[endl]
		put_str	line
		put_str	elusiveHeader
		put_str	line
		mov	rsi,r8
		call	interpretCode
		ret


;--------------------------------------------------------------------------------
; displayCommon(codeindex, data, num )
;              (rdi      , rsi , rdx)
;---------------------------------
; displays achievements that everyone has accomplished
displayCommon:
		xor	rcx,rcx
		mov	r8,-1		; r8=1111111111

calcCodeLoop:
		cmp	rcx,rdx
		jge	showCode

		and	r8,[rsi+NAMELEN]
		add	rsi,DATALEN
		inc	rcx
		jmp	calcCodeLoop

showCode:
		put_ch	[endl]
		put_ch	[endl]
		put_str	line
		put_str	commonHeader
		put_str	line
		mov	rsi,r8
		call	interpretCode
		ret



;--------------------------------------------------------------------------------
; readCodes(code,codeindex)
;---------------------------
; load codes from file and establish codeindex
; returns number of codes read
;
readCodes:

		xor	rcx,rcx

		fopenr	rbx,codefile
		cmp	eax,-1
		je	endReadCodes


readCodesLoop:
		fget_str	rbx,rdi,CODELEN
		cmp	eax,-1
		je	endReadCodes
		mov	[rsi+8*rcx],rdi
		add	rdi,CODELEN
		inc	rcx
		jmp	readCodesLoop

endReadCodes:
		fclosem	rbx
		mov	rax,rcx
		ret


;--------------------------------------------------------------------------------
; displayCodes(codeindex,n)
;---------------------------
; display codes along with id numbers
;
displayCodes:
		xor	rcx,rcx

displayCodesLoop:
		cmp	rcx,rsi
		jge	endDisplayCodes
		put_i	ecx
		put_ch	[space]
		put_str	[rdi+8*rcx]
		put_ch	[endl]
		inc	rcx
		jmp	displayCodesLoop

endDisplayCodes:
		mov	rax,rcx
		ret


;--------------------------------------------------------------------------------
; readData(data)
;---------------------------
; load data from file
; returns number of data elements read
;
readData:
		; rdi= data array
		xor	rsi,rsi		; rsi= # of elements we have read

		fopenr	rbx,datafile
		cmp	eax,-1
		je	endReadData

readDataLoop:
		fget_str	rbx,rdi,NAMELEN
		cmp	eax,-1
		je	endReadData

		xor	rdx,rdx		; rdx= bit string we are building
readCodeList:
		fget_i	rbx,ecx		; read ecx
		cmp	eax,-1
		je	nextData

		; insert rsi into set (rdx)
		mov	r8,1
		shl	r8,cl		; shl requires use of cl
		or	rdx,r8
		jmp	readCodeList

nextData:
		mov	[rdi+NAMELEN],rdx	; store bit string in array
		add	rdi,DATALEN
		inc	rsi
		jmp	readDataLoop

endReadData:
		fclosem	rbx
		mov	rax,rsi
		ret


;--------------------------------------------------------------------------------
; displayData(data,n)
;---------------------------
; display datas along with id numbers
;
displayData:
		xor	rcx,rcx

displayDataLoop:
		cmp	rcx,rsi
		jge	endDisplayData
		put_i	ecx
		put_ch	[space]
		put_str	rdi
		put_ch	[space]
		put_i	[rdi+NAMELEN]
		put_ch	[endl]
		add	rdi,DATALEN
		inc	rcx
		jmp	displayDataLoop

endDisplayData:
		mov	rax,rcx
		ret
