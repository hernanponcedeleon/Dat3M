package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;

import java.util.Set;

public class VisitorOpsBarrier extends SpirvBaseVisitor<Event> {

    private final ProgramBuilderSpv builder;

    public VisitorOpsBarrier(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpControlBarrier(SpirvParser.OpControlBarrierContext ctx) {
        // TODO: Is MM incorrect here?
        //  This is not an arbitrary value but a scope at which threads have to wait
        Expression value = builder.getExpression(ctx.execution().getText());
        if (!(value instanceof IntLiteral)) {
            throw new ParsingException("Non-constant execution scope " +
                    "of control barrier is not supported");
        }
        Event fence = EventFactory.newFenceWithId("cbar", value);
        fence.addTags(Tag.Spirv.CONTROL);
        if (builder.isSemanticsNone(ctx.semantics().getText())) {
            fence.removeTags(Tag.FENCE);
        } else {
            fence.addTags(builder.getScope(ctx.memory().getText()));
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
