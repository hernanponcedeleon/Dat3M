package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.program.event.core.Alloc;
import com.dat3m.dartagnan.program.event.core.MemFree;
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
    public boolean mayAlias(MemoryCoreEvent e1, MemoryCoreEvent e2) {
        return samePhysicalAddress(e1, e2) || wrappedAnalysis.mayAlias(e1, e2);
    }
    @Override
    public boolean mustAlias(MemoryCoreEvent e1, MemoryCoreEvent e2) {
        return samePhysicalAddress(e1, e2) || wrappedAnalysis.mustAlias(e1, e2);
    }

    @Override
    public boolean mayAlias(Alloc a, MemoryCoreEvent e) {
        throw new IllegalArgumentException("No dynamic memory allocation for virtual memory");
    }
    @Override
    public boolean mustAlias(Alloc a, MemoryCoreEvent e) {
        throw new IllegalArgumentException("No dynamic memory allocation for virtual memory");
    }

    @Override
    public boolean mayAlias(Alloc a, MemFree f) {
        throw new IllegalArgumentException("No dynamic memory allocation for virtual memory");
    }

    @Override
    public boolean mustAlias(Alloc a, MemFree f) {
        throw new IllegalArgumentException("No dynamic memory allocation for virtual memory");
    }

    @Override
    public boolean mayAlias(MemFree a, MemFree b) {
        throw new IllegalArgumentException("No dynamic memory allocation for virtual memory");
    }

    @Override
    public boolean mustAlias(MemFree a, MemFree b) {
        throw new IllegalArgumentException("No dynamic memory allocation for virtual memory");
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