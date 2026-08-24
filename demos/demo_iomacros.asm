;;
;; demo_iomacros.asm
;;
;; We demonstrate usages of the IO macros.
;;
;; by TSergeant
;;

%include "../lib/dumpregs.asm"
%include "../lib/iomacros.asm"

		global main

		section .data
fun:		db	"Hello",0
fun2:		db	"Tovarish",0
num:		dd	12334
num2:		dd	98776
hex:		dd	0x12345678
fpnum2:		dd	4.23
fpnum:		dq	1.23
sumo:		db	"sumo.txt",0
endl:		db	10,0
outfile:	db	"outfile.txt",0


		section .bss
mych:		resb	1
mystr:		resb	10
mynum:		resd	1
mydbl:		resq	1
mydbl2:		resq	1
myf:		resd	1
myf2:		resd	1
fp:		resq	1
bigstr:		resb	120


		section .text

main:
		mov	rax,-1
		mov	rbx,-1
		mov	rcx,-1
		mov	rdx,-1
		mov	rsi,-1
		mov	rdi,-1
		mov	r8,-1
		mov	r9,-1
		mov	r10,-1
		mov	r11,-1
		mov	r12,-1
		mov	r13,-1
		mov	r14,-1
		mov	r15,-1

		dump_regs
		fopenw	[fp],outfile
		fput_ch	[fp],'A'
		fput_ch	[fp],[fun]
		fput_str [fp],endl
		fput_str [fp],fun2
		fput_str [fp],endl
		fput_i	[fp],[num2]
		fput_str [fp],endl
		fput_i	[fp],78
		fput_str [fp],endl
		fput_f	[fp],[fpnum2]
		fput_str [fp],endl
		fput_dbl [fp],[fpnum]
		fput_str [fp],endl
		;fget_i	[fp],[myf]
		fclosem	[fp]
		dump_regs

		; demo put_ch

		mov	al,[fun]
		put_ch	al
		put_ch	'e'
		put_ch	[fun]
		mov	r8b,[fun+4]
		put_ch	r8b
		put_str	__NL

		; test put_str
		mov	rax,fun
		put_str	rax
		put_str	__NL
		put_str	fun2
		put_str	__NL

		; test put_i
		mov	rax,-1
		put_i	[num]
		put_str	__NL
		mov	eax,[num+4]
		put_i	eax
		put_str	__NL
		mov	esi,[num2]
		put_i	esi
		put_str	__NL
		put_i	7888
		put_str	__NL

		; test put_x
		put_x	[hex]
		put_str	__NL
		mov	esi,[hex]
		put_x	esi
		put_str	__NL
		put_x	7888
		put_str	__NL



		; test put_f
		put_f	[fpnum2]
		put_str	__NL
		mov	eax,[fpnum2]
		put_f	eax
		put_str	__NL

		; test put_dbl
		put_dbl	[fpnum]
		put_str	__NL
		mov	rax,[fpnum]
		put_dbl rax
		put_str	__NL

		; test get_ch
		;get_ch	cl
		;put_ch	cl
		;put_str	__NL
		;get_ch	ah		; NOTE: leftover \n is consumed
		;put_ch	ah
		;put_str	__NL
		;get_ch	[mych]
		;put_ch	[mych]
		;put_str	__NL
		;get_ch	al		; consumer leftover \n

		; test get_str
		;mov	rbx,mystr
		;mov	rax,10
		;get_str	rbx,rax
		;put_str	rbx
		;put_str	__NL
		;get_str	mystr
		;put_str	mystr
		;put_str	__NL

		; test get_i
		;get_i	ebx
		;put_i	ebx
		;put_str	__NL
		;mov	rbx,mynum
		;get_i	[rbx]
		;put_i	[rbx]
		;put_str	__NL
		;get_i	[mynum]
		;put_i	[mynum]
		;put_str	__NL

; NEXT write and test get_dbl and get_f

		; test get_dbl
		;dump_regs
		;mov	edi,mydbl
		;get_dbl	[edi+8]
		;dump_regs
		;put_dbl [mydbl2]
		;put_str	__NL

		; test get_f
		;dump_regs
		;get_f	ebx
		;dump_regs
		;put_f ebx
		;put_str	__NL
		;mov	edi,myf
		;get_f	[edi+4]
		;dump_regs
		;put_f [myf2]
		;put_str	__NL

		mov     eax, 60                 ; exit 0
		xor     rdi, rdi
		syscall

