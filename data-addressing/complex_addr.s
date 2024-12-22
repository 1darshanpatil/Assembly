#############################################################################################################
# You may get a nonsense error like below:
# complex_addr.s: Assembler messages:
# complex_addr.s: Warning: end of file not at end of a line; newline inserted
# [Ilya@m87 data-addressing]$ as complex_addr.s -o complex_addr.o
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
# Demonstrates "Base + Index + Scale + Displacement" addressing.
#
# .section .data
#   - myArr: .quad 10, 20, 30, 40
#
# .section .text
#   - _start:
#       1) leaq myArr(%rip), %r8 => load the base address of myArr
#       2) movq $2, %rax => index=2
#       3) movq (%r8, %rax, 8), %r9 => base = %r8, index = %rax, scale=8 => myArr[2] => 30
#       4) exit(0)
#############################################################################################################

        .section .data
myArr:  .quad 10, 20, 30, 40

        .section .text
        .globl _start

_start:
        leaq    myArr(%rip), %r8   # %r8 = address of myArr
        movq    $2, %rax           # index = 2
        movq    (%r8, %rax, 8), %r9  # myArr[2] => 30

        movq    $60, %rax          # sys_exit
        xorq    %rdi, %rdi         # exit code 0
        syscall

# <-- New line at the end -->

