package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;

import java.util.Set;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.*;

public class VisitorOpsAnnotation extends SpirvBaseVisitor<Void> {

    private final Decoration builtIn;
    private final Decoration offset;
    private final Decoration alignment;

    public VisitorOpsAnnotation(ProgramBuilder builder) {
        this.builtIn = builder.getDecorationsBuilder().getDecoration(BUILT_IN);
        this.offset = builder.getDecorationsBuilder().getDecoration(OFFSET);
        this.alignment = builder.getDecorationsBuilder().getDecoration(ALIGNMENT);
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
            case ALIGNMENT -> {
                String value = ctx.decoration().alignmentLiteralInteger().getText();
                alignment.addDecoration(id, value);
            }
            case BINDING, DESCRIPTOR_SET, SPEC_ID, NON_WRITABLE -> {
                // Skip
                // BINDING - The order of arguments to the entry point
                // DESCRIPTOR_SET - Linkage to arguments of the entry point
                // SPEC_ID - The order of spec constants
                // NON_WRITABLE - Read-only pointer
            }
            case ARRAY_STRIDE, BLOCK, BUFFER_BLOCK, COHERENT, CONSTANT, FUNC_PARAM_ATTR, LINKAGE_ATTRIBUTES,
                    NO_CONTRACTION, NO_PERSPECTIVE -> {
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
                // Skip
                // NON_WRITABLE - Read-only element
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
