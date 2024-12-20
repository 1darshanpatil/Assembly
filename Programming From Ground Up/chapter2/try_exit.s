.section .data
.section .text
.globl _start
_start:
  movl $1, %eax;
  movl $34, %ebx; #Writing some random numbers work here, so yup! The program works and you can see `echo $?`
  int $0x80
