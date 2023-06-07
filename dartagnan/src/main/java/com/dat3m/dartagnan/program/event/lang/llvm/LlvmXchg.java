package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;

import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LlvmXchg extends LlvmAbstractRMW {

    public LlvmXchg(Register register, Expression address, Expression value, String mo) {
        super(address, register, value, mo);
    }

    private LlvmXchg(LlvmXchg other){
        super(other);
    }

    @Override
    public String toString() {
        return resultRegister + " = llvm_xchg(*" + address + ", " + value + ", " + mo + ")\t### LLVM";
    }

    @Override
    public Expression getMemValue() {
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