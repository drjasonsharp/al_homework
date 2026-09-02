;; 
;; funcdemo5.asm
;;
;; void getAge(int &age)
;; {
;;   cout << "Enter age: ";
;;   cin >> age;
;; }
;;
;; i.e., subprogram using parameters passed by address; this version
;; uses the "new" I/O macros.
;;
;; by Terry Sergeant
;; 04 Nov 2002
;;
%include "/home/class/csci2093/iomacros.asm"

section .data
ageis:		db	"Age is   : ",0

section .bss
age:		resd	1

section .text
		global 		main
main:
		push	dword age	; pass address of age
		call	getAge
		add	ESP,4
		put_str	ageis		; "Age is: "
		put_i	[age]		;
		put_ch	10		; newline

alldone: 	mov	ebx,0		; return 0
		mov	eax,1		; on
		int	80h		; exit
end


;;-----------------------------------------------------------------
;; getAge - allows user to enter value for age

section .data
prompt:		db	"Enter age: ",0

section .text
getAge:		push	EBP		; adjust frame pointer
		mov	EBP,ESP
		push	EAX		; save context
		push	EBX
		put_str	prompt		; "Enter age: "
		get_i	EBX		; put it in EBX
		mov	EAX,[EBP+8]	; EAX= addr of age
		mov	[EAX],EBX	
		pop	EBX
		pop	EAX
		pop	EBP
		ret

