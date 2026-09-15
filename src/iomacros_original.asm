;;
;; iomacros.asm
;;
;; Programmer : Terry Sergeant
;; Version    : 16
;; Description: I/O macros for x86_64 NASM assembler.  Implemented by
;;              calling C stdio routines and linking via gcc.
;;              This implementation saves context and allows multiple
;;              types of arguments.  Performs I/O both to/from console
;;              and to/from files.
;;
;; Version 16 provides the align_stack macro that can be placed at the top
;; of an executable section to ensure 16-byte alignment of the stack which
;; prevents some C-language calls from crashing like they used to.
;;
;; Version 15 provides some updates to documentation and also
;; performs stack alignment to fix segfaults on systems that require
;; the -no-pie switch when linking with gcc. So, we need an even number
;; of pushes ... if not we use sub rsp,8 to make even
;;

		section	.data

__format_str:	db	"%s",0
__format_int:	db	"%d",0
__format_hex:	db	"%#010x",0
__format_f:	db	"%f",0
__format_dbl:	db	"%lf",0
__open_read:	db	"r",0
__open_write:	db	"w",0


		section .bss

__temp_mem:	resq	1
__fpu_mem:	resb	112


		section	.text

%define		ROF	0xFFFFFFFF

extern putchar,getchar,printf,scanf,stdin
extern fgets,fgetc,fopen,fclose,fscanf,fputc,fprintf


;; put_ch ch
;;-----------
;; Writes a single char, ch, to stdout.
;;
;; ch can be: reg8, mem8, or imm8
;;-----------------------------------------------------------
%macro	put_ch	1
	push	rax			; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8

	mov	dil,byte %1		; extra step so we can put_ch ah
	xor	rax,rax			; clear rax
	call	putchar			; display char

	add	rsp,8
	pop	r11			; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rax
%endmacro


;; put_str str
;;-------------
;; Writes a null-terminated character string, str, to stdout
;;
;; str must be a 64-bit address (label, reg, etc.)
;;-----------------------------------------------------------
%macro	put_str	1		; 1 here specifies we expect 1 argument
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

	;mov	rdi,%1		; %1 is the name of the first argument
	;xor	rax,rax		; clear rax
	;call	printf
	;mov	esi,%1
	mov	rdi,__format_str
	mov	rsi,%1
	xor	rax,rax		; clear rax
	call	printf

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


;; put_i num
;;-----------
;; Writes a signed integer, num, to stdout.
;;
;; num must be: reg32, mem32, or imm32
;;-----------------------------------------------------------
%macro	put_i	1
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

	mov	esi,%1
	mov	rdi,__format_int
	xor	rax,rax		; clear rax
	call	printf

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



;; put_x num
;;-----------
;; Writes four bytes of num as hexadecimal value
;;
;; num must be: reg32, mem32, or imm32
;;-----------------------------------------------------------
%macro	put_x	1
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

	mov	esi,%1
	mov	rdi,__format_hex
	xor	rax,rax		; clear rax
	call	printf

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


;; put_f num
;;------------
;; writes an IEEE single-precision floating point number
;; to stdout; NOTE: %f requires a double, but displays it as a
;; float ... so we have to use cvtss2sd to convert from float
;; to double.
;;
;; num must be: reg32 or mem32 (no support for immediate mode)
;;-----------------------------------------------------------
%macro	put_f	1
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

	; floating point values must be passed to printf in xmm0
	mov	eax, %1
	movd	xmm0, eax
	cvtss2sd xmm0,xmm0
	mov eax, 0x3F800000     ; 1.0 in IEEE 754 single-precision
	movd xmm0, eax          ; Move to xmm0
        cvtss2sd xmm0, xmm0     ; Convert to double-precision

	mov	rdi,__format_f
	mov	rax,1
	call	printf

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


;; put_dbl num
;;------------
;; writes an IEEE double-precision floating point number
;; to stdout
;;
;; num must be: reg64 or mem64 (no support for immediate mode)
;;-----------------------------------------------------------
%macro	put_dbl	1
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

	mov	rax, %1
	movq	xmm0, rax
	mov	rdi,__format_dbl
	mov	rax,1
	call	printf

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


;; get_ch ch
;;-----------
;; Reads a single char from stdin (keyboard) into ch.
;; ch can be: reg8 or mem8
;; NOTE: Answer is also returned in AL
;;-----------------------------------------------------------
%macro	get_ch	1
	push	rcx		; save context
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11

	call	getchar

	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx

	mov	%1,al		; move result into destination
%endmacro


;; get_str str,size
;;-------------
;; Uses fgets to read a string from stdin ... can specify a
;; maximum buffer size (default is 80); although this macro calls
;; C's fgets, it does some clean up afterwards that seemed like a good
;; idea to me:
;;   * the newline, if present, is taken out of the line
;;   * RAX returns the length of the string that was read
;; Keep in mind that the string will be null-terminated, so a buffer
;; of size 80 can store 79 "useful" characters and the null character.
;;
;; str must be a 64-bit address (label, reg, etc.)
;; get_str returns (in RAX) numbers of bytes stored in str
;;-----------------------------------------------------------
%macro	get_str	1-2 80
%ifidni %1,rax
%error get_str uses RAX to provide return status, so it may not also hold the value entered
%endif
	push	rbx			; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8

	mov	rdi,%1
	mov	rsi,%2
	mov	rdx,[stdin]		; read from stdin
	call	fgets			; use "safe" fgets

	cmp	rax,0			; fgets failed ...
	je	%%endofmacro

%%fgetsworked:				; else fgets worked, so we find length
	mov	rax,0			; of str and put it in RAX
	mov	rbx, qword %1		; RBX<-addr of string
%%loop:	cmp	byte [rbx+rax],10	; found newline char
	je	%%newline
	cmp	byte [rbx+rax],0	; found end of string char
	je	%%endofmacro
	inc	rax
	jmp	%%loop

%%newline:
	mov	byte [rbx+rax],0	; replace newline with null

%%endofmacro:
	add	rsp,8
	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx
%endmacro


;; get_i num
;;-----------
;; reads a signed int from stdin into num
;;
;; num can be: reg32,mem32
;; get_i also returns the read value in EAX
;;-----------------------------------------------------------
%macro	get_i	1
	push	rbx			; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8

	mov	rdi,__format_int
	mov	rsi,__temp_mem
	xor	rax,rax
	call	scanf

	add	rsp,8
	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx

	; this section comes after restoring context b/c
	; it is possible that %1 is something like: [ecx]
	mov	eax,[__temp_mem]	; but we need to use EAX to
	mov	%1,eax			; avoid possible memory-to-memory
%endmacro



;; get_f num
;;------------
;; reads an IEEE single-precision float from stdin into num
;;
;; num must be: reg32 or mem32
;; the result is returned in num and in EAX
;;-----------------------------------------------------------
%macro	get_f	1
	push	rbx			; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8

	mov	rdi,__format_f
	mov	rsi,__temp_mem
	xor	rax,rax
	call	scanf

	add	rsp,8
	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx

	; this section comes after restoring context b/c
	; it is possible that %1 is something like: [ecx]
	mov	eax,[__temp_mem]	; but we need to use EAX to
	mov	%1,eax			; avoid possible memory-to-memory
%endmacro


;; get_dbl num
;;------------
;; reads an IEEE double-precision float from stdin into num
;;
;; num must be: reg64 or mem64
;; the result is returned in num and in RAX
;;-----------------------------------------------------------
%macro	get_dbl	1
	push	rbx			; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8

	mov	rdi,__format_dbl
	mov	rsi,__temp_mem
	xor	rax,rax
	call	scanf

	add	rsp,8
	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx

	; this section comes after restoring context b/c
	; it is possible that %1 is something like: [ecx]
	mov	rax,[__temp_mem]	; but we need to use EAX to
	mov	%1,rax			; avoid possible memory-to-memory
%endmacro



;; fopenr fp,fname
;;------------------
;; opens file to read; fp is 64-bit file pointer; fname is
;; addr of a null-terminated string containing name of file to open
;;
;; fp can be: reg64, mem64 (NOTE: I have seen strange errors sometimes when
;;         reg64 so I always use mem64)
;; fopenr returns 0 in RAX if open fails
;;        returns file pointer address, otherwise
;; all registers other than RAX are preserved
;;-----------------------------------------------------------
%macro	fopenr	2
%ifidni %1,rax
%error fopenr uses RAX to provide return status, so it may not be an argument
%endif
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11

	mov	rdi,%2
	mov	rsi,__open_read
	xor	rax,rax
	call	fopen			; result in RAX
	mov	%1,rax			; returned value is fp (0 if failed)

	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
%endmacro



;; fopenw fp,fname
;;------------------
;; opens file to write; fp is 64-bit file pointer; fname is
;; addr of a null-terminated string containing name of file to open
;;
;; fp can be: reg64, mem64
;; fopenr returns 0 in RAX if open fails
;;        returns file pointer address, otherwise
;; all registers other than RAX are preserved
;;-----------------------------------------------------------
%macro	fopenw	2
%ifidni %1,rax
%error fopenw uses RAX to provide return status, so it may not be an argument
%endif
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11

	mov	rdi,%2
	mov	rsi,__open_write
	xor	rax,rax
	call	fopen			; result in RAX
	mov	%1,rax			; returned value is fp (0 if failed)

	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
%endmacro



;; fclose fp
;;------------------
;; closes file associated with fp
;;
;; fp can be: reg64, mem64
;; returns 0 in RAX if successful
;;         non-zero otherwise
;; all registers other than RAX are preserved
;;-----------------------------------------------------------
%macro	fclosem	1
%ifidni %1,rax
%error fclosem uses RAX to provide return status, so it may not be an argument
%endif
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11

	mov	rdi,%1			; fp of file to close
	call	fclose			; result in RAX

	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
%endmacro


;; fget_ch fp,ch
;;---------------
;; reads a single char from file pointer, fp, into 8-bit location, ch
;;
;; fp is 64-bit variable and can be: reg64, mem64
;; ch can be: reg8, mem8
;; fget_ch returns ROF (0xFFFFFFFF) in EAX if fails
;;         returns value read otherwise
;;-----------------------------------------------------------
%macro	fget_ch	2
%ifidni %1,RAX
%error fget_ch uses RAX to provide return status, so it may not be an argument
%endif
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11

	mov	rdi,%1			; fp is parameter
	call	fgetc			; result in RAX
	mov	%2,AL			; put result of getchar into memory

	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
%endmacro


;; fget_str fp,str,[bufsize=80]
;;-------------
;; Uses fgets to read a string from stdin ... can specify a
;; maximum buffer size (default is 80); although this macro calls
;; C's fgets, it does some clean up afterwards that seemed like a good
;; idea to me:
;;   * the newline, if present, is taken out of the line
;;   * RAX returns the length of the string that was read
;; Keep in mind that the string will be null-terminated, so a buffer
;; of size 80 can store 79 "useful" characters and the null character.
;;
;; fp is 64-bit file descriptor: reg64, mem64
;; str must be a 64-bit address (label, reg, etc.)
;; fget_str returns -1 in RAX if the read fails
;; fget_str returns (in RAX) numbers of bytes stored in str if read succeeds
;;-----------------------------------------------------------
%macro	fget_str	2-3 80
%ifidni %2,rax
%error fget_str uses RAX to provide return status, so it cannot be an argument
%endif
	push	rbx		; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8

	mov	rdi,%2
	mov	[__temp_mem],rdi	; we save this because we may need it if read succeeds
	mov	esi,%3
	mov	rdx,%1		; read from stdin
	call	fgets		; use "safe" fgets

	cmp	rax,0		; fgets failed ...
	je	%%readfail

%%nofail:				; else fgets worked, so we find length
	mov	rax,0		; of str and put it in RAX
	mov	rbx,[__temp_mem]	; RBX<-addr of string
%%loop:	cmp	byte [rbx+rax],10	; found newline char
	je	%%newline
	cmp	byte [rbx+rax],0	; found end of string char
	je	%%theend
	inc	rax
	jmp	%%loop

%%newline:
	mov	byte [rbx+rax],0	; replace newline with null
	jmp	%%theend

%%readfail:
	mov	eax,-1

%%theend:
	add	rsp,8
	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx

%endmacro


;; fget_i fp,num
;;----------------
;; reads a signed int from fp into num
;;
;; fp is 64-bit variable and can be: reg64, mem64
;; num can be: reg32,mem32
;; fget_i returns in EAX if the read failed, otherwise 1.
;;-----------------------------------------------------------
%macro	fget_i	2
%ifidni %1,rax
%error fget_i uses RAX to provide return status, so it may not be an argument
%endif
	push	rbx		; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8

	mov	rdi,%1
	mov	rsi,__format_int
	mov	rdx,__temp_mem
	xor	rax,rax
	call	fscanf

	add	rsp,8
	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx

	cmp	eax,0		; if zero we didn't get an int so fail
	jne	%%checkfail
	mov	eax,-1

%%checkfail:
	cmp	eax,-1
	je	%%theend

	; this section comes after restoring context b/c
	; it is possible that %1 is something like: [ecx]
	mov	eax,[__temp_mem]	; but we need to use EAX to
	mov	%2,eax		; avoid possible memory-to-memory
	mov	eax,1
%%theend:
%endmacro


;; fget_f fp,num
;;------------
;; reads an IEEE single-precision float from fp into num
;;
;; fp is 64-bit variable and can be: reg64, mem64
;; num must be: reg32 or mem32
;; returns -1 in EAX if read fails, else EAX is 1
;;-----------------------------------------------------------
%macro	fget_f	2
%ifidni %1,rax
%error fget_f uses RAX to provide return status, so it may not be an argument
%endif
	push	rbx			; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8


	mov	rdi,%1
	mov	rsi,__format_f
	mov	rdx,__temp_mem
	xor	rax,rax
	call	fscanf

	add	rsp,8
	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx

	cmp	eax,-1
	je	%%theend

	; this section comes after restoring context b/c
	; it is possible that %1 is something like: [ecx]
	mov	eax,[__temp_mem]	; but we need to use EAX to
	mov	%2,eax		; avoid possible memory-to-memory
	mov	eax,1

%%theend:
%endmacro



;; fget_dbl fp,num
;;------------
;; reads an IEEE single-precision float from fp into num
;;
;; fp is 64-bit variable and can be: reg64, mem64
;; num must be: reg32 or mem32
;; returns -1 in EAX if read fails; else 1
;;-----------------------------------------------------------
%macro	fget_dbl	2
%ifidni %1,rax
%error fget_dbl uses RAX to provide return status, so it may not be an argument
%endif
	push	rbx			; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8


	mov	rdi,%1
	mov	rsi,__format_dbl
	mov	rdx,__temp_mem
	xor	rax,rax
	call	fscanf

	add	rsp,8
	pop	r11		; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rbx

	cmp	eax,-1
	je	%%theend

	; this section comes after restoring context b/c
	; it is possible that %1 is something like: [ecx]
	mov	rax,[__temp_mem]	; but we need to use EAX to
	mov	%2,rax			; avoid possible memory-to-memory
	mov	rax,1
%%theend:
%endmacro



;; fput_ch fp,ch
;;-----------
;; Writes a single char, ch, to fp
;;
;; fp is 64-bit variable and can be: reg64, mem64
;; ch can be: reg8, mem8, or imm8
;;-----------------------------------------------------------
%macro	fput_ch	2
	push	rax			; save context
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	push	r8
	push	r9
	push	r10
	push	r11
	sub	rsp,8

	mov	dil,%2
	mov	rsi,%1
	xor	rax,rax			; clear rax
	call	fputc			; display char

	add	rsp,8
	pop	r11			; restore context
	pop	r10
	pop	r9
	pop	r8
	pop	rsi
	pop	rdi
	pop	rdx
	pop	rcx
	pop	rax
%endmacro



;; fput_str fp,str
;;-------------
;; Writes a null-terminated character string, str, to fp
;;
;; fp is 64-bit variable and can be: reg64, mem64
;; str must be a 64-bit address (label, reg, etc.)
;;-----------------------------------------------------------
%macro	fput_str	2
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

	mov	rdi,%1
	mov	rsi,%2
	xor	rax,rax		; clear rax
	call	fprintf

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



;; fput_i fp,num
;;-----------
;; Writes a signed integer, num, to fp.
;;
;; fp is 64-bit variable and can be: reg64, mem64
;; num must be: reg32, mem32, or imm32
;;-----------------------------------------------------------
%macro	fput_i	2
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

	mov	rdi,%1
	mov	rsi,__format_int
	mov	edx,%2
	xor	rax,rax		; clear rax
	call	fprintf

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



;; fput_f fp,num
;;------------
;; writes an IEEE single-precision floating point number
;; to fp; NOTE: %f requires a double, but displays it as a
;; float ... so we have to use cvtss2sd to convert from float
;; to double.
;;
;; fp is 64-bit variable and can be: reg64, mem64
;; num must be: reg32 or mem32 (no support for immediate mode)
;;-----------------------------------------------------------
%macro	fput_f	2
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

	; floating point values must be passed to printf in xmm0
	mov	eax,%2
	movd	xmm0, eax
	cvtss2sd xmm0,xmm0
	mov	rdi,%1
	mov	rsi,__format_f
	mov	rax,1
	call	fprintf

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


;; fput_dbl fp,num
;;------------
;; writes an IEEE double-precision floating point number
;; to fp.
;;
;; fp is 64-bit variable and can be: reg64, mem64
;; num must be: reg64 or mem64 (no support for immediate mode)
;;-----------------------------------------------------------
%macro	fput_dbl	2
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

	mov	rax,%2
	movq	xmm0, rax
	mov	rdi,%1
	mov	rsi,__format_dbl
	mov	rax,1
	call	fprintf

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


;; align_stack
;;-----------
;; In some programs, for reasons I cannot explain, the stack is not
;; initially aligned on a 16-byte boundary, which causes some
;; C-language function calls to crash. Calling this macro as the
;; first line of the program will get things started on the right
;; foot regardless of the initial state.
;;-----------------------------------------------------------
%macro	align_stack	0
	mov	rax, rsp
	and	rax, 15
	jz	%%aligned
	sub	rsp, 8
%%aligned:	
%endmacro

