package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.google.common.base.Preconditions;
import com.google.common.base.Predicate;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
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
    public void run(Program program) {
        Preconditions.checkArgument(program.isUnrolled(), "Constant propagation only works on unrolled programs.");
        program.getThreads().forEach(this::run);
    }

    private void run(Thread thread) {
        final Predicate<Expression> checkDoPropagate = propagateCopyAssignments
                ? (expr -> expr instanceof IConst || expr instanceof BConst || expr instanceof Register)
                : (expr -> expr instanceof IConst || expr instanceof BConst);

        Set<Event> reachableEvents = new HashSet<>();
        Map<Label, Map<Register, Expression>> inflowMap = new HashMap<>();
        // NOTE: An absent key represents the TOP value of our lattice (we start from
        // TOP everywhere)
        // BOT is not represented as it is never produced (we only ever join non-BOT
        // values and hence never produce BOT).
        Map<Register, Expression> propagationMap = new HashMap<>();
        boolean isTraversingDeadBranch = false;

        final ConstantPropagator propagator = new ConstantPropagator();
        for (Event cur : thread.getEvents()) {
            if (cur instanceof Label && inflowMap.containsKey(cur)) {
                // Merge inflow and mark the branch as alive (since it has inflow)
                propagationMap = isTraversingDeadBranch ? inflowMap.get(cur) : join(propagationMap, inflowMap.get(cur));
                isTraversingDeadBranch = false;
            }

            if (!isTraversingDeadBranch) {
                propagator.propagationMap = propagationMap;
                cur.transformExpressions(propagator);
                reachableEvents.add(cur);

                if (cur instanceof Local local) {
                    final Expression expr = local.getExpr();
                    final Expression valueToPropagate = checkDoPropagate.apply(expr) ? expr : null;
                    propagationMap.compute(local.getResultRegister(), (k, v) -> valueToPropagate);
                } else if (cur instanceof RegWriter rw) {
                    // We treat all other register writers as non-constant
                    propagationMap.remove(rw.getResultRegister());
                }

                if (cur instanceof CondJump jump) {
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
                    } else {
                        // We consider dead jumps as not-reachable, so they get deleted.
                        reachableEvents.remove(jump);
                    }
                }
            }

        }

        // ---------- Remove dead code ----------
        for (Event e : thread.getEvents()) {
            if (reachableEvents.contains(e)) {
                continue;
            } else if (e instanceof Label && e.hasTag(Tag.NOOPT)) {
                // FIXME: This check is just to avoid deleting loop-related labels (especially
                // the loop end marker) because those are used to find unrolled loops.
                // There should be better ways that do not retain such dead code: for example,
                // we could move the loop end marker into the last non-dead iteration.
                continue;
            }
            if (!e.tryDelete()) {
                logger.warn("Failed to delete unreachable event: {}:   {}", e.getGlobalId(), e);
            }
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
     * It does NOT
     * - use associativity to find more constant subexpressions
     * - simplify trivial expressions like "x == x" or "0*x" to avoid eliminating
     * any dependencies
     */
    private static class ConstantPropagator extends ExprTransformer {

        private Map<Register, Expression> propagationMap;

        @Override
        public Expression visit(Register reg) {
            final Expression retVal = propagationMap.getOrDefault(reg, reg);
            if (retVal instanceof BConst) {
                // We only have integral registers, so we need to implicitly convert booleans to
                // integers.
                BigInteger value = retVal.equals(BConst.TRUE) ? BigInteger.ONE : BigInteger.ZERO;
                return expressions.makeValue(value, reg.getType());
            } else {
                return retVal;
            }
        }

        @Override
        public Expression visit(Atom atom) {
            Expression lhs = atom.getLHS().visit(this);
            Expression rhs = atom.getRHS().visit(this);
            if (lhs instanceof BConst constant) {
                IntegerType type = rhs instanceof IExpr ? ((IExpr) rhs).getType() : types.getIntegerType(1);
                lhs = constant.isTrue() ? expressions.makeOne(type) : expressions.makeZero(type);
            }
            if (rhs instanceof BConst constant) {
                IntegerType type = lhs instanceof IExpr ? ((IExpr) lhs).getType() : types.getIntegerType(1);
                rhs = constant.isTrue() ? expressions.makeOne(type) : expressions.makeZero(type);
            }
            if (lhs instanceof IValue left && rhs instanceof IValue right) {
                return expressions.makeValue(atom.getOp().combine(left.getValue(), right.getValue()));
            } else {
                return expressions.makeBinary(lhs, atom.getOp(), rhs);
            }
        }

        @Override
        public BExpr visit(BExprBin bBin) {
            Expression lhs = bBin.getLHS().visit(this);
            Expression rhs = bBin.getRHS().visit(this);
            if (lhs instanceof BConst left && rhs instanceof BConst right) {
                return expressions.makeValue(bBin.getOp().combine(left.getValue(), right.getValue()));
            } else {
                return expressions.makeBinary(lhs, bBin.getOp(), rhs);
            }
        }

        @Override
        public BExpr visit(BExprUn bUn) {
            Expression inner = bUn.getInner().visit(this);
            if (inner instanceof BConst bc) {
                return expressions.makeValue(bUn.getOp().combine(bc.getValue()));
            } else {
                return expressions.makeUnary(bUn.getOp(), inner);
            }
        }

        @Override
        public IExpr visit(IExprBin iBin) {
            IExpr lhs = (IExpr) iBin.getLHS().visit(this);
            IExpr rhs = (IExpr) iBin.getRHS().visit(this);
            if (lhs instanceof IValue left && rhs instanceof IValue right) {
                return expressions.makeValue(iBin.getOp().combine(left.getValue(), right.getValue()), left.getType());
            } else {
                return expressions.makeBinary(lhs, iBin.getOp(), rhs);
            }
        }

        @Override
        public IExpr visit(IExprUn iUn) {
            IExpr inner = (IExpr) iUn.getInner().visit(this);
            if (inner instanceof IValue) {
                return expressions.makeUnary(iUn.getOp(), inner, iUn.getType()).reduce();
            }
            return expressions.makeUnary(iUn.getOp(), inner, iUn.getType());
        }

        @Override
        public Expression visit(IfExpr ifExpr) {
            Expression guard = ifExpr.getGuard().visit(this);
            Expression trueBranch = ifExpr.getTrueBranch().visit(this);
            Expression falseBranch = ifExpr.getFalseBranch().visit(this);
            if (guard instanceof BConst constant && trueBranch instanceof IValue && falseBranch instanceof IValue) {
                // We optimize ITEs only if all subexpressions are constant to avoid messing up
                // data dependencies
                return constant.getValue() ? trueBranch : falseBranch;
            }
            return expressions.makeConditional(guard, trueBranch, falseBranch);
        }

    }

}
