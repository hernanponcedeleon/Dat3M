package com.dat3m.dartagnan.analysis.graphRefinement.searchTree;

public class EmptyNode extends SearchNode {
    @Override
    protected SearchNode copy() {
        return new EmptyNode();
    }
}
