############################################################################################################
# PURPOSE: This program finds the maximum number from a set of data items.                                 #
#                                                                                                          #
# VARIABLES: The registers have the following purposes:                                                    #
#                                                                                                          #
#    %edi - Holds the index of the data item being examined.                                               #
#    %ebx - Stores the largest data item found.                                                            #
#    %eax - Holds the current data item.                                                                   #
#                                                                                                          #
# The following memory location is used:                                                                   #
#                                                                                                          #
#    data_items - Contains the list of data items. A 0 is used to terminate the list.                      #
#                                                                                                          #
# AUTHOR: Darshan P.                                                                                       #
# EMAIL: drshnp@outlook.com                                                                                #
#                                                                                                          #
# CREDITS: This program is based on examples and teachings from the book:                                  #
#          "Programming from Ground Up" by Jonathan Bartlett.                                              #
#                                                                                                          #
############################################################################################################


.section .data
data_items:                               # Array of data items
  .long 3, 67, 34, 22, 45, 42, 75, 31, 75, 2, 35, 63, 64, 214, 0  # 0 indicates the end of the list

.section .text

.globl _start

_start:
  # Initialize the index register (EDI) to start iterating through the array
  movl $0, %edi                           # %edi acts as a counter (index into the array)
  
  # Load the first data item into %eax and initialize %ebx as the maximum holder
  movl data_items(, %edi, 4), %eax        # Access the first item (data_items[0]) and load it into %eax
  movl %eax, %ebx                         # Initialize %ebx with the first data item (initial largest value)

# Start loop to compare items:
start_loop:
  # Check if the current item is 0, which marks the end of the array
  cmpl $0, %eax                           # Compare the current value in %eax with 0
  je loop_exit                            # If %eax is 0, jump to the exit label

  # Increment the index to move to the next item in the array
  incl %edi                               # Increment the index register (%edi)
  movl data_items(, %edi, 4), %eax        # Load the next data item into %eax

  # Compare the current data item with the largest value found so far
  cmpl %ebx, %eax                         # Compare %eax (current item) with %ebx (largest value)
  jle start_loop                          # If %eax is less than or equal to %ebx, continue the loop
  
  # If the current data item is greater, update %ebx to hold the new largest value
  movl %eax, %ebx                         # Update %ebx with the current larger value
  jmp start_loop                          # Jump back to the start of the loop to continue comparison

loop_exit:
  # The largest value found is now stored in %ebx
  # Perform a system call to exit the program
  movl $1, %eax                           # Prepare for the exit system call (sys_exit) by setting %eax to 1
  int $0x80                               # Make the system call to exit

############################################################################################################
# Learn More About These Instructions:                                                                     #
# - movl - https://www.felixcloutier.com/x86/mov                                                           #
# - cmpl - https://www.felixcloutier.com/x86/cmp                                                           #
# - incl - https://www.felixcloutier.com/x86/inc                                                           #
# - je - https://www.felixcloutier.com/x86/jcc                                                             #
# - jle - https://www.felixcloutier.com/x86/jcc                                                            #
# - jmp - https://www.felixcloutier.com/x86/jmp                                                            #
############################################################################################################
