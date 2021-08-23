package com.dat3m.dartagnan.program.event.pthread;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Events;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.math.BigInteger;
import java.util.LinkedList;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;

public class End extends Event {

	private final Address address;
	
    public End(Address address){
        this.address = address;
    }

    private End(End other){
    	super(other);
        this.address = other.address;
    }

    @Override
    public String toString() {
        return "end_thread()";
    }
	
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public End getCopy(){
        return new End(this);
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        LinkedList<Event> events = new LinkedList<>();
        Store store = Events.newStore(address, new IConst(BigInteger.ZERO, -1), SC);
        events.add(store);

        switch (target){
            case NONE:
                break;
            case TSO:
                events.addLast(Events.X86.newMFence());
                break;
            case POWER:
                events.addFirst(Events.Power.newSyncBarrier());
                break;
            case ARM:
                events.addFirst(Events.Arm.newISHBarrier());
                events.addLast(Events.Arm.newISHBarrier());
                break;
            case ARM8:
                events.addFirst(Events.Arm8.DMB.newISHBarrier());
                events.addLast(Events.Arm8.DMB.newISHBarrier());
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }

}
