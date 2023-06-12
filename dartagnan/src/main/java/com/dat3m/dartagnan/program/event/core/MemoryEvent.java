package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.HashSet;
import java.util.Set;

public interface MemoryEvent extends Event, RegReader {

    // TODO: Make this a List<MemoryAccess> to properly support multi-access events like MemCopy and RMW
    MemoryAccess getMemoryAccess();

    @Override
    default Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(getMemoryAccess().address(), Register.UsageType.ADDR, new HashSet<>());
    }

    @Override
    default <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitMemEvent(this);
    }
}
