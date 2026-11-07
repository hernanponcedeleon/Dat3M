package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryExpr;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;

import java.math.BigInteger;
import java.util.*;

/*
    Over-approximates the number of distinct loop-carried states at the loop header.
    The loop-carried state is the vector of the given registers (e.g., the live registers written in the loop).
    For each such register r, we count the values r can have at the back jump, i.e., the values of the
    definitions of r inside the loop that reach the back jump (S_r). A register that is not redefined keeps its
    header value. Hence, at every header visit, r has a value in S_r or its value at loop entry, and the number
    of distinct header states is at most M = PRODUCT_r (|S_r| + 1).

    Value counting is a syntactic over-approximation:
        - constants have one value, loop-invariant registers have one value per loop execution,
        - "x & C" has at most 2^popcount(C) values,
        - any other expression has at most the product of the counts of its operands,
        - and every expression has at most as many values as its type.
 */
public class CycleBoundAnalysis {

    private static final long INFINITE = Long.MAX_VALUE / 4;

    private final Set<Event> body;
    private final Event loopStart;
    private final Event backJump;
    private final Set<Register> writtenInLoop = new HashSet<>();
    private final Map<Event, Long> definitionCounts = new HashMap<>();
    private final Set<Event> definitionsInProgress = new HashSet<>();

    private CycleBoundAnalysis(LoopAnalysis.LoopInfo loop) {
        final LoopAnalysis.LoopIterationInfo iteration = loop.iterations().getFirst();
        this.body = new HashSet<>(iteration.computeBody());
        this.loopStart = iteration.getIterationStart();
        this.backJump = iteration.getIterationEnd();
        for (Event e : body) {
            if (e instanceof RegWriter writer) {
                writtenInLoop.add(writer.getResultRegister());
            }
        }
    }

    // Returns an over-approximation of the number of distinct values that "loopCarriedRegisters" can have
    // at the loop header (or a huge number if it cannot be bounded).
    public static long countLoopCarriedStates(LoopAnalysis.LoopInfo loop, Collection<Register> loopCarriedRegisters) {
        return new CycleBoundAnalysis(loop).countStates(loopCarriedRegisters);
    }

    private long countStates(Collection<Register> loopCarriedRegisters) {
        long states = 1;
        for (Register reg : loopCarriedRegisters) {
            long valuesAtBackJump = 0;
            for (Event def : reachingDefinitions(reg, backJump).defs()) {
                valuesAtBackJump = add(valuesAtBackJump, countDefinition(reg, def));
            }
            states = multiply(states, add(valuesAtBackJump, 1));
        }
        return states;
    }

    private record ReachingDefinitions(Set<Event> defs, boolean fromHeader) {}

    // Definitions of "reg" inside the loop iteration that reach "at" (excluding "at" itself).
    // "fromHeader" is true if some path from the loop header reaches "at" without redefining "reg".
    private ReachingDefinitions reachingDefinitions(Register reg, Event at) {
        final Set<Event> defs = new HashSet<>();
        boolean fromHeader = false;
        final Deque<Event> worklist = new ArrayDeque<>(predecessors(at));
        final Set<Event> visited = new HashSet<>();
        if (at == loopStart) {
            fromHeader = true;
        }
        while (!worklist.isEmpty()) {
            final Event e = worklist.pop();
            if (!visited.add(e)) {
                continue;
            }
            if (e instanceof RegWriter writer && writer.getResultRegister().equals(reg)) {
                defs.add(e);
                continue;
            }
            if (e == loopStart) {
                fromHeader = true;
                continue;
            }
            worklist.addAll(predecessors(e));
        }
        return new ReachingDefinitions(defs, fromHeader);
    }

    private List<Event> predecessors(Event e) {
        final List<Event> preds = new ArrayList<>();
        if (e == loopStart) {
            return preds; // We do not go around the back edge.
        }
        final Event prev = e.getPredecessor();
        if (prev != null && body.contains(prev) && !IRHelper.isAlwaysBranching(prev)) {
            preds.add(prev);
        }
        if (e instanceof Label label) {
            for (CondJump jump : label.getJumpSet()) {
                if (jump != backJump && body.contains(jump)) {
                    preds.add(jump);
                }
            }
        }
        return preds;
    }

    // Definitions that (transitively) depend on themselves, e.g. via an inner loop, can take any value.
    private long countDefinition(Register reg, Event def) {
        if (!(def instanceof Local local) || !definitionsInProgress.add(def)) {
            return typeCardinality(reg.getType());
        }
        final Long cached = definitionCounts.get(def);
        final long values = cached != null ? cached : count(local.getExpr(), local);
        definitionsInProgress.remove(def);
        definitionCounts.put(def, values);
        return values;
    }

    private long countRegister(Register reg, Event at) {
        if (!writtenInLoop.contains(reg)) {
            return 1; // Loop-invariant
        }
        final ReachingDefinitions rd = reachingDefinitions(reg, at);
        if (rd.fromHeader()) {
            return typeCardinality(reg.getType()); // Value flows around the back edge
        }
        long values = 0;
        for (Event def : rd.defs()) {
            values = add(values, countDefinition(reg, def));
        }
        return values;
    }

    private long count(Expression expr, Event at) {
        final long values;
        if (expr instanceof Register reg) {
            values = countRegister(reg, at);
        } else if (expr instanceof IntBinaryExpr bin && bin.getKind() == IntBinaryOp.AND
                && (bin.getLeft() instanceof IntLiteral || bin.getRight() instanceof IntLiteral)) {
            final IntLiteral mask = (IntLiteral) (bin.getLeft() instanceof IntLiteral ? bin.getLeft() : bin.getRight());
            final Expression other = mask == bin.getLeft() ? bin.getRight() : bin.getLeft();
            final BigInteger maskValue = mask.getValue();
            final long maskValues = maskValue.signum() >= 0 && maskValue.bitCount() < 62
                    ? 1L << maskValue.bitCount() : INFINITE;
            values = Math.min(maskValues, count(other, at));
        } else if (expr.getOperands().isEmpty()) {
            values = 1; // Constants
        } else {
            long product = 1;
            for (Expression operand : expr.getOperands()) {
                product = multiply(product, count(operand, at));
            }
            values = product;
        }
        return Math.min(values, typeCardinality(expr.getType()));
    }

    private static long typeCardinality(Type type) {
        if (type instanceof BooleanType) {
            return 2;
        }
        if (type instanceof IntegerType intType && intType.getBitWidth() < 62) {
            return 1L << intType.getBitWidth();
        }
        return INFINITE;
    }

    private static long add(long a, long b) {
        return Math.min(INFINITE, a + b);
    }

    private static long multiply(long a, long b) {
        if (a == 0 || b == 0) {
            return 0;
        }
        return a >= INFINITE / b ? INFINITE : a * b;
    }
}
