package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;

public class VirtualAliasAnalysis implements AliasAnalysis {
    private final AliasAnalysis wrappedAnalysis;

    private VirtualAliasAnalysis(AliasAnalysis analysis) {
        this.wrappedAnalysis = analysis;
    }

    public static AliasAnalysis wrap(AliasAnalysis analysis) {
        return new VirtualAliasAnalysis(analysis);
    }

    @Override
    public boolean mustAlias(Event a, Event b) {
        if (a instanceof MemoryCoreEvent ma && b instanceof MemoryCoreEvent mb) {
            return mustAccessSameAddress(ma, mb);
        }
        throw new IllegalArgumentException("Unsupported event types for VirtualAliasAnalysis");
    }

    @Override
    public boolean mayAlias(Event a, Event b) {
        if (a instanceof MemoryCoreEvent ma && b instanceof MemoryCoreEvent mb) {
            return mayAccessSameAddress(ma, mb);
        }
        throw new IllegalArgumentException("Unsupported event types for VirtualAliasAnalysis");
    }

    private boolean mayAccessSameAddress(MemoryCoreEvent e1, MemoryCoreEvent e2) {
        return samePhysicalAddress(e1, e2) || wrappedAnalysis.mayAlias(e1, e2);
    }

    private boolean mustAccessSameAddress(MemoryCoreEvent e1, MemoryCoreEvent e2) {
        return samePhysicalAddress(e1, e2) || wrappedAnalysis.mustAlias(e1, e2);
    }

    // GPU memory models make use of virtual addresses.
    // This models same_location_r from the PTX Alloy model.
    // Checking address1 and address2 hold the same physical address
    private boolean samePhysicalAddress(MemoryCoreEvent e1, MemoryCoreEvent e2) {
        // TODO: Add support for pointers
        if (!(e1.getAddress() instanceof VirtualMemoryObject addr1)
                || !(e2.getAddress() instanceof VirtualMemoryObject addr2)) {
            return false;
        }
        return addr1.getPhysicalAddress() == addr2.getPhysicalAddress();
    }
}