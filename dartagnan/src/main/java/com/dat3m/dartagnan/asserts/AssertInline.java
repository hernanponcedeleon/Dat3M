package com.dat3m.dartagnan.asserts;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.program.event.Local;

public class AssertInline extends AbstractAssert {
	
    private final Local e;

    public AssertInline(Local e){
        this.e = e;
    }

    @Override
    public BooleanFormula encode(SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
    	BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
		BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
		IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

		BooleanFormula eq;
		if(e.getResultRegisterExpr() instanceof BitvectorFormula) {
			eq = bvmgr.equal((BitvectorFormula)e.getResultRegisterExpr(), bvmgr.makeBitvector(e.getResultRegister().getPrecision(), BigInteger.ZERO));
    	} else {
			eq = imgr.equal((IntegerFormula)e.getResultRegisterExpr(), imgr.makeNumber(BigInteger.ZERO));
    	}
		return bmgr.and(e.exec(), eq);
    }

    @Override
    public String toString(){
        return "!" + e.getResultRegister();
    }
}
