;-----------------------------------------------------------------------------
; Escreve um numero na tela.
; Verificar se conteudo do Makefile esta' ok, e executar "make" no prompt;
; ou, se nao tiver Makefile:
; nasm -f elf -l escreve_num.lst escreve_num.asm
; gcc -o escreve_num  escreve_num.o
;-----------------------------------------------------------------------------

SECTION .data
msg     db      0xa, "Escrevendo um numero: Assembly 386 Linux",0xa
	db	"x = "
tamanho	equ     $ - msg		; Comprimento da mensagem

SECTION .text
global main
main:
; Escreve a mensagem inicial
	mov     edx,tamanho	; Comprimento da mensagem
	mov     ecx,msg		; ecx aponta para o inicio da mensagem
	mov     ebx,1		; descritor da saida: (1 = stdout)
	mov     eax,4		; Numero do servico (4 = sys_write)
	int     0x80		; Chama o kernel

; Chama a subrotina para escrever um numero
	mov	eax,123456789	; Numero a escrever
	call	escreve		; Chama a rotina que escreve o numero
	mov     eax,1		; Chamada do sistema: (1 = sys_exit)
	int     0x80		; Fim do programa principal

; Subrotina para escrever EAX como um numero em base dez
escreve:
	push	ebp		; Salva registradores na pilha
	push	eax		; (opcional)
	push	ebx
	push	ecx
	push	edx
	mov	ebp,esp		; Copia stack pointer em esp
	sub	esp,16		; Aloca 16 bytes na pilha
	mov	ecx,10
	dec	ebp
	mov	[ebp],cl	; Armazena 10=Line-Feed na pilha
pn1:	xor	edx,edx		; Deve zerar EDX antes de dividir
	div	ecx		; Divide o numero (EAX) por dez
	add	dl,'0'		; DL tem o resto da divisao
	dec	ebp		; Prepara para armazenar o digito na pilha
	mov	[ebp],dl	; Armazena
	or	eax,eax		; Testa se o numero chegou a zero
	jnz	pn1		; se nao, repete a operacao
	lea	edx,[esp+16]	; Calcula o comprimento da string
	sub	edx,ebp		; Comprimento = esp + 16 - ebp
	mov	ecx,ebp		; ECX aponta para o inicio do numero
	mov	ebx,1		; descritor (1 = stdout)
	mov	eax,4   	; Chamada do sistema: (4 = sys_write)
	int	0x80		; Escreve o numero como um string
	add	esp,16		; Restaura o valor de ESP
	pop	edx
	pop	ecx		; Restaura os registradores
	pop	ebx
	pop	eax
	pop	ebp
	ret
