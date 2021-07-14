package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

public enum IOpUn {
    MINUS, 
    BV2UINT, BV2INT, 
    INT2BV1, INT2BV8, INT2BV16, INT2BV32, INT2BV64, 
    TRUNC6432, TRUNC6416,TRUNC648, TRUNC641, TRUNC3216, TRUNC328, TRUNC321, TRUNC168, TRUNC161, TRUNC81,    
    ZEXT18, ZEXT116, ZEXT132, ZEXT164, ZEXT816, ZEXT832, ZEXT864, ZEXT1632, ZEXT1664, ZEXT3264, 
    SEXT18, SEXT116, SEXT132, SEXT164, SEXT816, SEXT832, SEXT864, SEXT1632, SEXT1664, SEXT3264;
	
    @Override
    public String toString() {
        switch(this){
    	case MINUS:
    		return "-";
        default:
        	return "";
        }
    }

    public Formula encode(Formula e, SolverContext ctx) {
		IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
		BitvectorFormulaManager bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();

    	switch(this){
    		case MINUS:
            	return e instanceof IntegerFormula ?
                		imgr.subtract(imgr.makeNumber(BigInteger.ZERO), (IntegerFormula)e) :
                		bvmgr.subtract(bvmgr.makeBitvector(32, BigInteger.ZERO), (BitvectorFormula)e);
    		case BV2UINT:
    			return e instanceof IntegerFormula ? e : bvmgr.toIntegerFormula((BitvectorFormula)e, false);
    		case BV2INT:
    			return e instanceof IntegerFormula ? e : bvmgr.toIntegerFormula((BitvectorFormula)e, true);
    		// ============ INT2BV ============
    		case INT2BV1:
    			return e instanceof IntegerFormula ? bvmgr.makeBitvector(1, (IntegerFormula)e) : e;
    		case INT2BV8:
    			return e instanceof IntegerFormula ? bvmgr.makeBitvector(8, (IntegerFormula)e) : e;
    		case INT2BV16:
    			return e instanceof IntegerFormula ? bvmgr.makeBitvector(16, (IntegerFormula)e) : e;
    		case INT2BV32:
    			return e instanceof IntegerFormula ? bvmgr.makeBitvector(32, (IntegerFormula)e) : e;
    		case INT2BV64:
    			return e instanceof IntegerFormula ? bvmgr.makeBitvector(64, (IntegerFormula)e) : e;
        	// ============ TRUNC ============    		
    		case TRUNC6432:
    			return e instanceof IntegerFormula ? e : bvmgr.extract((BitvectorFormula)e, 31, 0, false);
    		case TRUNC6416:
    		case TRUNC3216:
    			return e instanceof IntegerFormula ? e : bvmgr.extract((BitvectorFormula)e, 15, 0, false);
    		case TRUNC648:
    		case TRUNC328:
    		case TRUNC168:
    			return e instanceof IntegerFormula ? e : bvmgr.extract((BitvectorFormula)e, 7, 0, false);
    		case TRUNC641:
    		case TRUNC321:
    		case TRUNC161:
    		case TRUNC81:
    			return e instanceof IntegerFormula ? e : bvmgr.extract((BitvectorFormula)e, 1, 0, false);    		
        	// ============ ZEXT ============    		
    		case ZEXT18:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 7, false);
    		case ZEXT116:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 15, false);
    		case ZEXT132:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 31, false);
    		case ZEXT164:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 63, false);
    		case ZEXT816:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 8, false);
    		case ZEXT832:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 24, false);
    		case ZEXT864:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 56, false);
    		case ZEXT1632:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 16, false);
    		case ZEXT1664:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 48, false);
    		case ZEXT3264:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 32, false);
        	// ============ SEXT ============
    		case SEXT18:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 7, true);
    		case SEXT116:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 15, true);
    		case SEXT132:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 31, true);
    		case SEXT164:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 63, true);
    		case SEXT816:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 8, true);
    		case SEXT832:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 24, true);
    		case SEXT864:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 56, true);
    		case SEXT1632:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 16, true);
    		case SEXT1664:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 48, true);
    		case SEXT3264:
    			return e instanceof IntegerFormula ? e : bvmgr.extend((BitvectorFormula)e, 32, true);
    	}
        throw new UnsupportedOperationException("Encoding of not supported for IOpUn " + this);
    }
}
