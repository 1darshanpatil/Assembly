[x8664@darwinbox chapter2]$ as exit.s  -o exit.o
[x8664@darwinbox chapter2]$ ld exit.o -o exit
[x8664@darwinbox chapter2]$ lkfd
bash: lkfd: command not found
[x8664@darwinbox chapter2]$ echo $?
127
[x8664@darwinbox chapter2]$ ./exit 
[x8664@darwinbox chapter2]$ echo $?
0
[x8664@darwinbox chapter2]$ 


