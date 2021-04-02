package com.dat3m.dartagnan.program.event.pthread;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;

import java.util.LinkedList;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class InitLock extends Event {
	
	private final String name;
	private final IExpr address;
	private final IExpr value;

	public InitLock(String name, IExpr address, IExpr value){
		this.name = name;
        this.address = address;
        this.value = value;
    }

	private InitLock(InitLock other){
		this.name = other.name;
        this.address = other.address;
        this.value = other.value;
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
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        LinkedList<Event> events = new LinkedList<>();
        events.add(new Store(address, value, SC));
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
