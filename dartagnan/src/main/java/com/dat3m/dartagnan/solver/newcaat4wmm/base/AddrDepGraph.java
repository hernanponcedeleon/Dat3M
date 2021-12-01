package com.dat3m.dartagnan.solver.newcaat4wmm.base;

import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Map;
import java.util.Set;

public class AddrDepGraph extends DepGraph {

    @Override
    protected Map<EventData, Set<EventData>> getDependencyMap() {
        return model.getAddrDepMap();
    }
}
