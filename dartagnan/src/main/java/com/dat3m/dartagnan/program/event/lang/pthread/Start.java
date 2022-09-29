package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Start extends Load {

    private final Event creationEvent;

	public Start(Register reg, MemoryObject address, Event creationEvent){
		super(reg, address, MO_SC);
        this.creationEvent = creationEvent;
        addFilters(Tag.C11.PTHREAD);
    }

	private Start(Start other){
		super(other);
        this.creationEvent = other.creationEvent;
    }

    @Override
    public String toString() {
        return "start_thread()";
    }

    public Event getCreationEvent() {
        return creationEvent;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Start getCopy(){
        return new Start(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitStart(this);
	}
}