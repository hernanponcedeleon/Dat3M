package com.dat3m.dartagnan.wmm.graphRefinement.searchTree;

public class EmptyNode extends SearchNode {
    @Override
    protected SearchNode copy() {
        return new EmptyNode();
    }
}
