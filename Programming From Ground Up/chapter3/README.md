# Maximum

```bash
as maximum.asm -o maximum.o
ld maximum.o -o maximum
```

The maximum number is stored in `%ebx`, and the program exits with `SYS.exit(MAX_Num)`.
To check the result, use `echo $?` to display the exit status.

The C implementation can also be found, where, similar to the assembly version, goto is used instead of for or while loops.

