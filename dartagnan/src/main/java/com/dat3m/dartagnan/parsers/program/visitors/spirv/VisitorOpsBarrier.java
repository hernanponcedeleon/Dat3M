package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.Set;

public class VisitorOpsBarrier extends SpirvBaseVisitor<Event> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final IntegerType archType = TypeFactory.getInstance().getArchType();
    private final ProgramBuilder builder;
    private int nextBarrierId = 0;

    public VisitorOpsBarrier(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpControlBarrier(SpirvParser.OpControlBarrierContext ctx) {
        if (!ctx.execution().getText().equals(ctx.memory().getText())) {
            throw new ParsingException("Unequal scopes in OpControlBarrier are not supported");
        }
        Expression barrierId = expressions.makeValue(nextBarrierId++, archType);
        Event barrier = EventFactory.newControlBarrier("cbar", barrierId);
        barrier.addTags(Tag.Spirv.CONTROL);
        barrier.addTags(builder.getScope(ctx.execution().getText()));
        if (builder.isSemanticsNone(ctx.semantics().getText())) {
            barrier.removeTags(Tag.FENCE);
        } else {
            barrier.addTags(builder.getSemantics(ctx.semantics().getText()));
        }
        return builder.addEvent(barrier);
    }

    @Override
    public Event visitOpMemoryBarrier(SpirvParser.OpMemoryBarrierContext ctx) {
        if (!builder.isSemanticsNone(ctx.semantics().getText())) {
            Event fence = EventFactory.newFence(Tag.FENCE);
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
