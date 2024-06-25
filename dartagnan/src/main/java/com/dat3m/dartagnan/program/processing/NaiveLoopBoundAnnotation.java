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
    This pass adds a loop bound annotation to static loops of the form
        
        for (int i = I; i </<= C; i++) { Body }
    
    which have the following shape in our IR
    
            DUMMY <- I
        Loop:
            r0 <- DUMMY
            r1 <- ITE((DUMMY </<= C), 1, 0)
            if (r1 != 0) then goto Continue
            goto Exit
        Continue:
            Body
            r2 <- (DUMMY + 1)
            DUMMY <- r2
            goto Loop
        Exit:

    TODO: support general step increments
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

            // If this is a loop, the NormalizeLoops pass guarantees a unique backjump
            if (backJumps.size() != 1) {
                continue;
            }
            final CondJump backJump = backJumps.get(0);

            final Event pred = label.getPredecessor();
            final Event exit = backJump.getSuccessor();

            // Find candidate for looping count register.
            // The loop header should be dominated by the constant assignment to the counter.
            if (pred instanceof Local init && init.getExpr() instanceof IntLiteral initValExpr
                    && preDominatorTree.isDominatedBy(label, init)) {

                Register counterReg = init.getResultRegister();

                // Check if the counter is live at the loop header, there is a unique
                // increment to it, and that increment dominates the loop backjump.
                Event loopCountInc = getLoopBodyCountInc(label, backJump, counterReg, useDefAnalysis);
                if (liveAnalysis.getLiveRegistersAt(label).contains(counterReg)
                        && loopCountInc != null && preDominatorTree.isDominatedBy(backJump, loopCountInc)) {

                    // Loop exit jumps are gotos. We find all conditional jumps that
                    // skip the goto and thus, are related to the looping condition
                    List<CondJump> exitRegConds = label.getSuccessors().stream()
                            .filter(e -> e instanceof CondJump jump && e.getGlobalId() < backJump.getGlobalId()
                                    && jump.getSuccessor() instanceof CondJump exitJump && exitJump.isGoto()
                                    && exitJump.getLabel().equals(exit))
                            .map(CondJump.class::cast).toList();

                    // If there are more than one, we give up
                    if(exitRegConds.size() != 1) {
                        continue;
                    }

                    CondJump exitRegCond = exitRegConds.get(0);

                    // Check if the jump condition has shape r != 0
                    if (exitRegCond.getGuard() instanceof IntCmpExpr cond && cond.getLeft() instanceof Register iteResultReg
                            && cond.getKind().equals(IntCmpOp.NEQ) && cond.getRight() instanceof IntLiteral lit
                            && lit.isZero()) {

                        // Check if there is a unique ITE defining the r from above and bounding the loop.
                        Expression boundExpr = getLoopBound(label, backJump, iteResultReg, counterReg, initValExpr.getValueAsInt(), useDefAnalysis);
                        if(boundExpr != null) {
                            label.getPredecessor().insertAfter(EventFactory.Svcomp.newLoopBound(boundExpr));
                        }
                    }
                }
            }
        }
    }

    // Check if there is a single increment to the looping count register.
    // If there is, it returns the event performing the increment, otherwise it returns null.
    private Event getLoopBodyCountInc(Label header, CondJump backJump, Register loopingCount,
            UseDefAnalysis useDefAnalysis) {

        // Find writers to the looping count register within the loop body.
        List<RegWriter> writers = findWritersInLoop(header, backJump, loopingCount);
        // If there is not a single assignment to the count variable, we give up
        if (writers.size() != 1) {
            return null;
        }

        // We traverse the UseDef-chain until we find a non-trivial assignment
        RegWriter writer = chaseUseDefChain(writers.get(0), useDefAnalysis);
        if(writer == null) {
            return null;
        }

        // If the non-trivial assignment has the shape rk <- i + 1, we are done
        if (writer instanceof Local loc && loc.getExpr() instanceof IntBinaryExpr intBExpr
                && intBExpr.getLeft().equals(loopingCount) && intBExpr.getKind().equals(IntBinaryOp.ADD)
                && intBExpr.getRight() instanceof IntLiteral lit
                && lit.isOne()) {
            return writer;
        }

        // Otherwise we give up
        return null;
    }

    // Check if there is a single ITE(exitReg < C, 0, 1) computing the exit condition.
    // If there is, it returns C, otherwise it returns null.
    private Expression getLoopBound(Label header, CondJump backJump, Register exitReg, Register counterReg, int counterRegInitVal,
            UseDefAnalysis useDefAnalysis) {

        // Find writers to the looping exit register within the loop body.
        List<RegWriter> writers = findWritersInLoop(header, backJump, exitReg);
        // If there is not a single assignment to the exit variable, we give up
        if (writers.size() != 1) {
            return null;
        }

        // We traverse the UseDef-chain until we find a non-trivial assignment
        RegWriter writer = chaseUseDefChain(writers.get(0), useDefAnalysis);
        if(writer == null) {
            return null;
        }

        // If the non-trivial assignment has the shape rk <- ITE(exitReg < C, 0, 1), we are done
        if (writer instanceof Local loc && loc.getExpr() instanceof ITEExpr iteExpr
                && iteExpr.getCondition() instanceof IntCmpExpr cond
                && cond.getLeft().equals(counterReg)
                && (cond.getKind().equals(IntCmpOp.LT) || cond.getKind().equals(IntCmpOp.ULT)
                        || cond.getKind().equals(IntCmpOp.LTE) || cond.getKind().equals(IntCmpOp.ULTE))
                && cond.getRight() instanceof IntLiteral bound) {

            // We use C-I+1 for exitReg < C and C-I+2 for exitReg <= C
            return expressions.makeValue(
                BigInteger.valueOf(bound.getValueAsInt() - counterRegInitVal + (cond.getKind().isStrict() ? 1 : 2)),
                bound.getType());
        }

        // Otherwise we give up
        return null;
    }

    private List<RegWriter> findWritersInLoop(Event header, Event backJump, Register target) {
        return header.getSuccessors().stream()
                .filter(e -> e instanceof RegWriter writer
                        && writer.getResultRegister().equals(target) & e.getGlobalId() < backJump.getGlobalId())
                .map(RegWriter.class::cast)
                .toList();
    }

    private RegWriter chaseUseDefChain(RegWriter current, UseDefAnalysis useDefAnalysis) {
        List<RegWriter> writers;
        while (current instanceof Local loc && loc.getExpr() instanceof Register target) {
            writers = new ArrayList<>(useDefAnalysis.getDefs(loc, target));
            // If there is not a single assignment to the target of the UseDef-chain, we give up
            if (writers.size() != 1) {
                return null;
            }
            current = writers.get(0);
        }
        return current;
    }
}
