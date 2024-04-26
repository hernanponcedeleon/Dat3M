package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmXchg;
import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class XchgToDualCAS implements ProgramProcessor {

    protected final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private XchgToDualCAS() { }

    public static XchgToDualCAS newInstance() {
        return new XchgToDualCAS();
    }

    @Override
    public void run(Program program) {
        program.getFunctions().forEach(this::run);
    }

    private void run(Function function) {
        final XchgTransformer transformer = new XchgTransformer();
        if (function.hasBody()) {
            function.getEvents().forEach(e -> trasnformEvent(e, transformer));
        }
    }

    private void trasnformEvent(Event next, XchgTransformer transformer) {
        final Event pred = next.getPredecessor();
        final List<Event> events = next.accept(transformer);
        if (events.size() == 1) {
            // In the special case where the transformation does nothing, we keep the event as is.
            return;
        }
        if (!next.tryDelete()) {
            final String error = String.format("Could not transform event '%d:  %s' because it is not deletable." +
                    "The event is likely referenced by other events.", next.getGlobalId(), next);
            throw new IllegalStateException(error);
        }
        // The entry event is never a Xchg
        if (pred != null && !events.isEmpty()) {
            // Insert result of transformation
            events.forEach(e -> e.copyAllMetadataFrom(next));
            pred.insertAfter(events);
        }
    }

    private class XchgTransformer implements EventVisitor<List<Event>> {

        @Override
        public List<Event> visitEvent(Event e) {
            return Collections.singletonList(e);
        }

        @Override
        public List<Event> visitLlvmXchg(LlvmXchg e) {
            Register resultRegister = e.getResultRegister();
            Expression address = e.getAddress();
            String mo = e.getMo();

            Load load = newRMWLoadExclusiveWithMo(resultRegister, address, mo);
            Store store = newRMWStoreExclusiveWithMo(address, e.getValue(), true, mo);

            Label end = newLabel("Xchg_end");
            CondJump jump = newJumpUnless(expressions.makeNEQ(resultRegister, e.getValue()), end);

            return eventSequence(
                    load,
                    jump,
                    store,
                    // TODO potentially add F[REL] if the xchg requires release semantics
                    end
            );
        }
   }

}