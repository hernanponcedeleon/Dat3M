package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.specification.AbstractAssert;
import org.antlr.v4.runtime.tree.ParseTree;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;

public class VisitorSpirv extends SpirvBaseVisitor<Object> {

    private final ProgramBuilderSpv builder = new ProgramBuilderSpv();
    private final Map<String, SpirvBaseVisitor<?>> visitors = new HashMap<>();
    private final VisitorOpsConstant specConstantVisitor;

    public VisitorSpirv() {
        this.initializeVisitors();
        this.specConstantVisitor = getSpecConstantVisitor();
    }

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
                VisitorOpsConstant.class,
                VisitorOpsControlFlow.class,
                VisitorOpsDebug.class,
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
                Constructor<?> constructor = cls.getDeclaredConstructor(ProgramBuilderSpv.class);
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
        List<SpirvParser.OutputHeaderContext> outputHeaders = new ArrayList<>();
        for (SpirvParser.SpvHeaderContext header : ctx.spvHeaders().spvHeader()) {
            if (header.outputHeader() != null) {
                outputHeaders.add(header.outputHeader());
            } else {
                this.visit(header);
            }
        }
        visitSpvInstructions(ctx.spvInstructions());
        List<AbstractAssert> assertions = new ArrayList<>();
        for (SpirvParser.OutputHeaderContext outputHeader : outputHeaders) {
            assertions.add(visitOutputHeader(outputHeader));
        }
        AbstractAssert aggregatedAssertion = VisitorSpirvOutput.aggregateAssertions(assertions);
        builder.setAssert(aggregatedAssertion);
        return builder.build();
    }

    @Override
    public Object visitInputHeader(SpirvParser.InputHeaderContext ctx) {
        if (ctx.initList() != null) {
            new VisitorSpirvInput(builder).visitInitList(ctx.initList());
        }
        return null;
    }

    @Override
    public AbstractAssert visitOutputHeader(SpirvParser.OutputHeaderContext ctx) {
        if (ctx.assertionList() != null) {
            return new VisitorSpirvOutput(builder).visitAssertionList(ctx.assertionList());
        }
        return null;
    }

    @Override
    public Object visitConfigHeader(SpirvParser.ConfigHeaderContext ctx) {
        int workGroupID = Integer.parseInt(ctx.literanHeaderUnsignedInteger().get(0).getText());
        int subGroupID = Integer.parseInt(ctx.literanHeaderUnsignedInteger().get(1).getText());
        int threadID = Integer.parseInt(ctx.literanHeaderUnsignedInteger().get(2).getText());
        List<Integer> threadGrid = List.of(workGroupID, subGroupID, threadID);
        builder.setThreadGrid(threadGrid);
        return null;
    }

    @Override
    public Object visitSpvInstructions(SpirvParser.SpvInstructionsContext ctx) {
        this.visitChildren(ctx);
        return null;
    }

    @Override
    public Object visitOp(SpirvParser.OpContext ctx) {
        String name = parseOpName(ctx);
        SpirvBaseVisitor<?> visitor = visitors.get(name);
        if (visitor == null) {
            throw new ParsingException("Unsupported operation %s", name);
        }
        Object result = ctx.accept(visitor);
        if (isSpecConstantOp(ctx)) {
            if (result instanceof Register register) {
                specConstantVisitor.visitOpSpecConstantOp(register);
            } else {
                throw new ParsingException(
                        "Illegal result type for OpSpecConstantOp %s", name);
            }
        }
        return null;
    }
}
