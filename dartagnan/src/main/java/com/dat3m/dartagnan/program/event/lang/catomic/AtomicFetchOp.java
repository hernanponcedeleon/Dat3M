package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;

import java.util.List;

import static com.dat3m.dartagnan.configuration.Arch.POWER;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.arch.aarch64.utils.Mo.*;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.SC;

public class AtomicFetchOp extends AtomicAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public AtomicFetchOp(Register register, IExpr address, IExpr value, IOpBin op, String mo) {
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

    public IOpBin getOp() {
    	return op;
    }
    
    @Override
    public ExprInterface getMemValue() {
    	return value;
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
    public List<Event> compile(Arch target) {
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
                String loadMo = extractLoadMo(mo);
                String storeMo = extractStoreMo(mo);

                Load load = newRMWLoadExclusive(resultRegister, address, loadMo);
                Store store = newRMWStoreExclusive(address, dummyReg, storeMo, true);
                Label label = newLabel("FakeDep");
                Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

                // Extra fences for POWER
                Fence optionalMemoryBarrier = null;
                // Academics papers normally say an isync barrier is enough
                // However this makes benchmark linuxrwlocks.c fail
                // Additionally, power compilers in godbolt.org use a lwsync
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newLwSyncBarrier() : null;
                if(target.equals(POWER)) {
                    optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                            : storeMo.equals(REL) ? Power.newLwSyncBarrier()
                            : null;
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
                throw new UnsupportedOperationException("Compilation of atomic_fetch_" + op.toLinuxName() + tag + " is not implemented for " + target);
        }
        return events;
    }
}