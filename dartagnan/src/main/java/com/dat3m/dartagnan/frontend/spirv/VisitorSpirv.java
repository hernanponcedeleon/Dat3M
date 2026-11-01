package com.dat3m.dartagnan.frontend.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.frontend.spirv.ops.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.frontend.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ThreadGrid;

import org.antlr.v4.runtime.tree.ParseTree;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;

public class VisitorSpirv extends SpirvBaseVisitor<Program> {

    private static final Logger logger = LoggerFactory.getLogger(VisitorSpirv.class);
    private final Map<String, SpirvBaseVisitor<?>> visitors = new HashMap<>();
    private VisitorOpsConstant specConstantVisitor;
    private ProgramBuilder builder;

    @Override
    public Program visitSpv(SpirvParser.SpvContext ctx) {
        this.builder = createBuilder(ctx);
        this.initializeVisitors();
        this.specConstantVisitor = getSpecConstantVisitor();
        ctx.spvHeaders().accept(new VisitorSpirvInput(builder));
        ctx.spvInstructions().accept(this);
        ctx.spvHeaders().accept(new VisitorSpirvOutput(builder));
        return builder.build();
    }

    @Override
    public Program visitOp(SpirvParser.OpContext ctx) {
        String name = parseOpName(ctx);
        if (builder.getNextOps() != null) {
            if (!builder.getNextOps().contains(name)) {
                throw new ParsingException("Unexpected operation '%s'", name);
            }
            builder.clearNextOps();
        }
        SpirvBaseVisitor<?> visitor = visitors.get(name);
        if (visitor == null) {
            throw new ParsingException("Unsupported operation '%s'", name);
        }
        Object result = ctx.accept(visitor);
        if (isSpecConstantOp(ctx)) {
            if (result instanceof Register register) {
                specConstantVisitor.visitOpSpecConstantOp(register);
            } else {
                throw new ParsingException(
                        "Illegal result type for OpSpecConstantOp '%s'", name);
            }
        }
        return null;
    }

    private ProgramBuilder createBuilder(SpirvParser.SpvContext ctx) {
        ThreadGrid grid = new ThreadGrid(1, 1, 1, 1, 1);
        boolean hasConfig = false;
        for (SpirvParser.SpvHeaderContext header : ctx.spvHeaders().spvHeader()) {
            SpirvParser.ConfigHeaderContext cfgCtx = header.configHeader();
            if (cfgCtx != null) {
                if (hasConfig) {
                    throw new ParsingException("Multiple config headers are not allowed");
                }
                hasConfig = true;
                List<SpirvParser.LiteralHeaderUnsignedIntegerContext> literals = cfgCtx.literalHeaderUnsignedInteger();
                int threadCount = Integer.parseInt(literals.get(0).getText());
                int subgroupCount = Integer.parseInt(literals.get(1).getText());
                int workgroupCount = Integer.parseInt(literals.get(2).getText());
                grid = new ThreadGrid(threadCount, subgroupCount, workgroupCount, 1, 1);
            }
            SpirvParser.UnknownHeaderContext unknownCtx = header.unknownHeader();
            if (unknownCtx != null) {
                logger.warn("Unknown header {}", unknownCtx.ModeHeader_UnknownType());
            }
        }
        return new ProgramBuilder(grid);
    }

    private void initializeVisitors() {
        for (var constructor : getChildVisitors()) {
            VisitorOps<?> visitor = constructor.apply(builder);
            visitor.getSupportedOps().forEach(op -> {
                var oldVisitor = visitors.put(op, visitor);
                if (oldVisitor != null) {
                    final String msg = "Duplicated visitor for %s: defined at %s and %s."
                            .formatted(op, oldVisitor.getClass().getSimpleName(), visitor.getClass().getSimpleName());
                    throw new IllegalArgumentException(msg);
                }
            });
        }
    }

    String parseOpName(SpirvParser.OpContext ctx) {
        ParseTree innerCtx = ctx.getChild(0);
        if ("Op".equals(innerCtx.getChild(0).getText())) {
            return "Op" + innerCtx.getChild(1).getText();
        }
        if ("SpecConstantOp".equals(innerCtx.getChild(3).getText())) {
            return "Op" + innerCtx.getChild(5).getText();
        }
        return "Op" + innerCtx.getChild(3).getText();
    }

    boolean isSpecConstantOp(SpirvParser.OpContext ctx) {
        ParseTree innerCtx = ctx.getChild(0);
        if ("Op".equals(innerCtx.getChild(0).getText())) {
            return false;
        }
        return "SpecConstantOp".equals(innerCtx.getChild(3).getText());
    }

    private VisitorOpsConstant getSpecConstantVisitor() {
        return visitors.values().stream()
                .filter(VisitorOpsConstant.class::isInstance)
                .findFirst()
                .map(v -> (VisitorOpsConstant) v)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Missing visitor " + VisitorOpsConstant.class.getSimpleName()));
    }

    private Set<Function<ProgramBuilder, VisitorOps<?>>> getChildVisitors() {
        return Set.of(
                VisitorOpsAnnotation::new,
                VisitorOpsArithmetic::new,
                VisitorOpsAtomic::new,
                VisitorOpsBarrier::new,
                VisitorOpsBits::new,
                VisitorOpsComposite::new,
                VisitorOpsConstant::new,
                VisitorOpsControlFlow::new,
                VisitorOpsConversion::new,
                VisitorOpsDebug::new,
                VisitorOpsExtension::new,
                VisitorOpsFunction::new,
                VisitorOpsLogical::new,
                VisitorOpsMemory::new,
                VisitorOpsMisc::new,
                VisitorOpsSetting::new,
                VisitorOpsType::new
        );
    }

}
