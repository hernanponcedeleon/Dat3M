package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;

import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LlvmXchg extends LlvmAbstractRMW {

    public LlvmXchg(Register register, IExpr address, IExpr value, String mo) {
        super(address, register, value, mo);
    }

    private LlvmXchg(LlvmXchg other){
        super(other);
    }

    @Override
    public String toString() {
        return resultRegister + " = llvm_xchg(*" + address + ", " + value + ")\t### LLVM";
    }

    @Override
    public ExprInterface getMemValue() {
    	return value;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LlvmXchg getCopy(){
        return new LlvmXchg(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLlvmXchg(this);
	}
}