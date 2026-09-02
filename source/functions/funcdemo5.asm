;;
;; funcdemo5.asm
;;
;; Demonstrates writing a function to mimic the following code:
;;
;; tower(from,to,using,n)
;; {
;;    if (n==1)
;;      print "move from ",from," to ",to
;;    else {
;;      tower(from,using,to,n-1)
;;      tower(from,to,using,1)
;;      tower(using,to,from,n-1)
;; }
;;
;; We demonstrate stack-based and register-based calling conventions.
;;
;; by Terry Sergeant
;; For AL
;;
%include "../iomacros.asm"
%include "../dumpregs.asm"

		section .data
enternum:		db	"Enter number: ",0
movefrom:		db	"Move from ",0
moveto:		db	" to ",0
endl		db	0AH,0
welcome:		db	"welcome",10,0


		section .text
		global 		main
main:

		put_str	enternum
		get_i	ecx

		; stack-based parameters
		; tower(1,2,3,n)
		push	rcx	; n
		push	qword 3	; using
		push	qword 2	; to
		push	qword 1	; from
		;call	tower
		add	rsp,32


		; register-based parameters
		mov	edi,1
		mov	esi,2
		mov	rdx,3
		call	tower2	; rcx already contains n

;
theend:		mov     eax, 60
		xor     rdi, rdi
		syscall


tower:
		push	rbp
		mov	rbp,rsp
		push	r8

		mov	r8,[rbp+40]	; r8= n
		cmp	r8,1
		je	basecondition

basecondition:
		put_str	movefrom
		put_i	[rbp+16]
		put_str	moveto
		put_i	[rbp+24]
		put_str	endl

endtower:
		pop	r8
		pop	rbp
		ret


tower2:
		cmp	rcx,1
		je	basecondition2

		; tower(rdi,rsi,rdx,rcx)
		; tower(from,using,to,n-1)
		dec	rcx		; rcx= n-1
		push	rcx		; save regs b/c they'll
		push	rdx		; get scrambed in recursive call
		push	rsi
		push	rdi

		mov	r8,rsi		; swap rsi and rdx
		mov	rsi,rdx
		mov	rdx,r8
		call	tower2

		; tower(rdi,rsi,rdx,rcx)
		; tower(from,to,using,1)
		mov	rdi,[rsp]
		mov	rsi,[rsp+8]
		mov	rdx,[rsp+16]
		mov	rcx,1 call	tower2

		; tower(rdi,rsi,rdx,rcx)
		; tower(using,to,from,n-1)
		pop	rdx		; we pop regs in different
		pop	rsi		; order because order of
		pop	rdi		; args is different
		pop	rcx
		call	tower2

		jmp	endtower2

basecondition2:
		put_str	movefrom
		put_i	edi
		put_str	moveto
		put_i	esi
		put_str	endl

endtower2:
		ret

