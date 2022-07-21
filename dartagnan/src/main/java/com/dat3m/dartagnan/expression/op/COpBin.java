package com.dat3m.dartagnan.expression.op;

import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;

public enum COpBin {
    EQ, NEQ, GTE, LTE, GT, LT, UGTE, ULTE, UGT, ULT;

    @Override
    public String toString() {
        switch(this){
            case EQ:
                return "==";
            case NEQ:
                return "!=";
            case GTE:
            case UGTE:
                return ">=";
            case LTE:
            case ULTE:
                return "<=";
            case GT:
            case UGT:
                return ">";
            case LT:
            case ULT:
                return "<";
        }
        return super.toString();
    }

    public COpBin inverted() {
        switch(this){
            case EQ:
                return NEQ;
            case NEQ:
                return EQ;
            case GTE:
                return LT;
            case UGTE:
                return ULT;
            case LTE:
                return GT;
            case ULTE:
                return UGT;
            case GT:
                return LTE;
            case UGT:
                return ULTE;
            case LT:
                return GTE;
            case ULT:
                return UGTE;
            default:
                throw new UnsupportedOperationException(this + " cannot be inverted");
        }
    }

    public boolean isSigned() {
        switch(this){
            case EQ: case NEQ:
            case GTE: case LTE: case GT: case LT:
            	return true;
            case UGTE: case ULTE: case UGT: case ULT:
            	return false;
            default:
                throw new UnsupportedOperationException("isSigned() not implemented for " + this);
        }
    }

    public BooleanFormula encode(Formula e1, Formula e2, SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        if(e1 instanceof BooleanFormula && e2 instanceof BooleanFormula) {
            BooleanFormula b1 = (BooleanFormula)e1;
            BooleanFormula b2 = (BooleanFormula)e2;
    		switch(this) {
            	case EQ:
            		return bmgr.equivalence(b1, b2);
            	case NEQ:
            		return bmgr.not(bmgr.equivalence(b1, b2));
            	default:
            		throw new UnsupportedOperationException("Encoding of COpBin operation" + this + " not supported on boolean formulas.");
    		}
        }
        if(e1 instanceof IntegerFormula && e2 instanceof IntegerFormula) {
			IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
			IntegerFormula i1 = (IntegerFormula)e1;
			IntegerFormula i2 = (IntegerFormula)e2;
    		switch(this) {
    			case EQ:            		
            		return imgr.equal(i1, i2);
    			case NEQ:
            		return bmgr.not(imgr.equal(i1, i2));
    			case LT:
    			case ULT:
            		return imgr.lessThan(i1, i2);
    			case LTE:
    			case ULTE:
            		return imgr.lessOrEquals(i1, i2);
    			case GT:
    			case UGT:
            		return imgr.greaterThan(i1, i2);
    			case GTE:
    			case UGTE:
            		return imgr.greaterOrEquals(i1, i2);
    		}  	
        }
        if(e1 instanceof BitvectorFormula && e2 instanceof BitvectorFormula) {
        	BitvectorFormulaManager bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
        	BitvectorFormula bv1 = (BitvectorFormula)e1;
            BitvectorFormula bv2 = (BitvectorFormula)e2;
            switch(this) {
            	case EQ:
            		return bvmgr.equal(bv1, bv2);
            	case NEQ:
            		return bmgr.not(bvmgr.equal(bv1, bv2));
            	case LT:
            	case ULT:
            		return bvmgr.lessThan(bv1, bv2, this.equals(LT));
            	case LTE:
            	case ULTE:
            		return bvmgr.lessOrEquals(bv1, bv2, this.equals(LTE));
            	case GT:
            	case UGT:
            		return bvmgr.greaterThan(bv1, bv2, this.equals(GT));
            	case GTE:
            	case UGTE:
            		return bvmgr.greaterOrEquals(bv1, bv2, this.equals(GTE));
    		}        	
        }
        throw new UnsupportedOperationException("Encoding not supported for COpBin: " + e1 + " " + this + " " + e2);
    }

    public boolean combine(BigInteger a, BigInteger b){
        switch(this){
            case EQ:
                return a.compareTo(b) == 0;
            case NEQ:
                return a.compareTo(b) != 0;
            case LT:
            case ULT:
                return a.compareTo(b) < 0;
            case LTE:
            case ULTE:
                return a.compareTo(b) <= 0;
            case GT:
            case UGT:
                return a.compareTo(b) > 0;
            case GTE:
            case UGTE:
                return a.compareTo(b) >= 0;
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in COpBin");
    }

    // Due to constant propagation, and the lack of a proper type system
    // we can end up with comparisons like "False == 1", thus the following two methods
    public boolean combine(boolean a, BigInteger b){
        switch(this){
            case EQ:
                return ((b.compareTo(BigInteger.ONE) == 0) == a);
            case NEQ:
                return ((b.compareTo(BigInteger.ONE) == 0) != a);
		default:
	        throw new UnsupportedOperationException("Illegal operator " + this + " in COpBin");
        }
    }

    public boolean combine(BigInteger a, boolean b){
        switch(this){
            case EQ:
                return ((a.compareTo(BigInteger.ONE) == 0) == b);
            case NEQ:
                return ((a.compareTo(BigInteger.ONE) == 0) != b);
		default:
	        throw new UnsupportedOperationException("Illegal operator " + this + " in COpBin");
        }
    }
}
