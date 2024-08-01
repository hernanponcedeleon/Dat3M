package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import java.math.BigInteger;
import java.util.List;
import java.util.Map;

/*
    This pass normalizes loops to have a single unconditional backjump and a single entry point.
    It achieves this via two transformations.

    (1) Given a loop of the form

        entry:
        ...
        goto C
        ...
        L:
        ...
        C:
        ...
        goto L

    it transforms it to

        entry:
        __jumpedTo_L_From <- 0
        ...
        __jumpedTo_L_From <- 1
        goto L
        ...
        L:
        if __jumpedTo_L_From == 1 goto C
        ...
        C:
        ...
        __jumpedTo_L_From <- 0
        goto L

    (2) Given a loop of the form

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

        guaranteeSingleEntry(function);
        IdReassignment.newInstance().run(function);
        guaranteeSingleUnconditionalBackjump(function);

    }

    private void guaranteeSingleUnconditionalBackjump(Function function) {
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

    private void guaranteeSingleEntry(Function function) {
        int labelCounter = 0;
        for (Label label : function.getEvents(Label.class)) {

            final List<CondJump> backJumps = label.getJumpSet().stream()
                    .filter(j -> j.getLocalId() > label.getLocalId())
                    .sorted()
                    .toList();
            if (backJumps.isEmpty()) {
                continue;
            }

            int counter = 0;

            final Label loopBegin = label;
            final CondJump last = backJumps.get(backJumps.size() - 1);

            final Register sourceReg = function.newRegister(String.format("__jumpedTo_%s#%s_From", label, labelCounter), types.getArchType());
            final Local initJumpedFromOutside = EventFactory.newLocal(sourceReg, expressions.makeZero(types.getArchType()));
            function.getEntry().insertAfter(initJumpedFromOutside);

            final List<Label> loopBodyLabels = loopBegin.getSuccessor().getSuccessors().stream()
                    .takeWhile(ev -> ev != last)
                    .filter(Label.class::isInstance).map(Label.class::cast)
                    .toList();

            for (Label l : loopBodyLabels) {
                final List<CondJump> externalEntries = l.getJumpSet().stream()
                        .filter(j -> j.getLocalId() < loopBegin.getLocalId())
                        .toList();

                for (CondJump fromOutside : externalEntries) {
                    counter++;

                    final Expression source = expressions.makeValue(BigInteger.valueOf(counter), types.getArchType());
                    final Local jumpingFrom = EventFactory.newLocal(sourceReg, source);

                    fromOutside.updateReferences(Map.of(fromOutside.getLabel(), loopBegin));
                    fromOutside.getPredecessor().insertAfter(jumpingFrom);

                    final Label internalLabel = fromOutside.getLabel();
                    final CondJump jumpToInternal = EventFactory.newJump(expressions.makeEQ(sourceReg, source), internalLabel);
                    final Local resetJumpFromOutside = EventFactory.newLocal(sourceReg, expressions.makeZero(types.getArchType()));

                    loopBegin.insertAfter(jumpToInternal);
                    last.getPredecessor().insertAfter(resetJumpFromOutside);
                }
            }

            labelCounter++;
        }
    }
}
