package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.program.Events;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.LinkedList;

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
        LinkedList<Event> events = new LinkedList<>();
        switch (target) {
            case NONE:
                break;
            case TSO:
                if(SC.equals(mo)){
                    events.add(Events.X86.newMFence());
                }
                break;
            case POWER:
                if(ACQUIRE.equals(mo) || RELEASE.equals(mo) || ACQ_REL.equals(mo) || SC.equals(mo)){
                    events.add(Events.Power.newLwSyncBarrier());
                }
                break;
            case ARM:
                if(ACQUIRE.equals(mo) || RELEASE.equals(mo) || ACQ_REL.equals(mo) || SC.equals(mo)){
                    events.addLast(Events.Arm.newISHBarrier());
                }
                break;
            case ARM8:
                if(RELEASE.equals(mo) || ACQ_REL.equals(mo) || SC.equals(mo)){
                	events.addLast(Events.Arm8.DMB.newISHBarrier());
                }
                if(ACQUIRE.equals(mo)){
                	events.addLast(Events.Arm8.DSB.newISHLDBarrier());
                }                
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
