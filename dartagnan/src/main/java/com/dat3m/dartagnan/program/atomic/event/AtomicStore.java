package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.extractStoreMo;
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
            case ARM:
                Fence optionalBarrierBefore = mo.equals(RELEASE) || mo.equals(SC) ? Arm.newISHBarrier() : null;
                Fence optionalBarrierAfter = mo.equals(SC) ? Arm.newISHBarrier() : null;
                events = eventSequence(
                        optionalBarrierBefore,
                        store,
                        optionalBarrierAfter
                );
                break;
            case ARM8:
                if (mo.equals(ACQUIRE) || mo.equals(ACQUIRE_RELEASE)) {
                    throw new UnsupportedOperationException("AtomicStore can not have memory order: " + mo);
                }
            	String storeMo = extractStoreMo(mo);
            	events = eventSequence(
                        newStore(address, value, storeMo)
                );
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        setCLineForAll(events, this.cLine);
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
