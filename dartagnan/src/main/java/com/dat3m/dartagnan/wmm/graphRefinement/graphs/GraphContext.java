package com.dat3m.dartagnan.wmm.graphRefinement.graphs;

import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.VerificationContext;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.DependencyGraph;


// Not used yet
public class GraphContext {
    private VerificationContext verificationContext;
    private ModelContext modelContext;

    private DependencyGraph<RelationData> relDepGraph;


    public GraphContext(VerificationContext context) {
        this.verificationContext = context;

    }



}
