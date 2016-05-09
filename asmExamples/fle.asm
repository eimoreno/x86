; fle.asm  finds the e constant 
;
; compile  nasm -f elf fle.asm
; link     gcc -o fle  fle.o
; run      ./fle
;
        extern printf		; the C function to be called

%macro	pabc 1			; a "simple" print macro
	section	.data
.str	db	%1,0		; %1 is macro call first actual parameter
	section .text
				; push onto stack backwards 
	push	dword [c+4]	; double c (bottom)
	push	dword [c]	; double c
	push	dword [b+4]	; double b (bottom)
	push	dword [b]	; double b 
	push	dword [a+4]	; double a (bottom)
	push	dword [a]	; double a
	push	dword .str 	; users string
        push    dword fmt       ; address of format string
        call    printf          ; Call C function
        add     esp,32          ; pop stack 8*4 bytes
%endmacro
	
	section	.data  		; preset constants, writeable
e:	dq	2.718281828	; 64-bit variable e initialized to e
fmt:    db "%s, e = %e, novo_e = %e",10,0	; format string for printf
	
	section .bss 		; unitialized space
novo_e:	resq	1		; reserve a 64-bit word

	section .text		; instructions, code segment
	global	main		; for gcc standard linking
main:				; label
	
lit5:				; c=5.0;
	fld	qword [five]	; 5.0 constant
	fstp	qword [c]	; store into c
	pabc	"c=5.0"		; invoke the print macro
	
addb:				; c=a+b;
	fld	qword [a] 	; load a (pushed on flt pt stack, st0)
	fadd	qword [b]	; floating add b (to st0)
	fstp	qword [c]	; store into c (pop flt pt stack)
	pabc	"c=a+b"		; invoke the print macro
	
mulb:				; c=a*b;
	fld	qword [a]	; load a (pushed on flt pt stack, st0)
	fmul	qword [b]	; floating multiply by b (to st0)
	fstp	qword [c]	; store product into c (pop flt pt stack)
	pabc	"c=a*b"		; invoke the print macro
	
diva:				; c=c/a;
	fld	qword [c] 	; load c (pushed on flt pt stack, st0)
	fdiv	qword [a]	; floating divide by a (to st0)
	fstp	qword [c]	; store quotient into c (pop flt pt stack)
	pabc	"c=c/a"		; invoke the print macro

        mov     eax,0           ; exit code, 0=normal
	ret			; main returns to operating system


