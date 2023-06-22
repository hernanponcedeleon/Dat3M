package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.program.event.core.MemEvent;
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
    public boolean mayAlias(MemEvent e1, MemEvent e2) {
        return samePhysicalAddress(e1, e2) || wrappedAnalysis.mayAlias(e1, e2);
    }
    @Override
    public boolean mustAlias(MemEvent e1, MemEvent e2) {
        return samePhysicalAddress(e1, e2) || wrappedAnalysis.mustAlias(e1, e2);
    }

    // GPU memory models make use of virtual addresses.
    // This models same_location_r from the PTX Alloy model.
    // Checking address1 and address2 hold the same physical address
    private boolean samePhysicalAddress(MemEvent e1, MemEvent e2) {
        // TODO: Add support for pointers
        if (!(e1.getAddress() instanceof VirtualMemoryObject) || !(e2.getAddress() instanceof VirtualMemoryObject)) {
            return false;
        }
        VirtualMemoryObject addr1 = (VirtualMemoryObject) e1.getAddress();
        VirtualMemoryObject addr2 = (VirtualMemoryObject) e2.getAddress();
        return addr1.getPhysicalAddress() == addr2.getPhysicalAddress();
    }
}