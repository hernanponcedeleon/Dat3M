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

Installation
======
Run the compiling script
```
./install.sh
```
**Note:** If the java classes or libz3java cannot be found, set the the following variables manually:
```
export CLASSPATH=./import/antlr-4.7-complete.jar:./import/commons-io-2.5.jar:./import/com.microsoft.z3.jar:./import/commons-cli-1.4.jar:./bin/
export LD_LIBRARY_PATH=./import/
```
(use DYLD_LIBRARY_PATH in MacOS)

Usage
======
For checking reachability:
```
java dartagnan/Dartagnan -t <target> -cat <CAT file> -i <input> [options]
```
For checking state inclusion:
```
java porthos/Porthos -s <source> -scat <CAT file> -t <target> -tcat <CAT file> -i <input> [options]
```
Programs shall be written in the .pts format (see below). The path to the .pts file shall be provided in \<input>.

Strings \<source> and \<target> specify the architectures to which the program will be compiled. They must be one of the following: 
- sc
- tso
- pso
- rmo
- alpha
- power
- arm

The optional -cat,-scat,-tcat options specify the paths to the CAT files. When they are not provided, the memory model is extracted from the compilation options \<source> and \<target>.

Other optional arguments include:
- -relax: uses the relax encodnig for recursive relations,
- -unroll: unrolling bound for the BMC.

The .pts format
======

Examples are provided in the **benchmarks/** folder.
```
  program ::= {⟨loc⟩*} ⟨thrd⟩*

  ⟨thrd⟩ ::= thread String {⟨inst⟩*}

  ⟨inst⟩ ::= ⟨com⟩; | while ⟨pred⟩ {⟨inst⟩} | if ⟨pred⟩ {⟨inst⟩} | if ⟨pred⟩ {⟨inst⟩} else {⟨inst⟩}

  ⟨com⟩ ::= ⟨reg⟩ <- ⟨expr⟩ | ⟨reg⟩ = ⟨loc⟩.load(⟨atomic⟩) | ⟨loc⟩.store(⟨atomic⟩,⟨reg⟩)
  
  ⟨atomic⟩ ::= "_na" | "_sc" | "_rx" | "_acq" | "_rel" | "_con"
  
  ⟨pred⟩ ::= Bool | ⟨pred⟩ and ⟨pred⟩ | ⟨pred⟩ or ⟨pred⟩ | not ⟨pred⟩ 
  
          | ⟨expr⟩ == ⟨expr⟩ | ⟨expr⟩ != ⟨expr⟩
          
          | ⟨expr⟩ < ⟨expr⟩ | ⟨expr⟩ <= ⟨expr⟩
          
          | ⟨expr⟩ > ⟨expr⟩ | ⟨expr⟩ >= ⟨expr⟩
  
  ⟨expr⟩ ::= Int | ⟨reg⟩
  
          | ⟨expr⟩ + ⟨expr⟩ | ⟨expr⟩ - ⟨expr⟩

          | ⟨expr⟩ * ⟨expr⟩ | ⟨expr⟩ / ⟨expr⟩
  
          | ⟨expr⟩ & ⟨expr⟩ | ⟨expr⟩ | ⟨expr⟩
          
          | ⟨expr⟩ ^ ⟨expr⟩ 
  ```

Author and Contact
======
Dat3M is developed and maintained by [Hernán Ponce de León](mailto:ponce@fortiss.org), [Florian Furbach](mailto:f.furbach@tu-braunschweig.de) and [Natalia Gavrilenko](mailto:natalia.gavrilenko@aalto.fi). Please feel free to contact us in case of questions or to send feedback.
