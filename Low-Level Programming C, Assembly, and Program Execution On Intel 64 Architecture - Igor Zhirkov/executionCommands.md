We are using `nasm`, can be installed as `sudo pacman -S nasm`

* **Commands for the execution of the hello.asm**
```bash
nasm -felf64 hello.asm -o hello.o
ld -o hello hello.o 
chmod u+x hello
./hello 
```

* **Output**
```bash
hello, world!
Segmentation fault (core dumped)
```