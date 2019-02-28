package com.dat3m.dartagnan.program.arch.linux.event.rmw;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;

public abstract class RMWAbstract extends MemEvent implements RegWriter, RegReaderData {

    protected final Register resultRegister;
    protected final ExprInterface value;
    protected final String mo;
    protected ImmutableSet<Register> dataRegs;

    RMWAbstract(IExpr address, Register register, ExprInterface value, String mo) {
        super(address);
        this.resultRegister = register;
        this.value = value;
        this.mo = mo;
        this.dataRegs = value.getRegs();
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.READ, EType.WRITE,
                EType.RMW, EType.REG_WRITER, EType.REG_READER);
    }

    RMWAbstract(RMWAbstract other){
        super(other);
        this.resultRegister = other.resultRegister;
        this.value = other.value;
        this.mo = other.mo;
        this.dataRegs = other.dataRegs;
    }

    @Override
    public boolean is(String param){
        return super.is(param) || (mo != null && mo.equals(param));
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        throw new RuntimeException("Compilation to " + target + " is not supported for " + getClass().getName() + " " + mo);
    }
}
