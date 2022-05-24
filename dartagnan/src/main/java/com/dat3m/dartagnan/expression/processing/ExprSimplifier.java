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
    public ExprInterface visit(Atom atom) {
        ExprInterface lhs = atom.getLHS().visit(this);
        ExprInterface rhs = atom.getRHS().visit(this);
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
        if (lhs instanceof IConst && rhs instanceof  IConst) {
            IConst lc = (IConst) lhs;
            IConst rc = (IConst) rhs;
            return new BConst(atom.getOp().combine(lc.getValue(), rc.getValue()));
        }
        // Due to constant propagation, and the lack of a proper type system
        // we can end up with comparisons like "False == 1"
        if (lhs instanceof BConst && rhs instanceof IConst) {
            BConst lc = (BConst) lhs;
            IConst rc = (IConst) rhs;
            return new BConst(atom.getOp().combine(lc.getValue(), rc.getValue()));
        }
        if (lhs instanceof IConst && rhs instanceof BConst) {
            IConst lc = (IConst) lhs;
            BConst rc = (BConst) rhs;
            return new BConst(atom.getOp().combine(lc.getValue(), rc.getValue()));
        }
        if (lhs instanceof BExpr && rhs instanceof IConst) {
            // Simplify "cond == 1" to just "cond"
            // TODO: If necessary, add versions for "cond == 0" and for "cond != 0/1"
            if (atom.getOp() == COpBin.EQ && ((IConst) rhs).getValue().intValue() == 1) {
                return lhs;
            }
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
        ExprInterface innerExpr = bUn.getInner().visit(this);
    	if(!(innerExpr instanceof BExpr)) {
    		return bUn;
    	}
        BExpr inner = (BExpr) innerExpr;
        if (inner instanceof BConst) {
            return inner.isTrue() ? BConst.FALSE : BConst.TRUE;
        }
        if (inner instanceof BExprUn && bUn.getOp() == BOpUn.NOT) {
            return (BExpr) ((BExprUn)inner).getInner();
        }

        if (inner instanceof Atom && bUn.getOp() == BOpUn.NOT) {
            // Move negations into the atoms COp
            Atom atom = (Atom)inner;
            return new Atom(atom.getLHS(), atom.getOp().inverted(), atom.getRHS());
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
        if (lhs.equals(rhs)) {
        	switch(op) {
        		case AND:
        		case OR:
        			return lhs;
        		case XOR:
        			return IValue.ZERO;
        	}
        }
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
            	if(lhs instanceof IExprBin && ((IExprBin)lhs).getRHS() instanceof IConst  && ((IExprBin)lhs).getOp() != R_SHIFT) {
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

        // Simplifies "ITE(cond, 1, 0)" to "cond" and "ITE(cond, 0, 1) to "!cond"
        // TODO: It is not clear if this gives performance improvements or not
        if (t instanceof IConst && t.isInteger() && t.reduce().getValueAsInt() == 1
                && f instanceof IConst && f.isInteger() && f.reduce().getValueAsInt() == 0) {
            return cond;
        } else if (t instanceof IConst && t.isInteger() && t.reduce().getValueAsInt() == 0
                && f instanceof IConst && f.isInteger() && f.reduce().getValueAsInt() == 1) {
            return new BExprUn(BOpUn.NOT, cond);
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
