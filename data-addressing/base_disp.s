#############################################################################################################
# You may get a nonsense error like below:
# base_disp.s: Assembler messages:
# base_disp.s: Warning: end of file not at end of a line; newline inserted
# [Ilya@m87 data-addressing]$ as base_disp.s -o base_disp.o
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
# Demonstrates "Base + Displacement" addressing mode.
#
# .section .data
#  - Contains myArr, storing four 64-bit integers (10, 20, 30, 40).
#
# .section .text / .globl _start
#  - Standard: define our code section and entry point.
#
# _start:
#   1) leaq myArr(%rip), %r8
#      - Loads the address of 'myArr' into %r8 (RIP-relative).
#   2) movq 8(%r8), %r9
#      - Reads 8 bytes past %r8 => the second element (index 1) => 20, into %r9.
#   3) movq $60, %rax; xorq %rdi, %rdi; syscall
#      - Exits immediately with code 0.
#############################################################################################################

        .section .data
myArr:  .quad 10, 20, 30, 40

        .section .text
        .globl _start

_start:
        leaq    myArr(%rip), %r8      # Load address of myArr
        movq    8(%r8), %r9           # myArr[1] => 20 into %r9

        movq    $60, %rax             # sys_exit
        xorq    %rdi, %rdi            # exit code 0
        syscall

# <-- New line at the end -->

