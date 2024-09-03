package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ControlFlowBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.Return;

import java.util.*;

import static com.dat3m.dartagnan.program.event.EventFactory.newFunctionReturn;

public class VisitorOpsControlFlow extends SpirvBaseVisitor<Event> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private final ProgramBuilder builder;
    private final ControlFlowBuilder cfBuilder;
    private String continueLabelId;
    private String mergeLabelId;
    private String nextLabelId;

    public VisitorOpsControlFlow(ProgramBuilder builder) {
        this.builder = builder;
        this.cfBuilder = builder.getControlFlowBuilder();
    }

    @Override
    public Event visitOpPhi(SpirvParser.OpPhiContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        Register register = builder.addRegister(id, typeId);
        for (SpirvParser.VariableContext vCtx : ctx.variable()) {
            SpirvParser.PairIdRefIdRefContext pCtx = vCtx.pairIdRefIdRef();
            String labelId = pCtx.idRef(1).getText();
            String expressionId = pCtx.idRef(0).getText();
            cfBuilder.addPhiDefinition(labelId, register, expressionId);
        }
        builder.addExpression(id, register);
        return null;
    }

    @Override
    public Event visitOpLabel(SpirvParser.OpLabelContext ctx) {
        if (nextLabelId != null) {
            if (!nextLabelId.equals(ctx.idResult().getText())) {
                throw new ParsingException("Illegal label, expected '%s' but received '%s'",
                        nextLabelId, ctx.idResult().getText());
            }
            nextLabelId = null;
        }
        String labelId = ctx.idResult().getText();
        Label event = cfBuilder.getOrCreateLabel(labelId);
        cfBuilder.startBlock(labelId);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpSelectionMerge(SpirvParser.OpSelectionMergeContext ctx) {
        if (mergeLabelId == null) {
            mergeLabelId = ctx.mergeBlock().getText();
            builder.setNextOps(Set.of("OpBranchConditional", "OpSwitch"));
            return null;
        }
        throw new ParsingException("End label must be null");
    }

    @Override
    public Event visitOpLoopMerge(SpirvParser.OpLoopMergeContext ctx) {
        if (continueLabelId == null && mergeLabelId == null) {
            continueLabelId = ctx.continueTarget().getText();
            mergeLabelId = ctx.mergeBlock().getText();
            builder.setNextOps(Set.of("OpBranchConditional", "OpBranch"));
            return null;
        }
        throw new ParsingException("End and continue labels must be null");
    }

    @Override
    public Event visitOpBranch(SpirvParser.OpBranchContext ctx) {
        String labelId = ctx.targetLabel().getText();
        if (continueLabelId == null && mergeLabelId == null) {
            return visitGoto(labelId);
        }
        if (continueLabelId != null && mergeLabelId != null) {
            return visitLoopBranch(labelId);
        }
        throw new ParsingException("OpBranch '%s' must be either " +
                "a part of a loop definition or an arbitrary goto", labelId);
    }

    @Override
    public Event visitOpBranchConditional(SpirvParser.OpBranchConditionalContext ctx) {
        Expression guard = builder.getExpression(ctx.condition().getText());
        String trueLabelId = ctx.trueLabel().getText();
        String falseLabelId = ctx.falseLabel().getText();
        if (trueLabelId.equals(falseLabelId)) {
            throw new ParsingException("Labels of conditional branch cannot be the same");
        }
        if (mergeLabelId != null) {
            if (continueLabelId != null) {
                return visitLoopBranchConditional(guard, trueLabelId, falseLabelId);
            }
            return visitIfBranch(guard, trueLabelId, falseLabelId);
        }
        return visitConditionalJump(guard, trueLabelId, falseLabelId);
    }

    @Override
    public Event visitOpReturn(SpirvParser.OpReturnContext ctx) {
        Type returnType = builder.getCurrentFunctionType().getReturnType();
        if (types.getVoidType().equals(returnType)) {
            Return event = newFunctionReturn(null);
            builder.addEvent(event);
            return cfBuilder.endBlock(event);
        }
        throw new ParsingException("Illegal non-value return for a non-void function '%s'",
                builder.getCurrentFunctionName());
    }

    @Override
    public Event visitOpReturnValue(SpirvParser.OpReturnValueContext ctx) {
        Type returnType = builder.getCurrentFunctionType().getReturnType();
        if (!types.getVoidType().equals(returnType)) {
            String valueId = ctx.valueIdRef().getText();
            Expression expression = builder.getExpression(valueId);
            Event event = newFunctionReturn(expression);
            builder.addEvent(event);
            return cfBuilder.endBlock(event);
        }
        throw new ParsingException("Illegal value return for a void function '%s'",
                builder.getCurrentFunctionName());
    }

    private Event visitGoto(String labelId) {
        Label label = cfBuilder.getOrCreateLabel(labelId);
        Event event = EventFactory.newGoto(label);
        builder.addEvent(event);
        return cfBuilder.endBlock(event);
    }

    private Event visitLoopBranch(String labelId) {
        continueLabelId = null;
        mergeLabelId = null;
        return visitGoto(labelId);
    }

    private Event visitIfBranch(Expression guard, String trueLabelId, String falseLabelId) {
        for (String labelId : List.of(trueLabelId, falseLabelId)) {
            if (cfBuilder.isBlockStarted(labelId)) {
                throw new ParsingException("Illegal backward jump to '%s' from a structured branch", labelId);
            }
        }
        mergeLabelId = null;
        nextLabelId = trueLabelId;
        builder.setNextOps(Set.of("OpLabel"));
        Label falseLabel = cfBuilder.getOrCreateLabel(falseLabelId);
        Label mergeLabel = cfBuilder.createMergeLabel(falseLabelId);
        Event event = EventFactory.newIfJumpUnless(guard, falseLabel, mergeLabel);
        builder.addEvent(event);
        return cfBuilder.endBlock(event);
    }

    private Event visitConditionalJump(Expression guard, String trueLabelId, String falseLabelId) {
        if (cfBuilder.isBlockStarted(trueLabelId)) {
            if (cfBuilder.isBlockStarted(falseLabelId)) {
                throw new ParsingException("Unsupported conditional branch " +
                        "with two backward jumps to '%s' and '%s'", trueLabelId, falseLabelId);
            }
            String labelId = trueLabelId;
            trueLabelId = falseLabelId;
            falseLabelId = labelId;
            guard = ExpressionFactory.getInstance().makeNot(guard);
        }
        Label trueLabel = cfBuilder.getOrCreateLabel(trueLabelId);
        Label falseLabel = cfBuilder.getOrCreateLabel(falseLabelId);
        Event trueJump = builder.addEvent(EventFactory.newJump(guard, trueLabel));
        builder.addEvent(EventFactory.newGoto(falseLabel));
        return cfBuilder.endBlock(trueJump);
    }

    private Event visitLoopBranchConditional(Expression guard, String trueLabelId, String falseLabelId) {
        mergeLabelId = null;
        continueLabelId = null;
        nextLabelId = trueLabelId;
        builder.setNextOps(Set.of("OpLabel"));

        // TODO: For a structured while loop, a control dependency
        //  should be generated in the same way as for a structured if branch.
        //  We need to add a new event type for this.
        //  For now, we can treat while loop as unstructured jumps,
        //  because Vulkan memory model has no control dependency.

        return visitConditionalJump(guard, trueLabelId, falseLabelId);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpPhi",
                "OpBranch",
                "OpBranchConditional",
                "OpLabel",
                "OpLoopMerge",
                "OpSelectionMerge",
                "OpReturn",
                "OpReturnValue"
        );
    }
}
