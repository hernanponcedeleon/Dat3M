# Dat3M: Memory Model Aware Verification

This tool suite is currently composed of two tools.

* **DARTAGNAN:** a tool to check state reachability under weak memory models.

<p align="center"> 
<img src="https://github.com/hernanponcedeleon/Dat3M/blob/master/dartagnan/extras/dartagnan_small.jpg">
</p>

* **PORTHOS:** a tool to check state inclusion under weak memory models.

<p align="center"> 
<img src="https://github.com/hernanponcedeleon/Dat3M/blob/master/dartagnan/extras/porthos_small.jpg">
</p>

Requeriments
======
[Maven](https://maven.apache.org/) - Dependency Management

If you have a recent Debian or Ubuntu distribution, then install the package maven with 
```
apt-get install maven
```

Installation
======
To build the tools, from the Dat3m/ directory run
```
mvn install:install-file -Dfile=lib/z3-4.3.2.jar -DgroupId=com.microsoft -DartifactId="z3" -Dversion=4.3.2 -Dpackaging=jar
mvn clean package -DskipTests
```

Unit Tests
======
We provide a set of unit tests that can be run by
```
mvn test
```

Usage
======
For checking reachability:
```
java -jar dartagnan/target/dartagnan-2.0-jar-with-dependencies.jar -cat <CAT file> -i <program file> [-t <target>] [options]
```
For checking state inclusion:
```
java -jar porthos/target/porthos-2.0-jar-with-dependencies.jar -s <source> -scat <CAT file> -t <target> -tcat <CAT file> -i <program file> [options]
```
Dartagnan supports programs written in the .litmus or .pts formats (see below). For Porthos, programs shall be written in the .pts format since they need to be compiled to two different architectures.

The -cat,-scat,-tcat options specify the paths to the CAT files.

For programs written in the .pts format, \<source> and \<target> specify the architectures to which the program will be compiled. 
They must be one of the following: 
- none
- tso
- power
- arm
- arm8

Option target is mandatory in dartagnan when using the.pts format.

Other optional arguments include:
- -m, --mode {relaxed, idl, kleene}: specifies the encodnig for fixed points. Relaxed (the default mode) uses the Knaster-Tarski encoding introduced in []. Kleene mode uses the Kleene iteration encoding using one Boolean variable for each iteration step. Idl mode uses the Kleene iteration encoding introduced in []. 
- -a, --alias {none, cfi, cfs}: specifies the alias-analysis used. cfi (the default parameter) uses a control-flow-insensitive method. cfs uses a control-flow-sensitive method and none performs no alias analysis.
- -unroll: unrollifng bound for the BMC.

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

Author and Contact
======
Dat3M is developed and maintained by [Hernán Ponce de León](mailto:ponce@fortiss.org), [Florian Furbach](mailto:f.furbach@tu-braunschweig.de) and [Natalia Gavrilenko](mailto:natalia.gavrilenko@aalto.fi). Please feel free to contact us in case of questions or to send feedback.
