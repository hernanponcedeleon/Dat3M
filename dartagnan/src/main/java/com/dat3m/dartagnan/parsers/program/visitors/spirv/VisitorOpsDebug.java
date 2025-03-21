package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ControlFlowBuilder;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;

import java.util.Set;

public class VisitorOpsDebug extends SpirvBaseVisitor<Void> {

    private final ProgramBuilder builder;
    private final ControlFlowBuilder cfBuilder;

    public VisitorOpsDebug(ProgramBuilder builder) {
        this.builder = builder;
        this.cfBuilder = builder.getControlFlowBuilder();
    }

    @Override
    public Void visitOpString(SpirvParser.OpStringContext ctx) {
        String id = ctx.idResult().getText();
        String str = ctx.string().getText();
        builder.addDebugInfo(id, str);
        return null;
    }

    @Override
    public Void visitOpLine(SpirvParser.OpLineContext ctx) {
        String file = builder.getDebugInfo(ctx.file().getText());
        int line = Integer.parseInt(ctx.line().getText());
        SourceLocation loc = new SourceLocation(file, line);
        cfBuilder.setCurrentLocation(loc);
        return null;
    }

    @Override
    public Void visitOpNoLine(SpirvParser.OpNoLineContext ctx) {
        cfBuilder.removeCurrentLocation();
        return null;
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpSource",
                "OpSourceContinued",
                "OpSourceExtension",
                "OpName",
                "OpMemberName",
                "OpString",
                "OpLine",
                "OpNoLine",
                "OpModuleProcessed"
        );
    }
}
