package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.DominatorAnalysis;
import com.dat3m.dartagnan.program.analysis.LiveRegistersAnalysis;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.analysis.UseDefAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.utils.DominatorTree;

import java.util.List;
import java.util.Set;

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
        final List<LoopAnalysis.LoopInfo> loops = LoopAnalysis.onFunction(function).getLoopsOfFunction(function);

        for (LoopAnalysis.LoopInfo loop : loops) {
            final List<Event> loopBody = loop.iterations().get(0).computeBody();
            final Label label = (Label) loopBody.get(0);
            final Event backJump = loopBody.get(loopBody.size() - 1);

            // Find candidate for loop counter register. We check for the shape:
            //      loopCounter <- constant
            //      loopHeader:
            // The loop header should be dominated by the constant assignment to the counter.
            if (!(label.getPredecessor() instanceof Local init && init.getExpr() instanceof IntLiteral initValExpr
                    && preDominatorTree.isDominatedBy(label, init))) {
                continue;
            }
            final Register counterReg = init.getResultRegister();

            // Validate that we indeed have found the counter register.
            final boolean counterIsLive = liveAnalysis.getLiveRegistersAt(label).contains(counterReg);
            final Event loopCountInc = findUniqueIncrement(loopBody, counterReg, useDefAnalysis, preDominatorTree);
            final boolean counterIsAlwaysIncremented =
                    (loopCountInc != null) && preDominatorTree.isDominatedBy(backJump, loopCountInc);
            if (!(counterIsLive && counterIsAlwaysIncremented)) {
                // The candidate counter is either not the true loop counter, or
                // the counter computations are too complex to analyze.
                continue;
            }

            // Now we look for the loop exit condition.
            // (1) Find all exiting jumps
            final List<CondJump> exitingJumps = loopBody.stream().filter(e -> e instanceof CondJump jump &&
                    jump.getLabel().getLocalId() > backJump.getLocalId()).map(CondJump.class::cast).toList();

            // (2) Check for each exit whether it is related to the counter variable.
            // If so, try to deduce a loop bound and annotate the loop.
            for (CondJump exit : exitingJumps) {
                // We check for the special shape:
                //      if (notExit) goto L;
                //      goto exit;
                if (!(exit.isGoto() && exit.getPredecessor() instanceof CondJump jump)) {
                    continue;
                }
                final Expression negatedGuard = jump.getGuard();
                // Now we check for the guard shape "r != 0" (i.e., we exit when r == 0 due to the inversion).
                if (!(negatedGuard instanceof IntCmpExpr cond
                        && cond.getLeft() instanceof Register r
                        && cond.getKind() == IntCmpOp.NEQ
                        && cond.getRight() instanceof IntLiteral c && c.isZero())) {
                    continue;
                }
                // Now we need to check if r is actually related to the loop counter
                // Check if there is a unique ITE defining the r from above and bounding the loop.
                final Expression boundExpr = computeLoopBound(loopBody, r, counterReg,
                        initValExpr.getValueAsInt(), useDefAnalysis, preDominatorTree);
                if (boundExpr != null) {
                    label.getPredecessor().insertAfter(EventFactory.Svcomp.newLoopBound(boundExpr));
                    break;
                }
            }
        }
    }

    // Check if there is a single increment to the register.
    // If there is, it returns the event performing the increment, otherwise it returns null.
    private Event findUniqueIncrement(List<Event> events, Register register,
                                      UseDefAnalysis useDefAnalysis, DominatorTree<Event> preDominatorTree) {
        final RegWriter source = findUniqueSource(events, register, useDefAnalysis, preDominatorTree);
        if (source == null) {
            return null;
        }
        // We found the non-trivial source. Check that this is indeed the desired increment:
        // (1) It is an addition operation
        if (!(source instanceof Local local && local.getExpr() instanceof IntBinaryExpr add && add.getKind() == IntBinaryOp.ADD)) {
            return null;
        }
        // (2) The addition is a positive increment of the register.
        if (!(add.getLeft().equals(register) && add.getRight() instanceof IntLiteral c && c.getValue().signum() > 0)) {
            return null;
        }
        // TODO: return also the increment
        return local;
    }

    private Expression computeLoopBound(List<Event> events, Register exitReg, Register counterReg, int counterRegInitVal,
                                        UseDefAnalysis useDefAnalysis, DominatorTree<Event> preDominatorTree) {

        final RegWriter exitSource = findUniqueSource(events, exitReg, useDefAnalysis, preDominatorTree);
        if (exitSource == null) {
            return null;
        }

        // If the non-trivial assignment has the shape exitCond <- ITE(counter <(=) C, 1, 0), we are done
        if (!(exitSource instanceof Local local && local.getExpr() instanceof ITEExpr iteExpr
                && iteExpr.getCondition() instanceof IntCmpExpr cond
                && cond.getLeft().equals(counterReg)
                && cond.getKind().isLessCategory()
                && cond.getRight() instanceof IntLiteral bound
                && iteExpr.getTrueCase() instanceof IntLiteral one && one.isOne()
                && iteExpr.getFalseCase() instanceof IntLiteral zero && zero.isZero())) {
            return null;
        }
        // We use C-I+1 for counter < C and C-I+2 for counter <= C
        final ExpressionFactory expressions = ExpressionFactory.getInstance();
        final int loopIterations = bound.getValueAsInt() - counterRegInitVal + (cond.getKind().isStrict() ? 1 : 2);
        return expressions.makeValue(loopIterations, bound.getType());

    }

    // Finds the unique non-trivial assignment that (possibly indirectly) provides the value of <register>
    // Returns NULL, if no such unique assignment exists.
    private RegWriter findUniqueSource(List<Event> events, Register register, UseDefAnalysis useDefAnalysis, DominatorTree<Event> preDominatorTree) {
        final List<RegWriter> writers = events.stream()
                .filter(e -> e instanceof RegWriter writer && writer.getResultRegister().equals(register))
                .map(RegWriter.class::cast).toList();

        if (writers.size() != 1 || !(writers.get(0) instanceof Local assignment)) {
            // There is no unique writer, or the unique writer is not a simple assignment.
            return null;
        }
        // Since the assignment may go over several trivial copy assignments, we need to traverse
        // the UseDef-chain until we find a non-trivial assignment.
        final RegWriter source = chaseUseDefChain(assignment, useDefAnalysis, preDominatorTree);
        if (!events.contains(source)) {
            // For the edge case where the source is outside the provided events.
            return null;
        }
        return source;
    }

    private RegWriter chaseUseDefChain(RegWriter assignment, UseDefAnalysis useDefAnalysis, DominatorTree<Event> preDominatorTree) {
        RegWriter cur = assignment;
        while (cur instanceof Local loc && loc.getExpr() instanceof Register reg) {
            final Set<RegWriter> defs = useDefAnalysis.getDefs(loc, reg);
            if (defs.size() != 1) {
                // Multiple assignments (or none): too complex so give up.
                return null;
            }
            final RegWriter def = defs.iterator().next();
            if (!preDominatorTree.isDominatedBy(cur, def)) {
                // Sanity check that the only def is also dominating its use.
                // This might not be true if there are accesses to uninitialized registers.
                return null;
            }
            cur = def;
        }
        return cur;
    }
}
