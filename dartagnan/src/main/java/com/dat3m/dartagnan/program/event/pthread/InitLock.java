package com.dat3m.dartagnan.program.event.pthread;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.configuration.Arch;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;

public class InitLock extends Store {
	
	private final String name;

	public InitLock(String name, IExpr address, IExpr value){
		super(address, value, SC);
		this.name = name;
    }

	private InitLock(InitLock other){
        super(other);
		this.name = other.name;
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

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
    	Preconditions.checkNotNull(target, "Target cannot be null");
        return eventSequence(
                newStore(address, value, mo)
        );
    }
}