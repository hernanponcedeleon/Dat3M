package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.program.event.Tag.C11.*;
import static com.dat3m.dartagnan.program.event.Tag.*;

public class AtomicStore extends MemEvent implements RegReaderData {

    private ExprInterface value;

    public AtomicStore(IExpr address, ExprInterface value, String mo){
        super(address, mo);
        Preconditions.checkArgument(!mo.equals(MO_ACQUIRE) && !mo.equals(MO_ACQUIRE_RELEASE),
        		getClass().getName() + " can not have memory order: " + mo);
        this.value = value;
        addFilters(ANY, VISIBLE, MEMORY, WRITE, REG_READER);
    }

    private AtomicStore(AtomicStore other){
        super(other);
        this.value = other.value;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return value.getRegs();
    }

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return "atomic_store" + tag + "(*" + address + ", " +  value + (mo != null ? ", " + mo : "") + ")\t### C11";
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
    public AtomicStore getCopy(){
        return new AtomicStore(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitAtomicStore(this);
	}
}