# How to generate LLVM files with Inline Asm with Progress64

You need to clone [ARM-software/progress64](https://github.com/ARM-software/progress64).

In this case you have to generate the clients to leverage the API on your own.

Then, follow this pattern :
```
clang <Includes> <custom flags> -S -emit-llvm <file_path.c>
```
The Includes should contain :
1. path to progress64/include
2. path to progress64/src

The Custom flags should be set up accordingly to your client. In some cases, if you do not get inline asm, try to add :
1. ```-U__ARM_FEATURE_ATOMICS``` to force the compiler to avoid including the builtins

A valid example would therefore be, from root of progress64 :
```
clang -I <path_to_progress64>/include -I <path_to_progress64>/src -S -emit-llvm benchmarks/progress64/rwlock.c
```