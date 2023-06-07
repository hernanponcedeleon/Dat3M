package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.HashSet;
import java.util.Set;

public interface MemoryEvent extends Event, RegReader {

    Expression getAddress();
    void setAddress(Expression address);

    Expression getMemValue();
    void setMemValue(Expression value);

    String getMo();
    void setMo(String mo);

    @Override
    default Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(getAddress(), Register.UsageType.ADDR, new HashSet<>());
    }

    @Override
    default <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitMemEvent(this);
    }
}
