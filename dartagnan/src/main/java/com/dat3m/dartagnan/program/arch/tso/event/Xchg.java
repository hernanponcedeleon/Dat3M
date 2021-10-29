package com.dat3m.dartagnan.program.arch.tso.event;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.tso.utils.EType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;

public class Xchg extends MemEvent implements RegWriter, RegReaderData {

    private final Register resultRegister;
    private final ImmutableSet<Register> dataRegs;

    public Xchg(Address address, Register register) {
        super(address, null);
        this.resultRegister = register;
        this.dataRegs = ImmutableSet.of(resultRegister);
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.READ, EType.WRITE, EType.ATOM, EType.REG_WRITER, EType.REG_READER);
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
        Preconditions.checkArgument(target == Arch.TSO, "Compilation of xchg is not implemented for " + target);
        
        Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Load load = newRMWLoad(dummyReg, address, null);
        load.addFilters(EType.ATOM);

        RMWStore store = newRMWStore(load, address, resultRegister, null);
        store.addFilters(EType.ATOM);

        Local updateReg = newLocal(resultRegister, dummyReg);

        return eventSequence(
                load,
                store,
                updateReg
        );
    }

}
