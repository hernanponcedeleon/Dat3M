package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;

import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.REL;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.RX;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.RELAXED;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.RELEASE;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;

import java.util.LinkedList;

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
        Store store = new Store(address, value, mo);
        events.add(store);

        switch (target){
            case NONE:
                break;
            case TSO:
                if(SC.equals(mo)){
                    events.addLast(new Fence("Mfence"));
                }
                break;
            case POWER:
                if(RELEASE.equals(mo)){
                    events.addFirst(new Fence("Lwsync"));
                } else if(SC.equals(mo)){
                    events.addFirst(new Fence("Sync"));
                }
                break;
            case ARM:
                if(RELEASE.equals(mo) || SC.equals(mo)){
                    events.addFirst(new Fence("Ish"));
                    if(SC.equals(mo)){
                        events.addLast(new Fence("Ish"));
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
                store = new Store(address, value, storeMo);
                events.add(store);
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
