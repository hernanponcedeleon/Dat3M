package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.Return;

import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.newFunctionReturn;

public class VisitorOpsControlFlow extends SpirvBaseVisitor<Event> {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private final ProgramBuilderSpv builder;
    private String continueLabelId;
    private String mergeLabelId;
    private String nextLabelId;

    public VisitorOpsControlFlow(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpPhi(SpirvParser.OpPhiContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        Register register = builder.addRegister(id, typeId);
        for (SpirvParser.VariableContext vCtx : ctx.variable()) {
            SpirvParser.PairIdRefIdRefContext pCtx = vCtx.pairIdRefIdRef();
            Label event = builder.getOrCreateLabel(pCtx.idRef(1).getText());
            Map<Register, String> phiDefinitions = builder.getPhiDefinitions(event);
            phiDefinitions.put(register, pCtx.idRef(0).getText());
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
        Label event = builder.getOrCreateLabel(ctx.idResult().getText());
        builder.startBlock(event);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpBranch(SpirvParser.OpBranchContext ctx) {
        String labelId = ctx.targetLabel().getText();
        if (continueLabelId == null && mergeLabelId == null) {
            Label label = builder.getOrCreateLabel(labelId);
            Event event = EventFactory.newGoto(label);
            builder.addEvent(event);
            return builder.endBlock(event);
        }

        // TODO: Test me!
        continueLabelId = null;
        mergeLabelId = null;
        Label label = builder.getOrCreateLabel(labelId);
        Event event = EventFactory.newGoto(label);
        builder.addEvent(event);
        return builder.endBlock(event);
        //throw new ParsingException("Unsupported control flow around OpBranch '%s'", labelId);
    }

    @Override
    public Event visitOpBranchConditional(SpirvParser.OpBranchConditionalContext ctx) {
        if (ctx.trueLabel().getText().equals(ctx.falseLabel().getText())) {
            throw new ParsingException("Labels of conditional branch cannot be the same");
        }
        if (mergeLabelId == null) {
            return visitOpBranchConditionalUnstructured(ctx);
        }
        if (continueLabelId != null) {
            if (mergeLabelId.equals(ctx.trueLabel().getText())
                    && continueLabelId.equals(ctx.falseLabel().getText())) {
                mergeLabelId = null;
                continueLabelId = null;
                nextLabelId = ctx.trueLabel().getText();
                builder.setNextOps(Set.of("OpLabel"));
                return visitOpBranchConditionalStructuredLoop(ctx);
            }
            throw new ParsingException("Illegal labels, expected mergeLabel='%s' and continueLabel='%s' " +
                    "but received mergeLabel='%s' and continueLabel='%s'",
                    mergeLabelId, continueLabelId, ctx.trueLabel().getText(), ctx.falseLabel().getText());
        } else if (mergeLabelId.equals(ctx.falseLabel().getText())) {
            mergeLabelId = null;
            nextLabelId = ctx.trueLabel().getText();
            builder.setNextOps(Set.of("OpLabel"));
            return visitOpBranchConditionalStructured(ctx);
        }
        throw new ParsingException("Illegal last label in conditional branch, " +
                "expected '%s' but received '%s'", mergeLabelId, ctx.falseLabel().getText());
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
            builder.setNextOps(Set.of("OpBranch", "OpBranchConditional"));
            return null;
        }
        throw new ParsingException("End and continue labels must be null");

        // TODO: For a structured while loop, a control dependency
        //  should be generated in the same way as for a structured if.
        //  Add a new event for this.
    }

    @Override
    public Event visitOpReturn(SpirvParser.OpReturnContext ctx) {
        Type returnType = builder.getCurrentFunctionType().getReturnType();
        if (TYPE_FACTORY.getVoidType().equals(returnType)) {
            Return event = newFunctionReturn(null);
            builder.addEvent(event);
            return builder.endBlock(event);
        }
        throw new ParsingException("Illegal non-value return for a non-void function '%s'",
                builder.getCurrentFunctionName());
    }

    @Override
    public Event visitOpReturnValue(SpirvParser.OpReturnValueContext ctx) {
        Type returnType = builder.getCurrentFunctionType().getReturnType();
        if (!TYPE_FACTORY.getVoidType().equals(returnType)) {
            String valueId = ctx.valueIdRef().getText();
            Expression expression = builder.getExpression(valueId);
            Event event = newFunctionReturn(expression);
            builder.addEvent(event);
            return builder.endBlock(event);
        }
        throw new ParsingException("Illegal value return for a void function '%s'",
                builder.getCurrentFunctionName());
    }

    private Event visitOpBranchConditionalStructuredLoop(SpirvParser.OpBranchConditionalContext ctx) {
        String trueLabelId = validateForwardLabel(ctx.trueLabel().getText());
        String falseLabelId = validateBackwardLabel(ctx.falseLabel().getText());
        Expression guard = builder.getExpression(ctx.condition().getText());
        Label falseLabel = builder.getOrCreateLabel(falseLabelId);
        Label trueLabel = builder.getOrCreateLabel(trueLabelId);
        Event event = builder.addEvent(EventFactory.newIfJump(guard, trueLabel, trueLabel));
        builder.addEvent(EventFactory.newGoto(falseLabel));
        return builder.endBlock(event);
    }

    private Event visitOpBranchConditionalStructured(SpirvParser.OpBranchConditionalContext ctx) {
        validateForwardLabel(ctx.trueLabel().getText());
        String falseLabelId = validateForwardLabel(ctx.falseLabel().getText());
        Expression guard = builder.getExpression(ctx.condition().getText());
        Label falseLabel = builder.getOrCreateLabel(falseLabelId);
        Label mergeLabel = builder.makeBranchEndLabel(falseLabel);
        Event event = EventFactory.newIfJumpUnless(guard, falseLabel, mergeLabel);
        builder.addEvent(event);
        return builder.endBlock(event);
    }

    private Event visitOpBranchConditionalUnstructured(SpirvParser.OpBranchConditionalContext ctx) {
        // Representing a Spir-V two-labels conditional jump as a pair of jumps
        // TODO: A clean implementation with a new event type,
        //  support for unstructured back jumps
        if (!builder.hasBlock(ctx.trueLabel().getText()) && !builder.hasBlock(ctx.falseLabel().getText())) {
            Label trueLabel = builder.getOrCreateLabel(ctx.trueLabel().getText());
            Label falseLabel = builder.getOrCreateLabel(ctx.falseLabel().getText());
            Expression guard = builder.getExpression(ctx.condition().getText());
            Event trueJump = builder.addEvent(EventFactory.newJump(guard, trueLabel));
            builder.addEvent(EventFactory.newJumpUnless(guard, falseLabel));
            return builder.endBlock(trueJump);
        }

        Expression guard = builder.getExpression(ctx.condition().getText());
        Label trueLabel = builder.getOrCreateLabel(ctx.trueLabel().getText());
        Label falseLabel = builder.getOrCreateLabel(ctx.falseLabel().getText());
        Label trueEnd = builder.makeBranchBackJumpLabel(trueLabel);
        Label falseEnd = builder.makeBranchBackJumpLabel(falseLabel);

        Event trueJump = builder.addEvent(EventFactory.newJump(guard, trueEnd));
        builder.addEvent(EventFactory.newJumpUnless(guard, falseEnd));
        builder.addEvent(trueEnd);
        builder.addEvent(EventFactory.newGoto(trueLabel));
        builder.addEvent(falseEnd);
        builder.addEvent(EventFactory.newGoto(falseLabel));
        return builder.endBlock(trueJump);
    }

    private String validateBackwardLabel(String id) {
        if (!builder.hasBlock(id)) {
            throw new ParsingException("Illegal forward jump to label '%s' " +
                    "from a structured loop", id);
        }
        return id;
    }

    private String validateForwardLabel(String id) {
        if (builder.hasBlock(id)) {
            throw new ParsingException("Illegal backward jump to label '%s' " +
                    "from a structured branch", id);
        }
        return id;
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
