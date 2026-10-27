;;
;; funcdemo1.asm
;;
;; Demonstrates writing a function and calling it twice
;; (using call and ret commands).
;;
;; by Terry Sergeant
;; For AL
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
endmsg		db	"Goodbye.",10,0
endl		db	0AH,0


		section .text
		global 		main
main:
		;dump_regs
		;put_str	endl

		call	hello

		;dump_regs
		;put_str endl

		call	hello		

		put_str	endmsg
		;put_str endl

		;dump_regs
		;put_str	endl

theend:	
		mov     rax, 60
		xor     rdi, rdi
		syscall

		; function hello()
		section .data
begmsg:		db	"Hello World!",10,0

		section .text
hello:
		;dump_regs
		;put_str	endl

		put_str	begmsg
		;put_str endl

		ret

; NOTE: You can declare multiple text and data sections in a single source document
; It should be noted that the begmsg is visible to "main" above ...
; (and so is the label "hello").  ;
; Some things to try:
;  * observe what happens if we jmp to hello at beginning of main
;  * put dump_regs before the call and inside the function (note rsp)
;
; NOTE: The ret statement has to know where it needs to return to when the
; function call ends ... that return address is stored on the stack ... which
; is why RSP is changed by 8 during the call. When ret completes it removes
; the return address from the stack sending it back to its original state.

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits