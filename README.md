# Dat3M: Memory Model Aware Verification

This tool suite is currently composed of two tools.

* **DARTAGNAN:** a tool to check state reachability under weak memory models.

<p align="center"> 
<img src="https://github.com/hernanponcedeleon/Dat3M/blob/master/dartagnan/extras/dartagnan_small.jpg">
</p>

* **PORTHOS:** a tool to check execution and state inclusion under weak memory models.

<p align="center"> 
<img src="https://github.com/hernanponcedeleon/Dat3M/blob/master/dartagnan/extras/porthos_small.jpg">
</p>

Installation
======
Run the compiling script
```
. ./install.sh
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
java dartagnan/Dartagnan -t <target> -i <input>
```
For checking execution inclusion:
```
java porthos/Porthos -s <source> -t <target> -i <input>
```
For checking state inclusion:
```
java porthos/Porthos -s <source> -t <target> -i <input> -state
```
where \<input> must be a .pts program (see below) and \<source>, \<target> must be a CAT file or one of the following strings: 
- sc
- tso
- pso
- rmo
- alpha
- power
- arm

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
Dat3M is developed and maintained by [Hernán Ponce de León](mailto:ponce@fortiss.org) and [Florian Furbach](mailto:f.furbach@tu-braunschweig.de). Please feel free to us in case of questions or to send feedback.
