package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;

import java.util.ArrayList;
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
        __loopEntryPoint_L <- 0
        ...
        __loopEntryPoint_L <- 1
        goto L
        ...
        L:
        __forwardTo_L <- __loopEntryPoint_L
        __loopEntryPoint_L <- 0
        if __forwardTo_L == 1 goto C
        ...
        C:
        ...
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
        int loopCounter = 0;
        for (Label loopBegin : function.getEvents(Label.class)) {
            final List<CondJump> backJumps = loopBegin.getJumpSet().stream()
                    .filter(j -> j.getLocalId() > loopBegin.getLocalId())
                    .sorted()
                    .toList();
            if (backJumps.isEmpty()) {
                continue;
            }

            final CondJump loopEnd = backJumps.get(backJumps.size() - 1);
            final List<Label> loopIrregularEntryPoints = loopBegin.getSuccessor().getSuccessors().stream()
                    .takeWhile(ev -> ev != loopEnd)
                    .filter(Label.class::isInstance).map(Label.class::cast)
                    .filter(l -> isEntryPoint(loopBegin, loopEnd, l))
                    .toList();

            if (loopIrregularEntryPoints.isEmpty()) {
                continue;
            }

            final IntegerType entryPointType = types.getByteType();
            final Register entryPointReg = function.newRegister(String.format("__loopEntryPoint_%s#%s", loopBegin, loopCounter), entryPointType);
            final Register forwarderReg = function.newRegister(String.format("__forwardTo_%s#%s", loopBegin, loopCounter), entryPointType);
            final Local initEntryPointReg = EventFactory.newLocal(entryPointReg, expressions.makeZero(entryPointType));
            final Local assignForwarderReg = EventFactory.newLocal(forwarderReg, entryPointReg);
            final Local resetEntryPointReg = EventFactory.newLocal(entryPointReg, expressions.makeZero(entryPointType));
            function.getEntry().insertAfter(initEntryPointReg);

            final List<Event> forwardingInstrumentation = new ArrayList<>();
            forwardingInstrumentation.add(assignForwarderReg);
            forwardingInstrumentation.add(resetEntryPointReg);

            int counter = 0;
            for (Label entryPoint : loopIrregularEntryPoints) {
                final List<CondJump> enteringJumps = getEnteringJumps(loopBegin,loopEnd, entryPoint);
                assert (!enteringJumps.isEmpty());

                final Expression entryPointValue = expressions.makeValue(++counter, entryPointType);
                for (CondJump enteringJump : enteringJumps) {
                    if (enteringJump.getLocalId() > loopEnd.getLocalId()) {
                        // TODO: This case is rare as it would imply we have two (or more) overlapping loops.
                        //  In this case, we should first merge the overlapping loops into one large loop.
                        final String error = String.format("Cannot normalize loop with loop-entering backjump (overlapping loops?): %d:%s \t %s",
                                enteringJump.getLocalId(), enteringJump, SyntacticContextAnalysis.getSourceLocationString(enteringJump));
                        throw new UnsupportedOperationException(error);
                    }
                    if (!enteringJump.isGoto()) {
                        // TODO: We should support this case, but the current implementation is wrong
                        //  because if an instrumented jump is not taken, it still updates the entry point reg
                        //  which will never get reset: we would end up accidentally forwarding a regular loop entry.
                        final String error = String.format("Cannot normalize loop with conditional loop-entering jump: %d:%s \t %s",
                                enteringJump.getLocalId(), enteringJump, SyntacticContextAnalysis.getSourceLocationString(enteringJump));
                        throw new UnsupportedOperationException(error);
                    }
                    enteringJump.getPredecessor().insertAfter(EventFactory.newLocal(entryPointReg, entryPointValue));
                    enteringJump.updateReferences(Map.of(entryPoint, loopBegin));
                }

                final CondJump forwardingJump = EventFactory.newJump(expressions.makeEQ(forwarderReg, entryPointValue), entryPoint);
                forwardingInstrumentation.add(forwardingJump);
            }

            loopBegin.insertAfter(forwardingInstrumentation);
            loopCounter++;
        }
    }

    private boolean isEntryPoint(Event beginning, Event end, Label internal) {
        return !getEnteringJumps(beginning, end, internal).isEmpty();
    }

    private List<CondJump> getEnteringJumps(Event beginning, Event end, Label internal) {
        return internal.getJumpSet().stream()
                .filter(j -> j.getLocalId() < beginning.getLocalId() || end.getLocalId() < j.getLocalId())
                .toList();
    }
}
