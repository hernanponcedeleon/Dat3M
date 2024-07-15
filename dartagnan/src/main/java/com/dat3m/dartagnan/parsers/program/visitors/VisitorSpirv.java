package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.*;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ThreadGrid;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import org.antlr.v4.runtime.tree.ParseTree;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class VisitorSpirv extends SpirvBaseVisitor<Program> {

    private final Map<String, SpirvBaseVisitor<?>> visitors = new HashMap<>();
    private VisitorOpsConstant specConstantVisitor;
    private ProgramBuilder builder;

    static String parseOpName(SpirvParser.OpContext ctx) {
        ParseTree innerCtx = ctx.getChild(0);
        if ("Op".equals(innerCtx.getChild(0).getText())) {
            return "Op" + innerCtx.getChild(1).getText();
        }
        if ("SpecConstantOp".equals(innerCtx.getChild(3).getText())) {
            return "Op" + innerCtx.getChild(5).getText();
        }
        return "Op" + innerCtx.getChild(3).getText();
    }

    static boolean isSpecConstantOp(SpirvParser.OpContext ctx) {
        ParseTree innerCtx = ctx.getChild(0);
        if ("Op".equals(innerCtx.getChild(0).getText())) {
            return false;
        }
        return "SpecConstantOp".equals(innerCtx.getChild(3).getText());
    }

    private static Set<Class<?>> getChildVisitors() {
        return Set.of(
                VisitorOpsAnnotation.class,
                VisitorOpsArithmetic.class,
                VisitorOpsAtomic.class,
                VisitorOpsBarrier.class,
                VisitorOpsBits.class,
                VisitorOpsConstant.class,
                VisitorOpsControlFlow.class,
                VisitorOpsDebug.class,
                VisitorOpsExtension.class,
                VisitorOpsFunction.class,
                VisitorOpsLogical.class,
                VisitorOpsMemory.class,
                VisitorOpsSetting.class,
                VisitorOpsType.class
        );
    }

    private void initializeVisitors() {
        for (Class<?> cls : getChildVisitors()) {
            try {
                Constructor<?> constructor = cls.getDeclaredConstructor(ProgramBuilder.class);
                SpirvBaseVisitor<?> visitor = (SpirvBaseVisitor<?>) constructor.newInstance(builder);
                Method method = cls.getDeclaredMethod("getSupportedOps");
                Object object = method.invoke(visitor);
                if (object instanceof Set<?> ops) {
                    ops.forEach(op -> {
                        if (visitors.put(op.toString(), visitor) != null) {
                            throw new IllegalArgumentException("Attempt to redefine visitor for " + op);
                        }
                    });
                } else {
                    throw new IllegalArgumentException("Illegal supported Ops in " + cls.getName());
                }
            } catch (NoSuchMethodException | SecurityException |
                     InstantiationException | IllegalAccessException |
                     IllegalArgumentException | InvocationTargetException e) {
                throw new IllegalArgumentException("Failed to initialize visitor " + cls.getName(), e);
            }
        }
    }

    private VisitorOpsConstant getSpecConstantVisitor() {
        return visitors.values().stream()
                .filter(VisitorOpsConstant.class::isInstance)
                .findFirst()
                .map(v -> (VisitorOpsConstant) v)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Missing visitor " + VisitorOpsConstant.class.getSimpleName()));
    }

    @Override
    public Program visitSpv(SpirvParser.SpvContext ctx) {
        this.builder = createBuilder(ctx);
        this.initializeVisitors();
        this.specConstantVisitor = getSpecConstantVisitor();
        visitSpvInstructions(ctx.spvInstructions());
        visitSpvHeaders(ctx.spvHeaders());
        return builder.build();
    }

    private ProgramBuilder createBuilder(SpirvParser.SpvContext ctx) {
        ThreadGrid grid = new ThreadGrid(1, 1, 1, 1);
        VisitorSpirvInput visitor = new VisitorSpirvInput();
        boolean hasConfig = false;
        for (SpirvParser.SpvHeaderContext header : ctx.spvHeaders().spvHeader()) {
            if (header.inputHeader() != null && header.inputHeader().initList() != null) {
                visitor.visitInitList(header.inputHeader().initList());
            }
            if (header.configHeader() != null) {
                if (hasConfig) {
                    throw new ParsingException("Multiple config headers are not allowed");
                }
                hasConfig = true;
                int threadAmount = Integer.parseInt(header.configHeader().literanHeaderUnsignedInteger().get(0).getText());
                int subGroupAmount = Integer.parseInt(header.configHeader().literanHeaderUnsignedInteger().get(1).getText());
                int workGroupAmount = Integer.parseInt(header.configHeader().literanHeaderUnsignedInteger().get(2).getText());
                grid = new ThreadGrid(threadAmount, subGroupAmount, workGroupAmount, 1);
            }
        }
        return new ProgramBuilder(grid, visitor.getInputs());
    }

    @Override
    public Program visitSpvHeaders(SpirvParser.SpvHeadersContext ctx) {
        VisitorSpirvOutput visitor = new VisitorSpirvOutput(builder);
        for (SpirvParser.SpvHeaderContext header : ctx.spvHeader()) {
            if (header.outputHeader() != null && header.outputHeader().assertionList() != null) {
                visitor.visitAssertionList(header.outputHeader().assertionList());
            }
        }
        return null;
    }

    @Override
    public Program visitSpvInstructions(SpirvParser.SpvInstructionsContext ctx) {
        this.visitChildren(ctx);
        return null;
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
}
