package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.Register.*;

public interface MemoryEvent extends Event, RegReader {

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
