package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.function.Predicate;

import static com.dat3m.dartagnan.configuration.OptionNames.CONSTANT_PROPAGATION;
import static com.dat3m.dartagnan.configuration.OptionNames.PROPAGATE_COPY_ASSIGNMENTS;
import static com.dat3m.dartagnan.expression.op.IOpUn.CAST_SIGNED;
import static com.dat3m.dartagnan.expression.op.IOpUn.CAST_UNSIGNED;

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
        for (Event cur : func.getEvents()) {
            if (cur instanceof Label && inflowMap.containsKey(cur)) {
                // Merge inflow and mark the branch as alive (since it has inflow)
                propagationMap = isTraversingDeadBranch ? inflowMap.get(cur) : join(propagationMap, inflowMap.get(cur));
                isTraversingDeadBranch = false;
            }

            if (!isTraversingDeadBranch) {
                propagator.propagationMap = propagationMap;
                if (cur instanceof RegReader regReader) {
                    regReader.transformExpressions(propagator);
                }
                reachableEvents.add(cur);

                if (cur instanceof Local local) {
                    final Expression expr = local.getExpr();
                    final Expression valueToPropagate = checkDoPropagate.test(expr) ? expr : null;
                    propagationMap.compute(local.getResultRegister(), (k, v) -> valueToPropagate);
                } else if (cur instanceof RegWriter rw) {
                    // We treat all other register writers as non-constant
                    propagationMap.remove(rw.getResultRegister());
                }

                if (cur instanceof AbortIf abort && abort.getCondition() instanceof BConst bConst && bConst.getValue()) {
                    isTraversingDeadBranch = true;
                    propagationMap.clear();
                    continue;
                }

                if (cur instanceof CondJump jump) {
                    final Label target = jump.getLabel();
                    if (jump.isGoto()) {
                        // The successor event is going to be dead (unless it is a label with other inflow).
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
        for (Event e : func.getEvents()) {
            if (reachableEvents.contains(e)) {
                continue;
            } else if (e instanceof Label && e.hasTag(Tag.NOOPT)) {
                //FIXME: This check is just to avoid deleting loop-related labels (especially
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
     * - simplify trivial expressions like "x == x" or "0*x" to avoid eliminating any dependencies
     */
    private static class ConstantPropagator extends ExprTransformer {

        private Map<Register, Expression> propagationMap;

        @Override
        public Expression visit(Register reg) {
            return propagationMap.getOrDefault(reg, reg);
        }

        @Override
        public Expression visit(Atom atom) {
            Expression lhs = transform(atom.getLHS());
            Expression rhs = transform(atom.getRHS());
            if (lhs instanceof IValue left && rhs instanceof IValue right) {
                return expressions.makeValue(atom.getOp().combine(left.getValue(), right.getValue()));
            } else {
                return expressions.makeBinary(lhs, atom.getOp(), rhs);
            }
        }

        @Override
        public Expression visit(BExprBin bBin) {
            Expression lhs = transform(bBin.getLHS());
            Expression rhs = transform(bBin.getRHS());
            if (lhs instanceof BConst left && rhs instanceof BConst right) {
                return expressions.makeValue(bBin.getOp().combine(left.getValue(), right.getValue()));
            } else {
                return expressions.makeBinary(lhs, bBin.getOp(), rhs);
            }
        }

        @Override
        public Expression visit(BExprUn bUn) {
            Expression inner = transform(bUn.getInner());
            if (inner instanceof BConst bc) {
                return expressions.makeValue(bUn.getOp().combine(bc.getValue()));
            } else {
                return expressions.makeUnary(bUn.getOp(), inner);
            }
        }

        @Override
        public Expression visit(IExprBin iBin) {
            Expression lhs = transform(iBin.getLHS());
            Expression rhs = transform(iBin.getRHS());
            if (lhs instanceof IValue left && rhs instanceof IValue right) {
                return expressions.makeValue(iBin.getOp().combine(left.getValue(), right.getValue()), left.getType());
            } else {
                return expressions.makeBinary(lhs, iBin.getOp(), rhs);
            }
        }

        @Override
        public Expression visit(IExprUn iUn) {
            Expression inner = transform(iUn.getInner());
            Expression result;
            if ((iUn.getOp() == CAST_SIGNED || iUn.getOp() == CAST_UNSIGNED) && iUn.getType() == inner.getType()) {
                result = inner;
            } else {
                result = expressions.makeUnary(iUn.getOp(), inner, iUn.getType());
            }
            if (inner instanceof IValue) {
                return result.reduce();
            }
            return result;
        }

        @Override
        public Expression visit(IfExpr ifExpr) {
            Expression guard = transform(ifExpr.getGuard());
            Expression trueBranch = transform(ifExpr.getTrueBranch());
            Expression falseBranch = transform(ifExpr.getFalseBranch());
            // We optimize ITEs only if all subexpressions are constant to avoid messing up data dependencies
            if (guard instanceof BConst constant && constant.getValue() && falseBranch.getRegs().isEmpty()) {
                return trueBranch;
            }
            if (guard instanceof BConst constant && !constant.getValue() && trueBranch.getRegs().isEmpty()) {
                return falseBranch;
            }
            return expressions.makeConditional(guard, trueBranch, falseBranch);
        }

        private Expression transform(Expression expression) {
            Expression result = expression.visit(this);
            Verify.verify(result.getType().equals(expression.getType()), "Type mismatch in constant propagation.");
            return result;
        }
    }

}
