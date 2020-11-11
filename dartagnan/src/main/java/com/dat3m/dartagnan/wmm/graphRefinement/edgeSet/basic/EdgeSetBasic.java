package com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.basic;

import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EventLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.edgeSet.EdgeSetAbstract;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.*;

public abstract class EdgeSetBasic extends EdgeSetAbstract {

    public EdgeSetBasic(RelationData rel) {
        super(rel);
    }

    @Override
    public Set<Edge> addAll(Set<Edge> edges, int time) {
        return super.addAll(edges, time);
    }

    @Override
    public boolean add(Edge edge, int time) {
        return super.add(edge, time);
    }

}
