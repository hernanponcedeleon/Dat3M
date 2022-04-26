package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Join extends Load {

	private final Register pthread_t;

    public Join(Register pthread_t, Register reg, MemoryObject address) {
    	super(reg, address, MO_SC);
        this.pthread_t = pthread_t;
        addFilters(Tag.C11.PTHREAD);
    }

    public Join(Join other){
    	super(other);
        this.pthread_t = other.pthread_t;
    }

    @Override
    public String toString() {
        return "pthread_join(" + pthread_t + ")";
    }

    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Join getCopy(){
        return new Join(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitJoin(this);
	}
}