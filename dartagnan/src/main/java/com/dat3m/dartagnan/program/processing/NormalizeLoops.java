package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;

import java.util.Arrays;
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

    private final TypeFactory types = TypeFactory.getInstance();
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();

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

            // Guarantee header is the only fromOutside point
            final Label loopBegin = label;
            final CondJump uniqueBackJump = backJumps.get(0);

            final List<Label> loopBodyLabels = loopBegin.getSuccessor().getSuccessors().stream()
                    .takeWhile(ev -> ev != uniqueBackJump)
                    .filter(Label.class::isInstance).map(Label.class::cast)
                    .toList();
            for (Label l : loopBodyLabels) {
                final List<CondJump> externalEntries = l.getJumpSet().stream()
                        .filter(j -> j.getLocalId() < loopBegin.getLocalId() ||
                                j.getLocalId() > uniqueBackJump.getLocalId())
                        .toList();

                for(CondJump fromOutside : externalEntries) {

                    final Register jumpedFromOutside = function.newRegister("__jumpedFromOutside", types.getBooleanType());
                    final Local setJumpedFromOutside = EventFactory.newLocal(jumpedFromOutside, expressions.makeTrue());
                    final CondJump jumpToHeader = EventFactory.newGoto(loopBegin);
                    final Label internalLabel = fromOutside.getLabel();

                    fromOutside.replaceBy(setJumpedFromOutside);
                    setJumpedFromOutside.insertAfter(jumpToHeader);

                    final CondJump jumpToInternal = EventFactory.newJump(jumpedFromOutside, internalLabel);
                    final Local unsetJumpFromOutside = EventFactory.newLocal(jumpedFromOutside, expressions.makeFalse());

                    loopBegin.insertAfter(Arrays.asList(jumpToInternal, unsetJumpFromOutside));
                }
            }

        }
    }
}
