package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.AbstractMemoryEvent;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE_RELEASE;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;

public class AtomicStore extends AbstractMemoryEvent {

    private Expression value;

    public AtomicStore(Expression address, Expression value, String mo){
        super(address, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "Atomic events cannot have empty memory order");
        Preconditions.checkArgument(!mo.equals(MO_ACQUIRE) && !mo.equals(MO_ACQUIRE_RELEASE),
        		getClass().getName() + " can not have memory order: " + mo);
        this.value = value;
        addTags(WRITE);
    }

    private AtomicStore(AtomicStore other){
        super(other);
        this.value = other.value;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public String toString() {
        return "atomic_store(*" + address + ", " +  value + ", " + mo + ")\t### C11";
    }

    @Override
    public Expression getMemValue() {
    	return value;
    }
    
    @Override
    public void setMemValue(Expression value){
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