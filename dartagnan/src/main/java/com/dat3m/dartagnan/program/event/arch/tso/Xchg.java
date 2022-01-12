package com.dat3m.dartagnan.program.event.arch.tso;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Address;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.*;

public class Xchg extends MemEvent implements RegWriter, RegReaderData {

    private final Register resultRegister;
    private final ImmutableSet<Register> dataRegs;

    public Xchg(Address address, Register register) {
        super(address, null);
        this.resultRegister = register;
        this.dataRegs = ImmutableSet.of(resultRegister);
        addFilters(ANY, VISIBLE, MEMORY, READ, WRITE, Tag.TSO.ATOM, REG_WRITER, REG_READER);
    }

    private Xchg(Xchg other){
        super(other);
        this.resultRegister = other.resultRegister;
        this.dataRegs = other.dataRegs;
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString() {
        return "xchg(*" + address + ", " + resultRegister + ")";
    }

    @Override
    public ExprInterface getMemValue(){
        return resultRegister;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Xchg getCopy(){
        return new Xchg(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        Preconditions.checkArgument(target == Arch.TSO, "Compilation to " + target + " is not supported for " + getClass().getName());
        
        Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Load load = newRMWLoad(dummyReg, address, null);
        load.addFilters(Tag.TSO.ATOM);

        RMWStore store = newRMWStore(load, address, resultRegister, null);
        store.addFilters(Tag.TSO.ATOM);

        Local updateReg = newLocal(resultRegister, dummyReg);

        return eventSequence(
                load,
                store,
                updateReg
        );
    }
}