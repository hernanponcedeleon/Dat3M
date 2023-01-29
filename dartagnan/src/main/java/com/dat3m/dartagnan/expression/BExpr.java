package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.event.core.Event;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;

import java.math.BigInteger;

public abstract class BExpr implements ExprInterface {

    @Override
    public Formula toIntFormula(Event e, FormulaManager m) {
        if(ARCH_PRECISION > -1) {
        	BitvectorFormulaManager bvmgr = m.getBitvectorFormulaManager();
    		return m.getBooleanFormulaManager().ifThenElse(toBoolFormula(e, m),
    				bvmgr.makeBitvector(ARCH_PRECISION, BigInteger.ONE), 
    				bvmgr.makeBitvector(ARCH_PRECISION, BigInteger.ZERO)); 
        } else {
        	IntegerFormulaManager imgr = m.getIntegerFormulaManager();
    		return m.getBooleanFormulaManager().ifThenElse(toBoolFormula(e, m),
    				imgr.makeNumber(BigInteger.ONE), 
    				imgr.makeNumber(BigInteger.ZERO));        	
        }
    }

    @Override
    public BigInteger getIntValue(Event e, Model model, FormulaManager m) {
        return getBoolValue(e, model, m) ? BigInteger.ONE : BigInteger.ZERO;
    }
    
	public boolean isTrue() {
		return this.equals(BConst.TRUE);
	}

    public boolean isFalse() {
    	return this.equals(BConst.FALSE);
    }
}
