package com.dat3m.dartagnan.program.event.pthread;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
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
    	Preconditions.checkArgument(target != null, "Target cannot be null");

        Fence optionalBarrierBefore = null;
        Fence optionalBarrierAfter = null;
        Store store = newStore(address, IConst.ZERO, SC);

        switch (target){
            case NONE:
                break;
            case TSO:
                optionalBarrierAfter = X86.newMemoryFence();
                break;
            case POWER:
                optionalBarrierBefore = Power.newSyncBarrier();
                break;
            case ARM8:
                optionalBarrierBefore = Arm8.DMB.newISHBarrier();
                optionalBarrierAfter = Arm8.DMB.newISHBarrier();
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }

        List<Event> events = eventSequence(
                optionalBarrierBefore,
                store,
                optionalBarrierAfter
        );
        setCLineForAll(events, this.cLine);

        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }

}
