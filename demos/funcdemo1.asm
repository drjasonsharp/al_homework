;; 
;; funcdemo1.asm
;;
;; Demonstrates writing a function and calling it twice
;; (using call and ret commands).
;;
;; by Terry Sergeant
;; Fall 2014
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
		call	hello
		;dump_regs
		;put_str	endl
		put_str	endmsg

theend:		mov     eax, 60
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
; is why ESP is changed by 8 during the call. When ret completes it removes 
; the return address from the stack sending it back to its original state.


