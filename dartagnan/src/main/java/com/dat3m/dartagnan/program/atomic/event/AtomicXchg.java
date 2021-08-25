package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
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
    	List<Event> events;
        switch(target) {
            case NONE: 
            case TSO: {
                Load load = newRMWLoad(resultRegister, address, mo);
                Store store = newRMWStore(load, address, value, mo);
                events = eventSequence(
                        load,
                        store
                );
                break;
            }
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
            	Load load = newRMWLoadExclusive(resultRegister, address, loadMo);
                Store store = newRMWStoreExclusive(address, value, storeMo, true);
                Label label = newLabel("FakeDep");
                Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);


                Fence optionalMemoryBarrier = null;
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newISyncBarrier() : null;
                if(target.equals(POWER)) {
                    if (mo.equals(SC)) {
                        optionalMemoryBarrier = Power.newSyncBarrier();
                    } else if (storeMo.equals(REL)) {
                        optionalMemoryBarrier = Power.newLwSyncBarrier();
                    }
                }
                
                // All events for POWER and ARM8
                events = eventSequence(
                        optionalMemoryBarrier,
                        load,
                        fakeCtrlDep,
                        label,
                        store,
                        optionalISyncBarrier
                );
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
