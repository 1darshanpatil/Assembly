# # ###########################################################################################################
# rip_explanation.s
#
# This file demonstrates loading a 64-bit value from the .data section into %rax using RIP-relative
# addressing "myVar(%rip)". It includes an exhaustive explanation of:
#
#   1) What "movq" is.
#   2) How "myVar(%rip) -> %rax" works (why %rip, can we use something else, etc.).
#   3) Whether we can set %rip manually.
#   4) What special-purpose registers are (like %rip, %rsp, %rbp, etc.).
#
# Finally, it shows a minimal syscall (#60 => sys_exit) so the program ends gracefully.
# # ###########################################################################################################

        .section .data

myVar:  .quad 42
# ^ Here, we define "myVar" as a label for 8 bytes (.quad = 64 bits) initialized to 42.

        .section .text
        .globl _start

_start:
# #########################################################################################
# 1) What is movq?
#
# - "movq" is an instruction in x86-64 assembly; more precisely, it’s the 64-bit variant
#   of the mov family of instructions.
# - "mov" means “move data from a source operand to a destination operand.”
# - "q" stands for “quadword” (8 bytes, 64 bits).
#
# So "movq source, destination" means: “Copy 8 bytes from 'source' to 'destination'.”
#
# Instruction vs. Operator:
# - In assembly language, "mov" is typically called an instruction rather than an operator
#   or function. It tells the CPU, “Copy the value from A to B.”
#
# Example forms:
#   movb => move a byte (8 bits)
#   movw => move a word (16 bits)
#   movl => move a long (32 bits)
#   movq => move a quadword (64 bits)
# #########################################################################################

        movq    myVar(%rip), %rax

# #########################################################################################
# 2) myVar(%rip) -> %rax: How Does %rip Work Here?
#
# - "myVar(%rip)" is RIP-relative addressing:
#
#   %rip is the Instruction Pointer register on x86-64. It always points to the current
#   (or next) instruction’s address in memory.
#
# - When you write "myVar(%rip)", the assembler/linker computes a displacement (an offset)
#   such that at runtime:
#       effective_address = %rip + (some_offset)
#   That offset is chosen so the result = address of myVar.
#
# - Why do we use %rip?
#   * In 64-bit Linux, position-independent code (PIC) is common (for shared libraries
#     and security). RIP-relative addressing allows the code to work even if loaded at
#     different memory addresses.
#   * If the code (and data) get relocated, the offset from %rip to myVar remains consistent,
#     so no absolute addresses are “hard-coded.”
#
# - Could we use another register instead of %rip?
#   * For accessing global/static variables in 64-bit mode, the standard method is %rip-relative.
#   * In older 32-bit assembly, you might see absolute addresses (like "movl myVar, %eax") or
#     a base register. But in 64-bit with typical relocations, “myVar(%rip)” is recommended.
#   * You can do something like:
#
#       leaq myVar(%rip), %rbx
#       movq (%rbx), %rax
#
#     but that still uses %rip at least once to get myVar’s address into %rbx.
#   * True “absolute addressing” in 64-bit (like "movq 0x400056, %rax") is not
#     position-independent. So %rip is standard for referencing static data.
# #########################################################################################

        # After this line, %rax = 42 (the value stored at myVar).

# #########################################################################################
# 3) Can I Set %rip Manually?
#
# - %rip is not a general-purpose register; it’s the Instruction Pointer. The CPU updates
#   %rip automatically as it executes instructions (pointing to the next instruction).
# - In normal code, you cannot do something like "movq $0xdeadbeef, %rip". The CPU doesn’t
#   allow that form; it would break how instruction fetching works.
#
# - How do we normally “set” %rip?
#   * If you jump or call or return, that effectively changes %rip. For example:
#       jmp label => sets %rip to the address of 'label'.
#       call func => pushes old %rip, then loads %rip with 'func’s address'.
#   * So you can’t just treat %rip as a normal variable. Instead, you affect it
#     via flow-control instructions (jmp, call, ret).
#
# - What if multiple variables (myVar, yourVar, etc.) exist?
#   * Each label can be referenced with %rip. The assembler calculates the offset needed
#     for each label.
#   * Example:
#       movq myVar(%rip), %rax
#       movq yourVar(%rip), %rbx
#       movq ourVar(%rip), %rcx
#   * Each uses %rip-relative addressing but a different offset for each label.
#
# - So you can’t “store data in %rip” because %rip is not general-purpose storage. It’s the
#   CPU’s program counter telling which instruction is executing. We only manipulate it
#   indirectly via branches or calls.
# #########################################################################################

# #########################################################################################
# 4) What Are Special-Purpose Registers?
#
# - Special-purpose registers on x86-64 are those the CPU uses for specific tasks,
#   rather than for general data. They include:
#   * %rip => Instruction Pointer (which instruction is next)
#   * %rsp => Stack Pointer (top of the current stack frame)
#   * %rbp => Base Pointer (often used for stack frame in older calling conventions)
#   * %rflags => Flags register (stores condition codes, etc.)
#   * Segment registers => %cs, %ds, %es, %fs, %gs, %ss (mostly legacy in modern OS usage)
#
# - Typically, you do NOT store arbitrary data in these registers (except %rbp can be used
#   as a general register if you choose not to maintain the traditional base pointer).
#
# - %rip is strictly for instruction addresses; you don’t set it directly with "mov".
#   You let the CPU handle it or use jumps/calls/returns to change it.
# #########################################################################################

        # Now we do a minimal exit so the program ends cleanly in Linux x86-64.
        # Not explained in depth; just a standard snippet:
        movq    $60, %rax    # syscall number for sys_exit
        xorq    %rdi, %rdi   # exit code = 0
        syscall

# <--- Ensure there's a newline after 'syscall' to avoid assembler "end of file not at end of a line" warning.

#
# IN SHORT (recap):
#   movq => “move/copy 8 bytes.”
#   myVar(%rip) => Means “take the address of 'myVar' relative to %rip.”
#   %rip => special register (Instruction Pointer); you can’t do movq $123, %rip.
#   You change %rip via jumps/calls. 
#   Special-purpose registers => CPU-defined roles; not for free-form data storage.
# # ###########################################################################################################
