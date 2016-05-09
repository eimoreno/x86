# Makefile for nasm assembly code (and corresponding C code)

all: hello hello_p printf1 printf2 intarith fltarith rep_str rep_str_p inv_str_p escreve_num escreve_float ler_arq 

ler_arq: ler_arq.asm
	../nasm-0.98.39/nasm -f elf -l ler_arq.lst  ler_arq.asm
	gcc -o ler_arq  ler_arq.o

escreve_num: escreve_num.asm
	../nasm-0.98.39/nasm -f elf -l escreve_num.lst  escreve_num.asm
	gcc -o escreve_num  escreve_num.o

escreve_float: escreve_float.asm
	../nasm-0.98.39/nasm -f elf -l escreve_float.lst  escreve_float.asm
	gcc -o escreve_float  escreve_float.o

rep_str: rep_str.asm
	../nasm-0.98.39/nasm -f elf -l rep_str.lst  rep_str.asm
	gcc -o rep_str  rep_str.o

rep_str_p: rep_str.asm
	../nasm-0.98.39/nasm -f elf -l rep_str_p.lst  rep_str_p.asm
	gcc -o rep_str_p  rep_str_p.o

inv_str_p: inv_str_p.asm
	../nasm-0.98.39/nasm -f elf -l inv_str_p.lst  inv_str_p.asm
	gcc -o inv_str_p  inv_str_p.o

hello: hello.asm
	../nasm-0.98.39/nasm -f elf -l hello.lst  hello.asm
	gcc -o hello hello.o

hello_p: hello_p.asm
	../nasm-0.98.39/nasm -f elf -l hello_p.lst  hello_p.asm
	gcc -o hello_p hello_p.o

printf1: printf1.asm printf1.c
	../nasm-0.98.39/nasm -f elf -l printf1.lst  printf1.asm
	gcc -o printf1  printf1.o
	gcc -o printf1c printf1.c

printf2: printf2.asm printf2.c
	../nasm-0.98.39/nasm -f elf -l printf2.lst  printf2.asm
	gcc -o printf2  printf2.o
	gcc -o printf2c printf2.c

intarith: intarith.asm intarith.c
	../nasm-0.98.39/nasm -f elf -l intarith.lst  intarith.asm
	gcc -o intarith  intarith.o
	gcc -o intarithc intarith.c

fltarith: fltarith.asm fltarith.c
	../nasm-0.98.39/nasm -f elf -l fltarith.lst  fltarith.asm
	gcc -o fltarith  fltarith.o
	gcc -o fltarithc  fltarith.c

recompile:
	rm -f *.out
	rm -f *.outc
	make all

clean:  # for moving to another platform, keeping results
 
	rm -f ler_arq
	rm -f escreve_float
	rm -f escreve_num
	rm -f rep_str
	rm -f rep_str_p
	rm -f inv_str_p
	rm -f hello
	rm -f hello_p
	rm -f printf1
	rm -f printf2
	rm -f intarith
	rm -f fltarith
	rm -f a.out
	rm -f *~
	rm -f core*
	rm -f *.o

initial:
	rm -f *.out
	rm -f *.outc
	rm -f *.lst
	rm -f *.s
	make clean

web:
	chgrp cseeweb *
	chmod go+rx *
	chmod g+w *
