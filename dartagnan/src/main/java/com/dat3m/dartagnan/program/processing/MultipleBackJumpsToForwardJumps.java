package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;

import static java.util.Comparator.comparingInt;

import java.util.List;
import java.util.function.ToIntFunction;

public class MultipleBackJumpsToForwardJumps implements ProgramProcessor {

    public static MultipleBackJumpsToForwardJumps newInstance() {
        return new MultipleBackJumpsToForwardJumps();
    }

    @Override
    public void run(Program program) {
        program.getFunctions().forEach(p -> backToForwardJumps(p, Event::getGlobalId));
    }

    private void backToForwardJumps(Function function, ToIntFunction<Event> linId) {
        for (Label label : function.getEvents(Label.class)) {
            final List<CondJump> backJumps = label.getJumpSet().stream()
                    .filter(j -> linId.applyAsInt(j) > linId.applyAsInt(label))
                    .toList();

            if (backJumps.size() > 1) {
                final CondJump last = backJumps.stream().max(comparingInt(linId)).get();
                final Label jumpLabel = EventFactory.newLabel("Forward_to_" + last.getGlobalId());
                last.getPredecessor().insertAfter(jumpLabel);
                for(CondJump other : backJumps) {
                    if(other != last) {
                        final CondJump forwardJump = EventFactory.newJump(other.getGuard(), jumpLabel);
                        other.replaceBy(forwardJump);
                    }
                }
            }
        }
    }
}
