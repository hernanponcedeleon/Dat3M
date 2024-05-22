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

/*
    This pass transforms loops to have a single backjump using forward jumping.
    Given a loop of the form

    L:
    ...
    if X goto L
    ...
    if Y goto L
    More Code

    it transforms it to

    L:
    ...
    if X goto Forward_to_L
    ...
    if Y goto Forward_to_L
    goto Continue_after_last
    Forward_to_L:
    goto L
    Continue_after_last
    More Code
    ...
*/
public class MultipleBackJumpsToForwardJumps implements ProgramProcessor {

    public static MultipleBackJumpsToForwardJumps newInstance() {
        return new MultipleBackJumpsToForwardJumps();
    }

    @Override
    public void run(Program program) {
        program.getFunctions().forEach(f -> backToForwardJumps(f, Event::getGlobalId));
    }

    private void backToForwardJumps(Function function, ToIntFunction<Event> linId) {
        for (Label label : function.getEvents(Label.class)) {
            final List<CondJump> backJumps = label.getJumpSet().stream()
                    .filter(j -> linId.applyAsInt(j) > linId.applyAsInt(label))
                    .toList();

            if (backJumps.size() > 1) {
                final CondJump last = backJumps.stream().max(comparingInt(linId)).get();

                final Label forwardLabel = EventFactory.newLabel("Forward_to_" + label.getGlobalId());
                final CondJump gotoHead = EventFactory.newGoto(label);

                final Label continueLabel = EventFactory.newLabel("Continue_after_" + last.getGlobalId());
                final CondJump gotoContinue = EventFactory.newGoto(continueLabel);

                last.insertAfter(gotoContinue);
                gotoContinue.insertAfter(forwardLabel);
                forwardLabel.insertAfter(gotoHead);
                gotoHead.insertAfter(continueLabel);

                for(CondJump j : backJumps) {
                    final CondJump forwardJump = EventFactory.newJump(j.getGuard(), forwardLabel);
                    j.replaceBy(forwardJump);
                }
            }
        }
    }
}
