#############################################################################################################
# You may get a nonsense error like below:
# register.s: Assembler messages:
# register.s: Warning: end of file not at end of a line; newline inserted
# [Ilya@m87 data-addressing]$ as register.s -o register.o
# [Ilya@m87 data-addressing]$
#
# [[Solution]]
# Your code should end to a new line
# Ex:
# syscall
# <---New Line--->
#
# if you do not have <---New Line---> then the above error:)
#############################################################################################################

#############################################################################################################
# Explanation (Theory):
# Demonstrates "Register Addressing":
#
# Steps:
#   1) movq $123, %rax => sets %rax to 123
#   2) movq %rax, %rbx => copies %rax into %rbx (also 123)
#   3) sys_exit(0)
#############################################################################################################

    .section .text
    .globl _start

_start:
    movq $123, %rax          # immediate -> register
    movq %rax, %rbx          # register -> register

    movq $60, %rax           # sys_exit
    xorq %rdi, %rdi          # exit code 0
    syscall

# <-- New line at the end -->

