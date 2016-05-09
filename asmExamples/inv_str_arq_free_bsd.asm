;-----------------------------------------------------------------------------
; Autor: Eduardo Augusto Bezerra, 01/11/2006
; Inverte strings definidas no arquivo texto MAC211.txt.
; Versao para Free BSD (ver a int 80H separada e acionada via syscall)
; Verificar se conteudo do Makefile esta' ok, e executar "make" no prompt;
; ou, se nao tiver Makefile:
; nasm -f elf inv_str_arq_free_bsd.asm
; ld -s -o inv_str_arq_free_bsd inv_str_arq_free_bsd.o
;-----------------------------------------------------------------------------
O_RDONLY        equ     00
O_WRONLY		equ		01
O_RDWR		    equ		2
STDIN			equ		0
STDOUT          equ     1
SYS_EXIT        equ     1       
SYS_FORK		equ		2
SYS_READ        equ     3
SYS_WRITE       equ     4       
SYS_OPEN        equ     5
SYS_CLOSE		equ		6
SYS_CREAT		equ		8

SECTION .data
str1 		db 0x0A, "String original do arquivo: ", 0x0A, "--------------------------", 0x0A,  0
tam1 		equ $ - str1   ; Comprimento da str1
str2 		db 0x0A, "String invertida: ", 0x0A, "----------------", 0x0A, 0
tam2 		equ $ - str2   ; Comprimento da str2
str3 		db 0x0A, 10, "Fim do programa!", 0x0A, 0x0A, 0
tam 		equ $ - str3   ; Comprimento da str3
file_in		db "MAC211.txt", 0 ; the file to be read 
file_out	db "SAIDA.txt", 0 ; the file to be written
nr_bytes	dd	0

SECTION .bss                    ; non-initialized data section
buf     	resb    1024        ; a buffer with 1024 bytes
tam3 		equ $ - buf   		; Comprimento de buf
buf_d   	resb    1024        ; a buffer with 1024 bytes
tam4 		equ $ - buf_d 		; Comprimento de buf

section	.text
    global _start			;must be declared for linker (ld)

_syscall:		
	int	0x80		;system call
	ret

_start:				;tell linker entry point

        ;-----------------------------------------------------------
		; escreve na tela a primeira mensagem str1
        ;-----------------------------------------------------------
		push	dword tam1	;message length
		push	dword str1	;message to write
		push	dword 1		;file descriptor (stdout)
		mov		eax,0x4		;system call number (sys_write)
		call	_syscall	;call kernel
		add		esp,12		;clean stack (3 arguments * 4)

        ;-----------------------------------------------------------
		; Abre arquivo de entrada MAC211.txt.
		; Saida: EAX contem descritor do arquivo aberto para leitura
		; int open (const char *pathname, int flags, mode_t mode)
        ;-----------------------------------------------------------
        push	dword O_RDONLY
        push	dword 0
        push	dword file_in
        mov 	eax, SYS_OPEN       ; system call number (open)
		call	_syscall	;call kernel
		add		esp,12		;clean stack (3 arguments * 4)
		; no retorno do syscall acima, eax contem o descritor do arquivo aberto
		mov		edx, eax

        ;-----------------------------------------------------------
        ; Le todo o arquivo de entrada, e copia para variavel buf
        ; Saida: EAX contem nr. de bytes lidos - copiar para var. nr_bytes
        ; int read(int fd, void *buf, size_t count)
        ;-----------------------------------------------------------
        push	dword tam3
        push	dword buf
        push	dword eax
        mov 	eax, SYS_READ       ; system call number (read)
		call	_syscall	;call kernel
		add		esp,12		;clean stack (3 arguments * 4)
		; no retorno do syscall acima, eax contem o numero de bytes lidos (tamanho da string a ser convertida)		
		mov		[nr_bytes], eax
		
        ;-----------------------------------------------------------
        ; Fecha arquivo de entrada
        ; int close (int fd)
        ;-----------------------------------------------------------
        mov		eax, edx		; copia descritor do arquivo a ser fechado de volta para eax
        push	dword eax
        push	dword eax
        push	dword eax
        mov 	eax, SYS_CLOSE  ; system call number (close)
		call	_syscall		;call kernel
		add		esp,12			;clean stack (3 arguments * 4)

        ;-----------------------------------------------------------
		; Escreve na tela a string original lida do arquivo de entrada
        ;-----------------------------------------------------------
        mov		eax, [nr_bytes]
		push	dword eax		;message length
		push	dword buf		;message to write
		push	dword STDOUT	;file descriptor (stdout)
		mov		eax, SYS_WRITE	;system call number (sys_write)
		call	_syscall		;call kernel
		add		esp,12			;clean stack (3 arguments * 4)

        ;-----------------------------------------------------------
		; Escreve na tela a segunda mensagem str2
        ;-----------------------------------------------------------
		push	dword tam2		;message length
		push	dword str2		;message to write
		push	dword STDOUT	;file descriptor (stdout)
		mov		eax, SYS_WRITE	;system call number (sys_write)
		call	_syscall		;call kernel
		add		esp,12			;clean stack (3 arguments * 4)
		
        ;-----------------------------------------------------------
		; Inverte a string em buf (lida do arquivo), colocando em buf_d
        ;-----------------------------------------------------------
		mov		ecx, [nr_bytes]
		mov		esi, buf	; esi aponta para primeira posicao da string a ser invertida
		mov		edi, buf_d	; edi aponta para primeira posicao da string destino (buf)
		add		edi, ecx	; ao somar edi com o tamanho da string (ecx), edi passa a apontar para o final da string destino
		; copia os caracteres da string original para o destino, invertendo (de tras para frente)	 	
l1:		mov		al, [esi]
		mov		[edi], al
		inc		esi			; incrementa ponteiro para string (para pegar o proximo caracter)
		dec		edi			; decrementa ponteiro da string destino
		loop	l1			; vai para o proximo caracter
		
        ;-----------------------------------------------------------
		; Escreve string invertida (armazenada em buf) na tela
        ;-----------------------------------------------------------
		mov		ecx, [nr_bytes]
		push	dword ecx		;message length
		push	dword buf_d		;message to write
		push	dword STDOUT	;file descriptor (stdout)
		mov		eax, SYS_WRITE	;system call number (sys_write)
		call	_syscall		;call kernel
		add		esp,12			;clean stack (3 arguments * 4)

        ;-----------------------------------------------------------
        ; Cria arquivo de saida
		; int open (const char *pathname, int flags, mode_t mode)        
        ;-----------------------------------------------------------
        push	dword O_WRONLY		; 
        push	dword 1				; flags
        push	dword file_out
        mov 	eax, SYS_CREAT       ; system call number (creat)
		call	_syscall	;call kernel
		add		esp,12		;clean stack (3 arguments * 4)
		; no retorno do syscall acima, eax contem o descritor do arquivo aberto
		mov		edx, eax
		
        ;-----------------------------------------------------------
		; Escreve string invertida (armazenada em buf_d) no arquivo de saida
		; int write(int fd, const void *buf, size_t count)
        ;-----------------------------------------------------------
		mov		ecx, [nr_bytes]
				
        push	dword ecx			;message length
        push	dword buf_d			;message to write
        push	dword eax			; eax contem descritor do arquivo (ver acima)
        mov 	eax, SYS_WRITE       ; system call number (write)
		call	_syscall	;call kernel
		add		esp,12		;clean stack (3 arguments * 4)

        ;-----------------------------------------------------------
        ; Fecha arquivo de saida
        ; int close (int fd)
        ;-----------------------------------------------------------
        mov		eax, edx		; copia descritor do arquivo a ser fechado de volta para eax
        push	dword eax
        push	dword eax
        push	dword eax
        mov 	eax, SYS_CLOSE  ; system call number (close)
		call	_syscall		;call kernel
		add		esp,12			;clean stack (3 arguments * 4)

        ;-----------------------------------------------------------
		; Escreve mensagem de despedida na tela
        ;-----------------------------------------------------------
		push	dword tam		;message length
		push	dword str3		;message to write
		push	dword STDOUT	;file descriptor (stdout)
		mov		eax,0x4			;system call number (sys_write)
		call	_syscall		;call kernel
		add		esp,12			;clean stack (3 arguments * 4)

        ;-----------------------------------------------------------
		; exit()
        ;-----------------------------------------------------------
		push	dword 0		;exit code
		mov		eax,0x1		;system call number (sys_exit)
		call	_syscall	;call kernel

				;we do not return from sys_exit,
				;there's no need to clean stack

