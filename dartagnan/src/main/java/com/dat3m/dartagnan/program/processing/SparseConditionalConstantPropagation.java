package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.std.Malloc;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.base.Predicate;
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
        final EventSimplifier simplifier = new EventSimplifier();
        final Predicate<ExprInterface> checkDoPropagate = propagateCopyAssignments
                ? (expr -> expr instanceof IConst || expr instanceof BConst || expr instanceof Register)
                : (expr -> expr instanceof IConst || expr instanceof BConst);

        Set<Event> reachableEvents = new HashSet<>();
        Map<Label, Map<Register, ExprInterface>> inflowMap = new HashMap<>();
        // NOTE: An absent key represents the TOP value of our lattice (we start from
        // TOP everywhere)
        // BOT is not represented as it is never produced (we only ever join non-BOT
        // values and hence never produce BOT).
        Map<Register, ExprInterface> propagationMap = new HashMap<>();
        boolean isTraversingDeadBranch = false;

        for (Event cur : thread.getEvents()) {

            if (cur instanceof Label && inflowMap.containsKey(cur)) {
                // Merge inflow and mark the branch as alive (since it has inflow)
                propagationMap = isTraversingDeadBranch ? inflowMap.get(cur) : join(propagationMap, inflowMap.get(cur));
                isTraversingDeadBranch = false;
            }

            if (!isTraversingDeadBranch) {
                simplifier.setPropagationMap(propagationMap);
                // We only simplify non-dead code
                cur.accept(simplifier);
                reachableEvents.add(cur);

                if (cur instanceof Local) {
                    final Local local = (Local) cur;
                    final ExprInterface expr = local.getExpr();
                    final ExprInterface valueToPropagate = checkDoPropagate.apply(expr) ? expr : null;
                    propagationMap.compute(local.getResultRegister(), (k, v) -> valueToPropagate);
                } else if (cur instanceof RegWriter) {
                    // We treat all other register writers as non-constant
                    propagationMap.remove(((RegWriter) cur).getResultRegister());
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
                        final Map<Register, ExprInterface> finalPropagationMap = propagationMap;
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
            } else if (e instanceof Label && e.hasTag(Tag.NOOPT)) {
                // FIXME: This check is just to avoid deleting loop-related labels (especially
                // the loop end marker) because those are used to find unrolled loops.
                // There should be better ways that do not retain such dead code: for example,
                // we could move the loop end marker into the last non-dead iteration.
                continue;
            }
            e.delete();
        }
    }

    private Map<Register, ExprInterface> join(Map<Register, ExprInterface> x, Map<Register, ExprInterface> y) {
        Preconditions.checkNotNull(x);
        Preconditions.checkNotNull(y);

        final Map<Register, ExprInterface> smallerMap = x.size() <= y.size() ? x : y;
        final Map<Register, ExprInterface> largerMap = smallerMap == x ? y : x;
        final Map<Register, ExprInterface> joined = new HashMap<>(smallerMap);
        joined.entrySet().removeIf(entry -> entry.getValue() != largerMap.getOrDefault(entry.getKey(), null));
        return joined;
    }

    /*
     * Simplifies the expressions of events by inserting known constant values.
     */
    private static class EventSimplifier implements EventVisitor<Void> {

        private final ConstantPropagator propagator = new ConstantPropagator();

        public void setPropagationMap(Map<Register, ExprInterface> propagationMap) {
            this.propagator.propagationMap = propagationMap;
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
        public Void visitMemEvent(MemoryEvent e) {
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
    private static class ConstantPropagator extends ExprTransformer {

        private Map<Register, ExprInterface> propagationMap = new HashMap<>();

        @Override
        public ExprInterface visit(Register reg) {
            final ExprInterface retVal = propagationMap.getOrDefault(reg, reg);
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
        public ExprInterface visit(Atom atom) {
            ExprInterface lhs = atom.getLHS().visit(this);
            ExprInterface rhs = atom.getRHS().visit(this);
            if (lhs instanceof BConst) {
                lhs = expressions.makeValue(
                        ((BConst) lhs).isTrue() ? BigInteger.ONE : BigInteger.ZERO,
                        rhs instanceof IExpr ? ((IExpr) rhs).getType() : types.getIntegerType(1));
            }
            if (rhs instanceof BConst) {
                rhs = expressions.makeValue(
                        ((BConst) rhs).isTrue() ? BigInteger.ONE : BigInteger.ZERO,
                        lhs instanceof IExpr ? ((IExpr) lhs).getType() : types.getIntegerType(1));
            }
            if (lhs instanceof IValue left && rhs instanceof IValue right) {
                return expressions.makeValue(atom.getOp().combine(left.getValue(), right.getValue()));
            } else {
                return expressions.makeBinary(lhs, atom.getOp(), rhs);
            }
        }

        @Override
        public BExpr visit(BExprBin bBin) {
            ExprInterface lhs = bBin.getLHS().visit(this);
            ExprInterface rhs = bBin.getRHS().visit(this);
            if (lhs instanceof BConst left && rhs instanceof BConst right) {
                return expressions.makeValue(bBin.getOp().combine(left.getValue(), right.getValue()));
            } else {
                return expressions.makeBinary(lhs, bBin.getOp(), rhs);
            }
        }

        @Override
        public BExpr visit(BExprUn bUn) {
            ExprInterface inner = bUn.getInner().visit(this);
            if (inner instanceof BConst) {
                return expressions.makeValue(bUn.getOp().combine(((BConst) inner).getValue()));
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
            if (inner instanceof IValue && iUn.getOp() == IOpUn.MINUS) {
                return expressions.makeValue(((IValue) inner).getValue().negate(), iUn.getType());
            } else if (inner instanceof IValue && iUn.getOp() == IOpUn.CTLZ) {
                return expressions.makeUnary(iUn.getOp(), inner, iUn.getType()).reduce();
            } else {
                return expressions.makeUnary(iUn.getOp(), inner, iUn.getType());
            }
        }

        @Override
        public ExprInterface visit(IfExpr ifExpr) {
            ExprInterface guard = ifExpr.getGuard().visit(this);
            ExprInterface trueBranch = ifExpr.getTrueBranch().visit(this);
            ExprInterface falseBranch = ifExpr.getFalseBranch().visit(this);
            if (guard instanceof BConst constant && trueBranch instanceof IValue && falseBranch instanceof IValue) {
                // We optimize ITEs only if all subexpressions are constant to avoid messing up
                // data dependencies
                return constant.getValue() ? trueBranch : falseBranch;
            }
            return expressions.makeConditional(guard, trueBranch, falseBranch);
        }

    }

}
