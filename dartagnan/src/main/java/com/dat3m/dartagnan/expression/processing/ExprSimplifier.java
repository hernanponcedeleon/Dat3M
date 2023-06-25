package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.op.IOpBin.R_SHIFT;

//TODO: This is buggy for now, because Addresses are treated as IConst
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
                    return BConst.TRUE;
                case NEQ:
                case LT:
                case ULT:
                case GT:
                case UGT:
                    return BConst.FALSE;
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
        if (lhs instanceof BExpr && rhs instanceof IConst rc) {
            // Simplify "cond == 1" to just "cond"
            // TODO: If necessary, add versions for "cond == 0" and for "cond != 0/1"
            if (atom.getOp() == COpBin.EQ && rc.getValue().intValue() == 1) {
                return lhs;
            }
        }
        return expressions.makeBinary(lhs, atom.getOp(), rhs);
    }

    @Override
    public BExpr visit(BConst bConst) {
        return bConst;
    }

    @Override
    public BExpr visit(BExprBin bBin) {
        // Due to constant propagation we are not guaranteed to get BExprs
        if(!(bBin.getLHS().visit(this) instanceof BExpr lhs && bBin.getRHS().visit(this) instanceof BExpr rhs)) {
            return bBin;
        }
        switch (bBin.getOp()) {
            case OR:
                if (lhs.isTrue() || rhs.isTrue()) {
                    return BConst.TRUE;
                } else if (lhs.isFalse()) {
                    return rhs;
                } else if (rhs.isFalse()) {
                    return lhs;
                }
                break;
            case AND:
                if (lhs.isFalse() || rhs.isFalse()) {
                    return BConst.FALSE;
                } else if (lhs.isTrue()) {
                    return rhs;
                } else if (rhs.isTrue()) {
                    return lhs;
                }
                break;
        }
        return expressions.makeBinary(lhs, bBin.getOp(), rhs);
    }

    @Override
    public BExpr visit(BExprUn bUn) {
        // Due to constant propagation we are not guaranteed to get BExprs
        Expression innerExpr = bUn.getInner().visit(this);
        if(!(innerExpr instanceof BExpr)) {
            return bUn;
        }
        BExpr inner = (BExpr) innerExpr;
        if (inner instanceof BConst) {
            return expressions.makeValue(!inner.isTrue());
        }
        if (inner instanceof BExprUn in && bUn.getOp() == BOpUn.NOT) {
            return (BExpr) in.getInner();
        }

        if (inner instanceof Atom atom && bUn.getOp() == BOpUn.NOT) {
            // Move negations into the atoms COp
            return expressions.makeBinary(atom.getLHS(), atom.getOp().inverted(), atom.getRHS());
        }
        return expressions.makeUnary(bUn.getOp(), inner);
    }

    @Override
    public BExpr visit(BNonDet bNonDet) {
        return bNonDet;
    }

    @Override
    public IValue visit(IValue iValue) {
        return iValue;
    }

    @Override
    public IExpr visit(IExprBin iBin) {
        IExpr lhs = (IExpr)iBin.getLHS().visit(this);
        IExpr rhs = (IExpr)iBin.getRHS().visit(this);
        IOpBin op = iBin.getOp();
        if (lhs.equals(rhs)) {
            switch(op) {
                case AND:
                case OR:
                    return lhs;
                case XOR:
                    return expressions.makeZero(lhs.getType());
            }
        }
        if (! (lhs instanceof IConst || rhs instanceof IConst)) {
            return expressions.makeBinary(lhs, op, rhs);
        } else if (lhs instanceof IConst && rhs instanceof IConst) {
            // If we reduce MemoryObject as a normal IConst, we loose the fact that it is a Memory Object
            // We cannot call reduce for R_SHIFT (lack of implementation)
            if(!(lhs instanceof MemoryObject) && op != R_SHIFT) {
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
                if(lhs instanceof IExprBin lhsBin && lhsBin.getRHS() instanceof IConst && lhsBin.getOp() != R_SHIFT) {
                    IExpr newLHS = lhsBin.getLHS();
                    IExpr newRHS = expressions.makeBinary(lhsBin.getRHS(), lhsBin.getOp(), rhs).reduce();
                    return expressions.makeBinary(newLHS, op, newRHS);
                }

        }
        return expressions.makeBinary(lhs, op, rhs);
    }

    @Override
    public IExpr visit(IExprUn iUn) {
        return expressions.makeUnary(iUn.getOp(), iUn.getInner(), iUn.getType());
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
        if (t instanceof IConst tConstant && tConstant.isInteger() && tConstant.getValueAsInt() == 1
                && f instanceof IConst fConstant && fConstant.isInteger() && fConstant.getValueAsInt() == 0) {
            return cond;
        } else if (t instanceof IConst tConstant && tConstant.isInteger() && tConstant.getValueAsInt() == 0
                && f instanceof IConst fConstant && fConstant.isInteger() && fConstant.getValueAsInt() == 1) {
            return expressions.makeNot(cond);
        }

        return expressions.makeConditional(cond, t, f);
    }

    @Override
    public IExpr visit(INonDet iNonDet) {
        return iNonDet;
    }

    @Override
    public Expression visit(Register reg) {
        return reg;
    }

    @Override
    public Expression visit(MemoryObject address) {
        return address;
    }
}
