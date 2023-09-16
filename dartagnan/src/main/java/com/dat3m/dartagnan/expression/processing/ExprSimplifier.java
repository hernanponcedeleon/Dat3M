package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.op.IOpBin.RSHIFT;

public class ExprSimplifier extends ExprTransformer {

    @Override
    public Expression visit(Atom atom) {
        Expression lhs = atom.getLHS().visit(this);
        Expression rhs = atom.getRHS().visit(this);
        if (lhs.equals(rhs)) {
            switch(atom.getOp()) {
                case EQ:
                case LTE:
                case ULTE:
                case GTE:
                case UGTE:
                    return expressions.makeTrue();
                case NEQ:
                case LT:
                case ULT:
                case GT:
                case UGT:
                    return expressions.makeFalse();
            }
        }
        if (lhs instanceof IConst lc && rhs instanceof  IConst rc) {
            return expressions.makeValue(atom.getOp().combine(lc.getValue(), rc.getValue()));
        }
        // Due to constant propagation, and the lack of a proper type system
        // we can end up with comparisons like "False == 1"
        if (lhs instanceof BConst lc && rhs instanceof IConst rc) {
            return expressions.makeValue(atom.getOp().combine(lc.getValue(), rc.getValue()));
        }
        if (lhs instanceof IConst lc && rhs instanceof BConst rc) {
            return expressions.makeValue(atom.getOp().combine(lc.getValue(), rc.getValue()));
        }
        if (lhs.getType() instanceof BooleanType && rhs instanceof IConst rc) {
            // Simplify "cond == 1" to just "cond"
            // TODO: If necessary, add versions for "cond == 0" and for "cond != 0/1"
            if (atom.getOp() == COpBin.EQ && rc.getValue().intValue() == 1) {
                return lhs;
            }
        }
        return expressions.makeBinary(lhs, atom.getOp(), rhs);
    }

    @Override
    public Expression visit(BExprBin bBin) {
        Expression l = bBin.getLHS().visit(this);
        Expression r = bBin.getRHS().visit(this);
        Expression left = l instanceof BConst || !(r instanceof BConst) ? l : r;
        Expression right = left == l ? r : l;
        if (left instanceof BConst constant) {
            boolean value = constant.getValue();
            boolean neutralValue = switch (bBin.getOp()) {
                case OR -> false;
                case AND -> true;
            };
            if (value == neutralValue) {
                return right;
            }
            // otherwise value is the absorbing value
            if (right.getRegs().isEmpty()) {
                return left;
            }
        }
        return expressions.makeBinary(left, bBin.getOp(), right);
    }

    @Override
    public Expression visit(BExprUn bUn) {
        Expression inner = bUn.getInner().visit(this);
        assert bUn.getOp() == BOpUn.NOT;
        if (inner instanceof BConst constant) {
            return expressions.makeValue(!constant.getValue());
        }
        if (inner instanceof BExprUn innerUnary && innerUnary.getOp() == BOpUn.NOT) {
            return innerUnary.getInner();
        }

        if (inner instanceof Atom atom) {
            // Move negations into the atoms COp
            return expressions.makeBinary(atom.getLHS(), atom.getOp().inverted(), atom.getRHS());
        }
        return expressions.makeUnary(bUn.getOp(), inner);
    }

    @Override
    public Expression visit(IExprBin iBin) {
        Expression lhs = iBin.getLHS().visit(this);
        Expression rhs = iBin.getRHS().visit(this);
        IOpBin op = iBin.getOp();
        if (lhs.equals(rhs)) {
            switch(op) {
                case AND:
                case OR:
                    return lhs;
                case XOR:
                    return expressions.makeZero(iBin.getType());
            }
        }
        if (! (lhs instanceof IConst || rhs instanceof IConst)) {
            return expressions.makeBinary(lhs, op, rhs);
        } else if (lhs instanceof IConst && rhs instanceof IConst) {
            // If we reduce MemoryObject as a normal IConst, we loose the fact that it is a Memory Object
            // We cannot call reduce for RSHIFT (lack of implementation)
            if(!(lhs instanceof MemoryObject) && op != RSHIFT) {
                return expressions.makeBinary(lhs, op, rhs).reduce();
            }
            // Rule to reduce &mem + 0
            if(lhs instanceof MemoryObject && rhs.equals(expressions.makeZero(types.getArchType()))) {
                return lhs;
            }
        }

        if (lhs instanceof IConst lc) {
            BigInteger val = lc.getValue();
            switch (op) {
                case MULT:
                    if (val.equals(BigInteger.ZERO)) {
                        return lhs;
                    }
                    if (val.equals(BigInteger.ONE)) {
                        return rhs;
                    }
                case PLUS:
                    if (val.equals(BigInteger.ZERO)) {
                        return rhs;
                    }
            }
            return expressions.makeBinary(lhs, op, rhs);
        }

        IConst rc = (IConst)rhs;
        BigInteger val = rc.getValue();
        switch (op) {
            case MULT:
                if (val.equals(BigInteger.ZERO)) {
                    return rhs;
                }
                if (val.equals(BigInteger.ONE)) {
                    return lhs;
                }
                break;
            case PLUS:
            case MINUS:
                if(val.equals(BigInteger.ZERO)) {
                    return lhs;
                }
                // Rule for associativity (rhs is IConst) since we cannot reduce MemoryObjects
                // Either op can be +/-, but this does not affect correctness
                // e.g. (&mem + x) - y -> &mem + reduced(x - y)
                if(lhs instanceof IExprBin lhsBin && lhsBin.getRHS() instanceof IConst && lhsBin.getOp() != RSHIFT) {
                    Expression newLHS = lhsBin.getLHS();
                    Expression newRHS = expressions.makeBinary(lhsBin.getRHS(), lhsBin.getOp(), rhs).reduce();
                    return expressions.makeBinary(newLHS, op, newRHS);
                }

        }
        return expressions.makeBinary(lhs, op, rhs);
    }

    @Override
    public Expression visit(IExprUn iUn) {
        // TODO: Add simplifications
        return super.visit(iUn);
    }

    @Override
    public Expression visit(IfExpr ifExpr) {
        Expression cond = ifExpr.getGuard().visit(this);
        Expression t = ifExpr.getTrueBranch().visit(this);
        Expression f = ifExpr.getFalseBranch().visit(this);

        if (cond instanceof BConst constantGuard) {
            return constantGuard.getValue() ? t : f;
        } else if (t.equals(f)) {
            return t;
        }

        // Simplifies "ITE(cond, 1, 0)" to "cond" and "ITE(cond, 0, 1) to "!cond"
        // TODO: It is not clear if this gives performance improvements or not
        if (t instanceof IConst tConstant && tConstant.getType().isMathematical() && tConstant.getValueAsInt() == 1
                && f instanceof IConst fConstant && fConstant.getType().isMathematical() && fConstant.getValueAsInt() == 0) {
            return cond;
        } else if (t instanceof IConst tConstant && tConstant.getType().isMathematical() && tConstant.getValueAsInt() == 0
                && f instanceof IConst fConstant && fConstant.getType().isMathematical() && fConstant.getValueAsInt() == 1) {
            return expressions.makeNot(cond);
        }

        return expressions.makeConditional(cond, t, f);
    }


}
