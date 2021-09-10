package com.dat3m.dartagnan.analysis.saturation.searchTree;

public class EmptyNode extends SearchNode {
    @Override
    protected SearchNode copy() {
        return new EmptyNode();
    }
}
