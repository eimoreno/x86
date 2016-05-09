;  hello.asm  a first program for nasm for Linux, Intel, gcc
; Este programa utiliza a funcao printf do C, que e' mais portavel do que a int 0x80
;
; assemble:	nasm -f elf -l hello.lst  hello.asm
; link:		gcc -o hello  hello.o
; run:	        hello 
; output is:	Hello World 

extern	printf		; Funcao C a ser chamada

SECTION .data		; data section
msg:	db "Hello World", 10, 0	; the string to print, 10=cr
len:	equ $-msg		; "$" means "here"
				; len is a value, not an address

SECTION .text		; code section
global main		; make label available to linker 
main:				; standard  gcc  entry point

     push    ebp		; inicializa pilha
     mov     ebp,esp
     
	 push	msg		; salva na pilha o endereco da string (com formato aceito pelo printf)
	 call	printf	; chama a funcao em C (que utilizara' o parametro salvo na pilha)
	 add	esp, 4	; remove o endereco da string (msg possui 4 bytes) da pilha
	
     mov     esp, ebp	; recupera pilha como era antes de executar o programa
     pop     ebp
	 
     mov	eax, 0		; valor de retorno normal, sem erro
     ret				; return
     