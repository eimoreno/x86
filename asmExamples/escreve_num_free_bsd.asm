;-----------------------------------------------------------------------------
; Escreve um numero na tela. Versao para free bsd.
; Para montar/executar:
; nasm -f elf escreve_num_free_bsd.asm
; ld -s -o escreve_num_free_bsd escreve_num_free_bsd.o
;-----------------------------------------------------------------------------

SECTION .data
msg     db      0xa, "Escrevendo um numero: Assembly 386 Linux",0xa
	db	"x = "
tamanho	equ     $ - msg		; Comprimento da mensagem

SECTION .text
global _start

_syscall:		
	int	0x80		;system call
	ret

_start:
; Escreve a mensagem inicial
	mov     edx,tamanho	; Comprimento da mensagem
	mov     ecx,msg		; ecx aponta para o inicio da mensagem
	mov     ebx,1		; descritor da saida: (1 = stdout)
	mov     eax,4		; Numero do servico (4 = sys_write)
		push	edx			;message length
		push	ecx			;message to write
		push	dword 1		;file descriptor (stdout)
		mov	eax,4   	; Chamada do sistema: (4 = sys_write)
		call _syscall	;call kernel
		add	esp,12		; clean stack free BSD (3 arguments * 4)

; Chama a subrotina para escrever um numero
	mov	eax,123456789	; Numero a escrever
	call	escreve		; Chama a rotina que escreve o numero

			push	dword 0		;exit code
		mov		eax,0x1		;system call number (sys_exit)
		call	_syscall	;call kernel

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
		push	edx			;message length
		push	ecx			;message to write
		push	dword 1		;file descriptor (stdout)
		mov	eax,4   	; Chamada do sistema: (4 = sys_write)
						; Escreve o numero como um string
		call _syscall	;call kernel
		add	esp,12		; clean stack free BSD (3 arguments * 4)
	add	esp,16		; Restaura o valor de ESP
	pop	edx
	pop	ecx		; Restaura os registradores
	pop	ebx
	pop	eax
	pop	ebp
	ret
