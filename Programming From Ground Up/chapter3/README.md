# Maximum
![Screenshot From 2024-12-20 15-33-01](https://github.com/user-attachments/assets/f7173666-1330-4efe-ba98-888c2e4fded1)

```bash
as maximum.asm -o maximum.o
ld maximum.o -o maximum
```

The maximum number is stored in `%ebx`, and the program exits with `SYS.exit(MAX_Num)`.
To check the result, use `echo $?` to display the exit status.

The C implementation can also be found, where, similar to the assembly version, goto is used instead of for or while loops.

