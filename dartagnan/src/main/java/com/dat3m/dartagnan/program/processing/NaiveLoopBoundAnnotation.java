package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntCmpExpr;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.DominatorAnalysis;
import com.dat3m.dartagnan.program.analysis.LiveRegistersAnalysis;
import com.dat3m.dartagnan.program.analysis.UseDefAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.utils.DominatorTree;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

/*
    This pass adds a loop bound annotation (using bound C+1) to static loops of the form 
        
        for (int i = I; i < C; i++) { Body }
    
    which have the following shape in our IR
    
            DUMMY <- I
        Loop:
            r0 <- DUMMY // Useless, we can ignore
            r1 <- ITE((DUMMY < C), 1, 0)
            if (r1 != 0) then goto Continue
            goto Exit
        Continue:
            Body
            r2 <- (DUMMY + 1)
            DUMMY <- r2
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
        if (!function.hasBody()) {
            return;
        }

        final LiveRegistersAnalysis liveAnalysis = LiveRegistersAnalysis.forFunction(function);
        final UseDefAnalysis useDefAnalysis = UseDefAnalysis.forFunction(function);
        final DominatorTree<Event> preDominatorTree = DominatorAnalysis.computePreDominatorTree(function.getEntry(), function.getExit());

        for (Label label : function.getEvents(Label.class)) {
            final List<CondJump> backJumps = label.getJumpSet().stream()
                    .filter(j -> j.getGlobalId() > label.getGlobalId())
                    .sorted()
                    .toList();

            // If this is a loop, NormalizeLoops guarantees a unique backjump
            if (backJumps.size() != 1) {
                continue;
            }

            final Event pred = label.getPredecessor();
            // We ignore the first local event which is useless
            final Event next = label.getSuccessor().getSuccessor();
            final Event nNext = next.getSuccessor();
            final Event nnNext = nNext.getSuccessor();
            final CondJump backJump = backJumps.get(0);
            final Event exit = backJump.getSuccessor();

            if (pred instanceof Local init && init.getExpr() instanceof IntLiteral initValExpr
                    // The loop header is dominated by the constant assignment to the counting register.
                    && preDominatorTree.isDominatedBy(label, init)
                    // The loop counting register is live at the loop header.
                    && liveAnalysis.getLiveRegistersAt(label).contains(init.getResultRegister())
                    // Find the predicate and compute the bound
                    && next instanceof Local ite && ite.getExpr() instanceof ITEExpr iteExpr
                    && iteExpr.getCondition() instanceof IntCmpExpr cond
                    && cond.getLeft().equals(init.getResultRegister())
                    && (cond.getKind().equals(IntCmpOp.LT) || cond.getKind().equals(IntCmpOp.ULT)
                            || cond.getKind().equals(IntCmpOp.LTE) || cond.getKind().equals(IntCmpOp.ULTE))
                    && cond.getRight() instanceof IntLiteral bound
                    // The exit condition is dependent on the counting register.
                    && nNext instanceof CondJump continueJump && nnNext instanceof CondJump exitJump
                    && exitJump.getLabel().equals(exit)
                    && useDefAnalysis.getDefs(continueJump, ite.getResultRegister()).contains(ite)
                    // There is a single increment to the register and that increment dominates the
                    // loop backjump (this gives the step size).
                    && getLoopBodyCountInc(label, backJump, init.getResultRegister(), useDefAnalysis) != null
                    // The call to get() is guaranteed to succeed by the check above
                    && preDominatorTree.isDominatedBy(backJump,
                        getLoopBodyCountInc(label, backJump, init.getResultRegister(), useDefAnalysis))
            ) {
                final Expression boundExpr = expressions.makeValue(
                        // We use C-I+1 for i < C and C-I+2 for i <= C
                        BigInteger.valueOf(bound.getValueAsInt() - initValExpr.getValueAsInt() + (cond.getKind().isStrict() ? 1 : 2)),
                        bound.getType());
                label.getPredecessor().insertAfter(EventFactory.Svcomp.newLoopBound(boundExpr));
            }
        }
    }

    private Event getLoopBodyCountInc(Label header, CondJump backJump, Register reg,
            UseDefAnalysis useDefAnalysis) {

        List<Event> writers = header.getSuccessors().stream().filter(e -> e instanceof RegWriter writer
                && writer.getResultRegister().equals(reg) & e.getGlobalId() < backJump.getGlobalId()).toList();
        // If there is not a single assignment to the count variable, we give up
        if (writers.size() != 1) {
            return null;
        }

        Event current = writers.get(0);
        // We traverse the UseDef-chain until we find a non-trivial assignment
        while (current instanceof Local loc && loc.getExpr() instanceof Register target) {
            writers = new ArrayList<>(useDefAnalysis.getDefs(loc, target));
            // If there is not a single assignment to the target of the UseDef-chain, we give up
            if (writers.size() != 1) {
                return null;
            }
            current = writers.get(0);
        }

        // If the non-trivial assignment has the shape rk <- i + s, we are done
        if (current instanceof Local loc && loc.getExpr() instanceof IntBinaryExpr intBExpr
                && intBExpr.getLeft().equals(reg) && intBExpr.getKind().equals(IntBinaryOp.ADD)) {
            return current;
        }

        // Otherwise we give up
        return null;
    }
}
