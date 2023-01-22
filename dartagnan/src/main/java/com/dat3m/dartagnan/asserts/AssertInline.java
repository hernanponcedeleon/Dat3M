package com.dat3m.dartagnan.asserts;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Local;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.ArrayList;
import java.util.List;

public class AssertInline extends AbstractAssert {
	
    private final Local e;

    public AssertInline(Local e){
        this.e = e;
    }

    @Override
    public BooleanFormula encode(EncodingContext ctx) {
        final BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
		return bmgr.implication(ctx.execution(e), bmgr.not(ctx.equalZero(ctx.result(e))));
    }

    @Override
    public String toString(){
        return e.getResultRegister().toString();
    }
    
	@Override
	public List<Register> getRegs() {
		List<Register> regs = new ArrayList<>();
		regs.add(e.getResultRegister());
		regs.addAll(e.getExpr().getRegs());
		return regs;
	}
}
