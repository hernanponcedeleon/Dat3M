package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import static com.dat3m.dartagnan.expression.op.IOpBin.R_SHIFT;

import java.math.BigInteger;

//TODO: This is buggy for now, because Addresses are treated as IConst
public class ExprSimplifier extends ExprTransformer {

    @Override
    public ExprInterface visit(Atom atom) {
        ExprInterface lhs = atom.getLHS().visit(this);
        ExprInterface rhs = atom.getRHS().visit(this);
        if (lhs instanceof IConst && rhs instanceof  IConst) {
            IConst lc = (IConst) lhs;
            IConst rc = (IConst) rhs;
            return new BConst(atom.getOp().combine(lc.getValue(), rc.getValue()));
        }
        return new Atom(lhs, atom.getOp(), rhs);
    }

    @Override
    public BExpr visit(BConst bConst) {
        return bConst;
    }

    @Override
    public BExpr visit(BExprBin bBin) {
    	// Due to constant propagation we are not guaranteed to get BExprs
    	if(!(bBin.getLHS().visit(this) instanceof BExpr && bBin.getRHS().visit(this) instanceof BExpr)) {
    		return bBin;
    	}
        BExpr lhs = (BExpr) bBin.getLHS().visit(this);
        BExpr rhs = (BExpr) bBin.getRHS().visit(this);
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
        return new BExprBin(lhs, bBin.getOp(), rhs);
    }

    @Override
    public BExpr visit(BExprUn bUn) {
    	// Due to constant propagation we are not guaranteed to get BExprs
    	if(!(bUn.getInner().visit(this) instanceof BConst)) {
    		return bUn;
    	}
        BExpr inner = (BExpr) bUn.getInner().visit(this);
        if (inner instanceof BConst) {
            return inner.isTrue() ? BConst.FALSE : BConst.TRUE;
        }
        if (inner instanceof BExprUn && bUn.getOp() == BOpUn.NOT) {
            return (BExpr) ((BExprUn)inner).getInner();
        }
        return new BExprUn(bUn.getOp(), inner);
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
        if (! (lhs instanceof IConst || rhs instanceof IConst)) {
            return new IExprBin(lhs, iBin.getOp(), rhs);
        } else if (lhs instanceof IConst && rhs instanceof IConst) {
    		// If we reduce MemoryObject as a normal IConst, we loose the fact that it is a Memory Object
    		// We cannot call reduce for R_SHIFT (lack of implementation)
    		if(!(lhs instanceof MemoryObject) && iBin.getOp() != R_SHIFT) {
    			return new IExprBin(lhs, iBin.getOp(), rhs).reduce();
    		}
    		// Rule to reduce &mem + 0
    		if(lhs instanceof MemoryObject && rhs.equals(IValue.ZERO)) {
    			return lhs;
    		}
        }

        if (lhs instanceof IConst) {
            IConst lc = (IConst)lhs;
            BigInteger val = lc.getValue();
            switch (op) {
                case MULT:
                    return val.compareTo(BigInteger.ZERO) == 0 ? IValue.ZERO : val.equals(BigInteger.ONE) ? rhs : new IExprBin(lhs, op, rhs);
                case PLUS:
                    return val.compareTo(BigInteger.ZERO) == 0 ? rhs : new IExprBin(lhs, op, rhs);
                default:
                    return new IExprBin(lhs, op, rhs);
            }
        }

        IConst rc = (IConst)rhs;
        BigInteger val = rc.getValue();
        switch (op) {
            case MULT:
                return val.compareTo(BigInteger.ZERO) == 0 ? IValue.ZERO : val.equals(BigInteger.ONE) ? lhs : new IExprBin(lhs, op, rhs);
            case PLUS:
            case MINUS:
            	if(val.compareTo(BigInteger.ZERO) == 0) {
            		return lhs;
            	}
            	// Rule for associativity (rhs is IConst) since we cannot reduce MemoryObjects
            	// Either op can be +/-, but this does not affect correctness
            	// e.g. (&mem + x) - y -> &mem + reduced(x - y)
            	if(lhs instanceof IExprBin && ((IExprBin)lhs).getRHS() instanceof IConst) {
        			IExprBin lhsBin = (IExprBin)lhs;
            		IExpr newLHS = lhsBin.getLHS();
					IExpr newRHS = new IExprBin(lhsBin.getRHS(), lhsBin.getOp(), rhs).reduce();
					return new IExprBin(newLHS, op, newRHS);
            	}
            	return new IExprBin(lhs, op, rhs);
            default:
                return new IExprBin(lhs, op, rhs);
        }
    }

    @Override
    public IExpr visit(IExprUn iUn) {
        return new IExprUn(iUn.getOp(), iUn.getInner());
    }

    @Override
    public ExprInterface visit(IfExpr ifExpr) {
        BExpr cond = (BExpr) ifExpr.getGuard().visit(this);
        IExpr t = (IExpr) ifExpr.getTrueBranch().visit(this);
        IExpr f = (IExpr) ifExpr.getFalseBranch().visit(this);

        if (cond.isTrue()) {
            return t;
        } else if (cond.isFalse()) {
            return f;
        } else if (t.equals(f)) {
            return t;
        }
        return new IfExpr(cond, t, f);
    }

    @Override
    public IExpr visit(INonDet iNonDet) {
        return iNonDet;
    }

    @Override
    public ExprInterface visit(Register reg) {
        return reg;
    }

    @Override
    public ExprInterface visit(MemoryObject address) {
        return address;
    }
}
