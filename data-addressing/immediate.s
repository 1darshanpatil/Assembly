#############################################################################################################
# You may get a nonsense error like below:
# immediate.s: Assembler messages:
# immediate.s: Warning: end of file not at end of a line; newline inserted
# [Ilya@m87 data-addressing]$ as immediate.s -o immediate.o
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
# Demonstrates "Immediate Addressing":
#   movq $123, %rax => loads the literal 123 into %rax.
# Then we immediately exit(0).
#
# Steps:
#   1) movq $123, %rax  (Immediate value 123)
#   2) movq $60, %rax   => 60 is sys_exit
#   3) xorq %rdi, %rdi  => set exit code to 0
#   4) syscall          => exit(0)
#############################################################################################################

    .section .text
    .globl _start

_start:
    movq $123, %rax          # load 123 into %rax

    movq $60, %rax           # 60 => sys_exit
    xorq %rdi, %rdi          # exit code = 0
    syscall

# <-- New line at the end -->

