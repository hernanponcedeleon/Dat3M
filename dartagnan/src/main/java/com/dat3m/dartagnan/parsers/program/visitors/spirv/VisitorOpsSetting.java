package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.Set;

public class VisitorOpsSetting extends SpirvBaseVisitor<Void> {

    private final ProgramBuilder builder;

    public VisitorOpsSetting(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Void visitOpEntryPoint(SpirvParser.OpEntryPointContext ctx) {
        builder.setEntryPointId(ctx.entryPoint().getText());
        return null;
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpCapability",
                "OpMemoryModel",
                "OpEntryPoint",
                "OpExecutionMode",
                "OpExecutionModeId"
        );
    }
}
