# How to generate LLVM files with Inline Asm with Libvsync
This readme explains how to generate llvm benchmarks with inline asm. We explain how to do this on arm (v7 and v8), but doing it on other devices is similar.

*Note* : to generate those files you are going to need **Clang** which runs on an arm device.

## Libvsync
You need to clone [libvsync](https://github.com/open-s4c/libvsync).

Then, from libvsync's root follow this pattern :
```
clang <Includes> <Libvsync flags> <architecture> -S -emit-llvm <file_path.c>
```
The Includes should contain : 
1. path to libvsync/include
2. path to dat3m/include 

*Note* you might have to comment out **await_while()** declaration from **dat3m/include/dat3m.h**

The useful libvsync flags are :
1. VATOMIC_DISABLE_ARM64_LSE -- to let libvsync pick up *arm64_llsc.h*
3. VSYNC_DISABLE_POLITE_AWAIT 
2. VSYNC_VERIFICATION -- we are in verification mode
4. VSYNC_VERIFICATION_DAT3M -- to tell it that we are using Dat3M to verify
5. TWA_A=128 -- in case we are generating a ll file for twalock.c
6. VSYNC_VERIFICATION_QUICK -- reducing NTHREADS or READERS/WRITERS to speedup analysis

For the architecture these are the options : 
1. ```__aarch__``` to generate ARMV8
2. ```__arm__ ``` to generate ARMV7

A valid example would therefore be, from libvsync's root,
```
clang -I ./include -I Dat3M_HOME/include -DVATOMIC_DISABLE_ARM64_LSE -DVSYNC_DISABLE_POLITE_AWAIT -DVSYNC_VERIFICATION -DVSYNC_VERIFICATION_DAT3M -DVSYNCER_CHECK=on -DVSYNC_VERIFICATION_QUICK -D__aarch__ -S -emit-llvm test/spinlock/ttaslock.c
```
## Ck 
You need to clone [concurrencykit/ck](https://github.com/concurrencykit/ck).

DO NOT Install it via the ./configure script, as we want to generate inline asm independently from the underlying machine.

In this case you have to generate the clients to leverage the API on your own.

Then, follow this pattern :
```
clang <Includes> <custom flags> <architecture> -S -emit-llvm <file_path.c>
```
The Include should contain :
1. path to ck/include
2. path to ck/src folder in case you are using some of those implementation

The Custom flags should be set up accordingly to your client

For the architecture these are the options : 
1. ```__aarch__``` to generate ARMV8
2. ```__arm__ ``` &&  ```__ARM_ARCH_7__``` to generate ARMV7.
3. ```__riscv``` && ```__riscv_xlen=64``` to generate RISCV (they support 64 bit version only).

Please note that in case you want to generate ***riscv*** inline assembly, to avoid letting ```include/ck_pr.h``` include your architecture variant, you might want to state ```-U<architecture>``` to undefine your architecture variable depending on where it is located in the aformentioned file.

A valid example would therefore be, from ck's root, assuming you have your clients under ```test``` folder : 
```
clang -I ./include -I DAT3M_HOME/include -D__arm__ -D__ARM_ARCH_7__ -S -emit-llvm tests/caslock.c
```
