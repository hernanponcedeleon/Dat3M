package com.dat3m.dartagnan.program.event.pthread;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.math.BigInteger;
import java.util.LinkedList;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;
import static com.dat3m.dartagnan.program.utils.EType.PTHREAD;

public class Create extends Event {

	private final Register pthread_t;
	private final String routine;
	private final Address address;
	
    public Create(Register pthread_t, String routine, Address address){
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
        Store store = EventFactory.newStore(address, new IConst(BigInteger.ONE, -1), SC, cLine);
        store.addFilters(PTHREAD);
        events.add(store);

        switch (target){
            case NONE:
                break;
            case TSO:
                events.addLast(EventFactory.X86.newMemoryFence());
                break;
            case POWER:
                events.addFirst(EventFactory.Power.newSyncBarrier());
                break;
            case ARM:
                events.addFirst(EventFactory.Arm.newISHBarrier());
                events.addLast(EventFactory.Arm.newISHBarrier());
                break;
            case ARM8:
                events.addFirst(EventFactory.Arm8.DMB.newISHBarrier());
                events.addLast(EventFactory.Arm8.DMB.newISHBarrier());
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
