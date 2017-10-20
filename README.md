# PORTHOS: _One_ Tool _for all_ Models

![alt text](https://github.com/hernanponcedeleon/PORTHOS/blob/master/dartagnan/extras/porthos_small.jpg)

Requirements
======
- z3 (https://github.com/Z3Prover/z3)

Usage
======
For cheacking execution inclusion:
```
java porthos/Porthos -s <source> -t <target> -i <input>
```
For cheacking state inclusion:
```
java porthos/Porthos -s <source> -t <target> -i <input> -state
```
For cheacking reachability:
```
java dartagnan/Dartagnan -t <target> -i <input>
```

where \<input> must be a .litmus or .pts (see below) program and \<source>, \<target> must be one of the following MCMs: 
- sc
- tso
- pso
- rmo
- alpha
- power
- arm

More memory models can be defined using the CAT language. See /src/dartagnan/wmm/

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
PORTHOS is developed and maintained by Hernán Ponce de León. Please feel free to [contact me]( mailto:ponce@fortiss.org) in case of questions or to send feedback.
