#PURPOSE:  Simple program that exits and returns a status code back to the Linux kernel
#          status code back to the Linux kernel


#INPUT:    none
#

#OUTPUT:   returns a status code. This can be viewed by typing `echo $?` after the execution of the program.
#          I would recommend that you execute some failed code before exit.s; As very often `echo $?` returns `0` 
#          because of our previous executions.

#VARIABLES:
#         %eax holds the system call number
#         %ebx holds the return status

.section .data
.section .text
.globl _start
_start:
movl $1, %eax  # This is the linux kernel command
               # number (system call) for exiting
               # a program.


movl $0, %ebx # This is the status number we will
              # return to the operating system.
              # Change this around and it will will
              # return different things to
              # echo $?

int $0x80    # this wakes up the kernel to run
             # the exit command
