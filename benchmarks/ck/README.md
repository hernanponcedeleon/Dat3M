# How to generate LLVM files with Inline Asm with Ck

You need to clone [concurrencykit/ck](https://github.com/concurrencykit/ck).

DO NOT Install it via the ./configure script, as we want to generate inline asm independently from the underlying machine.

In this case you have to generate the clients to leverage the API on your own.

Then, follow this pattern :
```
clang <Includes> <custom flags> <architecture> -S -emit-llvm <file_path.c>
```
The Include should contain :
1. path to ck/include

The Custom flags should be set up accordingly to your client

For the architecture these are the options : 
1. ```__aarch__``` to generate ARMV8.
2. ```__arm__ ``` &&  ```__ARM_ARCH_7__``` to generate ARMV7.
3. ```__ppc64__``` to generate Power PC 64 bit.
4. ```__riscv``` && ```__riscv_xlen=64`` to generate RISCV 64 bit. 

A valid example would therefore be, from ck's root.
```
clang -I <path_to_ck>/include -I DAT3M_HOME/include -D__arm__ -D__ARM_ARCH_7__ -S -emit-llvm caslock.c
```