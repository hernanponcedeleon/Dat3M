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
    This pass transforms loops to have a single point.
    Given a loop of the form

        entry:
        ...
        goto C
        ...
        L:
        ...
        C:
        ...
        D:
        ...
        goto L
        ...
        goto D

    it transforms it to

        entry:
        __jumpedTo_L_From <- 0
        ...
        __jumpedTo_L_From <- 1
        goto L
        ...
        L:
        if __jumpedTo_L_From == 1 goto C
        if __jumpedTo_L_From == 2 goto D
        ...
        C:
        ...
        D:
        ...
        __jumpedTo_L_From <- 0
        goto L
        ...
        __jumpedTo_L_From <- 2
        goto L
*/
public class NormalizeLoopsSingleEntry implements FunctionProcessor {

    private final TypeFactory types = TypeFactory.getInstance();
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();

    public static NormalizeLoopsSingleEntry newInstance() {
        return new NormalizeLoopsSingleEntry();
    }

    @Override
    public void run(Function function) {

        // Guarantees header is the only entry point
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
            final CondJump uniqueBackJump = backJumps.get(0);

            final Register sourceReg = function.newRegister(String.format("__jumpedTo_%s_From", label), types.getArchType());
            final Local initJumpedFromOutside = EventFactory.newLocal(sourceReg, expressions.makeZero(types.getArchType()));
            function.getEntry().insertAfter(initJumpedFromOutside);

            final List<Label> loopBodyLabels = loopBegin.getSuccessor().getSuccessors().stream()
                    .takeWhile(ev -> ev != uniqueBackJump)
                    .filter(Label.class::isInstance).map(Label.class::cast)
                    .toList();

            for (Label l : loopBodyLabels) {
                final List<CondJump> externalEntries = l.getJumpSet().stream()
                        .filter(j -> j.getLocalId() < loopBegin.getLocalId() ||
                                j.getLocalId() > uniqueBackJump.getLocalId())
                        .toList();

                for (CondJump fromOutside : externalEntries) {
                    counter++;

                    final Expression source = expressions.makeValue(BigInteger.valueOf(counter), types.getArchType());
                    final Local jumpingFrom = EventFactory.newLocal(sourceReg, source);
                    final CondJump jumpToHeader = EventFactory.newGoto(loopBegin);

                    fromOutside.replaceBy(jumpingFrom);
                    jumpingFrom.insertAfter(jumpToHeader);
                    jumpToHeader.updateReferences(Map.of(jumpToHeader.getLabel(), loopBegin));

                    final Label internalLabel = fromOutside.getLabel();
                    final CondJump jumpToInternal = EventFactory.newJump(expressions.makeEQ(sourceReg, source), internalLabel);
                    final Local resetJumpFromOutside = EventFactory.newLocal(sourceReg, expressions.makeZero(types.getArchType()));

                    loopBegin.insertAfter(jumpToInternal);
                    uniqueBackJump.getPredecessor().insertAfter(resetJumpFromOutside);
                }
            }
        }
    }
}
