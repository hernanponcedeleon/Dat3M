package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;

/*
    This pass simply clears (i.e., "removes") all functions.
    It is one of the latest passes to be applied, meaning all function has already been processed.
 */
public class ClearFunctions implements ProgramProcessor {

    private ClearFunctions() { }

    public static ClearFunctions newInstance() { return new ClearFunctions(); }

    @Override
    public void run(Program program) {
        program.clearFunctions();
    }

}
