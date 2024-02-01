package com.dat3m.dartagnan.solver.onlineCaat;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.ArrayList;
import java.util.List;

public record RelationInfo(List<EdgeInfo> edges) implements EncodingInfo {

    public RelationInfo() {
        this(new ArrayList<>());
    }

    public void add(Relation relation, Event source, Event target) {
        edges.add(new EdgeInfo(relation, source, target));
    }
}
