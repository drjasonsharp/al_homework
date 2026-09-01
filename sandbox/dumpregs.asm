;;
;; dumpregs.asm
;;
;; Programmer : Terry Sergeant
;; Version    : 11 Oct 2022
;; Description: macros useful for showing contents of registers ... can
;;	be helpful in debugging, etc.
;;
;; 11 Oct 2022 NOTES - For systems that require gcc -no-pie switch we must
;;   make sure that the stack is aligned which means that we need an even
;;   number of pushes ... if odd we add "sub rsp" statements. Also, on such
;;   systems, the call to fflush in _p_reg was crashing so it has been removed.
;;

		extern printf

		section	.data

__FORMAT_DBL:	db	"%1.20lf",0
__FORMAT_REG:	db	"%08x",0
__RAX:		db	"RAX",0
__RBX:		db	"RBX",0
__RCX:		db	"RCX",0
__RDX:		db	"RDX",0
__RBP:		db	"RBP",0
__RSI:		db	"RSI",0
__RDI:		db	"RDI",0
__RSP:		db	"RSP",0
__R8:		db	"R8 ",0
__R9:		db	"R9 ",0
__R10:		db	"R10",0
__R11:		db	"R11",0
__R12:		db	"R12",0
__R13:		db	"R13",0
__R14:		db	"R14",0
__R15:		db	"R15",0
__RIP:		db	"RIP",0
__RFLAGS:	db	"FLG",0
__SPACE:	db	" ",0
__SPACES:	db	"        ",0
__NL:		db	10,0
__COLON:	db	": ",0
__XMMx:		db	"XMMx",0


		section .bss

__tmp:		resd	1
__tmp2:		resd	1
__temp_hex:	resq	1
__temp_dbl:	resq	1


		section .text

%macro	_p_s	1		; 1 here specifies we expect 1 argument
	push	rdi		; save context
	push	rsi
	push	rax
	push	rcx
	push	rdx
	push	r8
	push	r9
	push	r10
	push	r11
	push	r12

	mov	rdi,%1		; %1 is the name of the first argument
	xor	rax,rax		; clear rax
	call	printf

	pop	r12		; restore context
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	rdx
	pop	rcx
	pop	rax
	pop	rsi
	pop	rdi
%endmacro


; _p_reg register
;------------------
; Displays the contents of a 64-bit register in hexadecimal with the
; upper- and lower- 4-byte segments separated by a space. Any newlines
; needs to be added by the caller.
;
; We put the specified register into memory which allows us to see
; even registers that are used by C's printf. Also, printf treats
; parameters with "x" format string as 32-bit entities, so we
; have to call it twice with upper- and lower- segments of
; the register.
;-----------------------------------------------------------
%macro _p_reg 1
	push	rdi		; save context
	push	rsi
	push	rax
	push	rcx
	push	rdx
	push	r8
	push	r9
	push	r10
	push	r11
	push	r12

	mov	[__tmp],%1	; put reg to display into tmp

	mov	rdi,__FORMAT_REG
	mov	rsi,[__tmp2]	; print upper 32 bits
	xor	rax,rax
	call	printf

	mov	rdi,__SPACE	; print space
	xor	rax,rax
	call	printf

	mov	rdi,__FORMAT_REG
	mov	rsi,[__tmp]	; print lower 32 bits
	xor	rax,rax
	call	printf

	pop	r12
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	rdx
	pop	rcx
	pop	rax
	pop	rsi
	pop	rdi
%endmacro


; put_rflags
;-------------
; Displays the contents of the elusive rflags register.
;
; RFLAGS is modified by many instructions and so to get
; a snapshot we have to push its contents onto the stack
; prior to doing anything else. Then we pop its contents
; into a general purpose register to print it from there.
; After it's all said and done we need to restore its
; values and restore the temporary register as well.
;-----------------------------------------------------------
%macro put_rflags 0
	push	r15		; save r15 (temporary reg)
	pushfq			; pushfq to get rflags on stack
	pop	r15		; pop rflags off into r15
	sub	rsp,8
	_p_s	__RFLAGS	; modified by instructions, so ...
	_p_s	__COLON
	_p_reg	r15		; display it
	_p_s	__NL
	add	rsp,8
	push	r15		; push rflags value back on stack
	popfq			; pop it from stack into rflags
	pop	r15		; restore r15 to its orginal value
%endmacro



; _p_dbl
;-------------
; Displays contents of the argument as a double-precision floating
; point value.
;-----------------------------------------------------------
%macro	_p_dbl	1		; 1 here specifies we expect 1 argument
	push	rdi		; save context
	push	rsi
	push	rax
	push	rcx
	push	rdx
	push	r8
	push	r9
	push	r10
	push	r11
	push	r12

	; floating point values must be passed to printf in xmm0
	sub	rsp,16
	movdqu	[rsp],xmm0

	mov	rax, %1
	movq	xmm0, rax
	mov	rdi,__FORMAT_DBL
	mov	rax,1
	call	printf

	movdqu	xmm0,[rsp]
	add	rsp,16

	pop	r12		; restore context
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	rdx
	pop	rcx
	pop	rax
	pop	rsi
	pop	rdi
%endmacro




; _p_fpu
;-------------
; Displays contents of the FPU registers ST0-ST7 ... as 64-bit values
;-----------------------------------------------------------
%macro _p_xmm	1
	push	rax		; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8


	mov	al,%1
	add	al,0x30
	mov	[__XMMx+3],al
	_p_s	__XMMx
	_p_s	__COLON
	_p_dbl	[__temp_dbl]
	_p_s	__SPACE
	_p_s	__NL

	add	rsp,8
	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rax
%endmacro





; dump_xmm
;-------------
; Displays contents of the XMM0-XMM7 registers (as doubles)
;-----------------------------------------------------------
%macro dump_xmm 0
	movq	[__temp_dbl], xmm0
	_p_xmm	0
	movq	[__temp_dbl], xmm1
	_p_xmm	1
	movq	[__temp_dbl], xmm2
	_p_xmm	2
	movq	[__temp_dbl], xmm3
	_p_xmm	3
	movq	[__temp_dbl], xmm4
	_p_xmm	4
	movq	[__temp_dbl], xmm5
	_p_xmm	5
	movq	[__temp_dbl], xmm6
	_p_xmm	6
	movq	[__temp_dbl], xmm7
	_p_xmm	7
%endmacro


; dump_regs
;-------------
; Displays contents of all general purpose registers.
;-----------------------------------------------------------
%macro dump_regs 0
	_p_s	__RAX
	_p_s	__COLON
	_p_reg	rax
	_p_s	__SPACES
	_p_s	__R8
	_p_s	__COLON
	_p_reg	r8
	_p_s	__NL

	_p_s	__RBX
	_p_s	__COLON
	_p_reg	rbx
	_p_s	__SPACES
	_p_s	__R9
	_p_s	__COLON
	_p_reg	r9
	_p_s	__NL

	_p_s	__RCX
	_p_s	__COLON
	_p_reg	rcx
	_p_s	__SPACES
	_p_s	__R10
	_p_s	__COLON
	_p_reg	r10
	_p_s	__NL

	_p_s	__RDX
	_p_s	__COLON
	_p_reg	rdx
	_p_s	__SPACES
	_p_s	__R11
	_p_s	__COLON
	_p_reg	r11
	_p_s	__NL

	_p_s	__RBP
	_p_s	__COLON
	_p_reg	rbp
	_p_s	__SPACES
	_p_s	__R12
	_p_s	__COLON
	_p_reg	r12
	_p_s	__NL

	_p_s	__RSI
	_p_s	__COLON
	_p_reg	rsi
	_p_s	__SPACES
	_p_s	__R13
	_p_s	__COLON
	_p_reg	r13
	_p_s	__NL

	_p_s	__RDI
	_p_s	__COLON
	_p_reg	rdi
	_p_s	__SPACES
	_p_s	__R14
	_p_s	__COLON
	_p_reg	r14
	_p_s	__NL

	_p_s	__RSP
	_p_s	__COLON
	_p_reg	rsp
	_p_s	__SPACES
	_p_s	__R15
	_p_s	__COLON
	_p_reg	r15
	_p_s	__NL

%endmacro
