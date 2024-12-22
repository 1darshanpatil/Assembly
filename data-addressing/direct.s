#############################################################################################################
# You may get a nonsense error like below:
# direct.s: Assembler messages:
# direct.s: Warning: end of file not at end of a line; newline inserted
# [Ilya@m87 data-addressing]$ as direct.s -o direct.o
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
# Demonstrates "Direct (Absolute) Addressing" in x86-64. However, 
# x86-64 typically uses RIP-relative, so you might see 'myVar(%rip)'.
#
# .section .data
#   - myVar: .quad 42
#     => stores 64-bit integer 42 in memory.
#
# .section .text / .globl _start
#   - _start:
#       movq myVar(%rip), %rax => loads the value at 'myVar' into %rax.
#       Then do sys_exit(0).
#############################################################################################################

        .section .data
myVar:  .quad 42

        .section .text
        .globl _start

_start:
        movq    myVar(%rip), %rax  # load 42 into %rax

        movq    $60, %rax          # sys_exit(0)
        xorq    %rdi, %rdi
        syscall

# <-- New line at the end -->

