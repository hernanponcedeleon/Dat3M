package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;

import java.util.Set;

public class VisitorOpsBarrier extends SpirvBaseVisitor<Event> {

    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();
    private final IntegerType barrierIdType = TypeFactory.getInstance().getArchType();
    private final ProgramBuilderSpv builder;
    private int nextBarrierId = 0;

    public VisitorOpsBarrier(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpControlBarrier(SpirvParser.OpControlBarrierContext ctx) {
        if (!ctx.execution().getText().equals(ctx.memory().getText())) {
            throw new ParsingException("Unequal scopes in OpControlBarrier are not supported");
        }
        Expression barId = EXPR_FACTORY.makeValue(nextBarrierId++, barrierIdType);
        Event fence = EventFactory.newFenceWithId("cbar", barId);
        fence.addTags(Tag.Spirv.CONTROL);
        fence.addTags(builder.getScope(ctx.execution().getText()));
        if (builder.isSemanticsNone(ctx.semantics().getText())) {
            fence.removeTags(Tag.FENCE);
        } else {
            fence.addTags(builder.getSemantics(ctx.semantics().getText()));
        }
        return builder.addEvent(fence);
    }

    @Override
    public Event visitOpMemoryBarrier(SpirvParser.OpMemoryBarrierContext ctx) {
        if (!builder.isSemanticsNone(ctx.semantics().getText())) {
            // TODO: Refactoring. The EventFactory method adds a fence name as a tag.
            //  Refactor the factory method not to add name tag by default, then use it here.
            Event fence = new GenericVisibleEvent("membar", Tag.FENCE);
            fence.addTags(builder.getScope(ctx.memory().getText()));
            fence.addTags(builder.getSemantics(ctx.semantics().getText()));
            return builder.addEvent(fence);
        }
        throw new ParsingException("Illegal OpMemoryBarrier with semantics None");
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpControlBarrier",
                "OpMemoryBarrier"
        );
    }
}
