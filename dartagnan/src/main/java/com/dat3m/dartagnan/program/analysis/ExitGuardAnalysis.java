package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryOp;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryOp;
import com.dat3m.dartagnan.expression.integers.IntCmpExpr;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Assume;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.ExecutionStatus;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;

import java.util.*;

/*
    Checks whether a global side effect "e" is exit-guarded, i.e., no path that executes "e" can reach the
    back-jump of its loop. The analysis explores all paths from "e" to the loop exit, tracking (symbolic) values
    of registers that are assigned along the path. Branches whose guard becomes constant under the path facts
    (e.g., the CAS success flag after its guarding jump) are followed in one direction only.
 */
public class ExitGuardAnalysis {

    // Bounds the explored states per query; if exceeded, the answer is conservative. Typical CAS loops need 10-20 steps.
    private static final int MAX_STEPS = 100;

    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final Set<Event> body;
    private final Event backJump;

    private ExitGuardAnalysis(LoopAnalysis.LoopInfo loop) {
        final LoopAnalysis.LoopIterationInfo iteration = loop.iterations().getFirst();
        this.body = new HashSet<>(iteration.computeBody());
        this.backJump = iteration.getIterationEnd();
    }

    public static ExitGuardAnalysis forLoop(LoopAnalysis.LoopInfo loop) {
        return new ExitGuardAnalysis(loop);
    }

    private record State(Event event, Map<Register, Expression> facts) {}

    public boolean isExitGuarded(Event sideEffect) {
        // Find the jump (if any) that guards the side effect via fall-through.
        CondJump guard = null;
        Event cur = sideEffect.getPredecessor();
        while (cur != null && body.contains(cur)) {
            if (cur instanceof Label label && !label.getJumpSet().isEmpty()) {
                break; // Merge point
            }
            if (cur instanceof CondJump jump) {
                guard = jump.isGoto() ? null : jump;
                break;
            }
            cur = cur.getPredecessor();
        }

        final Map<Register, Expression> initialFacts = new HashMap<>();
        final Event start;
        if (guard != null) {
            assume(guard.getGuard(), false, initialFacts);
            start = guard.getSuccessor();
        } else {
            start = sideEffect;
        }

        final Deque<State> worklist = new ArrayDeque<>();
        final Set<State> visited = new HashSet<>();
        worklist.push(new State(start, initialFacts));
        int steps = 0;
        while (!worklist.isEmpty()) {
            if (++steps > MAX_STEPS) {
                return false;
            }
            final State state = worklist.pop();
            if (!visited.add(state)) {
                continue;
            }
            final Event e = state.event();
            if (e == null || !body.contains(e)) {
                continue; // Left the loop
            }
            if (e == backJump) {
                return false;
            }
            final Map<Register, Expression> facts = state.facts();

            switch (e) {
                case CondJump jump -> {
                    final Expression cond = evaluate(jump.getGuard(), facts);
                    if (!isFalse(cond)) {
                        worklist.push(branch(jump.getLabel(), jump.getGuard(), true, facts));
                    }
                    if (!isTrue(cond)) {
                        worklist.push(branch(jump.getSuccessor(), jump.getGuard(), false, facts));
                    }
                }
                case Return _ -> { } // Path leaves the function
                case AbortIf abort when isTrue(evaluate(abort.getCondition(), facts)) -> { } // Path aborts
                case Assume assume when isFalse(evaluate(assume.getExpr(), facts)) -> { } // Infeasible path
                default -> worklist.push(new State(e.getSuccessor(), transfer(e, facts, sideEffect)));
            }
        }
        return true;
    }

    // State reached by following a branch whose guard evaluates to "value".
    private State branch(Event target, Expression guard, boolean value, Map<Register, Expression> facts) {
        final Map<Register, Expression> branchFacts = new HashMap<>(facts);
        assume(guard, value, branchFacts);
        return new State(target, branchFacts);
    }

    // Facts after executing "e" (assuming "sideEffect" executes).
    private Map<Register, Expression> transfer(Event e, Map<Register, Expression> facts, Event sideEffect) {
        final Map<Register, Expression> nextFacts = new HashMap<>(facts);
        if (e instanceof RegWriter writer) {
            final Register reg = writer.getResultRegister();
            final Expression value = switch (e) {
                case Local local -> evaluate(local.getExpr(), facts);
                case ExecutionStatus status when status.getStatusEvent() == sideEffect ->
                        expressions.makeGeneralZero(reg.getType());
                default -> null;
            };
            kill(reg, nextFacts);
            if (value != null && !value.getRegs().contains(reg)) {
                nextFacts.put(reg, value);
            }
        }
        return nextFacts;
    }

    private void kill(Register reg, Map<Register, Expression> facts) {
        facts.remove(reg);
        facts.values().removeIf(v -> v.getRegs().contains(reg));
    }

    // Adds facts implied by "expr == value".
    private void assume(Expression expr, boolean value, Map<Register, Expression> facts) {
        switch (expr) {
            case Register reg when reg.getType() instanceof BooleanType -> {
                kill(reg, facts);
                facts.put(reg, expressions.makeValue(value));
            }
            case BoolUnaryExpr not when not.getKind() == BoolUnaryOp.NOT -> assume(not.getOperand(), !value, facts);
            case BoolBinaryExpr bin when (bin.getKind() == BoolBinaryOp.AND && value)
                    || (bin.getKind() == BoolBinaryOp.OR && !value) -> {
                assume(bin.getLeft(), value, facts);
                assume(bin.getRight(), value, facts);
            }
            case IntCmpExpr cmp when (cmp.getKind() == IntCmpOp.EQ && value)
                    || (cmp.getKind() == IntCmpOp.NEQ && !value) -> {
                final boolean regLeft = cmp.getLeft() instanceof Register;
                final Expression reg = regLeft ? cmp.getLeft() : cmp.getRight();
                final Expression other = regLeft ? cmp.getRight() : cmp.getLeft();
                if (reg instanceof Register r && other instanceof IntLiteral) {
                    kill(r, facts);
                    facts.put(r, other);
                }
            }
            default -> { }
        }
    }

    private Expression evaluate(Expression expr, Map<Register, Expression> facts) {
        final Substitution substitution = new Substitution(facts);
        return expr.accept(substitution);
    }

    private static boolean isTrue(Expression expr) {
        return expr instanceof BoolLiteral lit && lit.getValue();
    }

    private static boolean isFalse(Expression expr) {
        return expr instanceof BoolLiteral lit && !lit.getValue();
    }

    private static class Substitution extends ExprSimplifier {
        private final Map<Register, Expression> facts;

        private Substitution(Map<Register, Expression> facts) {
            super(true);
            this.facts = facts;
        }

        @Override
        public Expression visitRegister(Register reg) {
            return facts.getOrDefault(reg, reg);
        }
    }
}
