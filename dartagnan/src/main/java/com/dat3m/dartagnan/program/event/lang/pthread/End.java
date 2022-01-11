package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.Address;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.SC;

public class End extends Store {

    public End(Address address){
    	super(address, IConst.ZERO, SC);
    }

    private End(End other){
    	super(other);
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
    public List<Event> compile(Arch target) {
    	Preconditions.checkNotNull(target, "Target cannot be null");
    	
        Fence optionalBarrierBefore = null;
        Fence optionalBarrierAfter = null;
        Store store = newStore(address, value, mo);

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