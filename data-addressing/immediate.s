# ###########################################################################################################
# Explanation (Theory):
#
# This file demonstrates "immediate addressing" in x86-64 assembly via:
#   movq $147, %rax
#
# 1) Using %rax vs. any other register:
#    - We used %rax purely for illustration. In reality, you could pick **any** 64-bit 
#      general-purpose register. Here’s the complete list of 16 on x86-64:
#
#        %rax, %rbx, %rcx, %rdx, %rsi, %rdi, %rbp, %rsp,
#        %r8,  %r9,  %r10, %r11, %r12, %r13, %r14, %r15
#
#      Each has "sub-registers" in 32-bit, 16-bit, and 8-bit forms, for instance:
#         %rax -> %eax (32-bit), %ax (16-bit), %al (8-bit)
#         %rbx -> %ebx, %bx, %bl
#         %rcx -> %ecx, %cx, %cl
#         %rdx -> %edx, %dx, %dl
#         %rsi -> %esi, %si, %sil
#         %rdi -> %edi, %di, %dil
#         %rbp -> %ebp, %bp, %bpl
#         %rsp -> %esp, %sp, %spl
#         %r8  -> %r8d, %r8w, %r8b
#         ...
#         %r15 -> %r15d, %r15w, %r15b
#
#    - For our "immediate.s", picking %rax is just a convenient, common example. 
#      We often see %rax used in examples because historically it’s the “accumulator” register
#      and certain instructions optimize around it.
#
#    - **Official Reference**:
#      For further details on these registers and the x86-64 System V ABI, see:
#      https://refspecs.linuxfoundation.org/elf/x86_64-abi-0.99.pdf
#      (The AMD64 ABI Supplement)
#
# 2) sys_exit snippet:
#    - Next, we overwrite %rax with 60 => 'sys_exit'. We also do xorq %rdi, %rdi => exit code 0.
#    - Then "syscall" enters the kernel, ending the program with exit(0). These lines are simply
#      a minimal, standard approach to terminate on Linux x86-64. 
#
# ###########################################################################################################

        .section .text
        .globl _start

_start:
        movq $147, %rax       # (A) Demonstrate immediate addressing: %rax = 147 (64-bit)

        movq $60, %rax        # (B) Overwrite %rax => 60 (sys_exit)
        xorq %rdi, %rdi       # (C) %rdi = 0 => exit code
        syscall               # (D) Enter kernel => exit(0)

# Make sure you have a newline at the end of the file to avoid assembler warnings
