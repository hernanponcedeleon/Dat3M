package com.dat3m.dartagnan.program.event.arch.riscv;

import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class AmoOp extends AmoAbstract {

    private final IOpBin op;

    // Loads from address into rd and stores to address the value rd op r2 
	public AmoOp(Register rd, Register r2, IExpr address, String mo, IOpBin op) {
		super(rd, r2, address, mo);
        this.op = op;
	}

    private AmoOp(AmoOp other){
        super(other);
        this.op = other.op;
    }

	public IOpBin getOp() {
		return op;
	}
	
	public Register getOperand() {
		return r2;
	}
	
	@Override
	public String toString() {
		return String.format("%s = amo%s(%s, %s%s)", resultRegister, op.toLinuxName(), address, r2, (mo != null ? ", " + mo : ""));
		
	}
	
    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
        memLoadValueExpr = resultRegister.toIntFormulaResult(this, ctx);
        // TODO Below we need "r_result" and not "r"
        memStoreValueExpr = new IExprBin(resultRegister, op, r2).toIntFormula(this, ctx);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AmoOp getCopy(){
        return new AmoOp(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitAmoOp(this);
	}
}
