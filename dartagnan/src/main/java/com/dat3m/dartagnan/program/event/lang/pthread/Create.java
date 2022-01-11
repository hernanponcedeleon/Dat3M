package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.Address;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EType.PTHREAD;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.SC;

public class Create extends Store {

	private final Register pthread_t;
	private final String routine;
	
    public Create(Register pthread_t, String routine, Address address){
    	super(address, IConst.ONE, SC);
        this.pthread_t = pthread_t;
        this.routine = routine;
    }

    private Create(Create other){
    	super(other);
        this.pthread_t = other.pthread_t;
        this.routine = other.routine;
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
    public List<Event> compile(Arch target) {
    	Preconditions.checkNotNull(target, "Target cannot be null");

        Fence optionalBarrierBefore = null;
        Fence optionalBarrierAfter = null;
        Store store = newStore(address, value, mo, cLine);
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

        return eventSequence(
                optionalBarrierBefore,
                store,
                optionalBarrierAfter
        );
    }
}