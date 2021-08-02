package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

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

    public Formula encode(Formula e1, Formula e2, SolverContext ctx){
    	// Some SMT solvers do not support certain theories.
    	// Calling the constructor of the manager in such solvers results in an Exception.
    	// Thus we initialize the manager inside the branches
    	
		IntegerFormulaManager imgr;
		BitvectorFormulaManager bvmgr;

		switch(this){
            case PLUS:
            	if(e1 instanceof IntegerFormula) {
            		imgr = ctx.getFormulaManager().getIntegerFormulaManager();
            		return imgr.add((IntegerFormula)e1, (IntegerFormula)e2);            		
            	} else {
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.add((BitvectorFormula)e1, (BitvectorFormula)e2);            		
            	}
            case MINUS:
            	if(e1 instanceof IntegerFormula) {
            		imgr = ctx.getFormulaManager().getIntegerFormulaManager();
            		return imgr.subtract((IntegerFormula)e1, (IntegerFormula)e2);
            	} else {
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.subtract((BitvectorFormula)e1, (BitvectorFormula)e2);
            	}
            case MULT:
            	if(e1 instanceof IntegerFormula) {
            		imgr = ctx.getFormulaManager().getIntegerFormulaManager();
            		return imgr.multiply((IntegerFormula)e1, (IntegerFormula)e2);
            	} else {
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.multiply((BitvectorFormula)e1, (BitvectorFormula)e2);
            	}
            case DIV:
            case UDIV:
            	if(e1 instanceof IntegerFormula) {
            		imgr = ctx.getFormulaManager().getIntegerFormulaManager();
            		return imgr.divide((IntegerFormula)e1, (IntegerFormula)e2);
            	} else {
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.divide((BitvectorFormula)e1, (BitvectorFormula)e2, this.equals(DIV)); 
            	}
            case MOD:
            	if(e1 instanceof IntegerFormula) {
            		imgr = ctx.getFormulaManager().getIntegerFormulaManager();
            		return imgr.modulo((IntegerFormula)e1, (IntegerFormula)e2);
            	} else {
            		bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            		return bvmgr.modulo((BitvectorFormula)e1, (BitvectorFormula)e2, true); 
            	}
            case AND:
            	bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            	if(e1 instanceof IntegerFormula) {
            		return bvmgr.toIntegerFormula(bvmgr.and(bvmgr.makeBitvector(32, (IntegerFormula)e1), bvmgr.makeBitvector(32, (IntegerFormula)e2)), false);
            	} else {
            		return bvmgr.and((BitvectorFormula)e1, (BitvectorFormula)e2); 
            	}
            case OR:
            	bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            	if(e1 instanceof IntegerFormula) {
            		return bvmgr.toIntegerFormula(bvmgr.or(bvmgr.makeBitvector(32, (IntegerFormula)e1), bvmgr.makeBitvector(32, (IntegerFormula)e2)), false);
            	} else {
            		return bvmgr.or((BitvectorFormula)e1, (BitvectorFormula)e2); 
            	}
            case XOR:
            	bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            	if(e1 instanceof IntegerFormula) {
            		return bvmgr.toIntegerFormula(bvmgr.xor(bvmgr.makeBitvector(32, (IntegerFormula)e1), bvmgr.makeBitvector(32, (IntegerFormula)e2)), false);
            	} else {
            		return bvmgr.xor((BitvectorFormula)e1, (BitvectorFormula)e2); 
            	}
            case L_SHIFT:
            	bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            	if(e1 instanceof IntegerFormula) {
            		return bvmgr.toIntegerFormula(bvmgr.shiftLeft(bvmgr.makeBitvector(32, (IntegerFormula)e1), bvmgr.makeBitvector(32, (IntegerFormula)e2)), false);
            	} else {
            		return bvmgr.shiftLeft((BitvectorFormula)e1, (BitvectorFormula)e2); 
            	}
            case R_SHIFT:
            	bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            	if(e1 instanceof IntegerFormula) {
            		return bvmgr.toIntegerFormula(bvmgr.shiftRight(bvmgr.makeBitvector(32, (IntegerFormula)e1), bvmgr.makeBitvector(32, (IntegerFormula)e2), false), false);
            	} else {
            		return bvmgr.shiftRight((BitvectorFormula)e1, (BitvectorFormula)e2, false); 
            	}
            case AR_SHIFT:
            	bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
            	if(e1 instanceof IntegerFormula) {
            		return bvmgr.toIntegerFormula(bvmgr.shiftRight(bvmgr.makeBitvector(32, (IntegerFormula)e1), bvmgr.makeBitvector(32, (IntegerFormula)e2), true), false); 
            	} else {
            		return bvmgr.shiftRight((BitvectorFormula)e1, (BitvectorFormula)e2, true); 
            	}
        }
        throw new UnsupportedOperationException("Encoding of not supported for IOpBin " + this);
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
            case SREM:
            case UREM:
                return a.mod(b);
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
