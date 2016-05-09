;-----------------------------------------------------------------------------
; Inverte as strings definidas na area de dados.
; Este programa utiliza a funcao printf do C, que e' mais portavel do que a int 0x80
; Verificar se conteudo do Makefile esta' ok, e executar "make" no prompt;
; ou, se nao tiver Makefile:
; nasm -f elf -l inv_str.lst inv_str.asm
; gcc -o inv_str  inv_str.o
;-----------------------------------------------------------------------------

; Declaracao de funcoes externas
; printf do C e' mais portavel do que a int 0x80

extern	printf		; Funcao C a ser chamada

SECTION .data
str1 db "Teste de inversao de string.";, 0x0A, 0	; Notar a utilizacao da formatacao para o printf, incluindo um "/n" e um "/0" no final da string
tam1 equ $ - str1   ; Comprimento da str1
;str2 db 10, "1234567890", 10, 0
;str3 db "Funciona!", 10, 0
;str4 db "!anoicnuF", 0x0A, 0
dbg1 db "--> var1 = %d", 0x0A, 0
dbg2 db "--> var2 = %c", 0x0A, 0
dbg3 db "--> var3 = %c", 0x0A, 0

SECTION .bss                    ; non-initialized data section
buf     resb    256             ; a buffer with 256 bytes

SECTION .text
global main
main:
   
   		mov		ax, ds
   		mov		es, ax
   		
		push    ebp		; inicializa pilha
     	mov     ebp,esp
   
		mov		ecx, tam1
		mov		esi, str1	; esi aponta para primeira posicao da string a ser invertida
		mov		edi, buf
		add		edi, ecx
	 	
l1:		mov		al, [esi]
		mov		[edi], al
		
		inc		esi			; incrementa ponteiro para string (para pegar o proximo caracter)
		dec		edi
		loop	l1			; vai para o proximo caracter


		; escreve string invertida (armazenada em buf) na tela com printf
		
		push	buf			; salva na pilha o endereco da string (com formato aceito pelo printf)
	 	call	printf		; chama a funcao em C (que utilizara' o parametro salvo na pilha)
	 	pop		eax			; retira buf da pilha
    


;		push	dword [ebx]
;		push	dbg3
;	 	call	printf
;	 	pop		eax	
;	 	pop		eax	
		
;	 	push	edx
;		push	dbg1
;	 	call	printf
;	 	pop		eax	
;	 	pop		eax	

	 	
	 	
fim: 
     	mov     esp, ebp	; recupera pilha como era antes de executar o programa
     	pop     ebp
	 
     	mov	eax, 0		; valor de retorno normal, sem erro
     	ret				; return
