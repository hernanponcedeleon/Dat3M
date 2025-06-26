package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;
import java.util.function.Predicate;

import static com.dat3m.dartagnan.configuration.OptionNames.CONSTANT_PROPAGATION;
import static com.dat3m.dartagnan.configuration.OptionNames.PROPAGATE_COPY_ASSIGNMENTS;

/*
    Sparse conditional constant propagation performs both CP and DCE simultaneously.
    It is more precise than any sequence of simple CP/DCE passes.
 */
@Options
public class SparseConditionalConstantPropagation implements FunctionProcessor {

    private static final Logger logger = LogManager.getLogger(SparseConditionalConstantPropagation.class);

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
    public void run(Function func) {
        if (!func.hasBody()) {
            return;
        }
        final Predicate<Expression> checkDoPropagate = propagateCopyAssignments
                ? (expr -> expr instanceof MemoryObject || expr instanceof IntLiteral || expr instanceof BoolLiteral || expr instanceof Register)
                : (expr -> expr instanceof MemoryObject || expr instanceof IntLiteral || expr instanceof BoolLiteral);

        Set<Event> reachableEvents = new HashSet<>();
        Map<Label, Map<Register, Expression>> inflowMap = new HashMap<>();
        // NOTE: An absent key represents the TOP value of our lattice (we start from
        // TOP everywhere)
        // BOT is not represented as it is never produced (we only ever join non-BOT
        // values and hence never produce BOT).
        Map<Register, Expression> propagationMap = new HashMap<>();
        boolean isTraversingDeadBranch = false;

        final List<LoopAnalysis.LoopIterationInfo> loops = LoopAnalysis.onFunction(func).getLoopsOfFunction(func)
                .stream().filter(info -> !info.isUnrolled())
                .map(info -> info.iterations().get(0)).toList();

        final ConstantPropagator propagator = new ConstantPropagator();
        for (Event cur : func.getEvents()) {

            if (cur instanceof Label && inflowMap.containsKey(cur)) {
                // Merge inflow and mark the branch as alive (since it has inflow)
                propagationMap = isTraversingDeadBranch ? inflowMap.get(cur) : join(propagationMap, inflowMap.get(cur));
                isTraversingDeadBranch = false;
            }

            if (isTraversingDeadBranch) {
                // We are in dead code, so avoid propagation
                continue;
            }

            if (cur instanceof Label) {
                // If we enter a loop, we remove all registers in the propagationMap that
                // are touched by the loop body.
                final LoopAnalysis.LoopIterationInfo loop = loops.stream()
                        .filter(l -> l.getIterationStart() == cur).findFirst().orElse(null);
                if (loop != null) {
                    for (Event e : loop.computeBody()) {
                        if (e instanceof RegWriter writer) {
                            propagationMap.remove(writer.getResultRegister());
                        }
                    }
                }
            }

            // Update event with propagation data
            propagator.propagationMap = propagationMap;
            if (cur instanceof RegReader regReader && !cur.hasTag(Tag.NOOPT)) {
                regReader.transformExpressions(propagator);
            }
            reachableEvents.add(cur);

            // Invalidate outdated propagation data
            if (cur instanceof RegWriter rw) {
                propagationMap.remove(rw.getResultRegister());
                if (propagateCopyAssignments) {
                    propagationMap.values().removeIf(expr -> expr.getRegs().contains(rw.getResultRegister()));
                }
            }

            // Add new propagation data
            if (cur instanceof Local local) {
                final Expression expr = local.getExpr();
                final Expression valueToPropagate = checkDoPropagate.test(expr) ? expr : null;
                propagationMap.compute(local.getResultRegister(), (k, v) -> valueToPropagate);
            } else if (cur instanceof ThreadArgument arg) {
                // Propagate constant arguments passed across threads
                final Expression expr = arg.getCreator().getArguments().get(arg.getIndex());
                final Expression valueToPropagate = expr.getRegs().isEmpty() ? expr : null;
                propagationMap.compute(arg.getResultRegister(), (k, v) -> valueToPropagate);
            }

            if (cur instanceof CondJump jump) {
                if (jump.isDead()) {
                    // We consider dead jumps as not-reachable, so they get deleted.
                    reachableEvents.remove(jump);
                } else {
                    // Join current map with label-associated map
                    final Label target = jump.getLabel();
                    final Map<Register, Expression> finalPropagationMap = propagationMap;
                    inflowMap.compute(target, (k, v) -> v == null ? new HashMap<>(finalPropagationMap)
                            : join(v, finalPropagationMap));
                }
            }

            if (IRHelper.isAlwaysBranching(cur)) {
                // The current instruction is branching, so there is no direct flow to the next event
                isTraversingDeadBranch = true;
                propagationMap.clear();
            }

        }

        // ---------- Remove dead code ----------
        final Set<Event> toBeDeleted = new HashSet<>();
        for (Event e : func.getEvents()) {
            if (reachableEvents.contains(e) || (e instanceof Label && e.hasTag(Tag.NOOPT))) {
                //FIXME: The second check is just to avoid deleting loop-related labels (especially
                // the loop end marker) because those are used to find unrolled loops.
                // There should be better ways that do not retain such dead code: for example,
                // we could move the loop end marker into the last non-dead iteration.
                continue;
            }
            toBeDeleted.add(e);
        }
        final Set<Event> failedToDelete = IRHelper.bulkDelete(toBeDeleted);
        for (Event e : failedToDelete) {
            logger.warn("Failed to delete unreachable event: {}:   {}", e.getLocalId(), e);
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
     * A simple expression transformer that
     * - replaces regs by constant values (if known)
     * - simplifies constant (sub)expressions to a single constant
     * It does NOT eliminate any register expressions (e.g. "r == r" or "0*r") to keep register dependencies.
     */
    private static class ConstantPropagator extends ExprSimplifier {

        private Map<Register, Expression> propagationMap;

        ConstantPropagator() {
            super(false);
        }

        @Override
        public Expression visitRegister(Register reg) {
            return propagationMap.getOrDefault(reg, reg);
        }
    }

}
