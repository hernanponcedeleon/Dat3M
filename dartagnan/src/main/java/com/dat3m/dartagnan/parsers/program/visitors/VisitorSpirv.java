package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import org.antlr.v4.runtime.tree.ParseTree;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class VisitorSpirv extends SpirvBaseVisitor<Program> {

    private final ProgramBuilderSpv builder = new ProgramBuilderSpv();
    private final Map<String, SpirvBaseVisitor<?>> visitors = new HashMap<>();
    private final VisitorOpsConstant specConstantVisitor;

    public VisitorSpirv() {
        this.initializeVisitors();
        this.specConstantVisitor = getSpecConstantVisitor();
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
        visitInputAnnotation(ctx.spvHeader().inputAnnotation());
        visitConfigAnnotation(ctx.spvHeader().configAnnotation());
        visitSpvInstructions(ctx.spvInstructions());
        visitOutputAnnotation(ctx.spvHeader().outputAnnotation());
        return builder.build();
    }

    @Override
    public Program visitInputAnnotation(SpirvParser.InputAnnotationContext ctx) {
        //TODO: Implement
        return null;
    }

    @Override
    public Program visitOutputAnnotation(SpirvParser.OutputAnnotationContext ctx) {
        if (ctx.assertionFilter() != null) {
            builder.setAssertFilter(new VisitorSpirvAssertions(builder).visitAssertionFilter(ctx.assertionFilter()));
        }
        if (ctx.assertionList() != null) {
            builder.setAssert(new VisitorSpirvAssertions(builder).visitAssertionList(ctx.assertionList()));
        }
        return null;
    }

    @Override
    public Program visitConfigAnnotation(SpirvParser.ConfigAnnotationContext ctx) {
        int workGroupID = Integer.parseInt(ctx.literanAnnUnsignedInteger().get(0).getText());
        int subGroupID = Integer.parseInt(ctx.literanAnnUnsignedInteger().get(1).getText());
        int threadID = Integer.parseInt(ctx.literanAnnUnsignedInteger().get(2).getText());
        List<Integer> threadGrid = List.of(workGroupID, subGroupID, threadID);
        builder.setThreadGrid(threadGrid);
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
}
