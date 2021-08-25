package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
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
    	Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
    	Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));
    	List<Event> events;
        switch(target) {
            case NONE: case TSO: {

                Load load = newRMWLoad(resultRegister, address, mo);
                Store store = newRMWStore(load, address, dummyReg, mo);
                events = eventSequence(
                        load,
                        localOp,
                        store
                );
                break;
            }
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
            	Load load = newRMWLoadExclusive(resultRegister, address, loadMo);
                Store store = newRMWStoreExclusive(address, dummyReg, storeMo, true);
                Label label = newLabel("FakeDep");
                Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

                // Extra fences for POWER
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
                        localOp,
                        store,
                        optionalISyncBarrier
                );
                break;
            default:
                String tag = mo != null ? "_explicit" : "";
                throw new RuntimeException("Compilation of atomic_fetch_" + op.toLinuxName() + tag + " is not implemented for " + target);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);        
    }
}
