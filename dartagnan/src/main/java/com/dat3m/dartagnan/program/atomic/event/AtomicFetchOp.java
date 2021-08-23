package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.Arrays;
import java.util.LinkedList;

import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;

public class AtomicFetchOp extends AtomicAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public AtomicFetchOp(Register register, IExpr address, ExprInterface value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    private AtomicFetchOp(AtomicFetchOp other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return resultRegister + " = atomic_fetch_" + op.toLinuxName() + tag + "(*" + address + ", " + value + (mo != null ? ", " + mo : "") + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicFetchOp getCopy(){
        return new AtomicFetchOp(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
    	Load load;
    	Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
    	Local add = EventFactory.newLocal(dummyReg, new IExprBin(resultRegister, op, value));
    	Store store;
    	LinkedList<Event> events = new LinkedList<>();
        switch(target) {
            case NONE: case TSO:
                load = EventFactory.newRMWLoad(resultRegister, address, mo);
                store = EventFactory.newRMWStore((RMWLoad)load, address, dummyReg, mo);
                events = new LinkedList<>(Arrays.asList(load, add, store));
                break;
            case POWER:
            case ARM8:
                String loadMo;
                String storeMo;
                switch (mo) {
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
                store = EventFactory.newRMWStoreExclusive(address, dummyReg, storeMo, true);
                Label label = EventFactory.newLabel("FakeDep");
                Event ctrl = EventFactory.newFakeCtrlDep(resultRegister, label);

                // Extra fences for POWER
                if(target.equals(POWER)) {
                    if (mo.equals(SC)) {
                        events.addFirst(EventFactory.Power.newSyncBarrier());
                    } else if (storeMo.equals(REL)) {
                        events.addFirst(EventFactory.Power.newLwSyncBarrier());
                    }
                }
                
                // All events for POWER and ARM8
                events.addAll(Arrays.asList(load, ctrl, label, add, store));
                
                // Extra fences for POWER
                if (target.equals(POWER) && loadMo.equals(ACQ)) {
                    events.addLast(EventFactory.Power.newISyncBarrier());
                }
                break;
            default:
                String tag = mo != null ? "_explicit" : "";
                throw new RuntimeException("Compilation of atomic_fetch_" + op.toLinuxName() + tag + " is not implemented for " + target);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);        
    }
}
