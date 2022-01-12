package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;

import java.util.List;

import static com.dat3m.dartagnan.configuration.Arch.POWER;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.ARMv8.*;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Tag.SC;

public class AtomicXchg extends AtomicAbstract implements RegWriter, RegReaderData {

    public AtomicXchg(Register register, IExpr address, IExpr value, String mo) {
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

    @Override
    public ExprInterface getMemValue() {
    	return value;
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
    public List<Event> compile(Arch target) {
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
                String loadMo = extractLoadMoFromCMo(mo);
                String storeMo = extractStoreMoFromCMo(mo);

                Load load = newRMWLoadExclusive(resultRegister, address, loadMo);
                Store store = newRMWStoreExclusive(address, value, storeMo, true);
                Label label = newLabel("FakeDep");
                Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

                Fence optionalMemoryBarrier = null;
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(MO_ACQ)) ? Power.newISyncBarrier() : null;
                if(target.equals(POWER)) {
                    optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                            : storeMo.equals(MO_REL) ? Power.newLwSyncBarrier()
                            : null;
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
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
        }
        return events;
    }
}