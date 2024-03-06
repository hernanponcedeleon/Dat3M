package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.Return;

import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.newFunctionReturn;

public class VisitorOpsControlFlow extends SpirvBaseVisitor<Event> {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private final ProgramBuilderSpv builder;
    private Label endLabel;

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
        return null;
    }

    @Override
    public Event visitOpLabel(SpirvParser.OpLabelContext ctx) {
        Label event = builder.getOrCreateLabel(ctx.idResult().getText());
        builder.startBlock(event);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpBranch(SpirvParser.OpBranchContext ctx) {
        String labelId = ctx.targetLabel().getText();
        if (endLabel == null) {
            Label label = builder.getOrCreateLabel(labelId);
            Event event = EventFactory.newGoto(label);
            builder.addEvent(event);
            builder.endBlock(event);
            return event;
        }
        throw new ParsingException("Illegal control flow around OpBranch '%s'", labelId);
    }

    @Override
    public Event visitOpBranchConditional(SpirvParser.OpBranchConditionalContext ctx) {
        Expression guard = builder.getExpression(ctx.condition().getText());
        Label trueLabel = builder.getOrCreateLabel(ctx.trueLabel().getText());
        Label falseLabel = builder.getOrCreateLabel(ctx.falseLabel().getText());
        if (!trueLabel.equals(falseLabel)) {
            Event event;
            if (endLabel == null) {
                event = EventFactory.newJumpUnless(guard, falseLabel);
            } else {
                event = EventFactory.newIfJumpUnless(guard, falseLabel, endLabel);
                endLabel = null;
            }
            builder.addEvent(event);
            builder.endBlock(event);
            return event;
        }
        throw new ParsingException("Labels of conditional branch cannot be the same");
    }

    @Override
    public Event visitOpSelectionMerge(SpirvParser.OpSelectionMergeContext ctx) {
        if (endLabel == null) {
            endLabel = builder.getOrCreateLabel(ctx.mergeBlock().getText());
            return endLabel;
        }
        throw new ParsingException("End label must be null");
    }

    @Override
    public Event visitOpLoopMerge(SpirvParser.OpLoopMergeContext ctx) {
        // TODO: For a structured while loop, a control dependency
        //  should be generated in the same way as for a structured if.
        //  Add a new event for this.
        return null;
    }

    @Override
    public Event visitOpReturn(SpirvParser.OpReturnContext ctx) {
        Type returnType = builder.getCurrentFunctionType().getReturnType();
        if (TYPE_FACTORY.getVoidType().equals(returnType)) {
            Return event = newFunctionReturn(null);
            builder.addEvent(newFunctionReturn(null));
            builder.endBlock(event);
            return null;
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
            builder.endBlock(event);
            return null;
        }
        throw new ParsingException("Illegal value return for a void function '%s'",
                builder.getCurrentFunctionName());
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
