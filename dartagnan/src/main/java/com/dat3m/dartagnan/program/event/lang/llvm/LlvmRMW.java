package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LlvmRMW extends LlvmAbstractRMW {

    private final IOpBin op;

    public LlvmRMW(Register register, IExpr address, IExpr value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    private LlvmRMW(LlvmRMW other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return resultRegister + " = llvm_rmw_" + op.toLinuxName() + 
            "(*" + address + ", " + value + ", " + mo + ")\t### LLVM";
    }

    public IOpBin getOp() {
    	return op;
    }

    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LlvmRMW getCopy(){
        return new LlvmRMW(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLlvmRMW(this);
	}
}