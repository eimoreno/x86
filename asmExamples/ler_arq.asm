;-----------------------------------------------------------------------------
; Abre arquivo, le alguns bytes, envia para stdout.
; Verificar se conteudo do Makefile esta' ok, e executar "make" no prompt;
; ou, se nao tiver Makefile:
; nasm -f elf -l ler_arq.lst ler_arq.asm
; gcc -o ler_arq  ler_arq.o
;-----------------------------------------------------------------------------

;; This little assembly program issues 4 system calls to the Linux Kernel: 
;; it opens a file, reads some bytes from it, sends the bytes to stdout,
;; and exits. Totally cool!

O_RDONLY        equ     00
STDOUT          equ     1
SYS_EXIT        equ     1       
SYS_READ        equ     3
SYS_WRITE       equ     4       
SYS_OPEN        equ     5

SECTION .data
file    db      "MAC211.txt", 0 ; the file to be read 

SECTION .bss                    ; non-initialized data section
buf     resb    256             ; a buffer with 256 bytes

SECTION .text                   ; text (executable code) section
global main
main:
        ; int open (const char *pathname, int flags, mode_t mode)
        mov edx, O_RDONLY       ; third argument: read mode 
        mov ecx, 0              ; second argument: flags may be 0
        mov ebx, file           ; first argument: pathname
        mov eax, SYS_OPEN       ; system call number (open)
        int 0x80                ; call kernel

        ; int read(int fd, void *buf, size_t count)
        mov edx, 256            ; third argument: bytes to read
        mov ecx, buf            ; second argument: pointer to buffer
        mov ebx, eax            ; first argument: file descriptor
        mov eax, SYS_READ       ; system call number (read)
        int 0x80                ; call kernel

        ; int write(int fd, const void *buf, size_t count)
        mov edx, eax            ; third argument: message length
        mov ecx, buf            ; second argument: pointer to message to write
        mov ebx, STDOUT         ; first argument: file handle (stdout)
        mov eax, SYS_WRITE      ; system call number (sys_write)
        int 0x80                ; call kernel

        ; void _exit(int status);
        mov ebx, 0              ; first argument: exit code
        mov eax, SYS_EXIT       ; system call number (sys_exit)
        int 0x80

