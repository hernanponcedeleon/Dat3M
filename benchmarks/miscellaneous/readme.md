# Miscellaneous test source files
Source files for the precompiled unit test resources located in `dartagnan/src/test/resources/miscellaneous`.
The resources are generated with `clang -S -emit-llvm`.

## Special compiler options
- `ilp32-long-in-struct.c`: `-m32`
- `ilp32-ubsan-struct.c`: `-m32 -fsanitize=signed-integer-overflow`
