package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.Arrays;
import java.util.LinkedList;

import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;

public class AtomicXchg extends AtomicAbstract implements RegWriter, RegReaderData {

    public AtomicXchg(Register register, IExpr address, ExprInterface value, String mo) {
        super(address, register, value, mo);
    }

    private AtomicXchg(AtomicXchg other){
        super(other);
    }

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return resultRegister + " = atomic_exchange" + tag + "(*" + address + ", " + value + (mo != null ? ", " + mo : "") + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicXchg getCopy(){
        return new AtomicXchg(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
    	Load load;
    	Store store;
    	LinkedList<Event> events = new LinkedList<>();
        switch(target) {
            case NONE: 
            case TSO:
                load = EventFactory.newRMWLoad(resultRegister, address, mo);
                store = EventFactory.newRMWStore(load, address, value, mo);
                events = new LinkedList<>(Arrays.asList(load, store));
                break;
            case POWER:
            case ARM8:
            	String loadMo;
            	String storeMo;
            	switch(mo) {
            		case SC:
                    case ACQ_REL:
            			loadMo = ACQ;
            			storeMo = REL;
            			break;
            		case ACQUIRE:
            			loadMo = ACQ;
            			storeMo = RX;
            			break;
            		case RELEASE:
            			loadMo = RX;
            			storeMo = REL;
            			break;
            		case RELAXED:
            			loadMo = RX;
            			storeMo = RX;
            			break;
            		default:
            			throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
            	}
            	load = EventFactory.newRMWLoadExclusive(resultRegister, address, loadMo);
                store = EventFactory.newRMWStoreExclusive(address, value, storeMo, true);
                Label label = EventFactory.newLabel("FakeDep");
                Event fakeCtrlDep = EventFactory.newFakeCtrlDep(resultRegister, label);

                // Extra fences for POWER
                if(target.equals(POWER)) {
                    if (mo.equals(SC)) {
                        events.addFirst(EventFactory.Power.newSyncBarrier());
                    } else if (storeMo.equals(REL)) {
                        events.addFirst(EventFactory.Power.newLwSyncBarrier());
                    }                	
                }
                
                // All events for POWER and ARM8
                events.addAll(Arrays.asList(load, fakeCtrlDep, label, store));

                // Extra fences for POWER
                if (target.equals(POWER) && loadMo.equals(ACQ)) {
                    events.addLast(EventFactory.Power.newISyncBarrier());
                }
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
