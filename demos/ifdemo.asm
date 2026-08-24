;; 
;; ifdemo.asm
;;
;; Here we demonstrate using cmp and j* commands to achieve equivalent 
;; statements to high level languages.
;;
;; by Terry Sergeant
;; Fall 2014
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		global main
		extern printf,fflush,scanf

		section .data

ENDL:		db	10,0
a:		db	"x < 0",0
b:		db	"x >= z && x <= 20",0
c:		db	"x < 0 || x > y",0
d:		db	"!(x==0 && y==0)",0
e:		db	"xd > yd",0
true:		db	": true",0
false:		db	": false",0
xlab		db	"x: ",0
ylab		db	"y: ",0
zlab		db	"z: ",0
xdlab		db	"xd: ",0
ydlab		db	"yd: ",0
zdlab		db	"zd: ",0

x:		dd	5
y:		dd	-5	
z:		dd	0

xd:		dq	5.5
yd:		dq	5.49999999
zd:		dq	0.0


		section .bss

mychar:		resb	1
mystr:		resb	80
myint:		resd	1
mydbl:		resq	1


		section .text

main:
		put_str	xlab
		put_i	[x]
		put_str	ENDL
		put_str	ylab
		put_i	[y]
		put_str	ENDL
		put_str	zlab
		put_i	[z]
		put_str	ENDL
		put_str	xdlab
		put_i	[xd]
		put_str	ENDL
		put_str	ydlab
		put_i	[yd]
		put_str	ENDL
		put_str	zdlab
		put_i	[zd]
		put_str	ENDL
		put_str	ENDL


		; if (x < 0)
		put_str	a
		cmp	dword [x],0
		jl	ifa
		put_str	false
		jmp	endifa
ifa:		put_str	true
endifa:		put_str	ENDL


		; if (x >= z && x <= 20)
		put_str	b
		mov	r8d,[x]
		cmp	r8d,[z]
		jl	elseb
		cmp	dword [x],20
		jg	elseb
		put_str	true
		jmp	endifb
elseb:		put_str	false
endifb:		put_str	ENDL


		; if (x < 0 || x > y)
		put_str	c
		cmp	dword [x],0
		jl	ifc
		mov	r8d,[x]
		cmp	r8d,[y]
		jg	ifc
		put_str	false
		jmp	endifc
ifc:		put_str	true
endifc:		put_str	ENDL

		; if (!(x==0 && y==0))
		put_str	d
		cmp	dword[x],0
		jne	ifd
		cmp	dword[y],0
		jne	ifd
		put_str	false
		jmp	endifd
ifd:		put_str	true
endifd:		put_str	ENDL


;-------------------------------------------------------------------------
; fcomi val --> cmp ST0,val
; fcomip val --> cmp ST0,val and then pop ST0
; fld val --> push val into ST0
; NOTE: after use fcomi commands you use ja,jb, etc., instead of jg, jl ...

		; if (xd > yd)
		put_str	e
		fld	qword [yd]
		fld	qword [xd]
		fcomip	ST1
		ja	ife
		put_str	false
		jmp	endife
ife:		put_str	true
endife:		fstp	qword[zd]
		put_str	ENDL


		; exit(0)
		mov     eax, 60
		xor     rdi, rdi
		syscall


