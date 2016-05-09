;
; Programa para identificar se um arquivo de entrada
; eh ou nao um arquivo do MS-Word
;
; Autor: Richard Rene Pereira
; Data: 26/05/2009
; FACIN/FENG, PUCRS
; Disciplina: Arquitetura de Computadores I
;
; Passos para gerar o executavel:
; nasm -f elf exerc_arq_i.asm
; ld -s -o exerc_arq_i exerc_arq_i.o
;
; Utilizacao:
; Copiar um arquivo qualquer (Word ou nao) 
; denominado teste.doc para o mesmo diretorio 
; do executavel e digitar na linha de comando:
; ./exerc_arq_i.asm
;
; Plataforma:
; Linux version 2.6.27.5-117.fc10.i686 (mockbuild@x86-7.fedora.phx.redhat.com) 
;gcc version 4.3.2 20081105 (Red Hat 4.3.2-7)
;

O_RDONLY        equ     00
STDOUT          equ     1
SYS_EXIT        equ     1       
SYS_READ        equ     3
SYS_WRITE       equ     4       
SYS_OPEN        equ     5

SECTION .data
file    db      "teste.doc", 0 ; the file to be read 
str1 	db 	"Eh arquivo do Word!", 0xA
tam1	equ     $ - str1   ; Comprimento da string
str2 	db 	"Nao eh arquivo do Word!", 0xA
tam2	equ     $ - str2   ; Comprimento da string
const 	db 	0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1

SECTION .bss                    ; non-initialized data section
buf     resb    8             	; a buffer with 8 bytes

SECTION .text                   ; text (executable code) section
;global main
_start:
	mov esi, buf
	mov edi, const

        ; int open (const char *pathname, int flags, mode_t mode)
        mov edx, O_RDONLY       ; third argument: read mode 
        mov ecx, 0              ; second argument: flags may be 0
        mov ebx, file           ; first argument: pathname
        mov eax, SYS_OPEN       ; system call number (open)
        int 0x80                ; call kernel
	; eax contem descritor do arquivo aberto
        push eax		; salvar o descritor do arquivo aberto

        ; int read(int fd, void *buf, size_t count)
        mov edx, 8            	; third argument: bytes to read
        mov ecx, buf            ; second argument: pointer to buffer
        mov ebx, eax            ; first argument: file descriptor
        mov eax, SYS_READ       ; system call number (read)
        int 0x80                ; call kernel

	; eax contem nr. de bytes lidos

	; esi aponta para os dados lidos do arquivo
	; edi aponta para a constante de referencia

	mov ecx, 8
compara:
	dec ecx
	jz  ehword
	mov al, [esi]	; [buf]
	mov ah, [edi]	; [const]
	inc esi
	inc edi
	cmp al, ah
	je compara

	jmp nword

	; escreve na tela
ehword:	mov     edx,tam1	; Comprimento da mensagem
	mov     ecx,str1	; ecx aponta para o inicio da mensagem
	jmp 	exec

nword:	mov     edx,tam2	; Comprimento da mensagem
	mov     ecx,str2	; ecx aponta para o inicio da mensagem

exec:	mov     ebx,1		; descritor da saida: (1 = stdout)
	mov     eax,4		; Numero do serviÃ§o (4 = sys_write)
	int     0x80		; Chama o kernel para imprimir a string

fim: 	
        ; void _exit(int status);
        mov ebx, 0              ; first argument: exit code
        mov eax, SYS_EXIT       ; system call number (sys_exit)
        int 0x80
