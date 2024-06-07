package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;

import java.util.List;
import java.util.Map;

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
    if X goto __repeatLoop_L
    ...
    if Y goto __repeatLoop_L
    goto __breakLoop_L
    __repeatLoop_L:
    goto L
    __breakLoop_L
    More Code
    ...
*/
public class NormalizeLoops implements FunctionProcessor {

    public static NormalizeLoops newInstance() {
        return new NormalizeLoops();
    }

    @Override
    public void run(Function function) {
        int counter = 0;
        for (Label label : function.getEvents(Label.class)) {
            final List<CondJump> backJumps = label.getJumpSet().stream()
                    .filter(j -> j.getLocalId() > label.getLocalId())
                    .sorted()
                    .toList();

            // LoopFormVerification requires a unique and unconditional backjump
            if (backJumps.isEmpty() || (backJumps.size() == 1 && backJumps.get(0).isGoto())) {
                continue;
            }

            final CondJump last = backJumps.get(backJumps.size() - 1);

            final Label forwardLabel = EventFactory.newLabel("__repeatLoop_#" + counter);
            final CondJump gotoRepeat = EventFactory.newGoto(label);

            final Label breakLabel = EventFactory.newLabel("__breakLoop_#" + counter);
            final CondJump gotoBreak = EventFactory.newGoto(breakLabel);

            last.insertAfter(List.of(gotoBreak, forwardLabel, gotoRepeat, breakLabel));

            for(CondJump j : backJumps) {
                j.updateReferences(Map.of(j.getLabel(), forwardLabel));
            }

            counter++;
        }
    }
}
