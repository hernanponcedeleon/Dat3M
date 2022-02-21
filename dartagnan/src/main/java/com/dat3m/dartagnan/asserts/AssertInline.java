package com.dat3m.dartagnan.asserts;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Local;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public class AssertInline extends AbstractAssert {
	
    private final Local e;

    public AssertInline(Local e){
        this.e = e;
    }

    @Override
    public BooleanFormula encode(SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

		BooleanFormula eq;
		if(e.getResultRegisterExpr() instanceof BitvectorFormula) {
			BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
			eq = bvmgr.equal((BitvectorFormula)e.getResultRegisterExpr(), bvmgr.makeBitvector(e.getResultRegister().getPrecision(), BigInteger.ZERO));
    	} else {
    		IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
			eq = imgr.equal((IntegerFormula)e.getResultRegisterExpr(), imgr.makeNumber(BigInteger.ZERO));
    	}
		return bmgr.and(e.exec(), eq);
    }

    @Override
    public String toString(){
        return "!" + e.getResultRegister();
    }
    
	@Override
	public List<Register> getRegs() {
		List<Register> regs = new ArrayList<>();
		regs.add(e.getResultRegister());
		regs.addAll(e.getExpr().getRegs());
		return regs;
	}
}
