package com.dat3m.porthos;

import com.dat3m.dartagnan.program.Program;

public class PorthosResult {

    private boolean isPortable;
    private int iterations;
    private Program sourceProgram;
    private Program targetProgram;

    PorthosResult(boolean isPortable, int iterations, Program sourceProgram, Program targetProgram){
        this.isPortable = isPortable;
        this.iterations = iterations;
        this.sourceProgram = sourceProgram;
        this.targetProgram = targetProgram;
    }

    public boolean getIsPortable(){
        return isPortable;
    }

    public int getIterations(){
        return iterations;
    }

    public Program getSourceProgram(){
        return sourceProgram;
    }

    public Program getTargetProgram(){
        return targetProgram;
    }
}
