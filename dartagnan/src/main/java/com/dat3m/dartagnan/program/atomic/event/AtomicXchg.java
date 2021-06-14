package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWLoadExclusive;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWStoreExclusive;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWStoreExclusiveStatus;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.ACQ;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.REL;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.RX;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;

import java.util.Arrays;
import java.util.LinkedList;

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
                load = new RMWLoad(resultRegister, address, mo);
                store = new RMWStore((RMWLoad)load, address, value, mo);
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
            	load = new RMWLoadExclusive(resultRegister, address, loadMo);
                store = new RMWStoreExclusive(address, value, storeMo, true);
            	Register statusReg = new Register("status(" + getOId() + ")", resultRegister.getThreadId(), resultRegister.getPrecision());
                RMWStoreExclusiveStatus status = new RMWStoreExclusiveStatus(statusReg, (RMWStoreExclusive)store);
                Label end = (Label)getThread().getExit();
                Event jump = new CondJump(new Atom(statusReg, COpBin.EQ, IConst.ONE), end);

                // Extra fences for POWER
                if(target.equals(POWER)) {
                    if (mo.equals(SC)) {
                        events.addFirst(new Fence("Sync"));
                    } else if (storeMo.equals(REL)) {
                        events.addFirst(new Fence("Lwsync"));
                    }                	
                }
                
                // All events for POWER and ARM8
                events.addAll(Arrays.asList(load, store, status, jump));

                // Extra fences for POWER
                if (target.equals(POWER) && loadMo.equals(ACQ)) {
                    events.addLast(new Fence("Isync"));
                }
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
