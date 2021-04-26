package com.dat3m.dartagnan.program.event.pthread;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;
import static com.dat3m.dartagnan.program.utils.EType.PTHREAD;

import java.math.BigInteger;
import java.util.LinkedList;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class Create extends Event {

	private final Register pthread_t;
	private final String routine;
	private final Address address;
	
    public Create(Register pthread_t, String routine, Address address, int cLine){
    	super(cLine);
        this.pthread_t = pthread_t;
        this.routine = routine;
        this.address = address;
    }

    private Create(Create other){
    	super(other);
        this.pthread_t = other.pthread_t;
        this.routine = other.routine;
        this.address = other.address;
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

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------


    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        LinkedList<Event> events = new LinkedList<>();
        Store store = new Store(address, new IConst(BigInteger.ONE, -1), SC, cLine);
        store.addFilters(PTHREAD);
        events.add(store);

        switch (target){
            case NONE:
                break;
            case TSO:
                events.addLast(new Fence("Mfence"));
                break;
            case POWER:
                events.addFirst(new Fence("Sync"));
                break;
            case ARM: case ARM8:
                events.addFirst(new Fence("Ish"));
                events.addLast(new Fence("Ish"));
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
