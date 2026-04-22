# How to generate LLVM files with Inline Asm with Ck

You need to clone [concurrencykit/ck](https://github.com/concurrencykit/ck).

**DO NOT** install it via the `./configure` script, as we want to generate inline asm independently from the underlying machine.

In this case you have to generate the clients to leverage the API on your own.

Then, follow this pattern :
```
clang <Includes> <custom flags> <architecture> -S -emit-llvm <file_path.c>
```
The `<Includes>` should contain:
1. path to ck/include

The Custom flags should be set up accordingly to your client

For the architecture these are the options : 
1. `__aarch__` to generate ARMV8.
2. `__arm__ ` &&  `__ARM_ARCH_7__` to generate ARMV7.
3. `__ppc64__` to generate Power PC 64 bit.
4. `__riscv` && `__riscv_xlen=64` to generate RISCV 64 bit. 

A valid example would therefore be, from this directory.
Given that `CK` contains the path to a local copy of `ck`'s repository.
```
clang -I "$CK"/include -I "$DAT3M_HOME"/include -target arm64-pc-linux-gnu -D__aarch__ -S -emit-llvm caslock.c
```