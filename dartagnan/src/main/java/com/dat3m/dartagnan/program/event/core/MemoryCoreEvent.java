package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.HashSet;
import java.util.Set;

public interface MemoryCoreEvent extends MemoryEvent, RegReader {

    IExpr getAddress();
    Type getAccessType();

    @Override
    default Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(getAddress(), Register.UsageType.ADDR, new HashSet<>());
    }

    @Override
    default <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitMemEvent(this);
    }
}
