package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.Type;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.MemoryAccess;
import com.dat3m.dartagnan.prototype.program.event.MemoryEvent;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/*

    Core memory events are the only memory events whose analysis and encoding we fully support.
    These memory events are "simple" in the sense that they always access a single address with a single access type.
    There are 4 major types of core memory events: Load, Store, ReadModifyWrite, and "Generic".
        - Load/Store are as expected, but they may have more specialized subclasses like Init, RMWLoadExclusive, and RMWStore
        - ReadModifyWrite is a core event that represents single-node(!) RMWs.
          Typically, RMWs can also be implemented with two events using LL/SC (i.e. Load + Store).
        - "GenericMemoryEvent" is a baseclass for abstract notions of memory events that neither load nor store,
           but still have a memory address (e.g., SRCU or hazard pointers).

     All other high-level/complex memory events need to get compiled down to one or more core memory events.
 */
public interface MemoryCoreEvent extends MemoryEvent {

    Expression getAddress();
    void setAddress(Expression address);

    Type getAccessType();
    void setAccessType(Type type);

    MemoryAccess.Mode getAccessMode(); // Not sure if needed anymore.
    String getMo(); // Not sure if needed...

    @Override
    default List<MemoryAccess> getMemoryAccesses() {
        return List.of(new MemoryAccess(getAddress(), getAccessType(), getAccessMode()));
    }

    @Override
    default Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(getAddress(), Register.UsageType.ADDR, new HashSet<>());
    }
}
