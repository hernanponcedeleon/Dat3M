![build](https://github.com/hernanponcedeleon/Dat3M/actions/workflows/maven.yml/badge.svg?branch=development)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Coverage](../badges/coverage.svg)
![Branches](../badges/branches.svg)

# Dat3M: Memory Model Aware Verification

**Dartagnan** is a tool to check state reachability under weak memory models.

Requirements
======
* [Maven](https://maven.apache.org/) (if you want to build the tools. If not see the [release](https://github.com/hernanponcedeleon/Dat3M/releases) section)
* [Java 8](https://openjdk.java.net/projects/jdk/16/) or above (if you want to compile from source)
* [Smack 2.5.0](https://github.com/smackers/smack) or above (only to verify C programs)
* [Clang](https://clang.llvm.org) the concrete version depends on your `smack` version

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
docker run -w /home/Dat3M -v /sys/fs/cgroup:/sys/fs/cgroup:rw -it dartagnan /bin/bash
```

**From Sources**

Set Dat3M's home and add it to the path
```
export DAT3M_HOME=<Dat3M's root>
export PATH=$DAT3M_HOME/:$PATH
```

If you are verifying C code, be sure both `clang` and `smack` are in your `PATH`.

To build the tool run
```
mvn clean install -DskipTests
```

**Unit Tests**

We provide a set of unit tests that can be run by
```
mvn test
```
**Note:** there are almost 40K tests, running them can take several hs.

Usage
======
Dartagnan comes with a user interface (not available from the docker container) where it is easy to import, export and modify both the program and the memory model and select the options for the verification engine (see below).
You can start the user interface by running
```
java -jar ui/target/ui-3.0.0.jar
```
<p align="center"> 
<img src="ui/src/main/resources/ui.jpg">
</p>

Dartagnan supports programs written in the `.c`, `.litmus` or `.bpl` (Boogie code generated by smack) formats.

There are three possible results for the verification:
- `FAIL`: one assertion was violated.
- `PASS`: loops have been fully unrolled and all assertions are satisfied.
- `UNKNOWN`: no assertion violation was found, but loops have not been fully unrolled (you need to increase the unrolling bound).

You can also run Dartagnan from the console:

```
java -jar dartagnan/target/dartagnan-3.0.0.jar <CAT file> <program file>
```

Options take the form `--key=value` and are listed here.
- `program.processing.compilationTarget` is required for programs written in `.c` and `.bpl`. It specifies the architectures to which the program will be compiled. It must be one of `none`, `tso`, `power`, `arm` or `arm8`. Program written in `.litmus` format do not require such option.
- `program.analysis.alias`: specifies the alias-analysis used. Option `andersen` (the default one) uses a control-flow-insensitive method. Option `cfs` uses a control-flow-sensitive method. Option `none` performs no alias analysis.
- `program.processing.loopUnroll`: unrolling bound for the BMC (default is 1).
- `solver`: specifies which SMT solver to use as a backend. Since we use [JavaSMT](https://github.com/sosy-lab/java-smt), several SMT solvers are supported depending on the OS and the used SMT logic (default is Z3).
- `method`: specifies which solving method to use. Options `incremental` (the default one) and `assume` solve a monolithic formula using incremental/assume-based SMT solving. Option `refinement` uses a customized solver for memory consistency.
- `timeout` accepts the number of seconds for the solving process.

Dartagnan supports input non-determinism, assumptions and assertions using the [SVCOMP](https://sv-comp.sosy-lab.org/2020/index.php) commands `__VERIFIER_nondet_X`, `__VERIFIER_assume` and `__VERIFIER_assert`.

**SV-COMP Experiments**

The docker container includes the [benchexec](https://github.com/sosy-lab/benchexec) framework to run all [SV-COMP](https://sv-comp.sosy-lab.org/) experiments, just run (this can take a couple of hs)
```
benchexec dartagnan.xml --no-container
```
The `dartagnan.xml` file instructs benchexec to use 4 CPUs, so either be sure your docker configuration has access to 4 CPUs or change the entry `cpuCores="4"` to match you CPUs limit.

Authors and Contact
======
**Maintainer:**

* [Hernán Ponce de León](mailto:hernan.ponce@unibw.de)

**Developers:**

* [Thomas Haas](mailto:t.haas@tu-braunschweig.de)

**Former Developers:**

* Florian Furbach
* Natalia Gavrilenko

Please feel free to contact us in case of questions or to send feedback.

References
======
[1] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: [**Portability Analysis for Weak Memory Models. PORTHOS: One Tool for all Models**](https://hernanponcedeleon.github.io/pdfs/sas2017.pdf). SAS 2017.

[2] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: [**BMC with Memory Models as Modules**](https://hernanponcedeleon.github.io/pdfs/fmcad2018.pdf). FMCAD 2018.

[3] Natalia Gavrilenko, Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: [**BMC for Weak Memory Models: Relation Analysis for Compact SMT Encodings**](https://hernanponcedeleon.github.io/pdfs/cav2019.pdf). CAV 2019.

[4] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: [**Dartagnan: Bounded Model Checking for Weak Memory Models (Competition Contribution)**](https://hernanponcedeleon.github.io/pdfs/svcomp20.pdf). TACAS 2020.

[5] Hernán Ponce de León, Thomas Haas, Roland Meyer: [**Dartagnan: Leveraging Compiler Optimizations and the Price of Precision (Competition Contribution)**](https://hernanponcedeleon.github.io/pdfs/svcomp2021.pdf). TACAS 2021.
