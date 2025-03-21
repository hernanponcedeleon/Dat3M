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
    private final Decoration offset;

    public VisitorOpsAnnotation(ProgramBuilder builder) {
        this.builtIn = builder.getDecorationsBuilder().getDecoration(BUILT_IN);
        this.offset = builder.getDecorationsBuilder().getDecoration(OFFSET);
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
            case BINDING, CONSTANT, NON_WRITABLE, SPEC_ID -> {
                // skip
            }
            case ALIGNMENT, ARRAY_STRIDE, BLOCK, BUFFER_BLOCK, COHERENT, DESCRIPTOR_SET, FUNC_PARAM_ATTR,
                    LINKAGE_ATTRIBUTES, NO_CONTRACTION, NO_PERSPECTIVE -> {
                // TODO: Implementation
            }
            default -> throw new ParsingException("Unsupported decoration '%s'", type);
        }
        return null;
    }

    @Override
    public Void visitOpMemberDecorate(SpirvParser.OpMemberDecorateContext ctx) {
        String id = ctx.structureType().getText();
        String index = ctx.member().getText();
        DecorationType type = fromString(ctx.decoration().getChild(0).getText());
        switch (type) {
            case OFFSET -> {
                String value = ctx.decoration().byteOffsetLiteralInteger().getText();
                offset.addDecoration(id, index, value);
            }
            case NON_WRITABLE -> {
                // skip
            }
            default -> throw new ParsingException("Unsupported member decoration '%s'", type);
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
