There is a difference between 32-bit and 64-bit in terms of how sys_exit is handled in the code, not in the code itself but in how the sys_exit system call is invoked:

```bash
[Ilya@m87 Desktop]$ cat /usr/include/asm/unistd_32.h  | grep "exit"
#define __NR_exit 1
#define __NR_exit_group 252
[Ilya@m87 Desktop]$ cat /usr/include/asm/unistd_64.h  | grep "exit"
#define __NR_exit 60
#define __NR_exit_group 231
[Ilya@m87 Desktop]$ 
```

Here, for `32-bit` architecture, we need to set `%eax = 1`, whereas for `64-bit` architecture, we use `%rax = 60`.
