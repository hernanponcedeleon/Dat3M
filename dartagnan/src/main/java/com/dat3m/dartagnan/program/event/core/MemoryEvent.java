package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;

public interface MemoryEvent extends Event, RegReader {

    IExpr getAddress();
    void setAddress(IExpr address);

    ExprInterface getMemValue();
    void setMemValue(ExprInterface value);

    String getMo();
    void setMo(String mo);

    @Override
    Set<Register.Read> getRegisterReads();

    boolean canRace();

    @Override
    <T> T accept(EventVisitor<T> visitor);
}
