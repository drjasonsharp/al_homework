;; 
;; malloc.asm
;;
;; Demonstrates dynamically allocating memory.
;;
;; by Terry Sergeant
;; Fall 2014
;;
;;
%include "iomacros.asm"
%include "dumpregs.asm"

		global main

		section .data
endl		db	10,0

		section .bss

		section .text

main:

		dump_regs
		mov	rax,9		; syscall mmap
		xor	rdi,rdi		; addr = NULL
		mov	rsi,36		; # of bytes to reserve
		mov	rdx,3		; PROT_READ|PROT_WRITE
		mov	r10,0x22	; MAP_PRIVATE|MAP_ANONYMOUS
		mov	r8,-1		; fd=-1
		xor	r9,r9		; offset=0
		syscall			; issue system call for mmap, number 9		
		put_str	endl
		dump_regs

		;mov	rdi,rax				; assign rax to rdi
		;mov	dword [rdi],100;	; put 100 into the value of rdi
		;put_i	[rdi]				; display value of rdi
		;put_str	endl
		;dump_regs

		mov     eax, 60                 ; exit 0
		xor     rdi, rdi
		syscall

; section needed to remove warning:
;/usr/bin/ld: warning: skeleton.o: missing .note.GNU-stack section implies executable stack
;/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker

section .note.GNU-stack noalloc noexec nowrite progbits