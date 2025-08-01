package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.Set;

public class VisitorOpsBarrier extends SpirvBaseVisitor<Event> {

    private final ProgramBuilder builder;
    private int nextBarrierId = 0;

    public VisitorOpsBarrier(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpControlBarrier(SpirvParser.OpControlBarrierContext ctx) {
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.WORKGROUP.equals(execScope) && !Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Event barrier = EventFactory.newControlBarrier("cbar", Integer.toString(nextBarrierId++), execScope);
        barrier.addTags(Tag.Spirv.CONTROL);
        barrier.addTags(getScopeTag(ctx.memory().getText()));
        Set<String> tags = getMemorySemanticsTags(ctx.semantics().getText());
        if (Set.of(Tag.Spirv.RELAXED).equals(tags)) {
            barrier.removeTags(Tag.FENCE);
        } else {
            barrier.addTags(tags);
        }
        return builder.addEvent(barrier);
    }

    @Override
    public Event visitOpMemoryBarrier(SpirvParser.OpMemoryBarrierContext ctx) {
        Set<String> tags = getMemorySemanticsTags(ctx.semantics().getText());
        if (!Set.of(Tag.Spirv.RELAXED).equals(tags)) {
            Event fence = EventFactory.newFence(Tag.FENCE);
            fence.addTags(getScopeTag(ctx.memory().getText()));
            fence.addTags(tags);
            return builder.addEvent(fence);
        }
        throw new ParsingException("Illegal OpMemoryBarrier with semantics None");
    }

    private String getScopeTag(String scopeId) {
        return HelperTags.parseScope(scopeId, builder.getExpression(scopeId));
    }

    private Set<String> getMemorySemanticsTags(String semanticsId) {
        return HelperTags.parseMemorySemanticsTags(semanticsId, builder.getExpression(semanticsId));
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpControlBarrier",
                "OpMemoryBarrier"
        );
    }
}
