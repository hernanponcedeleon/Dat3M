package com.dat3m.dartagnan.program.specification;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.LastValueInterface;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.FormulaManager;

import java.util.ArrayList;
import java.util.List;

public class AssertBasic extends AbstractAssert {

    private final LastValueInterface e1;
    private final LastValueInterface e2;
    private final COpBin op;

    public AssertBasic(LastValueInterface e1, COpBin op, LastValueInterface e2){
        this.e1 = e1;
        this.e2 = e2;
        this.op = op;
    }

    @Override
    public BooleanFormula encode(EncodingContext context) {
        FormulaManager ctx = context.getFormulaManager();
        return context.encodeComparison(op, e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx));
    }

    @Override
    public String toString(){
        return valueToString(e1) + op + valueToString(e2);
    }

    private String valueToString(LastValueInterface value){
        if(value instanceof Register){
            return ((Register)value).getThreadId() + ":" + value;
        }
        return value.toString();
    }

	@Override
	public List<Register> getRegs() {
		List<Register> regs = new ArrayList<>();
		if(e1 instanceof Register) {
			regs.add((Register) e1);
		}
		if(e2 instanceof Register) {
			regs.add((Register) e2);
		}
		return regs;
	}
}
