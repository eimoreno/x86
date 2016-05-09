;-----------------------------------------------------------------------------
; Escreve uma string na tela diversas vezes.
; Este programa utiliza a funcao printf do C, que e' mais portavel do que a int 0x80
; Verificar se conteudo do Makefile esta' ok, e executar "make" no prompt;
; ou, se nao tiver Makefile:
; nasm -f elf -l rep_str.lst rep_str.asm
; gcc -o rep_str  rep_str.o
;-----------------------------------------------------------------------------

; Declaracao de funcoes externas
; printf do C e' mais portavel do que a int 0x80

extern	printf		; Funcao C a ser chamada

SECTION .data
str1 db "Teste de repeticao de string. Repeticao nr: %d", 0xA, 0	; Notar a utilizacao da formatacao para o printf, incluindo um "/n" e um "/0" no final da string
tamanho	equ     $ - str1   ; Comprimento da string - nao e' necessario para esse programa

SECTION .text
global main
main:

     push    ebp		; inicializa pilha
     mov     ebp,esp

	 mov	ecx, 0x0A	; numero de repeticoes (escrita na tela)
lbl: push	ecx		; salva na pilha nr. da repeticao para o printf (vai do maior para o menor)
	 push	str1	; salva na pilha o endereco da string (com formato aceito pelo printf)
	 call	printf	; chama a funcao em C (que utilizara' os dois parametros salvos na pilha)
	 pop	eax		; retira da pilha a str1 (nao serve para nada, apenas para retirar um dos parametros salvos na pilha para uso do printf)
	 pop	ecx		; recupera numero de repeticoes da pilha
     dec 	ecx		; decrementa numero de repeticoes
     jcxz	fim		; se acabaram as repeticoes, desvia para o fim
     jmp	lbl		; repete a escrita na tela

fim: 
     mov     esp, ebp	; recupera pilha como era antes de executar o programa
     pop     ebp
	 
     mov	eax, 0		; valor de retorno normal, sem erro
     ret				; return
     