package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.event.arch.aarch64.utils.Mo.extractStoreMo;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.*;

public class AtomicStore extends MemEvent implements RegReaderData {

    private final ExprInterface value;
    private final ImmutableSet<Register> dataRegs;

    public AtomicStore(IExpr address, ExprInterface value, String mo){
        super(address, mo);
        Preconditions.checkArgument(!mo.equals(ACQUIRE) && !mo.equals(ACQUIRE_RELEASE), 
        		getClass().getName() + " can not have memory order: " + mo);
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

    @Override
    public ExprInterface getMemValue() {
    	return value;
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
    public List<Event> compile(Arch target) {
        List<Event> events;
        Store store = newStore(address, value, mo);
        switch (target){
            case NONE:
                events = eventSequence(
                        store
                );
                break;
            case TSO:
                Fence optionalMFence = mo.equals(SC) ? X86.newMemoryFence() : null;
                events = eventSequence(
                        store,
                        optionalMFence
                );
                break;
            case POWER:
                Fence optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                        : mo.equals(RELEASE) ? Power.newLwSyncBarrier() : null;
                events = eventSequence(
                        optionalMemoryBarrier,
                        store
                );
                break;
            case ARM8:
                String storeMo = extractStoreMo(mo);
                events = eventSequence(
                        newStore(address, value, storeMo)
                );
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
        }
        return events;
    }
}