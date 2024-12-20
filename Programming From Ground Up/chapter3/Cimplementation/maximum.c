/* 
##########################################################################################################
 * PURPOSE: This program finds the largest number from a set of data items using a simple loop and comparison.  
 * INPUT: An array of integers terminated by 0.                                                              
 * OUTPUT: Prints the largest value in the array.                                                            
 *                                                                                                          
 * AUTHOR: Darshan P.                                                                                       
 * EMAIL: drshnp@outlook.com                                                                                
##########################################################################################################
*/

#include <stdio.h>

int main() {
    // Array of data items (0 indicates the end of the list)
    int data_items[] = {3, 67, 34, 22, 45, 75, 2, 35, 63, 214, 0};

    // Initialize variables to simulate registers
    int edi = 0;        // %edi - Acts as the index into the array
    int eax = data_items[edi];  // %eax - Holds the current data item (initially first item)
    int ebx = eax;       // %ebx - Stores the largest data item found (initialize with first item)

start_loop:
    // Check if the current value is 0 (end of the list)
    if (eax == 0)
        goto loop_exit;  // If 0 is encountered, exit the loop

    // If current value (eax) is less than or equal to the largest found (ebx), continue loop
    if (eax <= ebx)
        goto start_loop;  // If eax <= ebx, skip the update of ebx and continue the loop

    // Update the largest value found (ebx) if the current value (eax) is greater
    ebx = eax;

    // Increment the index (edi) and load the next item from the array into eax
    edi++;
    eax = data_items[edi];

    // Continue the loop
    goto start_loop;

loop_exit:
    // Print the largest value found in the array
    printf("The largest value in the array is: %d\n", ebx);
    return 0;  // Exit the program
}
