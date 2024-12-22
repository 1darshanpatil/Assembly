#############################################################################################################
# You may get a nonsense error like below:
# indirect.s: Assembler messages:
# indirect.s: Warning: end of file not at end of a line; newline inserted
# [Ilya@m87 data-addressing]$ as indirect.s -o indirect.o
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
# Demonstrates "Register Indirect Addressing":
#
# .section .data
#   somveVal: .quad 999
#     => a 64-bit integer with the value 999 in memory.
#
# .section .text
#   _start:
#     leaq somveVal(%rip), %rbx => get address of somveVal into %rbx
#     movq (%rbx), %rax         => dereference that address to load 999 into %rax
#     sys_exit(0)
#############################################################################################################

    .section .data
somveVal:   .quad 999

    .section .text
    .globl  _start

_start:
    leaq    somveVal(%rip), %rbx   # %rbx = address of somveVal
    movq    (%rbx), %rax           # %rax = *%rbx => 999

    movq    $60, %rax              # sys_exit
    xorq    %rdi, %rdi             # exit code 0
    syscall

# <-- New line at the end -->

