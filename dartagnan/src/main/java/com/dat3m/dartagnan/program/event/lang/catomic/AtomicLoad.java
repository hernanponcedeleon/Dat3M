package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EType;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.google.common.base.Preconditions;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.event.arch.aarch64.utils.Mo.extractLoadMo;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.*;

public class AtomicLoad extends MemEvent implements RegWriter {

    private final Register resultRegister;

    public AtomicLoad(Register register, IExpr address, String mo) {
        super(address, mo);
    	Preconditions.checkArgument(!mo.equals(RELEASE) && !mo.equals(ACQUIRE_RELEASE), 
    			getClass().getName() + " can not have memory order: " + mo);
        this.resultRegister = register;
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.READ, EType.REG_WRITER);
    }

    private AtomicLoad(AtomicLoad other){
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return resultRegister + " = atomic_load" + tag + "(*" + address + (mo != null ? ", " + mo : "") + ")";
    }

    @Override
    public ExprInterface getMemValue(){
        return resultRegister;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicLoad getCopy(){
        return new AtomicLoad(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        List<Event> events;
        Load load = newLoad(resultRegister, address, mo);

        switch (target) {
            case NONE:
            case TSO:
                events = eventSequence(
                        load
                );
                break;
            case POWER: {
                Fence optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier() : null;
                Label optionalLabel =
                        (mo.equals(SC) || mo.equals(ACQUIRE) || mo.equals(RELAXED)) ?
                                newLabel("FakeDep") :
                                null;
                CondJump optionalFakeCtrlDep =
                        (mo.equals(SC) || mo.equals(ACQUIRE) || mo.equals(RELAXED)) ?
                                newFakeCtrlDep(resultRegister, optionalLabel) :
                                null;
                Fence optionalISyncBarrier =
                        (mo.equals(SC) || mo.equals(ACQUIRE)) ?
                                Power.newISyncBarrier() :
                                null;
                events = eventSequence(
                        optionalMemoryBarrier,
                        load,
                        optionalFakeCtrlDep,
                        optionalLabel,
                        optionalISyncBarrier
                );
                break;
            }
            case ARM8:
                String loadMo = extractLoadMo(mo);
                events = eventSequence(
                        newLoad(resultRegister, address, loadMo)
                );
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
        }
        return events;
    }
}