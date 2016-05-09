;-----------------------------------------------------------------------------
; Escreve um numero na tela.
; Verificar se conteudo do Makefile esta' ok, e executar "make" no prompt;
; ou, se nao tiver Makefile:
; nasm -f elf -l escreve_float.lst escreve_float.asm
; gcc -o escreve_float  escreve_float.o
;-----------------------------------------------------------------------------

SECTION .data
msg       db  0xa, "Escrevendo um numero: Assembly 386 Linux",0xa
          db	 "x = "
tamanho	   equ $ - msg		; Comprimento da mensagem
msg1      db  0xa, "Escrevendo um outro numero: Assembly 386 Linux",0xa
          db	 "x = "
tamanho1  equ $ - msg1	; Comprimento da mensagem 1
tmp_flt   dq  2.54       ; double-precision float
tmp_int   dw  20

section .bss
resp_mult resb  4

SECTION .text
global main
main:         ; Ponto de entrada do programa

; Escreve a mensagem inicial (msg)
	mov     edx,tamanho	; Comprimento da mensagem
	mov     ecx,msg		; ecx aponta para o inicio da mensagem
	mov     ebx,1		; descritor da saida: (1 = stdout)
	mov     eax,4		; Numero do servico (4 = sys_write)
	int     0x80		; Chama o kernel

; Chama a sub-rotina para escrever um numero
	mov	eax, 123456789	; Numero a escrever
	call	escreve		; Chama a rotina que escreve o numero

	mov     edx,tamanho1; Comprimento da mensagem
	mov     ecx,msg1		; ecx aponta para o inicio da mensagem
	mov     ebx,1		; descritor da saida: (1 = stdout)
	mov     eax,4		; Numero do servico (4 = sys_write)
	int     0x80		; Chama o kernel

; Multiplica inteiro por float, e coloca resultado em inteiro
  fld  dword[tmp_flt]   ; coloca o conteudo da variavel tmp_flt na pilha de regs da fpu
  fmul dword[tmp_int]   ; st0 = sto * tmp_int
  fist dword[resp_mult] ; resp_mult = st0 (convertido de double para int)
  mov  eax, dword[resp_mult]
  call escreve

	mov  eax,1		; Chamada do sistema: (1 = sys_exit)
	int  0x80		; Fim do programa principal

; Subrotina para escrever EAX como um numero em base dez
escreve:
	push	ebp		; Salva registradores na pilha
	push	eax		; (opcional)
	push	ebx
	push	ecx
	push	edx
	mov	ebp,esp		; Salva stack pointer
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
