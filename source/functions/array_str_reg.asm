;
; Call a C-language function to read strings into an array and then call an
; x86 function (register-based conventions) to find the index of the longest
; one.
;
; @author  Terry Sergeant
; @version For AL
;
; NOTE 10/21/2024: On josephus this code no longer links ... because the memory references
; are no good ... will need to modify future assignments so the assembly code
; does not make use of "local variables" (i.e., declared in data or bss).
; At the moment the aging CSCI server (RHEL v6) doesn't sqwak about it.
;
%include "../iomacros.asm"
%include "../dumpregs.asm"
%define NAMELENGTH 27

		extern readStrings

		section .data

infile:		db	"../names.txt",0
f_label:	db	"input file   : ",0
n_label:	db	"# of names   : ",0
i_label:	db	"index of long: ",0
s_label:	db	"longest name : ",0
endl:		db	10,0

		section .bss
f:		resq	1
a:		resb	10000*NAMELENGTH
len:		resd	10000
n:		resd	1


		section .text

		global main

main:
		mov	rdi,a
		mov	rsi,infile
		call	readStrings

		mov	[n],eax

		put_i	[n]
		put_str	endl

		mov	rdi,a
		xor	rsi,rsi
		mov	esi,[n]
		call	findLongPos

		xor	rbx,rbx
		mov	ebx,eax

		put_str	f_label
		put_str	infile
		put_str	endl
		put_str	n_label
		put_i	[n]
		put_str	endl
		put_str	i_label
		put_i	ebx
		put_str	endl

		imul	rbx,NAMELENGTH
		add	rbx,a
		put_str	s_label
		put_str	rbx
		put_str	endl

theend:		mov     eax, 60
		xor     rdi, rdi
		syscall



;
; Given an array of names as a parameter along with the number of names,
; find and return the index of the longest name
;
; rdi= addr of a
; rsi= addr of nameLen
; edx= n
; int findLongPos(char [][NAMELENGTH] a, int n)
;   int lpos= 0; // r8
;   char* laddr= a[0]; // r9
;   int strlen1= strlen(a[0]); // r11
;   for (i=1; i<n; i++)   // i->r10, n->esi
;      strlen2= strlen(a[i]); // a[i]->r13
;      if (strlen2 > strlen1)
;         lpos= i;
;         laddr= a[i];
;         strlen1= strlen2
;      endif
;   endfor
;

findLongPos:
		mov	r10,1		; r10=1
		xor	r8,r8		; lpos= 0
		mov	r9,rdi		; laddr= a[0]
		mov	r13,rdi
		call	strlen
		mov	r11,rax		; strlen1= strlen(a[0])

findLongLoop:
		cmp	r10d,esi
		jge	endFindLongPos

		add	r13,NAMELENGTH	; r13=a[i]
		mov	rdi,r13
		call	strlen
		cmp	rax,r11
		jle	notLonger

		mov	r11,rax		; strlen1= strlen2
		mov	r8,r10		; lpos= i
		mov	r9,r13		; laddr= a[i]
notLonger:
		inc	r10
		jmp	findLongLoop

endFindLongPos:
		mov	rax,r8
		ret


;
; Given the addr of a string, determine its length.
;
; rdi= addr of str
; int strlen(char [] str)
;

strlen:
		xor	rax,rax
strlenloop:
		cmp	byte [rdi+rax],0
		je	endstrlen
		inc	rax
		jmp	strlenloop

endstrlen:
		ret
