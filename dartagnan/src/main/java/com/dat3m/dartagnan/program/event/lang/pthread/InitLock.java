package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class InitLock extends Store {
	
	private final String name;

	public InitLock(String name, IExpr address, IExpr value){
		super(address, value, MO_SC);
		this.name = name;
    }

	private InitLock(InitLock other){
        super(other);
		this.name = other.name;
		addFilters(C11.LOCK);
    }

    @Override
    public String toString() {
        return "pthread_mutex_init(&" + name + ", " + value + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public InitLock getCopy(){
        return new InitLock(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitInitLock(this);
	}
}