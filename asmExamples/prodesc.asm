; nasm -f elf -l prodesc.lst prodesc.asm
; gcc -o prodesc  prodesc.o

;Escrever um programa em assembly para a arquitetura IA32, no Linux, para calcular o produto ;escalar entre dois vetores de inteiros com 10 posições cada. Os elementos dos vetores ;precisam ser fornecidos pelo usuário (linha de comando). Após calculado o produto escalar, ;esse valor final deverá ser apresentado na tela (stdout).
;
;O programa devera realizar o equivalente ao seguinte trecho de codigo em C:
;
;int x[10];
;int y[10];
;int acumula = 0;
;int main(){
;   // escrever aqui rotina para entrar com os conteudos dos dois vetores
;    for (i = 0; i < 10; i++) acumula += x[i] * y[i];
;   printf ("\nProduto escalar = %d\n", acumula);
;   exit (0);
;}
;
;Dica 1: Ao realizar uma entrada de dados pelo teclado, o dado lido nao sera um valor ;numerico a ser utilizado em uma operação aritmetica. E preciso converter esse valor antes de ;realizar qualquer operacao aritmetica. Podera ser utilizado a sub-rotina escreve_num como ;base para essa conversao. Essa sub-rotina converte um valor numerico para "string", ;possibilitando a escrita desse valor na tela.
;
;Dica 2: Chamadas de sistema no Linux - Syscall (servicos do sistema operacional):
;MOV AX, w    ; w = codigo do servico
;MOV BX, x    ; x = codigo do que sera realizado
;MOV CX, y    ; y = codigo do que sera realizado
;MOV DX, z    ; z = codigo do que sera realizado
;INT 0x80
;
;Dica 3: Definicao de vetor:
;VET_X db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;VET_Y db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;
;Dica 4: Repeticao (do ... while):
;            MOV ECX, 10
;            MOV EAX, 0
;repete:     INC EAX       ; EAX++
;            LOOP repete   ; ECX--, ECX != 0?, se sim, salta para repete
;
;Dica 5: Usando array
;      MOV ESI, VET_X
;      MOV EDI, VET_Y
;      MOV ECX, 10
;R:    MOV EAX, [ESI]    ; EAX = *ESI
;      MOV [EDI], EAX    ; *EDI, EAX
;      INC ESI           ; ESI++
;      INC EDI           ; EDI++
;      LOOP R 


STDIN		equ	0
STDOUT          equ     1
SYS_EXIT        equ     1
SYS_READ        equ     3
SYS_WRITE       equ     4
SYS_OPEN        equ     5
MAX		equ	10
BUFLEN		equ	256


SECTION .data
result	  db	0
VET_X      db     0,0,0,0,0,0,0,0,0,0
VET_Y      db     0,0,0,0,0,0,0,0,0,0
str1	   db     0xa, "Digite o valor para o vetor 1: ", 0xa
tam1	   equ     $ - str1     ; Comprimento da string
str2	   db     0xa, "Produto escalar de VET_X.VET_Y: "
tam2	   equ     $ - str2     ; Comprimento da string
str3	   db     0xa, "Digite o valor para o vetor 2: ", 0xa
tam3	   equ     $ - str3     ; Comprimento da string
buf	   db	  0

SECTION .text                   ; text (executable code) section
global main
main:
	; mostra primeira mensagem (entrada do vetor 1)
	mov     edx,tam1	; comprimento da mensagem
        mov     ecx,str1	; ecx aponta para o inicio da mensagem
	mov     ebx,STDOUT      ; descritor da saida: (stdout = 1)
	mov     eax,SYS_WRITE   ; numero do servico (sys_write = 4)
	int     0x80		; chama o kernel para imprimir a string
	; entrada dos valores do primeiro vetor	
	mov	esi, VET_X
	mov	ecx, MAX
lbl:	push	ecx
	mov     eax,SYS_READ	; numero do servico (sys_read = 3)
	mov     ebx,STDIN	; leitura do teclado
	mov     ecx,buf         ; destino da leitura
	mov     edx,BUFLEN      ; numero de bytes a serem lidos
	int     0x80		; chama o kernel
	pop	ecx
	xor	eax, eax
	mov	al, [buf]
	sub	al, 0x30
	mov	[esi], al
	inc	esi
	loop	lbl

	; mostra segunda mensagem (entrada do vetor 2)
	mov     edx,tam3	; comprimento da mensagem
        mov     ecx,str3	; ecx aponta para o inicio da mensagem
	mov     ebx,STDOUT      ; descritor da saida: (stdout = 1)
	mov     eax,SYS_WRITE   ; numero do servico (sys_write = 4)
	int     0x80		; chama o kernel para imprimir a string
	; entrada dos valores do segundo vetor	
	mov	esi, VET_Y
	mov	ecx, MAX
lbl1:	push	ecx
	mov     eax,SYS_READ	; numero do servico (sys_read = 3)
	mov     ebx,STDIN	; leitura do teclado
	mov     ecx,buf         ; destino da leitura
	mov     edx,BUFLEN      ; numero de bytes a serem lidos
	int     0x80		; chama o kernel
	pop	ecx
	xor	eax, eax
	mov	al, [buf]
	sub	al, 0x30
	mov	[esi], al
	inc	esi
	loop	lbl1

	; calcula o produto escalar de VET_X e VET_Y
	mov	esi, VET_X
	mov	edi, VET_Y
	mov	ecx, 10
lbl3:	xor	ebx, ebx
	xor	eax, eax
	mov	bl, [esi]
	mov	al, [edi]
	mul	bx
	xor	ebx, ebx
	mov	bl, [result]
	add	ax, bx
	mov	[result], al
	inc	esi
	inc	edi
	loop	lbl3

	; mostra terceira mensagem (resultado)
	mov     edx,tam2	; comprimento da mensagem
        mov     ecx,str2	; ecx aponta para o inicio da mensagem
	mov     ebx,STDOUT      ; descritor da saida: (stdout = 1)
	mov     eax,SYS_WRITE   ; numero do servico (sys_write = 4)
	int     0x80		; chama o kernel para imprimir a string
	; escreve o produto escalar na tela
	xor	eax, eax
	mov	al, [result]
	call escreve

        mov     eax,SYS_EXIT	; Chamada do sistema: (sys_exit = 1)
	int     0x80		; Fim do programa principal


; rotina para escrever na tela (STDOUT) um inteiro contido em EAX
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
