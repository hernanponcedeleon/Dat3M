package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.base.Predicate;
import com.google.common.collect.Sets;
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

@Options
public class SparseConditionalConstantPropagation implements ProgramProcessor {

    @Option(name = PROPAGATE_COPY_ASSIGNMENTS,
            description = "Propagates copy assignments of the form 'reg2 := reg1' to eliminate " +
                    "intermediate register 'reg2'. Can only be active if " + CONSTANT_PROPAGATION + " is enabled.",
            secure = true)
    private boolean propagateCopyAssignments = false;

    // ====================================================================================

    private SparseConditionalConstantPropagation() { }

    public static SparseConditionalConstantPropagation newInstance() {
        return new SparseConditionalConstantPropagation();
    }

    public static SparseConditionalConstantPropagation fromConfig(Configuration config) throws InvalidConfigurationException {
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
        final Predicate<ExprInterface> checkDoPropagate = propagateCopyAssignments ?
                (expr -> expr instanceof IConst || expr instanceof BConst || expr instanceof Register)
                : (expr -> expr instanceof IConst || expr instanceof BConst);

        Set<Event> reachableEvents = new HashSet<>();
        Map<Label, Map<Register, ExprInterface>> inflowMap = new HashMap<>();
        Map<Register, ExprInterface> propagationMap = new HashMap<>();
        boolean isDeadBranch = false;

        for (Event cur : thread.getEvents()) {

            if (cur instanceof Label) {
                if (inflowMap.containsKey(cur)) {
                    propagationMap = join(propagationMap, inflowMap.getOrDefault(cur, Map.of()));
                    isDeadBranch = false;
                }
            }

            if (!isDeadBranch) {
                simplifier.setPropagationMap(propagationMap);
                cur.accept(simplifier);
                reachableEvents.add(cur);

                if (cur instanceof Local) {
                    final Local local = (Local) cur;
                    final ExprInterface expr = local.getExpr();
                    final ExprInterface valueToPropagate = checkDoPropagate.apply(expr) ? expr : TOP;
                    propagationMap.put(local.getResultRegister(), valueToPropagate);
                } else if (cur instanceof RegWriter) {
                    // We treat all other register writers as non-constant
                    //propagationMap.remove(((RegWriter) cur).getResultRegister());
                    propagationMap.put(((RegWriter) cur).getResultRegister(), TOP);
                }


                if (cur instanceof CondJump) {
                    final CondJump jump = (CondJump) cur;
                    final Label target = jump.getLabel();

                    if (jump.isGoto()) {
                        isDeadBranch = true;
                        propagationMap.clear();
                    }
                    if (!jump.isDead()) {
                        // Join current map with label-associated map
                        final Map<Register, ExprInterface> finalPropagationMap = propagationMap;
                        inflowMap.compute(target, (k, v) -> join(v != null ? v : Map.of(), finalPropagationMap));
                    }
                }
            }

        }

        Set<Event> diff = new HashSet<>(Sets.difference(new HashSet<>(thread.getEvents()), reachableEvents));
        if (!diff.isEmpty()) {
            System.out.printf("Reachable %d;  Total %d\n", reachableEvents.size(), thread.getEvents().size());
            System.out.println(diff);
        }
    }

    private Map<Register, ExprInterface> join(Map<Register, ExprInterface> x, Map<Register, ExprInterface> y) {
        Preconditions.checkNotNull(x);
        Preconditions.checkNotNull(y);

        Map<Register, ExprInterface> joined = new HashMap<>(x);
        for(Map.Entry<Register, ExprInterface> entry : y.entrySet()) {
            joined.merge(entry.getKey(), entry.getValue(), (v1, v2) -> v1.equals(v2) ? v1 : TOP);
        }
        return joined;
    }

    // ============================ Utility classes ============================

    private static final ExprInterface TOP = new IConst() {
        @Override
        public BigInteger getValue() { throw new UnsupportedOperationException(); }

        @Override
        public <T> T visit(ExpressionVisitor<T> visitor) { throw new UnsupportedOperationException(); }
    };

    /*
        Simplifies the expressions of events by inserting known constant values.
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
            e.setGuard((BExpr) e.getGuard().visit(propagator));
            return null;
        }

        @Override
        public Void visitLocal(Local e) {
            e.setExpr(e.getExpr().visit(propagator));
            return null;
        }

        @Override
        public Void visitMemEvent(MemEvent e) {
            e.setAddress((IExpr)e.getAddress().visit(propagator));
            return null;
        }

        @Override
        public Void visitStore(Store e) {
            e.setMemValue(e.getMemValue().visit(propagator));
            return visitMemEvent(e);
        }
    }


    /*
        A simple expression transformer that
            - replaces regs by constant values (if known)
            - simplifies constant (sub)expressions to a single constant
        It does NOT
            - use associativity to find more constant subexpressions
            - simplify trivial expressions like "x == x" or "0*x" to avoid eliminating any dependencies
     */
    private static class ConstantPropagator extends ExprTransformer {

        private Map<Register, ExprInterface> propagationMap = new HashMap<>();

        @Override
        public ExprInterface visit(Register reg) {
            ExprInterface retVal = propagationMap.compute(reg, (k, v) -> v == null || v == TOP ? reg : v );
            if (retVal instanceof BConst) {
                // We only have integral registers, so we need to implicitly convert booleans to integers.
                return retVal.equals(BConst.TRUE) ? IValue.ONE : IValue.ZERO;
            } else {
                return retVal;
            }
        }

        @Override
        public ExprInterface visit(Atom atom) {
            ExprInterface lhs = atom.getLHS().visit(this);
            ExprInterface rhs = atom.getRHS().visit(this);
            if (lhs instanceof BConst) {
                lhs = lhs.equals(BConst.TRUE) ? IValue.ONE : IValue.ZERO;
            }
            if (rhs instanceof BConst) {
                rhs = rhs.equals(BConst.TRUE) ? IValue.ONE : IValue.ZERO;
            }
            if (lhs instanceof IValue && rhs instanceof IValue) {
                IValue left = (IValue) lhs;
                IValue right = (IValue) rhs;
                return atom.getOp().combine(left.getValue(), right.getValue()) ? BConst.TRUE : BConst.FALSE;
            } else {
                return new Atom(lhs, atom.getOp(), rhs);
            }
        }

        @Override
        public BExpr visit(BExprBin bBin) {
            ExprInterface lhs = bBin.getLHS().visit(this);
            ExprInterface rhs = bBin.getRHS().visit(this);
            if (lhs instanceof BConst && rhs instanceof BConst) {
                BConst left = (BConst) lhs;
                BConst right = (BConst) rhs;
                return bBin.getOp().combine(left.getValue(), right.getValue()) ? BConst.TRUE : BConst.FALSE;
            } else {
                return new BExprBin(lhs, bBin.getOp(), rhs);
            }
        }

        @Override
        public BExpr visit(BExprUn bUn) {
            ExprInterface inner = bUn.getInner().visit(this);
            if (inner instanceof BConst) {
                return bUn.getOp().combine(((BConst) inner).getValue()) ? BConst.TRUE : BConst.FALSE;
            } else {
                return new BExprUn(bUn.getOp(), inner);
            }
        }

        @Override
        public IExpr visit(IExprBin iBin) {
            IExpr lhs = (IExpr) iBin.getLHS().visit(this);
            IExpr rhs = (IExpr) iBin.getRHS().visit(this);
            if (lhs instanceof IValue && rhs instanceof IValue) {
                IValue left = (IValue) lhs;
                IValue right = (IValue) rhs;
                return new IValue(iBin.getOp().combine(left.getValue(), right.getValue()), left.getPrecision());
            } else {
                return new IExprBin(lhs, iBin.getOp(), rhs);
            }
        }

        @Override
        public IExpr visit(IExprUn iUn) {
            IExpr inner = (IExpr) iUn.getInner().visit(this);
            if (inner instanceof IValue && iUn.getOp() == IOpUn.MINUS) {
                // We only optimize negation but no casting operations.
                return new IValue(((IValue) inner).getValue().negate(), inner.getPrecision());
            } else {
                return new IExprUn(iUn.getOp(), inner);
            }
        }

        @Override
        public ExprInterface visit(IfExpr ifExpr) {
            BExpr guard = (BExpr) ifExpr.getGuard().visit(this);
            IExpr trueBranch = (IExpr) ifExpr.getTrueBranch().visit(this);
            IExpr falseBranch = (IExpr) ifExpr.getFalseBranch().visit(this);
            if (guard instanceof BConst && trueBranch instanceof IValue && falseBranch instanceof IValue) {
                // We optimize ITEs only if all subexpressions are constant to avoid messing up data dependencies
                return guard.equals(BConst.TRUE) ? trueBranch : falseBranch;
            }
            return new IfExpr(guard, trueBranch, falseBranch);
        }

    }

}
