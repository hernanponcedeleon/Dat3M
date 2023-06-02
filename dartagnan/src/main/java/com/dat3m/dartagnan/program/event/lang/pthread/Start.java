package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Start extends Load {

    private final AbstractEvent creationEvent;

	public Start(Register reg, IExpr address, AbstractEvent creationEvent){
		super(reg, address, MO_SC);
        this.creationEvent = creationEvent;
        addTags(Tag.C11.PTHREAD);
    }

	private Start(Start other){
		super(other);
        this.creationEvent = other.creationEvent;
    }

    @Override
    public String toString() {
        return "start_thread()";
    }

    public AbstractEvent getCreationEvent() {
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