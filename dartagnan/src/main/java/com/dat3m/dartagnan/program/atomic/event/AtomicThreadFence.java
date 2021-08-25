package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;

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
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        List<Event> events;
        Fence fence = null;
        switch (target) {
            case NONE:
                break;
            case TSO:
                fence = mo.equals(SC) ? X86.newMemoryFence() : null;
                break;
            case POWER:
                fence = mo.equals(ACQUIRE) || mo.equals(RELEASE) || mo.equals(ACQ_REL) || mo.equals(SC) ?
                        Power.newLwSyncBarrier() : null;
                break;
            case ARM:
                fence = mo.equals(ACQUIRE) || mo.equals(RELEASE) || mo.equals(ACQ_REL) || mo.equals(SC) ?
                        Arm.newISHBarrier() : null;
                break;
            case ARM8:
                fence = mo.equals(RELEASE) || mo.equals(ACQ_REL) || mo.equals(SC) ?
                        Arm8.DMB.newISHBarrier() : mo.equals(ACQUIRE) ? Arm8.DSB.newISHLDBarrier() : null;
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        events = eventSequence(
                fence
        );
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
