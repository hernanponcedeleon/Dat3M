# TACAS 2018

This folder contains the scripts to reproduce the reachability and state inclusion experiments from Tables 2 and 3 in the article *"Porthos: a Memory Model-aware Verification Tool"* submitted to *TACAS 2018*.

Just run the scripts in bash, e.g.
```
sh dartagnan_tso.sh
```
(be sure the directory including the timeout binary is in your PATH).

The benchmarks translated from .pts format to .litmus format to be run with [HERD](http://diy.inria.fr/) are in the [benchmarks](https://github.com/hernanponcedeleon/PORTHOS/tree/master/dartagnan/benchmarks/all_rx) folder.

The memory models files for running HERD are in the [cat](https://github.com/hernanponcedeleon/PORTHOS/tree/master/dartagnan/cat) folder.
