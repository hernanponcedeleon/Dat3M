package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.memory.MemoryObject;

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
        return virtuallyAlias(e1, e2) || wrappedAnalysis.mayAlias(e1, e2); // + version for mustAlias
    }
    @Override
    public boolean mustAlias(MemEvent e1, MemEvent e2) {
        return virtuallyAlias(e1, e2) || wrappedAnalysis.mustAlias(e1, e2);
    }

    // GPU memory models make use of virtual addresses.
    // This models same_alias_r from the PTX Alloy model
    // There are 4 cases to consider ("alias" below refers to the syntax
    // used when allocating memory in the preamble of the litmus test).
    // (1) - both addresses are virtual: they should both alias to the same physical address
    // (2,3) - one virtual, one physical: the virtual should alias to the physical one
    // (4) - both addresses are physical: the traditional alias analysis handles this
    public boolean virtuallyAlias(MemEvent e1, MemEvent e2) {
        // TODO: Add support for pointers, i.e. if `x` and `y` virtually alias,
        // then `x + offset` and `y + offset` should too
        if (!(e1.getAddress() instanceof MemoryObject) || !(e2.getAddress() instanceof MemoryObject)) {
            return false;
        }
        MemoryObject addr1 = (MemoryObject) e1.getAddress();
        MemoryObject addr2 = (MemoryObject) e2.getAddress();
        boolean isAdd1Virtual = addr1.isVirtual();
        boolean isAdd2Virtual = addr2.isVirtual();
        if (isAdd1Virtual && isAdd2Virtual) {
            // Case (1)
            // Virtual addresses always have an alias
            assert(addr1.getAlias() != null);
            assert(addr2.getAlias() != null);
            // addr1, addr2 should virtually alias to the same physical Address
            return addr1.getAlias() == addr2.getAlias();
        } else if (!isAdd1Virtual && isAdd2Virtual) {
            // Case (2)
            // Virtual addresses always have an alias
            assert(addr2.getAlias() != null);
            // addr2 should virtually alias to physical addr1
            return addr1 == addr2.getAlias();
        } else if (isAdd1Virtual) {
            // Case (3)
            // Virtual addresses always have an alias
            assert(addr1.getAlias() != null);
            // addr1 should virtually alias to physical addr2
            return addr1.getAlias() == addr2;
        } else {
            // Case (4)
            // The normal AliasAnalysis handles the case where both addresses are physical
            return false;
        }
    }
}