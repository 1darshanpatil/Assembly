/* ##########################################################################################################
 * PURPOSE: The C implementation of exit.s                                                                  
 * INPUT: None                                                                                              
 * OUTPUT: Returns a status code. This can be viewed by typing `echo $?` after the execution of the program.
 *                                                                                                          
 * AUTHOR: Darshan P.                                                                                       
 * EMAIL: drshnp@outlook.com                                                                                
 * ##########################################################################################################
*/

#include <unistd.h> // Provides syscall constants
#include <sys/syscall.h> // For SYS_exit

int main() {
    int status = 0;

    // Perform a direct system call to exit the program with the specified status.
    syscall(SYS_exit, status);

    /*
     * The return statement below is technically part of the main function
     * and would typically indicate the exit status of the program.
     * However, it will never be executed because the syscall above
     * terminates the program immediately by invoking the kernel's exit mechanism.
     * 
     * In short, any code written after the syscall(SYS_exit, ...) is unreachable
     * and will have no effect on the program's behavior
     */
    return 1; 
    // This line is unreachable, but it is included to demonstrate
    // that even if you specify a return value here, it won't take effect.
}

