# AtomicReplacePass

LLVM pass to replace all occurrences of atomic loads, stores, CAS instructions, RMW instructions,
and fences with calls to functions.

Here is the list of replacement functions:

| Instruction    | Replacement function |
| -------------- | -------------------- |
| `load atomic`  | `i32 @__llvm_atomic32_load(i32* x, i32 mode);`<br>`i64 @__llvm_atomic64_load(i64* x, i32 mode);` |
| `store atomic` | `void @__llvm_atomic32_store(i32* x, i32 y, i32 mode);`<br>`void @__llvm_atomic64_store(i64* x, i64 y, i32 mode);` |
| `cmpxchg`      | `{ i32, i1 } @__llvm_atomic32_cmpxchg(i32* x, i32 expected, i32 desired, i32 mode_succ, i32 mode_fail);`<br>`{ i64, i1 } @__llvm_atomic64_cmpxchg(i64* x, i64 expected, i64 desired, i32 mode_succ, i32 mode_fail);` |
| `atomicrmw op` | `i32 @__llvm_atomic32_rmw(i32* x, i32 y, i32 mode, i32 op);`<br>`i64 @__llvm_atomic64_rmw(i64* x, i64 y, i32 mode, i32 op);` |
| `fence`        | `void @__llvm_atomic_fence(i32 mode);` |

In the table `mode`, `mode_succ` and `mode_fail` denote ordering semantics,
and `op` denotes type of an RMW instruction (`xchg`, `add`, `sub`, `and`, `or`, `xor`).

For `cmpxchg` instruction only `strong` is supported.

Additional arguments (like `volatile`, `align` or `syncscope`) are ignored.


## Building

The LLVM pass is in the form of a shared library `libatomic-replace.so` that can be
dynamically loaded by the LLVM `opt` tool.

We support LLVM and Clang versions from 10 through 15.

We use CMake scripts for building the library and tests, but since the library source
consists of two files only, it should be fairly easy to compile them manually as well.

The following list of commands builds code in `build` subdirectory (resulting in library
`build/libatomic-replace.so`) and tests the library.
Finally, it installs the library (in a default path for libraries)
together with `atomic-replace` wrapper script (in a default path for binaries).

```bash
mkdir build; cd build
cmake ..
make
make test
[sudo] make install
```


## Usage

To run the pass on a program in LLVM IR from `input.ll` file, and obtain
transformed program in `output.ll` run following command:

```bash
atomic-replace input.ll output.ll
```

You can use `${ATOMIC_REPLACE_OPTS}` environment variable to specify additional passes that should
be run after replacing the atomics.
Behind the scenes, the command dynamically loads the library using the LLVM `opt` tool:

```bash
opt -load=libatomic-replace.so -atomic-replace ${ATOMIC_REPLACE_OPTS} input.ll -S -o output.ll
```

Since the library uses the legacy pass manager of LLVM, the additional
`-enable-new-pm=0` option is added, if your LLVM version is greater or equal to 13.
