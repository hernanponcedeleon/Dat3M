package com.dat3m.dartagnan.prototype.program.event;

import com.dat3m.dartagnan.prototype.program.Register;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/*
    Memory events are the only events that access memory in some way (usually load/store).
    These include:
        - Core events like Store, Load, and LL/SC
        - Complex/Compound events like RMW, AMO, and MemCpy/MemSet.
        - Abstract events like SRCU and SMR protection (hazard pointers).

   NOTES:
        - Simple loads and stores perform exactly 1 access with known address, mode, and type.
        - RMW events (not yet compiled down), perform exactly 2 accesses (Mode.Store + Mode.Load)
        - MemCopy performs 2 accesses (Load + Store), but the accessType will be of
            unknown size (byte-array with unknown size?).
        - Other types of address-related events like SRCU and hazard pointer can be modelled with
           an access of Mode.Other and some special access type like "void" or possibly an "unknown type".
           The idea is that such memory events would still participate in the loc-relation.

    References:
     - SRCU is understood as special kind of load/store:
       https://github.com/torvalds/linux/blob/master/tools/memory-model/Documentation/explanation.txt
 */
public interface MemoryEvent extends Event, Register.Reader {
    List<MemoryAccess> getMemoryAccesses();

    @Override
    default Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> reads = new HashSet<>();
        for (MemoryAccess access : getMemoryAccesses()) {
            Register.collectRegisterReads(access.address(), Register.UsageType.ADDR, reads);
        }
        return reads;
    }
}
