#############################################################################################################
# You may get a nonsense error like below:
# addressing.s: Assembler messages:
# addressing.s: Warning: end of file not at end of a line; newline inserted
# [Ilya@m87 data-addressing]$ as addressing.s -o addressing.o
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
# This file demonstrates multiple addressing modes in x86-64 AT&T syntax:
#   1) Immediate Addressing
#   2) Register Addressing
#   3) Direct (Absolute) Addressing
#   4) Register Indirect Addressing
#   5) Base + Displacement Addressing
#   6) Base + Index + Scale + Displacement
#
# .section .data
#   - Declares a region for global/static variables.
# .align 8
#   - Aligns the data on an 8-byte boundary.
#
# myVar: .quad 42
#   - Reserves 8 bytes (64 bits) and stores the value 42 at the label 'myVar'.
#
# myArr: .quad 10, 20, 30, 40
#   - Reserves 32 bytes (4 x 8 bytes) storing the sequence (10, 20, 30, 40).
#
# .section .text
#   - Switches to the code section.
# .globl _start
#   - Marks '_start' as a global symbol (the program entry point for Linux).
#
# _start:
#   1) movq $123, %rax
#      - Immediate addressing: loads the literal constant 123 into register %rax.
#
#   2) movq %rax, %rbx
#      - Register addressing: copies the value from %rax into %rbx.
#
#   3) movq myVar(%rip), %rcx
#      - Direct addressing (RIP-relative): loads the 64-bit value at 'myVar' into %rcx (which becomes 42).
#
#   4) leaq myVar(%rip), %rdx
#      - Loads the address of 'myVar' into %rdx.
#     movq (%rdx), %rsi
#      - Register indirect addressing: dereferences %rdx to load the value 42 into %rsi.
#
#   5) leaq myArr(%rip), %r8
#      - Gets the address of myArr in %r8.
#     movq 8(%r8), %r9
#      - Base + displacement: reads 8 bytes after %r8 => the second element of myArr => 20, stores in %r9.
#
#   6) movq $2, %rax
#      - Puts 2 into %rax to serve as an index.
#     movq (%r8, %rax, 8), %r10
#      - Base + index + scale + displacement: effectively myArr[2] => 30, stored in %r10.
#
#   Finally, we exit:
#     movq $60, %rax
#      - 60 is the syscall number for sys_exit on Linux x86-64.
#     xorq %rdi, %rdi
#      - Sets %rdi=0 (the exit code).
#     syscall
#      - Triggers an immediate exit(0).
#############################################################################################################

    .section .data
    .align 8

myVar: .quad 42
myArr: .quad 10, 20, 30, 40

    .section .text
    .globl _start

_start:
    # 1) Immediate addressing
    movq $123, %rax                 # %rax = 123

    # 2) Register addressing
    movq %rax, %rbx                 # %rbx = %rax = 123

    # 3) Direct addressing
    movq myVar(%rip), %rcx          # %rcx = the 64-bit value at myVar => 42

    # 4) Register indirect
    leaq myVar(%rip), %rdx          # %rdx = address of myVar
    movq (%rdx), %rsi               # %rsi = *(%rdx) => 42

    # 5) Base + displacement
    leaq myArr(%rip), %r8           # %r8 = address of myArr
    movq 8(%r8), %r9                # %r9 = *(%r8+8) => 20

    # 6) Base + index + scale + displacement
    movq $2, %rax                    # index = 2
    movq (%r8, %rax, 8), %r10        # %r10 = myArr[2] => 30

    # sys_exit(0)
    movq $60, %rax                   # 60 = sys_exit
    xorq %rdi, %rdi                  # %rdi = 0
    syscall

# <-- New line at the end -->

