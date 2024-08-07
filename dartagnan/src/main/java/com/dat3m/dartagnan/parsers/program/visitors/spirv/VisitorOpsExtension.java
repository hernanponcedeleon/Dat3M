package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtension;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtensionClspvReflection;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class VisitorOpsExtension extends SpirvBaseVisitor<Void> {

    private final Map<String, VisitorExtension<?>> availableVisitors = new HashMap<>();
    private final Map<String, String> visitorIds = new HashMap<>();

    public VisitorOpsExtension(ProgramBuilderSpv builder) {
        this.availableVisitors.put("NonSemantic.ClspvReflection.5", new VisitorExtensionClspvReflection(builder));
    }

    @Override
    public Void visitOpExtInstImport(SpirvParser.OpExtInstImportContext ctx) {
        String name = ctx.nameLiteralString().getText();
        name = name.substring(1, name.length() - 1);
        SpirvBaseVisitor<?> visitor = availableVisitors.get(name);
        if (visitor != null) {
            String id = ctx.idResult().getText();
            visitorIds.put(id, name);
            return null;
        }
        throw new ParsingException("Unsupported Spir-V extension '%s'", name);
    }

    @Override
    public Void visitOpExtInst(SpirvParser.OpExtInstContext ctx) {
        String id = ctx.set().getText();
        String name = visitorIds.get(id);
        if (name != null) {
            VisitorExtension<?> visitor = availableVisitors.get(name);
            String instruction = getFirstTokenText(ctx.instruction());
            if (visitor.getSupportedInstructions().contains(instruction)) {
                ctx.accept(visitor);
                return null;
            }
            throw new ParsingException("External instruction '%s' is not implemented for '%s'", instruction, name);
        }
        throw new ParsingException("Unexpected extension id '%s'", id);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpExtInstImport",
                "OpExtInst"
        );
    }

    private static String getFirstTokenText(ParseTree ctx) {
        while (!(ctx instanceof TerminalNode)) {
            ctx = ctx.getChild(0);
        }
        return ctx.getText();
    }
}
