package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;

import java.util.LinkedList;

import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.REL;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.RX;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;

public class AtomicStore extends MemEvent implements RegReaderData {

    private final ExprInterface value;
    private final ImmutableSet<Register> dataRegs;

    public AtomicStore(IExpr address, ExprInterface value, String mo){
        super(address, mo);
        this.value = value;
        this.dataRegs = value.getRegs();
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.WRITE, EType.REG_READER);
    }

    private AtomicStore(AtomicStore other){
        super(other);
        this.value = other.value;
        this.dataRegs = other.dataRegs;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return "atomic_store" + tag + "(*" + address + ", " +  value + (mo != null ? ", " + mo : "") + ")";
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicStore getCopy(){
        return new AtomicStore(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------


    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        LinkedList<Event> events = new LinkedList<>();
        Store store = EventFactory.newStore(address, value, mo);
        events.add(store);

        switch (target){
            case NONE:
                break;
            case TSO:
                if(SC.equals(mo)){
                    events.addLast(EventFactory.X86.newMFence());
                }
                break;
            case POWER:
                if(RELEASE.equals(mo)){
                    events.addFirst(EventFactory.Power.newLwSyncBarrier());
                } else if(SC.equals(mo)){
                    events.addFirst(EventFactory.Power.newSyncBarrier());
                }
                break;
            case ARM:
                if(RELEASE.equals(mo) || SC.equals(mo)){
                    events.addFirst(EventFactory.Arm.newISHBarrier());
                    if(SC.equals(mo)){
                        events.addLast(EventFactory.Arm.newISHBarrier());
                    }
                }
                break;
            case ARM8:
            	String storeMo;
            	switch (mo) {
					case SC:
					case RELEASE:
						storeMo = REL;
						break;
					case RELAXED:
						storeMo = RX;
						break;
					default:
	                    throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
					}
                events = new LinkedList<>();
                store = EventFactory.newStore(address, value, storeMo);
                events.add(store);
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
