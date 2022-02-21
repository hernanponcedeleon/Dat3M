package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Create extends Store {

	private final Register pthread_t;
	private final String routine;
	
    public Create(Register pthread_t, String routine, MemoryObject address){
    	super(address, IValue.ONE, MO_SC);
        this.pthread_t = pthread_t;
        this.routine = routine;
        addFilters(Tag.C11.PTHREAD);
    }

    private Create(Create other){
    	super(other);
        this.pthread_t = other.pthread_t;
        this.routine = other.routine;
    }

    @Override
    public String toString() {
        return "pthread_create(" + pthread_t + ", " + routine + ")";
    }
	
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Create getCopy(){
        return new Create(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitCreate(this);
	}
}