package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;

import java.util.Set;

public class VisitorOpsAnnotation extends SpirvBaseVisitor<Void> {

    private final ProgramBuilderSpv builder;

    public VisitorOpsAnnotation(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Void visitOpDecorate(SpirvParser.OpDecorateContext ctx) {
        if (ctx.decoration().builtIn() != null) {
            String id = ctx.targetIdRef().getText();
            String decoration = ctx.decoration().builtIn().getText();
            builder.addDecoration(id, decoration);
        }
        return null;
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpDecorate",
                "OpExtInstImport",
                "OpMemberDecorate"
        );
    }
}
