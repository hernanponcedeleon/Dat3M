package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntCmpExpr;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;

import java.math.BigInteger;
import java.util.List;

/*
    This pass adds a loop bound annotation (using bound C+1) to static loops of the form 
        
        for (int i = 0; i < C; i++)
    
    which have the following shape in our IR
    
        Loop:
            t <- DUMMY // Useless, we can ignore
            r <- ITE(i < C, 1, 0)
            if(r != 0); then goto Continue
            goto Exit
        Continue:
            Body
            goto Loop
        Exit:
*/
public class NaiveLoopBoundAnnotation implements FunctionProcessor {

    private ExpressionFactory expressions = ExpressionFactory.getInstance();

    public static NaiveLoopBoundAnnotation newInstance() {
        return new NaiveLoopBoundAnnotation();
    }

    @Override
    public void run(Function function) {
        for (Label label : function.getEvents(Label.class)) {
            final List<CondJump> backJumps = label.getJumpSet().stream()
                    .filter(j -> j.getGlobalId() > label.getGlobalId())
                    .sorted()
                    .toList();

            // If this is a loop, NormalizeLoops guarantees a unique backjump
            if (backJumps.size() == 1) {
                // We ignore the first local event which is useless
                final Event next = label.getSuccessor().getSuccessor();
                final Event nextNext = next.getSuccessor();
                final Event nextNextNext = nextNext.getSuccessor();
                final Event backJump = backJumps.get(0);
                final Event exit = backJump.getSuccessor();

                if (next instanceof Local local && local.getExpr() instanceof ITEExpr ite
                        && ite.getCondition() instanceof IntCmpExpr cond
                        && (cond.getKind().equals(IntCmpOp.LT) || cond.getKind().equals(IntCmpOp.ULT)
                                || cond.getKind().equals(IntCmpOp.LTE) || cond.getKind().equals(IntCmpOp.ULTE))
                        && cond.getRight() instanceof IntLiteral bound && nextNext instanceof CondJump jump1
                        && label.getGlobalId() < jump1.getLabel().getGlobalId()
                        && jump1.getLabel().getGlobalId() < backJump.getGlobalId()
                        && nextNextNext instanceof CondJump jump2 && jump2.getLabel().equals(exit)) {
                    final Expression boundExpr = expressions.makeValue(
                            // We use C+1 for i < C and C+2 for i <= C
                            BigInteger.valueOf(bound.getValueAsInt() + (cond.getKind().equals(IntCmpOp.LT) || cond.getKind().equals(IntCmpOp.ULT) ? 1 : 2)),
                            bound.getType());
                    label.getPredecessor().insertAfter(EventFactory.Svcomp.newLoopBound(boundExpr));
                }
            }
        }
    }
}
