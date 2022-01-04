package com.dat3m.dartagnan.program.event.pthread;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
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
    	Preconditions.checkNotNull(target, "Target cannot be null");

        Fence optionalBarrierBefore = null;
        Fence optionalBarrierAfter = null;
        Store store = newStore(address, IConst.ONE, SC, cLine);
        store.addFilters(PTHREAD);

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
