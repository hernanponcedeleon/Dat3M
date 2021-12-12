package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Map;
import java.util.Set;

public class CtrlDepGraph extends DepGraph {

    @Override
    protected Map<EventData, Set<EventData>> getDependencyMap() {
        return model.getCtrlDepMap();
    }
}
