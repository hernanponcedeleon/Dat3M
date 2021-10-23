package com.dat3m.dartagnan.program.utils.preprocessing;

import com.dat3m.dartagnan.program.Program;

/*
    A ProgramPreprocessor is an algorithm that runs on a program and somehow
    transforms it.
 */
public interface ProgramPreprocessor {
    void run(Program program);
}
