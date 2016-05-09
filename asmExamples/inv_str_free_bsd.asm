;-----------------------------------------------------------------------------
; Inverte as strings definidas na area de dados.
; Versao para Free BSD (ver a int 80H separada e acionada via syscall)
; Verificar se conteudo do Makefile esta' ok, e executar "make" no prompt;
; ou, se nao tiver Makefile:
; nasm -f elf inv_str_free_bsd.asm
; ld -s -o inv_str_free_bsd inv_str_free_bsd.o
;-----------------------------------------------------------------------------

SECTION .data
str1 db 0x0a, ".gnirts ed oasrevni ed etseT", 0x0A, 0	; Notar a utilizacao da formatacao para o printf, incluindo um "/n" e um "/0" no final da string
tam1 equ $ - str1   ; Comprimento da str1

str2 db 0x0a, "Teste de inversao de string.", 0x0A, 0	; Notar a utilizacao da formatacao para o printf, incluindo um "/n" e um "/0" no final da string
tam2 equ $ - str2   ; Comprimento da str2

str3 db 10, "1234567890", 10, 0
tam3 equ $ - str3   ; Comprimento da str3

str4 db "Funciona!", 10, 0
tam4 equ $ - str4   ; Comprimento da str4

str5 db 10, "!anoicnuF", 0x0A, 0
tam5 equ $ - str5   ; Comprimento da str5

SECTION .bss                    ; non-initialized data section
buf     resb    256             ; a buffer with 256 bytes


section	.text
    global _start			;must be declared for linker (ld)

_syscall:		
	int	0x80		;system call
	ret

_start:				;tell linker entry point
;********************
;********************
; STRING 1 - str1
;********************
;********************
		mov		ecx, tam1
		mov		esi, str1	; esi aponta para primeira posicao da string a ser invertida
		mov		edi, buf	; edi aponta para primeira posicao da string destino (buf)
		add		edi, ecx	; ao somar edi com o tamanho da string (ecx), edi passa a apontar para o final da string destino

		; copia os caracteres da string original para o destino, invertendo (de tras para frente)	 	
l1:		mov		al, [esi]
		mov		[edi], al
		
		inc		esi			; incrementa ponteiro para string (para pegar o proximo caracter)
		dec		edi			; decrementa ponteiro da string destino
		loop	l1			; vai para o proximo caracter

		; escreve string invertida (armazenada em buf) na tela com printf
		
		push	dword tam1	;message length
		push	dword buf	;message to write
		push	dword 1		;file descriptor (stdout)
		mov	eax,0x4		;system call number (sys_write)
		call	_syscall	;call kernel
		add	esp,12		;clean stack (3 arguments * 4)

;********************
;********************
; STRING 2 - str2
;********************
;********************
		mov		ecx, tam2
		mov		esi, str2	; esi aponta para primeira posicao da string a ser invertida
		mov		edi, buf	; edi aponta para primeira posicao da string destino (buf)
		add		edi, ecx	; ao somar edi com o tamanho da string (ecx), edi passa a apontar para o final da string destino

		; copia os caracteres da string original para o destino, invertendo (de tras para frente)	 	
l2:		mov		al, [esi]
		mov		[edi], al
		
		inc		esi			; incrementa ponteiro para string (para pegar o proximo caracter)
		dec		edi			; decrementa ponteiro da string destino
		loop	l2			; vai para o proximo caracter

		; escreve string invertida (armazenada em buf) na tela com printf
		
		push	dword tam2	;message length
		push	dword buf	;message to write
		push	dword 1		;file descriptor (stdout)
		mov	eax,0x4		;system call number (sys_write)
		call	_syscall	;call kernel
		add	esp,12		;clean stack (3 arguments * 4)

;********************
;********************
; STRING 3 - str3
;********************
;********************
		mov		ecx, tam3
		mov		esi, str3	; esi aponta para primeira posicao da string a ser invertida
		mov		edi, buf	; edi aponta para primeira posicao da string destino (buf)
		add		edi, ecx	; ao somar edi com o tamanho da string (ecx), edi passa a apontar para o final da string destino

		; copia os caracteres da string original para o destino, invertendo (de tras para frente)	 	
l3:		mov		al, [esi]
		mov		[edi], al
		
		inc		esi			; incrementa ponteiro para string (para pegar o proximo caracter)
		dec		edi			; decrementa ponteiro da string destino
		loop	l3			; vai para o proximo caracter

		; escreve string invertida (armazenada em buf) na tela com printf
		
		push	dword tam3	;message length
		push	dword buf	;message to write
		push	dword 1		;file descriptor (stdout)
		mov	eax,0x4		;system call number (sys_write)
		call	_syscall	;call kernel
		add	esp,12		;clean stack (3 arguments * 4)
		
;********************
;********************
; STRING 4 - str4
;********************
;********************
		mov		ecx, tam4
		mov		esi, str4	; esi aponta para primeira posicao da string a ser invertida
		mov		edi, buf	; edi aponta para primeira posicao da string destino (buf)
		add		edi, ecx	; ao somar edi com o tamanho da string (ecx), edi passa a apontar para o final da string destino

		; copia os caracteres da string original para o destino, invertendo (de tras para frente)	 	
l4:		mov		al, [esi]
		mov		[edi], al
		
		inc		esi			; incrementa ponteiro para string (para pegar o proximo caracter)
		dec		edi			; decrementa ponteiro da string destino
		loop	l4			; vai para o proximo caracter

		; escreve string invertida (armazenada em buf) na tela com printf
		
		push	dword tam4	;message length
		push	dword buf	;message to write
		push	dword 1		;file descriptor (stdout)
		mov	eax,0x4		;system call number (sys_write)
		call	_syscall	;call kernel
		add	esp,12		;clean stack (3 arguments * 4)
		
;********************
;********************
; STRING 5 - str5
;********************
;********************
		mov		ecx, tam5
		mov		esi, str5	; esi aponta para primeira posicao da string a ser invertida
		mov		edi, buf	; edi aponta para primeira posicao da string destino (buf)
		add		edi, ecx	; ao somar edi com o tamanho da string (ecx), edi passa a apontar para o final da string destino

		; copia os caracteres da string original para o destino, invertendo (de tras para frente)	 	
l5:		mov		al, [esi]
		mov		[edi], al
		
		inc		esi			; incrementa ponteiro para string (para pegar o proximo caracter)
		dec		edi			; decrementa ponteiro da string destino
		loop	l5			; vai para o proximo caracter

		; escreve string invertida (armazenada em buf) na tela com printf
		
		push	dword tam5	;message length
		push	dword buf	;message to write
		push	dword 1		;file descriptor (stdout)
		mov	eax,0x4		;system call number (sys_write)
		call	_syscall	;call kernel
		add	esp,12		;clean stack (3 arguments * 4)
		
				;the alternate way to call kernel:
				;push	eax
				;call	7:0


		push	dword 0		;exit code
		mov	eax,0x1		;system call number (sys_exit)
		call	_syscall	;call kernel

				;we do not return from sys_exit,
				;there's no need to clean stack

