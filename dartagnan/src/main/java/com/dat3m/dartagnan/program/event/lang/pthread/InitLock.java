package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Store;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.eventSequence;
import static com.dat3m.dartagnan.program.EventFactory.newStore;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.SC;

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