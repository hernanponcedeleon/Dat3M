package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.ACQUIRE;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.ACQ_REL;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.RELEASE;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;

import java.util.LinkedList;

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
                    events.add(new Fence("Mfence"));
                }
                break;
            case POWER:
                if(ACQUIRE.equals(mo) || RELEASE.equals(mo) || ACQ_REL.equals(mo) || SC.equals(mo)){
                    events.add(new Fence("Lwsync"));
                }
                break;
            case ARM: case ARM8:
                if(ACQUIRE.equals(mo) || RELEASE.equals(mo) || ACQ_REL.equals(mo) || SC.equals(mo)){
                    events.addLast(new Fence("Ish"));
                }
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
