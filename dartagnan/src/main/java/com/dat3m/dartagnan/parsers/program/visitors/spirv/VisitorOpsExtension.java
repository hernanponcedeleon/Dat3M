package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtension;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtensionClspvReflection;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtensionOpenClStd;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class VisitorOpsExtension extends SpirvBaseVisitor<Void> {

    private final Map<String, VisitorExtension<?>> availableVisitors = new HashMap<>();
    private final Map<String, String> visitorIds = new HashMap<>();

    public VisitorOpsExtension(ProgramBuilder builder) {
        VisitorExtensionClspvReflection clspv = new VisitorExtensionClspvReflection(builder);
        VisitorExtensionOpenClStd opencl = new VisitorExtensionOpenClStd(builder);
        this.availableVisitors.put("NonSemantic.ClspvReflection.5", clspv);
        this.availableVisitors.put("NonSemantic.ClspvReflection.6", clspv);
        this.availableVisitors.put("OpenCL.std", opencl);
    }

    @Override
    public Void visitOpExtension(SpirvParser.OpExtensionContext ctx) {
        String name = ctx.nameLiteralString().getText();
        name = name.substring(1, name.length() - 1);
        if (!"SPV_KHR_vulkan_memory_model".equals(name)) {
            throw new ParsingException("Unsupported extension '%s'", name);
        }
        return null;
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

    private String getFirstTokenText(ParseTree ctx) {
        while (!(ctx instanceof TerminalNode)) {
            ctx = ctx.getChild(0);
        }
        return ctx.getText();
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpExtension",
                "OpExtInstImport",
                "OpExtInst"
        );
    }
}
