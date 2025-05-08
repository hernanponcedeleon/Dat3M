package com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.Set;

public class VisitorExtensionGlslStd extends VisitorExtension<Expression> {

    private final ProgramBuilder builder;

    public VisitorExtensionGlslStd(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Set<String> getSupportedInstructions() {
        return Set.of();
    }
}
