package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.pointer.PtrAddExpr;
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
    public boolean mayAlias(MemoryCoreEvent e1, MemoryCoreEvent e2) {
        return samePhysicalAddress(e1, e2) || wrappedAnalysis.mayAlias(e1, e2);
    }
    @Override
    public boolean mustAlias(MemoryCoreEvent e1, MemoryCoreEvent e2) {
        return samePhysicalAddress(e1, e2) || wrappedAnalysis.mustAlias(e1, e2);
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
        // FIXME: Ugly code because somewhere a (virtual address + 0) is being generated.
        VirtualMemoryObject v1;
        VirtualMemoryObject v2;

        if (e1.getAddress() instanceof VirtualMemoryObject addr){
            v1 = addr;
        }else if(e1.getAddress() instanceof PtrAddExpr addr){
            v1 =(VirtualMemoryObject) addr.getBase();
        }else{return false;}

        if (e2.getAddress() instanceof VirtualMemoryObject addr){
            v2 = addr;
        }else if(e2.getAddress() instanceof PtrAddExpr addr){
            v2 =(VirtualMemoryObject) addr.getBase();
        }else{return false;}

        return v1.getPhysicalAddress() == v2.getPhysicalAddress();
    }
}