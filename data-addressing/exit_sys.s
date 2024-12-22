#############################################################################################################
# You may get a nonsense error like below:
# exit_deep_explanation.s: Assembler messages:
# exit_deep_explanation.s: Warning: end of file not at end of a line; newline inserted
# [Ilya@m87 data-addressing]$ as exit_deep_explanation.s -o exit_deep_explanation.o
# [Ilya@m87 data-addressing]$
#
# [[Solution]]
# Your code should end with a newline
# Ex:
# syscall
# <---New Line--->
#
# if you do not have <---New Line---> then the above error:)
#############################################################################################################

#############################################################################################################
# Explanation (Theory):
#
# We want to exit a Linux x86-64 process with code 0 by making a system call. The snippet is:
#
#     movq $60, %rax       # 1) Put syscall number for 'exit' in %rax
#     xorq %rdi, %rdi      # 2) Clear %rdi to 0 (the exit code)
#     syscall              # 3) Actually invoke the system call
#
# Let's break down each question and concept in detail:
#
# --------------------------------------------------------------------------------
# (1) Who set '60' as the syscall number for exit, and why?
#
#   - On Linux x86-64, "60" is the official identifier for the 'sys_exit' system call.
#   - This mapping (syscall number -> meaning) is defined by the Linux kernel developers.
#   - You can find the authoritative list in the Linux source code, for example:
#         arch/x86/entry/syscalls/syscall_64.tbl
#     or in installed headers, typically under:
#         /usr/include/asm/unistd_64.h
#     or:
#         /usr/include/asm-generic/unistd.h
#   - Each syscall has a unique integer. For instance:
#       60 = sys_exit
#       1  = sys_write
#       2  = sys_open
#     etc. So "60" is not arbitrary; it’s set by the kernel maintainers.
#
#   - What if we put something else instead of 60 in %rax?
#       • If we put a valid *different* syscall number (e.g., 1 for sys_write), 
#         we'd be calling that different syscall instead. For example, '1' would attempt
#         to perform a write operation, not exit. 
#       • If we put an invalid number (one that isn't implemented), the kernel would return
#         an error code (e.g., -ENOSYS) to indicate "bad syscall number."
#       • In short, changing the number changes the syscall. We specifically want 'exit', 
#         so we use 60.
#
# --------------------------------------------------------------------------------
# (2) Why put the syscall number in %rax? Could we use another register?
#
#   - The *System V AMD64 ABI* (Application Binary Interface) plus Linux’s own conventions
#     define that for 64-bit syscalls, the syscall number *must* go in %rax.
#   - This is documented in official ABI docs and in the Linux kernel documentation.
#     For instance:
#       • The AMD64 ABI Supplement:
#           https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf
#       • The Linux kernel docs (search for "x86 syscall calling convention").
#   - So NO, we cannot just pick a different register. The kernel specifically checks %rax
#     to see which syscall you want.
#   - If you put 60 in %rbx, for example, the kernel wouldn't interpret that as "exit" unless
#     it was moved back to %rax before calling `syscall`.
#   - In summary, the Linux x86-64 syscall calling convention *mandates*:
#       • %rax = syscall number
#       • %rdi = 1st argument
#       • %rsi = 2nd argument
#       • %rdx = 3rd argument
#       • %r10 = 4th argument
#       • %r8  = 5th argument
#       • %r9  = 6th argument
#
# --------------------------------------------------------------------------------
# (3) Why xorq %rdi, %rdi to set %rdi = 0?
#
#   - The 'exit' system call (syscall #60) takes exactly one argument: the exit code 
#     (also called "status"), which must be placed in %rdi.
#   - Here, we want to exit with code 0 => success. So we set %rdi = 0.
#   - "xorq %rdi, %rdi" is a quick, efficient way of doing "movq $0, %rdi":
#       - XOR-ing a register with itself always yields 0,
#         which the CPU writes back into that same register.
#   - On Linux x86-64, the **syscall argument registers** are used in this order:
#       1st argument => %rdi
#       2nd argument => %rsi
#       3rd argument => %rdx
#       4th argument => %r10
#       5th argument => %r8
#       6th argument => %r9
#
#     For example, if we call 'sys_write' (syscall #1), then:
#       - %rdi = file descriptor
#       - %rsi = pointer to buffer
#       - %rdx = number of bytes to write
#       ... and so on for any additional arguments.
#
#   - Hence, each syscall defines how it uses these registers. For 'exit' (60),
#     only the 1st argument (exit code) matters, so we set %rdi=0.
#
#   - Official references for these conventions:
#       • The System V AMD64 ABI for Linux (e.g., 
#         https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf)
#       • The Linux kernel source/docs (look for "syscall calling convention").
#       • "man 2 syscalls" or "man 2 syscall" on most Linux systems, which outline 
#         how arguments map onto registers for each system call.
#
# --------------------------------------------------------------------------------
# (4) What is 'ring 0'? Who sets these "rings" rules, and what does it have to do with syscalls?
#
#   - Modern x86-64 CPUs implement a hierarchical *privilege model* with "rings":
#       • Ring 0 = highest privilege (kernel mode).
#       • Ring 3 = lowest privilege (user mode).
#       • Rings 1 and 2 exist in theory, but are rarely used in general-purpose OSes.
#
#   - **Why do we have rings?** 
#       - It's about *protection* and *security*. The OS kernel (in ring 0) can directly access 
#         hardware (CPU instructions that configure memory, devices, etc.). User applications 
#         (in ring 3) are restricted: they *cannot* directly use privileged CPU instructions or 
#         mess with hardware resources. 
#       - If every user program had full hardware access, a crash or malicious program could 
#         corrupt the entire system. Rings enforce boundaries to prevent that.
#
#   - What if we didn’t have rings? How could a hacker exploit that?
#       - In the early days of personal computing (e.g., DOS-era), there was minimal or no
#         hardware memory protection. Any program could freely overwrite or tamper with
#         system structures, leading to crashes or malicious takeovers.
#       - Without ring separation, a malicious or buggy user program could:
#           1) Directly execute privileged CPU instructions (turn off interrupts, remap memory, etc.).
#           2) Access critical hardware registers to spy on or manipulate other processes.
#           3) Overwrite the OS kernel’s code or data in memory, effectively taking over
#              the entire machine.
#           4) Bypass any security checks and read/write any file, device, or network interface.
#       - This means **one** compromised program could compromise the **entire system** instantly.
#       - Modern OSes and CPU architectures introduced “rings” (0 through 3) so the kernel
#         has full privileges (ring 0) while user programs (ring 3) are constrained. This
#         containment strategy prevents a single malicious user process from subverting
#         everything. You must go through a well-defined “syscall gate,” where the kernel
#         validates requests and enforces security policies.
#
#       - Essentially, rings are a crucial security barrier:
#           • They confine user code to “safe” operations.
#           • If a process tries something privileged, it must transition into the kernel
#             via a controlled pathway (syscall).
#           • This stops a hacker from directly issuing hardware commands or patching the OS
#             in memory—unless they discover a kernel-level exploit (which is much harder).
#
#   - **How do syscalls fit in?**  
#       - Normally, user code runs in ring 3, which *cannot* directly issue privileged instructions 
#         (like accessing the disk controller or terminating another process). Instead, user programs 
#         request these actions by making a "system call" — that is, they ask the kernel (ring 0) 
#         to do it on their behalf. 
#       - The 'syscall' instruction is the carefully controlled mechanism for switching from 
#         ring 3 (user mode) *into* ring 0 (kernel mode). 
#         Once in ring 0, the kernel sees what you asked for (e.g., "read a file", "exit the process", 
#         "write to network") and, if permitted, performs the operation. Then it switches back to 
#         ring 3 when done.
#
#   - **But reading/writing is so basic—why rings for that?**  
#       - Even something "basic" like reading a file involves hardware resources (disk or SSD), 
#         which must be accessed carefully so one process can’t overwrite another’s data 
#         or read sensitive files. By requiring syscalls, the OS can check permissions, 
#         manage buffers, schedule I/O safely, etc.
#       - Thus, *every* I/O operation from user space (reading/writing files, network, etc.) 
#         travels via a syscall boundary into the kernel (ring 0), ensuring proper security and 
#         resource management.
#
#   - **But isn't it trivial in Python? We just do "with open('file', 'r')" and it works?**
#       - Indeed, from a high-level language like Python, opening a file *seems* trivial:
#         "with open('myfile.txt', 'r') as f: ...".
#       - Under the hood, Python’s I/O library (written in C) eventually calls the OS-provided
#         "open" or "fopen" functions. *Those* functions, in turn, invoke a syscall (like 'sys_openat'
#         or 'sys_open') to actually talk to the kernel.
#       - So even though it *looks* easy to the programmer, your Python code is *still* using a
#         well-defined syscall boundary to request that the OS open the file. The kernel (running
#         in ring 0) checks file permissions, disk access rules, and so on.
#       - If you don’t have permissions, the syscall will fail (e.g., "Permission denied"). This
#         is precisely how the OS enforces security—even from a simple Python script.

#   - **If getting into ring 0 is “one step” (the syscall), why is it still secure and challenging?**
#       - The 'syscall' instruction *does* transition from ring 3 (user mode) to ring 0 (kernel mode).
#       - **However**, user code doesn’t get to *stay* in ring 0 or run arbitrary instructions
#         there. Instead, the kernel has a carefully written “syscall dispatcher.” It looks at:
#           1) The syscall number in %rax (e.g., open, read, write, exit),
#           2) The arguments in %rdi, %rsi, %rdx, etc.,
#         then it runs **kernel code** to do exactly that operation, applying permission checks
#         and resource management along the way.
#       - Once that kernel code finishes, the CPU returns to ring 3 (user space). You never
#         directly “drive” ring 0 yourself; you can only *request* operations from it.
#       - This design *prevents* a malicious program from just “flipping a switch” and
#         permanently taking over ring 0. If the kernel sees a bogus request or lacks permissions,
#         it can block or return an error.
#
#   - **Does having a single-step syscall to ring 0 make the system vulnerable?**
#       - Not automatically. A "syscall" transition is tightly controlled by the kernel:
#           1) The kernel *only* executes code paths it explicitly implements. 
#              (For instance, sys_open or sys_read.) There’s no "let me do whatever I want"
#              function exposed to user space.
#           2) Each syscall includes permission checks, validating file descriptors,
#              user IDs, memory buffers, etc. If something’s disallowed, the kernel
#              returns an error instead of performing the operation.
#       - Even for a skilled hacker, "one step to ring 0" is not enough:
#           1) They would need to find a **kernel bug** or exploit (like a memory corruption)
#              that breaks out of these checks and grants arbitrary ring 0 control.
#           2) Modern kernels implement security features (ASLR, stack canaries, 
#              SELinux, etc.) that make it significantly harder to craft a successful exploit.
#           3) Most syscalls are well audited and have been tested heavily. 
#              Zero-day kernel exploits do exist, but they’re rare and difficult to develop.
#       - Thus, while a syscall is a formal gateway to ring 0, it’s heavily regulated.
#         Absent a kernel vulnerability, user space can’t just seize control. It only
#         “requests” actions; the kernel decides whether to comply.
#
#   - **Hence**: 
#       - A high-level command like "with open(...)" is just a friendly wrapper around a
#         restricted gateway (the syscall). 
#       - The kernel still has full control over what happens in ring 0. 
#       - User-space can’t bypass kernel checks—only *ask* the kernel to do certain tasks.
#         This is why ring separation remains secure, even though user code can “reach” ring 0
#         via syscalls.
#
#
#   - **Where is this documented? Who sets the ring rules?**  
#       - Intel (and AMD) define this ring model in their CPU architecture manuals. 
#         E.g. "Intel® 64 and IA-32 Architectures Software Developer’s Manual."
#       - The OS (like Linux) arranges how ring 3 code can invoke ring 0 code (e.g., via the 'syscall' 
#         instruction), sets up which syscalls exist, and enforces security checks. 
#         This is partly defined by the CPU hardware, partly by OS design.
#
#   - **Visualizing it with your eyes closed**:
#       - Imagine the CPU as a series of concentric circles (rings). The outer ring (ring 3) is 
#         "user land," where normal apps run. The innermost ring (ring 0) is the "kernel land," 
#         with full access to the machine. 
#       - A user program is like a person standing outside the fortress walls, wanting something 
#         done inside. The "syscall" is a secure gate that leads inside (ring 0). 
#         The kernel is the guard deciding whether the request is valid, and if so, doing the 
#         privileged action. 
#
#   - **In short**, rings are a CPU-enforced security feature, and syscalls are the "bridge" 
#     from user-space (unprivileged) to kernel-space (privileged). Without it, any program 
#     could do anything—breaking reliability and security.
#
# --------------------------------------------------------------------------------
# (5) Are syscalls just "functions"?
#
#   - They act *like* function calls into the kernel, but they're special in that:
#       1) You’re switching from ring 3 (user mode) to ring 0 (kernel mode).
#       2) The parameters and return values follow a specific register-based convention.
#       3) The CPU uses the SYSCALL/SYSRET instructions instead of a normal CALL/RET.
#   - So they are not "normal" user-space functions. They’re "system calls" that the kernel
#     provides, each identified by a number. Once inside the kernel, the code runs with
#     full privileges to manage hardware resources and process scheduling.
#
# --------------------------------------------------------------------------------
# (6) How does "syscall" fit with %rax and XOR?
#
#   - Because "syscall" looks at %rax for the syscall number, and uses specific registers
#     for arguments. 
#   - So we must set %rax=60 for 'exit', and we must set the 1st argument in %rdi=0 (the exit code).
#   - Then "syscall" transitions to the kernel with those register values. The kernel sees
#     "Oh, 60? That’s sys_exit. The exit code is in %rdi => 0. Let's terminate the process."
#
#
# Official References & Links:
#
# 1) **System V AMD64 ABI** (Application Binary Interface)
#    - Explains the calling conventions, including how registers (%rax, %rdi, etc.) 
#      are used for arguments and syscall numbers in x86-64. 
#    - The latest official PDF is often found here:
#        https://refspecs.linuxfoundation.org/elf/x86_64-abi-0.99.pdf
#
# 2) **Linux Man Pages** for System Calls
#    - "man 2 syscall" and "man 2 syscalls" provide an overview of how syscalls work
#      on Linux, including the use of registers and the difference from normal functions.
#    - Example: https://man7.org/linux/man-pages/man2/syscall.2.html
#
# 3) **Intel 64 and IA-32 Architectures Software Developer’s Manual**
#    - Describes the SYSCALL/SYSRET instructions, ring transitions, and the CPU-level details
#      of how user code enters kernel mode. 
#    - Official Intel site: 
#        https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
#      (see Vol. 2 for the instruction set reference).
#
# 4) **AMD64 Architecture Programmer’s Manual** (if using AMD processors)
#    - Similar coverage of SYSCALL, SYSRET, privilege levels, etc. 
#    - Hosted on AMD’s developer site:
#        https://www.amd.com/en/support/tech-docs/amd64-architecture-programmers-manual
#
# 5) **Linux Kernel Source & Documentation**
#    - The kernel code shows exactly how each syscall number is mapped and implemented. 
#    - For instance, look under:
#        arch/x86/entry/syscalls/syscall_64.tbl (to see syscall numbers)
#        Documentation/userspace-api/syscall-user-dispatch.rst (for some details on syscalls)
#    - Available at https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 
#
# These sources confirm why syscalls are not just normal function calls (due to ring transitions),
# how %rax holds the syscall number, how arguments go into %rdi, %rsi, etc., and how the CPU 
# switches from ring 3 to ring 0 using SYSCALL/SYSRET rather than CALL/RET.
#
# --------------------------------------------------------------------------------
# (7) Where can I find a list of all syscalls and official references?
#
#   - On Linux, you can check:
#       • /usr/include/asm/unistd_64.h
#       • /usr/include/asm-generic/unistd.h
#       • arch/x86/entry/syscalls/syscall_64.tbl (in the Linux source)
#       • "man 2 syscalls" or "man 2 syscall"
#     These show all the valid syscalls and their numbers (read, write, open, close, etc.).
#   - For the x86-64 ABI details:
#       • "System V Application Binary Interface: AMD64 Architecture Processor Supplement"
#       • Intel manuals if you want to see how the hardware implements "syscall" and rings.
#
# --------------------------------------------------------------------------------
# (8) Is this code OS- and architecture-specific?
#
#   - Yes. 
#     * OS-specific * because the syscall numbers (like 60 for exit) are Linux-specific.
#       On macOS, FreeBSD, or Windows, you would have different numbers or even different ways
#       to invoke the kernel. 
#     * Architecture-specific * because the "syscall" instruction is part of x86-64 architecture,
#       and the register usage (like "put the syscall number in %rax") is part of Linux's
#       x86-64 convention. On ARM or RISC-V, the details are different.
#
# Conclusion:
# - This snippet is the minimal Linux x86-64 way to say, "Kernel, please exit my program with code 0."
# - We use '60' because Linux says so for sys_exit. 
# - We use '%rax' because the ABI demands it.
# - We do 'xorq %rdi, %rdi' because the exit code must be in %rdi, and we want 0.
# - "syscall" is how we jump from ring 3 (user mode) to ring 0 (kernel mode) to actually run exit code.
#############################################################################################################

        .section .text
        .globl _start

_start:
        movq $60, %rax        # (1) sys_exit's number in Linux x86-64 is 60
        xorq %rdi, %rdi       # (2) set exit code to 0 (1st arg in %rdi)
        syscall               # (3) transition to kernel -> sys_exit(0)

# <--- New line here to avoid assembler warning.
