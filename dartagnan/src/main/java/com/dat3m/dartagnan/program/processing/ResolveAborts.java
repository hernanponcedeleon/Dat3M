package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.AbortIf;

import static com.google.common.base.Preconditions.checkArgument;

public class ResolveAborts implements FunctionProcessor {

    private ResolveAborts() {}

    public static ResolveAborts newInstance() { return new ResolveAborts(); }

    @Override
    public void run(Function function) {
        checkArgument(function instanceof Thread,
                "Called %s with non-thread function '%s'.", getClass(), function.getName());
        final Label threadEnd = EventFactory.newLabel("END_OF_T%d".formatted(function.getId()));
        for (AbortIf abort : function.getEvents(AbortIf.class)) {
            final Event jumpToEnd = EventFactory.newJump(abort.getCondition(), threadEnd);
            jumpToEnd.addTags(abort.getTags());
            IRHelper.replaceWithMetadata(abort, jumpToEnd);
        }
        function.append(threadEnd);
    }
}
