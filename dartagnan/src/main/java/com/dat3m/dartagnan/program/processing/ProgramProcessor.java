package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;

/*
    A ProgramProcessor is an algorithm that runs on a program and somehow
    transforms it.
 */
public interface ProgramProcessor {
    void run(Program program);
}