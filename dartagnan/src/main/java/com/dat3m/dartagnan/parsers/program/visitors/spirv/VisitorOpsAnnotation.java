package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.Set;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.*;

public class VisitorOpsAnnotation extends SpirvBaseVisitor<Void> {

    private final Decoration builtIn;
    private final Decoration specId;

    public VisitorOpsAnnotation(ProgramBuilder builder) {
        this.builtIn = builder.getDecorationsBuilder().getDecoration(BUILT_IN);
        this.specId = builder.getDecorationsBuilder().getDecoration(SPEC_ID);
    }

    @Override
    public Void visitOpDecorate(SpirvParser.OpDecorateContext ctx) {
        String id = ctx.targetIdRef().getText();
        DecorationType type = fromString(ctx.decoration().getChild(0).getText());
        switch (type) {
            case BUILT_IN -> {
                String value = ctx.decoration().builtIn().getText();
                builtIn.addDecoration(id, value);
            }
            case SPEC_ID -> {
                String value = ctx.decoration().specializationConstantID().getText();
                specId.addDecoration(id, value);
            }
            case ARRAY_STRIDE, BINDING, BLOCK, BUFFER_BLOCK, COHERENT, DESCRIPTOR_SET, OFFSET, NO_CONTRACTION, NO_PERSPECTIVE, NON_WRITABLE -> {
                // TODO: Implementation
            }
            default -> throw new ParsingException("Unsupported decoration type '%s'", type);
        }
        return null;
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpDecorate",
                "OpMemberDecorate"
        );
    }
}
