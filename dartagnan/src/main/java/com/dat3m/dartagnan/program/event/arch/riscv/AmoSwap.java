package com.dat3m.dartagnan.program.event.arch.riscv;

import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class AmoSwap extends AmoAbstract {

    // Loads from address into rd and stores to address the value rd op r2 
	public AmoSwap(Register rd, Register r2, IExpr address, String mo) {
		super(rd, r2, address, mo);
	}

    private AmoSwap(AmoSwap other){
        super(other);
    }

	public Register getValue() {
		return r2;
	}
	
    @Override
	public String toString() {
		return String.format("%s = amoswap(%s, %s%s)", resultRegister, address, r2, (mo != null ? ", " + mo : ""));
		
	}
    
    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
        memLoadValueExpr = resultRegister.toIntFormulaResult(this, ctx);
        memStoreValueExpr = r2.toIntFormula(this, ctx);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AmoSwap getCopy(){
        return new AmoSwap(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitAmoSwap(this);
	}
}
