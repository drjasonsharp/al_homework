;
; Demonstrate I/O issues with floating point numbers.
;
; @author  Terry Sergeant
;

%include "iomacros.asm"

		section .data
pi:		dq	3.141592653589793       ; PI
e:		dq	2.71828182845904523536  ; Euler's constant
phi:		dq	1.6180339887            ; golden ratio
av:		dq	6.022141e23             ; Avagadro's number
gr:		dq	6.674e-11               ; gravitational constant
one:		dq	1.0			; one
endl:		db	10,0


		section .bss
ans:		resq	1

		section .text

		global 		main
main:
		movsd	xmm0,[pi]	; put pi in xmm0
		movsd	xmm1,[e]	; put e in xmm1
		movsd	xmm2,[phi]	; put phi in xmm2
		movsd	xmm3,[av]	; put av in xmm3
		movsd	xmm4,[gr]	; put gr in xmm4
		movsd	xmm5,[one]	; put one in xmm5

		movsd	xmm0,[pi]
		addsd	xmm0,[e]
		movsd	[ans],xmm0
		put_dbl	[ans]
		put_str	endl

		; NOTE: put_dbl destroys some of the xmm registers
		; Add statements below to figure out which xmm registers got messed up

alldone: 	mov	ebx,0		; return 0
		mov	eax,1		; on
		int	80h		; exit

