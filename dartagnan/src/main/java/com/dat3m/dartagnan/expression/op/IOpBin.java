package com.dat3m.dartagnan.expression.op;

import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import static java.util.Arrays.asList;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

public enum IOpBin {
    PLUS, MINUS, MULT, DIV, UDIV, MOD, AND, OR, XOR, L_SHIFT, R_SHIFT, AR_SHIFT, SREM, UREM;
	
	public static List<IOpBin> BWOps = Arrays.asList(UDIV, AND, OR, XOR, L_SHIFT, R_SHIFT, AR_SHIFT, SREM, UREM); 
	
    @Override
    public String toString() {
        switch(this){
            case PLUS:
                return "+";
            case MINUS:
                return "-";
            case MULT:
                return "*";
            case DIV:
                return "/";
            case MOD:
                return "%";
            case AND:
                return "&";
            case OR:
                return "|";
            case XOR:
                return "^";
            case L_SHIFT:
                return "<<";
            case R_SHIFT:
                return ">>>";
            case AR_SHIFT:
                return ">>";
            default:
            	return super.toString();        	
        }
    }

    public String toLinuxName(){
        switch(this){
            case PLUS:
                return "add";
            case MINUS:
                return "sub";
            case AND:
                return "and";
            case OR:
                return "or";
            case XOR:
                return "xor";
            default:
            	throw new UnsupportedOperationException("Linux op name is not defined for " + this);
        }
    }

    public static IOpBin intToOp(int i) {
        switch(i) {
            case 0: return PLUS;
            case 1: return MINUS;
            case 2: return AND;
            case 3: return OR;
            default:
                throw new UnsupportedOperationException("The binary operator is not recognized");
        }
    }
    
    public Formula encode(Formula e1, Formula e2, SolverContext ctx){
    	// Some SMT solvers do not support certain theories.
    	// Calling the constructor of the manager in such solvers results in an Exception.
    	// Thus we initialize the manager inside the branches
    	
		BitvectorFormulaManager bvmgr;

		if(e1 instanceof IntegerFormula && e2 instanceof IntegerFormula) {
			IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
            IntegerFormula i1 = (IntegerFormula)e1;
            IntegerFormula i2 = (IntegerFormula)e2;
			switch(this){
            	case PLUS:
            		return imgr.add(i1, i2);
            	case MINUS:
            		return imgr.subtract(i1, i2);
            	case MULT:
            		return imgr.multiply(i1, i2);
            	case DIV:
            	case UDIV:
            		return imgr.divide(i1, i2);
            	case MOD:
            		return imgr.modulo(i1, i2);
            	case AND:
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.toIntegerFormula(bvmgr.and(bvmgr.makeBitvector(32, i1), bvmgr.makeBitvector(32, i2)), false);
            	case OR:
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.toIntegerFormula(bvmgr.or(bvmgr.makeBitvector(32, i1), bvmgr.makeBitvector(32, i2)), false);
            	case XOR:
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.toIntegerFormula(bvmgr.xor(bvmgr.makeBitvector(32, i1), bvmgr.makeBitvector(32, i2)), false);
            	case L_SHIFT:
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.toIntegerFormula(bvmgr.shiftLeft(bvmgr.makeBitvector(32, i1), bvmgr.makeBitvector(32, i2)), false);
            	case R_SHIFT:
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.toIntegerFormula(bvmgr.shiftRight(bvmgr.makeBitvector(32, i1), bvmgr.makeBitvector(32, i2), false), false);
            	case AR_SHIFT:
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.toIntegerFormula(bvmgr.shiftRight(bvmgr.makeBitvector(32, i1), bvmgr.makeBitvector(32, i2), true), false);
            	case SREM:
            	case UREM:
            		IntegerFormula zero = imgr.makeNumber(0);
        			IntegerFormula modulo = imgr.modulo(i1, i2);
            		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
            		BooleanFormula cond = bmgr.and(imgr.distinct(asList(modulo, zero)), imgr.lessThan(i1, zero));
            		return bmgr.ifThenElse(cond, imgr.subtract(modulo, i2), modulo);
            	default:
                    throw new UnsupportedOperationException("Encoding of IOpBin operation " + this + " not supported on integer formulas.");
			}			
		} else if ( e1 instanceof BitvectorFormula && e2 instanceof BitvectorFormula) {
			bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            BitvectorFormula bv1 = (BitvectorFormula)e1;
            BitvectorFormula bv2 = (BitvectorFormula)e2;
			switch(this){
            	case PLUS:
            		return bvmgr.add(bv1, bv2);
            	case MINUS:
            		return bvmgr.subtract(bv1, bv2);
            	case MULT:
            		return bvmgr.multiply(bv1, bv2);
            	case DIV:
            	case UDIV:
            		return bvmgr.divide(bv1, bv2, this.equals(DIV));
            	case MOD:
            		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
            		BitvectorFormula rem = bvmgr.modulo(bv1, bv2, true);
            		// Check if rem and bv2 have the same sign
            		int rem_length = bvmgr.getLength(rem);
            		int bv2_length = bvmgr.getLength(bv2);
            		BitvectorFormula srem = bvmgr.extract(rem, rem_length-1, rem_length-1);
            		BitvectorFormula sbv2 = bvmgr.extract(bv2, bv2_length-1, bv2_length-1);
            		BooleanFormula cond = bvmgr.equal(srem, sbv2);
            		// If they have the same sign, return the reminder, otherwise invert it
            		return bmgr.ifThenElse(cond, rem, bvmgr.negate(rem));
            	case SREM:
            		return bvmgr.modulo(bv1, bv2, true);
            	case UREM:
            		return bvmgr.modulo(bv1, bv2, false);
            	case AND:
            		return bvmgr.and(bv1, bv2);
            	case OR:
            		return bvmgr.or(bv1, bv2);
            	case XOR:
            		return bvmgr.xor(bv1, bv2);
            	case L_SHIFT:
            		return bvmgr.shiftLeft(bv1, bv2);
            	case R_SHIFT:
            		return bvmgr.shiftRight(bv1, bv2, false);
            	case AR_SHIFT:
            		return bvmgr.shiftRight(bv1, bv2, true);
            	default:
                    throw new UnsupportedOperationException("Encoding of IOpBin operation " + this + " not supported on bitvector formulas.");
            }
		} else {
            throw new UnsupportedOperationException("Encoding of IOpBin operation " + this + " not supported on formulas of mismatching type.");
		}
    }

    public BigInteger combine(BigInteger a, BigInteger b){
        switch(this){
            case PLUS:
                return a.add(b);
            case MINUS:
                return a.subtract(b);
            case MULT:
                return a.multiply(b);
            case DIV:
            case UDIV:
                return a.divide(b);
            case MOD:
                return a.mod(b);
            case SREM:
            case UREM:
                return a.remainder(b);
            case AND:
                return a.and(b);
            case OR:
                return a.or(b);
            case XOR:
                return a.xor(b);
            case L_SHIFT:
                return a.shiftLeft(b.intValue());
            case R_SHIFT:
            	// BigInteger do not support logical shift
                throw new UnsupportedOperationException("Illegal operator " + this + " in IOpBin");
            case AR_SHIFT:
                return a.shiftRight(b.intValue());
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in IOpBin");
    }
}
