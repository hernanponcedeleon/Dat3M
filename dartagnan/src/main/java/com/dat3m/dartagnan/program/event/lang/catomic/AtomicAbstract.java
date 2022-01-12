package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.linux.utils.Tag;
import com.google.common.collect.ImmutableSet;

import java.util.List;

public abstract class AtomicAbstract extends MemEvent implements RegWriter, RegReaderData {

    protected final Register resultRegister;
    protected final IExpr value;
    protected ImmutableSet<Register> dataRegs;

    AtomicAbstract(IExpr address, Register register, IExpr value, String mo) {
        super(address, mo);
        this.resultRegister = register;
        this.value = value;
        this.dataRegs = value.getRegs();
        addFilters(Tag.ANY, Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.WRITE,
                Tag.RMW, Tag.REG_WRITER, Tag.REG_READER);
    }

    AtomicAbstract(AtomicAbstract other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.value = other.value;
        this.dataRegs = other.dataRegs;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public ImmutableSet<Register> getDataRegs() {
        return dataRegs;
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public List<Event> compile(Arch target) {
        throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
    }
}