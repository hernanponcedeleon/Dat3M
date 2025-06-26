package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;

import java.util.List;

public class VirtualAliasAnalysis implements AliasAnalysis {
    private final AliasAnalysis wrappedAnalysis;
    private final Config config;

    private VirtualAliasAnalysis(AliasAnalysis analysis, Config config) {
        this.wrappedAnalysis = analysis;
        this.config = config;
    }

    public static AliasAnalysis wrap(AliasAnalysis analysis, Config config) {
        return new VirtualAliasAnalysis(analysis, config);
    }

    @Override
    public boolean mayAlias(Event e1, Event e2) {
        if (e1 instanceof MemoryCoreEvent me1 && e2 instanceof MemoryCoreEvent me2) {
            return samePhysicalAddress(me1, me2) || wrappedAnalysis.mayAlias(me1, me2);
        }
        return true;
    }

    @Override
    public boolean mustAlias(Event e1, Event e2) {
        if (e1 instanceof MemoryCoreEvent me1 && e2 instanceof MemoryCoreEvent me2) {
            return samePhysicalAddress(me1, me2) || wrappedAnalysis.mustAlias(me1, me2);
        }
        return false;
    }

    @Override
    public boolean mayObjectAlias(Event a, Event b) {
        return true;
    }

    @Override
    public boolean mustObjectAlias(Event a, Event b) {
        return false;
    }

    @Override
    public List<Integer> mayMixedSizeAccesses(MemoryCoreEvent event) {
        return config.defaultMayMixedSizeAccesses(event);
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