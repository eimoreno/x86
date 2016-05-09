;-----------------------------------------------------------------------------
; Escreve uma string na tela diversas vezes.
; Verificar se conteudo do Makefile esta' ok, e executar "make" no prompt;
; ou, se nao tiver Makefile:
; nasm -f elf -l rep_str.lst rep_str.asm
; gcc -o rep_str  rep_str.o
;-----------------------------------------------------------------------------

SECTION .data
str1 db "Teste de repeticao de string", 0xA
tamanho	equ     $ - str1   ; Comprimento da string

SECTION .text
global main
main:

	 mov	ecx, 0x0A	; numero de repeticoes (escrita na tela)
	 push	ecx		; salva numero de repeticoes na pilha
	 mov     edx,tamanho	; Comprimento da mensagem
lbl: mov     ecx,str1	; ecx aponta para o inicio da mensagem
	 mov     ebx,1		; descritor da saida: (1 = stdout)
	 mov     eax,4		; Numero do serviço (4 = sys_write)
	 int     0x80		; Chama o kernel para imprimir a string

	 pop	ecx		; recupera numero de repeticoes da pilha
     dec 	ecx		; decrementa numero de repeticoes
	 push	ecx		; salva novo numero de repeticoes na pilha
     jcxz	fim		; se acabaram as repeticoes, desvia para o fim
     jmp	lbl		; repete a escrita na tela
fim: mov     eax,1		; Chamada do sistema: (1 = sys_exit)
	 int     0x80		; Fim do programa principal
