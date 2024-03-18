package com.dat3m.dartagnan.program.event;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.Register.*;

public interface MemoryEvent extends RegReader {

    List<MemoryAccess> getMemoryAccesses();

    @Override
    default Set<Read> getRegisterReads() {
        final Set<Read> regReads = new HashSet<>();
        getMemoryAccesses().forEach(access -> collectRegisterReads(access.address(), UsageType.ADDR, regReads));
        return regReads;
    }

    @Override
    default <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitMemEvent(this);
    }
}
