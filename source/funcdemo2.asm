;; 
;; funcdemo2.asm printInfo(id,name,gpa) (old way)
;; funcdemo3.asm printInfo(id,name,gpa) (new way; why we need the old way)
;; funcdemo3.asm printInfo(Student)
;; funcdemo4.asm calcDogYears(age)
;; funcdemo6.asm recursive nfact() (old way and new way? ... perhaps need something not tail recursive)
;; 
;; by Terry Sergeant
;; Fall 2014
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		section .data
idnum:		dq	1234		; int (leave 64 bits b/c passing on stack)
name:		db	"Frederick",0	; string
gpa:		dq	3.33		; double
endmsg:		db	"Goodbye.",10,0
endl:		db	0AH,0


		section .text
		global 		main
main:
		;dump_regs
		push	qword [idnum]
		call	printInfo
		add	rsp,8
		put_str	endmsg
		;dump_regs

theend:		mov     eax, 60
		xor     rdi, rdi
		syscall

		; function printInfo(int id, string name, double gpa)

		section .text
printInfo:	push	rbp
		mov	rbp,rsp
		put_i	[rbp+16]
		put_str	endl
		pop	rbp
		ret

; NOTE: It is conventional to use a "frame pointer" to keep track o
