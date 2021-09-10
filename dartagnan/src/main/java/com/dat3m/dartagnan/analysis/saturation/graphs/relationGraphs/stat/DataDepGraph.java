package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.stat;

import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Map;
import java.util.Set;

public  class DataDepGraph extends DepGraph {

    @Override
    protected Map<EventData, Set<EventData>> getDependencyMap() {
        return model.getDataDepMap();
    }
}
