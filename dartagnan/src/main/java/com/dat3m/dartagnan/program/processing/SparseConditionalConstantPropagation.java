package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.std.Malloc;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.ExpressionTransformer;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionNames.CONSTANT_PROPAGATION;
import static com.dat3m.dartagnan.configuration.OptionNames.PROPAGATE_COPY_ASSIGNMENTS;

/*
    Sparse conditional constant propagation performs both CP and DCE simultaneously.
    It is more precise than any sequence of simple CP/DCE passes.
 */
@Options
public class SparseConditionalConstantPropagation implements ProgramProcessor {

    @Option(name = PROPAGATE_COPY_ASSIGNMENTS,
            description = "Propagates copy assignments of the form 'reg2 := reg1' to eliminate " +
                    "intermediate register 'reg2'. Can only be active if " + CONSTANT_PROPAGATION + " is enabled.",
            secure = true)
    private boolean propagateCopyAssignments = true;

    // ====================================================================================

    private SparseConditionalConstantPropagation() {
    }

    public static SparseConditionalConstantPropagation newInstance() {
        return new SparseConditionalConstantPropagation();
    }

    public static SparseConditionalConstantPropagation fromConfig(Configuration config)
            throws InvalidConfigurationException {
        SparseConditionalConstantPropagation instance = newInstance();
        config.inject(instance);
        return instance;
    }

    // ====================================================================================

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isUnrolled(), "Constant propagation only works on unrolled programs.");
        ExpressionFactory expressionFactory = ExpressionFactory.getInstance();
        for (Thread thread : program.getThreads()) {
            run(thread, expressionFactory);
        }
    }

    private void run(Thread thread, ExpressionFactory expressionFactory) {
        final EventSimplifier simplifier = new EventSimplifier(expressionFactory);

        Set<Event> reachableEvents = new HashSet<>();
        Map<Label, Map<Register, Expression>> inflowMap = new HashMap<>();
        // NOTE: An absent key represents the TOP value of our lattice (we start from
        // TOP everywhere)
        // BOT is not represented as it is never produced (we only ever join non-BOT
        // values and hence never produce BOT).
        Map<Register, Expression> propagationMap = new HashMap<>();
        boolean isTraversingDeadBranch = false;

        for (Event cur : thread.getEvents()) {

            if (cur instanceof Label && inflowMap.containsKey(cur)) {
                // Merge inflow and mark the branch as alive (since it has inflow)
                propagationMap = isTraversingDeadBranch ? inflowMap.get(cur) : join(propagationMap, inflowMap.get(cur));
                isTraversingDeadBranch = false;
            }

            if (!isTraversingDeadBranch) {
                simplifier.propagator.propagationMap = propagationMap;
                // We only simplify non-dead code
                cur.accept(simplifier);
                reachableEvents.add(cur);

                if (cur instanceof RegWriter) {
                    Register register = ((RegWriter) cur).getResultRegister();
                    // Loads may generate replacements for register expressions.
                    // We treat all other register writers as non-constant.
                    Expression expr = cur instanceof Local ? ((Local) cur).getExpr() : null;
                    boolean doPropagate = expr != null && expr.getRegs().isEmpty() ||
                            propagateCopyAssignments && expr instanceof Register;
                    propagationMap.compute(register, (k, v) -> doPropagate ? expr : null);
                    if (propagateCopyAssignments) {
                        propagationMap.values().remove(register);
                    }
                }

                if (cur instanceof CondJump) {
                    final CondJump jump = (CondJump) cur;
                    final Label target = jump.getLabel();
                    if (jump.isGoto()) {
                        // The successor event is going to be dead (unless it is a label with other
                        // inflow).
                        isTraversingDeadBranch = true;
                        propagationMap.clear();
                    }
                    if (!jump.isDead()) {
                        // Join current map with label-associated map
                        final Map<Register, Expression> finalPropagationMap = propagationMap;
                        inflowMap.compute(target, (k, v) -> v == null ? new HashMap<>(finalPropagationMap)
                                : join(v, finalPropagationMap));
                    }
                }
            }

        }

        // ---------- Remove dead code ----------
        for (Event e : thread.getEvents()) {
            if (reachableEvents.contains(e)) {
                continue;
            } else if (e instanceof Label && e.is(Tag.NOOPT)) {
                // FIXME: This check is just to avoid deleting loop-related labels (especially
                // the loop end marker) because those are used to find unrolled loops.
                // There should be better ways that do not retain such dead code: for example,
                // we could move the loop end marker into the last non-dead iteration.
                continue;
            }
            e.delete();
        }
    }

    private Map<Register, Expression> join(Map<Register, Expression> x, Map<Register, Expression> y) {
        Preconditions.checkNotNull(x);
        Preconditions.checkNotNull(y);

        final Map<Register, Expression> smallerMap = x.size() <= y.size() ? x : y;
        final Map<Register, Expression> largerMap = smallerMap == x ? y : x;
        final Map<Register, Expression> joined = new HashMap<>(smallerMap);
        joined.entrySet().removeIf(entry -> entry.getValue() != largerMap.getOrDefault(entry.getKey(), null));
        return joined;
    }

    /*
     * Simplifies the expressions of events by inserting known constant values.
     */
    private static class EventSimplifier implements EventVisitor<Void> {

        private final ConstantPropagator propagator;

        private EventSimplifier(ExpressionFactory factory) {
            this.propagator = new ConstantPropagator(factory);
        }

        @Override
        public Void visitEvent(Event e) {
            return null;
        }

        @Override
        public Void visitCondJump(CondJump e) {
            e.setGuard(e.getGuard().visit(propagator));
            return null;
        }

        @Override
        public Void visitLocal(Local e) {
            e.setExpr(e.getExpr().visit(propagator));
            return null;
        }

        @Override
        public Void visitMemEvent(MemEvent e) {
            e.setAddress(e.getAddress().visit(propagator));
            return null;
        }

        @Override
        public Void visitStore(Store e) {
            e.setMemValue(e.getMemValue().visit(propagator));
            return visitMemEvent(e);
        }

        @Override
        public Void visitMalloc(Malloc e) {
            e.setSizeExpr(e.getSizeExpr().visit(propagator));
            return null;
        }
    }

    /*
     * A simple expression transformer that
     * - replaces regs by constant values (if known)
     * - simplifies constant (sub)expressions to a single constant
     * It does NOT
     * - use associativity to find more constant subexpressions
     * - simplify trivial expressions like "x == x" or "0*x" to avoid eliminating
     * any dependencies
     */
    private static class ConstantPropagator extends ExpressionTransformer {

        private Map<Register, Expression> propagationMap = new HashMap<>();

        private ConstantPropagator(ExpressionFactory factory) {
            super(factory);
        }

        @Override
        public Expression visit(Register reg) {
            return propagationMap.getOrDefault(reg, reg);
        }
    }

}
