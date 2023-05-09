package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE_RELEASE;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;

public class LlvmStore extends MemEvent implements RegReaderData {

    private ExprInterface value;

    public LlvmStore(IExpr address, ExprInterface value, String mo){
        super(address, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
        Preconditions.checkArgument(!mo.equals(MO_ACQUIRE) && !mo.equals(MO_ACQUIRE_RELEASE),
        		getClass().getName() + " cannot have memory order: " + mo);
        this.value = value;
        addFilters(WRITE);
    }

    private LlvmStore(LlvmStore other){
        super(other);
        this.value = other.value;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return value.getRegs();
    }

    @Override
    public String toString() {
        return "llvm_store(*" + address + ", " +  value + ", " + mo + ")\t### LLVM";
    }

    @Override
    public ExprInterface getMemValue() {
    	return value;
    }
    
    @Override
    public void setMemValue(ExprInterface value){
        this.value = value;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LlvmStore getCopy(){
        return new LlvmStore(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLlvmStore(this);
	}
}