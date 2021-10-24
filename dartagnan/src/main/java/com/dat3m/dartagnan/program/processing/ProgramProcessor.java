package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;

/*
    A ProgramProcessor is an algorithm that runs on a program and somehow
    transforms it.
 */
//TODO: We might want to distinguish between
//  - A processor that takes a program instance and modifies it (simplification)
//  - A transformer that takes a program and constructs a new one (unrolling/compilation)
public interface ProgramProcessor {
    void run(Program program);
}
