# Dat3M: Memory Model Aware Verification

<p align="center"> 
<img src="ui/src/main/resources/dat3m.png">
</p>

This tool suite is currently composed of two tools

* **Dartagnan:** a tool to check state reachability under weak memory models, and
* **Porthos:** a tool to check state inclusion under weak memory models.

Requirements
======
* [Maven](https://maven.apache.org/) (if you want to build the tools. If not see the [release](https://github.com/hernanponcedeleon/Dat3M/releases) section)
* [SMACK 2.5.0](https://github.com/smackers/smack) (only to verify C programs)

Installation
======
Download the z3 dependency
```
mvn install:install-file -Dfile=lib/z3-4.8.6.jar -DgroupId=com.microsoft -DartifactId="z3" -Dversion=4.8.6 -Dpackaging=jar
```
Set Dat3M's home, the path and shared libraries variables (replace the latter by DYLD_LIBRARY_PATH in **MacOS**)
```
export DAT3M_HOME=<Dat3M's root>
export PATH=$DAT3M_HOME/:$PATH
export LD_LIBRARY_PATH=$DAT3M_HOME/lib/:$LD_LIBRARY_PATH
```

To build the tools run
```
mvn clean install -DskipTests
```

Unit Tests
======
We provide a set of unit tests that can be run by
```
mvn test
```
**Note:** there are almost 40K tests, running them can take several hs.

Usage
======
Dat3M comes with a user interface (UI) where it is easy to select the tool to use (Dartagnan or Porthos), import, export and modify both the program and the memory model and select the options for the verification engine (see below).
You can start the UI by running
```
java -jar ui/target/ui-2.0.7-jar-with-dependencies.jar
```
<p align="center"> 
<img src="ui/src/main/resources/ui.jpg">
</p>

Dartagnan supports programs written in the `.litmus` or `.bpl` (Boogie) formats. For Porthos, programs shall be written in the `.pts` format which is explained [here](porthos/pts.md).

If SMACK was correctly installed, C programs can be converted to Boogie using the following command:
```
smack -t -bpl <new Boogie file> <C file> [--integer-encoding bit-vector] --no-memory-splitting --clang-options="-DCUSTOM_VERIFIER_ASSERT -I\$DAT3M_HOME/include/"
```

You can also run Dartagnan and Porthos from the console.

For checking reachability (Dartagnan):
```
java -jar dartagnan/target/dartagnan-2.0.7-jar-with-dependencies.jar -cat <CAT file> [-t <target>] -i <program file> [options]
```
For checking state inclusion (Porthos):
```
java -jar porthos/target/porthos-2.0.7-jar-with-dependencies.jar -s <source> -scat <CAT file> -t <target> -tcat <CAT file> -i <program file> [options]
```
The `-cat`,`-scat`,`-tcat` options specify the paths to the CAT files.

For programs written in the `.bpl` (if the original c program uses the `std::atomic` library) or `.pts` format, `\<source>` and `\<target>` specify the architectures to which the program will be compiled. They must be one of the following: 
- none
- tso
- power
- arm
- arm8

Program written in `.litmus` format do not require such options.

Other optional arguments include:
- `-m, --mode {knastertarski, idl, kleene}`: specifies the encoding for fixed points. Knaster-tarski (default mode) uses the encoding introduced in [2]. Mode idl uses the Integer Difference Logic iteration encoding introduced in [1]. Kleene mode uses the Kleene iteration encoding using one Boolean variable for each iteration step.
- `-a, --alias {none, andersen, cfs}`: specifies the alias-analysis used. Option andersen (the default one) uses a control-flow-insensitive method. Option cfs uses a control-flow-sensitive method. Option none performs no alias analysis.
- `-unroll`: unrolling bound for the BMC.

Dartagnan supports input non-determinism, assumptions and assertions using the [SVCOMP](https://sv-comp.sosy-lab.org/2020/index.php) commands `__VERIFIER_nondet_X`, `__VERIFIER_assume` and `__VERIFIER_assert`.

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
[1] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: **Portability Analysis for Weak Memory Models. PORTHOS: One Tool for all Models**. SAS 2017.

[2] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: **BMC with Memory Models as Modules**. FMCAD 2018.

[3] Natalia Gavrilenko, Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: **BMC for Weak Memory Models: Relation Analysis for Compact SMT Encodings**. CAV 2019.

[4] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: **Dartagnan: Bounded Model Checking for Weak Memory Models (Competition Contribution)**. TACAS 2020.

[5] Hernán Ponce de León, Thomas Haas, Roland Meyer: **Dartagnan: Leveraging Compiler Optimizations and the Price of Precision (Competition Contribution)**. TACAS 2021.
