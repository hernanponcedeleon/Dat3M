package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.program.event.Tag.STRONG;

import java.util.HashSet;
import java.util.Set;

public class LlvmCmpXchg extends LlvmAbstractRMW {

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

    // The llvm instructions actually returns a structure.
    // In most cases the structure is not used as a whole, 
    // but rather by accessing its members. Thus there is
    // no need to support this method.
    @Override
    public Register getResultRegister() {
		throw new UnsupportedOperationException("getResultRegister() not supported for " + this);
    }

    // However member registers have the form reg(idx) and
    // thus we need to know the id of the original register.
    // This would be a possible usage for the method above
    // having an implementation, but we rather introduce this
    // one to avoid wrong usages.
    public String getResultRegisterAsString() {
		return resultRegister.toString();
    }

    public ExprInterface getExpectedValue() {
    	return expectedValue;
    }
    
    @Override
    public ImmutableSet<Register> getDataRegs() {
        Set<Register> registers = new HashSet<>();
        registers.addAll(value.getRegs());
        registers.addAll(expectedValue.getRegs());
        return ImmutableSet.copyOf(registers);
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