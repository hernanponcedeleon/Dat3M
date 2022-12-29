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
    private Register oldValueRegister;
    private Register cmpRegister;

    public LlvmCmpXchg(Register oldValueRegister, Register cmpRegister, IExpr address, IExpr expectedValue, IExpr value, String mo, boolean strong) {
        super(address, null, value, mo);
        this.expectedValue = expectedValue;
        this.oldValueRegister = oldValueRegister;
        this.cmpRegister = cmpRegister;
        if(strong) {
        	addFilters(STRONG);
        }
    }

    private LlvmCmpXchg(LlvmCmpXchg other){
        super(other);
        this.expectedValue = other.expectedValue;
        this.oldValueRegister = other.oldValueRegister;
        this.cmpRegister = other.cmpRegister;
    }

    // The llvm instructions actually returns a structure.
    // In most cases the structure is not used as a whole, 
    // but rather by accessing its members. Thus there is
    // no need to support this method.
    @Override
    public Register getResultRegister() {
		throw new UnsupportedOperationException("getResultRegister() not supported for " + this);
    }

    public Register getStructRegister(int idx) {
		switch(idx) {
            case 0:
                return oldValueRegister;
            case 1:
                return cmpRegister;
            default:
                throw new UnsupportedOperationException("Cannot access structure with id " + idx + " in " + getClass().getName());
        }
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
        return "(" + oldValueRegister + ", " + cmpRegister + ") = llvm_cmpxchg" + (is(STRONG) ? "_strong" : "_weak") + 
            "(*" + address + ", " + expectedValue + ", " + value + ", " + mo + ")\t### LLVM";
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
