package com.dat3m.dartagnan.program.event.pthread;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.EventFactory;
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
        Store store = EventFactory.newStore(address, new IConst(BigInteger.ZERO, -1), SC);
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
