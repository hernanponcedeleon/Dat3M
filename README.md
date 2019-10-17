# Dat3M: Memory Model Aware Verification

<p align="center"> 
<img src="ui/src/main/resources/dat3m.png">
</p>

This tool suite is currently composed of two tools.

* **DARTAGNAN:** a tool to check state reachability under weak memory models.
* **PORTHOS:** a tool to check state inclusion under weak memory models.

Requirements
======
[Maven](https://maven.apache.org/) - Dependency Management

If you have a recent Debian or Ubuntu distribution, then install the package maven with 
```
apt-get install maven
```

Installation
======
To build the tools, from the Dat3M/ directory run
* **Linux:**
```
make
```
* **MacOS:**
```
mvn install:install-file -Dfile=lib/z3-4.3.2.jar -DgroupId=com.microsoft -DartifactId="z3" -Dversion=4.3.2 -Dpackaging=jar
mvn clean install -DskipTests
export DYLD_LIBRARY_PATH=./lib/
```

Unit Tests
======
We provide a set of unit tests that can be run by
```
mvn test
```

Binaries
======
The precompiled jars can be found in the "[release](https://github.com/hernanponcedeleon/Dat3M/releases)" section.

Usage
======
* **Linux:** You can start the tool by double-clicking the <img src="ui/src/main/resources/dat3m.png" width="30" height="30"> launcher
* **MacOS:** To run the tool, from the Dat3M/ directory run
```
java -jar ui/target/ui-2.0.5-jar-with-dependencies.jar
```
Additionally, you can run DARTAGNAN and PORTHOS from the console.

For checking reachability:
```
java -jar dartagnan/target/dartagnan-2.0.5-jar-with-dependencies.jar -cat <CAT file> -i <program file> [-t <target>] [options]
```
For checking state inclusion:
```
java -jar porthos/target/porthos-2.0.5-jar-with-dependencies.jar -s <source> -scat <CAT file> -t <target> -tcat <CAT file> -i <program file> [options]
```
DARTAGNAN supports programs written in the .litmus or .pts formats (see below). For PORTHOS, programs shall be written in the .pts format since they need to be compiled to two different architectures.

The -cat,-scat,-tcat options specify the paths to the CAT files.

For programs written in the .pts format, \<source> and \<target> specify the architectures to which the program will be compiled. 
They must be one of the following: 
- none
- tso
- power
- arm
- arm8

**Note:** Option target is mandatory in DARTAGNAN when using the .pts format.

Other optional arguments include:
- -m, --mode {knastertarski, idl, kleene}: specifies the encoding for fixed points. Knaster-tarski (default mode) uses the encoding introduced in [2]. Mode idl uses the Integer Difference Logic iteration encoding introduced in [3]. Kleene mode uses the Kleene iteration encoding using one Boolean variable for each iteration step.
- -a, --alias {none, andersen, cfs}: specifies the alias-analysis used. Option andersen (the default one) uses a control-flow-insensitive method. Option cfs uses a control-flow-sensitive method. Option none performs no alias analysis.
- -unroll: unrolling bound for the BMC.

The .pts format
======

Examples are provided in the **benchmarks/** folder.
```
  program ::= {⟨loc⟩*} ⟨thrd⟩*

  ⟨thrd⟩ ::= thread String {⟨inst⟩}

  ⟨inst⟩ ::= ⟨com⟩ | ⟨inst⟩; ⟨inst⟩ | while ⟨pred⟩ {⟨inst⟩} | if ⟨pred⟩ {⟨inst⟩} else {⟨inst⟩}

  ⟨com⟩ ::= ⟨reg⟩ <- ⟨expr⟩ | ⟨reg⟩ = ⟨loc⟩.load(⟨atomic⟩) | ⟨loc⟩.store(⟨atomic⟩,⟨reg⟩)
  
  ⟨atomic⟩ ::= "_sc" | "_rx" | "_acq" | "_rel" | "_con"
  
  ⟨pred⟩ ::= Bool | ⟨pred⟩ and ⟨pred⟩ | ⟨pred⟩ or ⟨pred⟩ | not ⟨pred⟩ 
  
          | ⟨expr⟩ == ⟨expr⟩ | ⟨expr⟩ != ⟨expr⟩
          
          | ⟨expr⟩ < ⟨expr⟩ | ⟨expr⟩ <= ⟨expr⟩
          
          | ⟨expr⟩ > ⟨expr⟩ | ⟨expr⟩ >= ⟨expr⟩
  
  ⟨expr⟩ ::= Int | ⟨reg⟩
  
          | ⟨expr⟩ + ⟨expr⟩ | ⟨expr⟩ - ⟨expr⟩
  
          | ⟨expr⟩ * ⟨expr⟩ | ⟨expr⟩ / ⟨expr⟩
          
          | ⟨expr⟩ % ⟨expr⟩ 
  ```

Authors and Contact
======
Dat3M is developed and maintained by [Hernán Ponce de León](mailto:ponce@fortiss.org), [Florian Furbach](mailto:f.furbach@tu-braunschweig.de) and [Natalia Gavrilenko](mailto:natalia.gavrilenko@aalto.fi). Please feel free to contact us in case of questions or to send feedback.

References
======
[1] Natalia Gavrilenko, Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: **BMC for Weak Memory Models: Relation Analysis for Compact SMT Encodings**. CAV 2019.

[2] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: **BMC with Memory Models as Modules**. FMCAD 2018.

[3] Hernán Ponce de León, Florian Furbach, Keijo Heljanko, Roland Meyer: **Portability Analysis for Weak Memory Models. PORTHOS: One Tool for all Models**. SAS 2017.

