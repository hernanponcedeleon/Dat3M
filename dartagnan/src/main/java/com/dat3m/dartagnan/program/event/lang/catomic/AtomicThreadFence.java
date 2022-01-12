package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Fence;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.C11.*;

public class AtomicThreadFence extends Fence {

    private final String mo;

    public AtomicThreadFence(String mo) {
        super("atomic_thread_fence");
        this.mo = mo;
    }

    private AtomicThreadFence(AtomicThreadFence other){
        super(other);
        this.mo = other.mo;
    }

    @Override
    public String toString() {
        return name + "(" + mo + ")";
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicThreadFence getCopy(){
        return new AtomicThreadFence(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        Fence fence = null;
        switch (target) {
            case NONE:
                break;
            case TSO:
                fence = mo.equals(MO_SC) ? X86.newMemoryFence() : null;
                break;
            case POWER:
                fence = mo.equals(MO_ACQUIRE) || mo.equals(MO_RELEASE) || mo.equals(MO_ACQUIRE_RELEASE) || mo.equals(MO_SC) ?
                        Power.newLwSyncBarrier() : null;
                break;
            case ARM8:
                fence = mo.equals(MO_RELEASE) || mo.equals(MO_ACQUIRE_RELEASE) || mo.equals(MO_SC) ? AArch64.DMB.newISHBarrier()
                        : mo.equals(MO_ACQUIRE) ? AArch64.DSB.newISHLDBarrier() : null;
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
        }
        return eventSequence(
                fence
        );
    }
}