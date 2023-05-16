package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.parsers.LLVMIRBaseVisitor;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;

public class VisitorLlvm extends LLVMIRBaseVisitor<Object> {

    private final ProgramBuilder programBuilder;

    public VisitorLlvm(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point


}