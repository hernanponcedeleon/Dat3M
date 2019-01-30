package com.dat3m.porthos;

import com.dat3m.dartagnan.program.Program;

class PorthosResult {

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

    boolean getIsPortable(){
        return isPortable;
    }

    int getIterations(){
        return iterations;
    }

    Program getSourceProgram(){
        return sourceProgram;
    }

    Program getTargetProgram(){
        return targetProgram;
    }
}
