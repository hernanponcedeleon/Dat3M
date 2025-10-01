package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtension;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtensionClspvReflection;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtensionGlslStd;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions.VisitorExtensionOpenClStd;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class VisitorOpsExtension extends SpirvBaseVisitor<Expression> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private final Map<String, VisitorExtension<Expression>> availableVisitors = new HashMap<>();
    private final Map<String, String> visitorIds = new HashMap<>();
    private final ProgramBuilder builder;

    public VisitorOpsExtension(ProgramBuilder builder) {
        VisitorExtensionClspvReflection clspv = new VisitorExtensionClspvReflection(builder);
        VisitorExtensionGlslStd glsl = new VisitorExtensionGlslStd(builder);
        VisitorExtensionOpenClStd opencl = new VisitorExtensionOpenClStd(builder);
        this.builder = builder;
        this.availableVisitors.put("NonSemantic.ClspvReflection.5", clspv);
        this.availableVisitors.put("NonSemantic.ClspvReflection.6", clspv);
        this.availableVisitors.put("GLSL.std.450", glsl);
        this.availableVisitors.put("OpenCL.std", opencl);
    }

    @Override
    public Expression visitOpExtension(SpirvParser.OpExtensionContext ctx) {
        // Addition features provided by an extension.
        // If a feature is not supported, an error will be thrown
        // when processing the corresponding instruction.
        return null;
    }

    @Override
    public Expression visitOpExtInstImport(SpirvParser.OpExtInstImportContext ctx) {
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
    public Expression visitOpExtInst(SpirvParser.OpExtInstContext ctx) {
        String extId = ctx.set().getText();
        String extName = visitorIds.get(extId);
        if (extName != null) {
            VisitorExtension<Expression> visitor = availableVisitors.get(extName);
            String resultId = ctx.idResult().getText();
            String instruction = getFirstTokenText(ctx.instruction());
            if (visitor.getSupportedInstructions().contains(instruction)) {
                Expression result = ctx.accept(visitor);
                Type type = builder.getType(ctx.idResultType().getText());
                if (result != null) {
                    if (!(type.equals(result.getType()))) {
                        throw new ParsingException("Mismatching result type in OpExtInst '%s'", resultId);
                    }
                    return builder.addExpression(resultId, result);
                } else if (!(type.equals(types.getVoidType()))) {
                    throw new ParsingException("Mismatching result type in OpExtInst '%s'", resultId);
                }
                return null;
            }
            throw new ParsingException("External instruction '%s' is not implemented for '%s'", instruction, extName);
        }
        throw new ParsingException("Unexpected extension id '%s'", extId);
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
