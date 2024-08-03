![build](https://github.com/hernanponcedeleon/Dat3M/actions/workflows/maven.yml/badge.svg?branch=development)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Coverage](../badges/coverage.svg)
![Branches](../badges/branches.svg)

# Dat3M: Memory Model Aware Verification

**Dartagnan** is a tool to check state reachability under weak memory models.

Requirements
======
* [Maven](https://maven.apache.org/) 3.8 or above
* [Java](https://openjdk.java.net/projects/jdk/17/) 17 or above
* [Clang](https://clang.llvm.org) (only to verify C programs)
* [Graphviz](https://graphviz.org) (only if option `--witness=png` is used)

Installation
======

**Docker**

The docker contains everything pre-installed to run the tool.

1. Build the container:
```
docker build . -t dartagnan
```

2. Run the container:
```
docker run -w /home/Dat3M -it dartagnan /bin/bash
```

**From Sources**

Set Dat3M's home and the folder to generate output files (the output folder can be something different)
```
export DAT3M_HOME=<Dat3M's root>
export DAT3M_OUTPUT=$DAT3M_HOME/output
```

At least the following compiler flag needs to be set, further can be added (only to verify C programs)
```
export CFLAGS="-I$DAT3M_HOME/include"
```

If you are verifying C code, be sure `clang` is in your `PATH`.

To build the tool run
```
mvn clean install -DskipTests
```

Troubleshooting
======
**MacOS ARM**

Dartagnan automatically loads native binaries for its supported SMT solvers.
However, it always loads the x86 binaries even on MacOS ARM.
This will trigger the following error when using Z3:
```
java.lang.UnsatisfiedLinkError: no libz3 in java.library.path: [/Users/***/Library/Java/Extensions, /Library/Java/Extensions, /Network/Library/Java/Extensions, /System/Library/Java/Extensions, /usr/lib/java, .]
```
A workaround here is to manually download the ARM binaries (https://github.com/Z3Prover/z3/releases/), unpack the .zip, and place the two `.dylib` files (`libz3.dylib` and `libz3java.dylib`) into one of the folders mentioned in the error message (e.g., `Library/Java/Extensions`).

Usage
======
Dartagnan comes with a user interface (not available from the docker container) where it is easy to import, export and modify both the program and the memory model and select the options for the verification engine (see below).
You can start the user interface by running
```
java -jar ui/target/ui.jar
```
<p align="center"> 
<img src="ui/src/main/resources/ui.jpg">
</p>

Dartagnan supports programs written in the `.c`, `.litmus` formats.

There are three possible results for the verification:
- `FAIL`: the property was violated.
- `PASS`: loops have been fully unrolled and the property satisfied.
- `UNKNOWN`: no violation was found, but loops have not been fully unrolled (you need to increase the unrolling bound).

You can also run Dartagnan from the console:

```
java -jar dartagnan/target/dartagnan.jar <CAT file> [--target=<arch>] <program file> [options]
```
For programs written in `.c`, value `<arch>` specifies the programming language or architectures to which the program will be compiled. For programs written in `.litmus` format, if the `--target` option is not given, Dartagnan will automatically extract the `<arch>` from the litmus test header. `<arch>` must be one of the following: 
- c11
- lkmm
- imm
- tso
- power
- arm8
- riscv
- ptx
- vulkan

The target architecture is supposed to match (this is responsibility of the user) the intended weak memory model specified by the CAT file. 

Further options can be specified using `--<option>=<value>`. Common options include:
- `bound`: unrolling bound for the BMC (default is 1).
- `property`: the properties to be checked. Possible values are `program_spec` (e.g, safety properties as program assertions), `liveness` (i.e., all spinloops terminate), `cat_spec` (e.g., [data races as specified in the cat file](https://github.com/hernanponcedeleon/Dat3M/blob/master/cat/rc11.cat#L34-L39)). Default is `program_spec,cat_spec,liveness`.
- `solver`: specifies which SMT solver to use as a backend. Since we use [JavaSMT](https://github.com/sosy-lab/java-smt), several SMT solvers are supported depending on the OS and the used SMT logic (default is Z3).
- `method`: specifies which solving method to use. Option `lazy` (the default one) uses a customized solver for memory consistency. Option `eager` solves a monolithic formula using SMT solving. 

Dartagnan supports input non-determinism using the [SVCOMP](https://sv-comp.sosy-lab.org/2020/index.php) command `__VERIFIER_nondet_X`.

You can set up specific bounds for individual loops in the C code by annotating the loop with `__VERIFIER_loop_bound(...)`. For example,
```
__VERIFIER_loop_bound(2);
while(1) {
    ...
}
```
will unroll this loop twice and use the bound passed to the `--bound` option for all other loops.

Authors and Contact
======
**Maintainer:**

* [Hernán Ponce de León](https://hernanponcedeleon.github.io)

**Developers:**

* [Natalia Gavrilenko](https://www.linkedin.com/in/natalia-g-206ba1203/)
* [Thomas Haas](https://www.tcs.cs.tu-bs.de/group/haas/home.html)
* [René Pascal Maseli](https://www.tcs.cs.tu-bs.de/group/maseli/home.html)
* [Haining Tong](https://researchportal.helsinki.fi/fi/persons/haining-tong)

**Former Developers:**

* Florian Furbach

Please feel free to [contact us](mailto:hernanl.leon@huawei.com) in case of questions or to send feedback.

Awards
======
- Distinguished Paper @ OOPSLA 2022
- Gold Medal @ SVCOMP 2023
- Gold Medal (x2) @ SVCOMP 2024

References
======
[1] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: [**Portability Analysis for Weak Memory Models. PORTHOS: One Tool for all Models**](https://hernanponcedeleon.github.io/pdfs/sas2017.pdf). SAS 2017.

[2] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: [**BMC with Memory Models as Modules**](https://hernanponcedeleon.github.io/pdfs/fmcad2018.pdf). FMCAD 2018.

[3] Natalia Gavrilenko, Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: [**BMC for Weak Memory Models: Relation Analysis for Compact SMT Encodings**](https://hernanponcedeleon.github.io/pdfs/cav2019.pdf). CAV 2019.

[4] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: [**Dartagnan: Bounded Model Checking for Weak Memory Models (Competition Contribution)**](https://hernanponcedeleon.github.io/pdfs/svcomp20.pdf). TACAS 2020.

[5] Hernán Ponce de León, Thomas Haas, Roland Meyer: [**Dartagnan: Leveraging Compiler Optimizations and the Price of Precision (Competition Contribution)**](https://hernanponcedeleon.github.io/pdfs/svcomp2021.pdf). TACAS 2021.

[6] Hernán Ponce de León, Thomas Haas, Roland Meyer: [**Dartagnan: SMT-based Violation Witness Validation (Competition Contribution)**](https://hernanponcedeleon.github.io/pdfs/svcomp2022.pdf). TACAS 2022.

[7] Thomas Haas, Roland Meyer, Hernán Ponce de León: [**CAAT: Consistency as a Theory**](https://hernanponcedeleon.github.io/pdfs/oopsla2022.pdf). OOPSLA 2022.

[8] Thomas Haas, René Maseli, Roland Meyer, Hernán Ponce de León: [**Static Analysis of Memory Models for SMT Encodings**](https://hernanponcedeleon.github.io/pdfs/oopsla2023.pdf). OOPSLA 2023.
