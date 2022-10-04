package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.STRONG;

public class LlvmCmpXchg extends LlvmAbstract {

    private IExpr expectedValue;

    public LlvmCmpXchg(Register register, IExpr address, IExpr expectedValue, IExpr value, String mo, boolean strong) {
        super(address, register, value, mo);
        this.expectedValue = expectedValue;
        if(strong) {
        	addFilters(STRONG);
        }
    }

    private LlvmCmpXchg(LlvmCmpXchg other){
        super(other);
        this.expectedValue = other.expectedValue;
    }

    public ExprInterface getExpectedValue() {
    	return expectedValue;
    }
    
    @Override
    public String toString() {
    	String tag = is(STRONG) ? "_strong" : "_weak";
        return resultRegister + " = llvm_cmpxchg" + tag + "(*" + address + ", " + expectedValue + ", " + value + (mo != null ? ", " + mo : "") + ")\t### LLVM";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LlvmCmpXchg getCopy(){
        return new LlvmCmpXchg(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLlvmCmpXchg(this);
	}
}