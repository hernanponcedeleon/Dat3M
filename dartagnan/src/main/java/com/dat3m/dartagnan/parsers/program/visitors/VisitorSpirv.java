package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;

public class VisitorSpirv extends SpirvBaseVisitor<Expression> {

    private final ProgramBuilder programBuilder = ProgramBuilder.forLanguage(Program.SourceLanguage.SPV);
    public Program buildProgram() {
        return programBuilder.build();
    }
}
