package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;

import java.util.List;

public abstract class AtomicAbstract extends MemEvent implements RegWriter, RegReaderData {

    protected final Register resultRegister;
    protected final ExprInterface value;
    protected ImmutableSet<Register> dataRegs;

    AtomicAbstract(IExpr address, Register register, ExprInterface value, String mo) {
        super(address, mo);
        this.resultRegister = register;
        this.value = value;
        this.dataRegs = value.getRegs();
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.READ, EType.WRITE,
                EType.RMW, EType.REG_WRITER, EType.REG_READER);
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
        throw new RuntimeException("Compilation to " + target + " is not supported for " + getClass().getName() + " " + mo);
    }

}
