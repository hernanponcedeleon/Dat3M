package com.dat3m.dartagnan.wmm.graphRefinement.searchTree;

class FakeRoot extends DecisionNode {

    public FakeRoot() {
        super(null);
        negative = null;
    }

    public SearchNode getTrueRoot() {
        return positive;
    }

    public void setTrueRoot(SearchNode node) {
        this.positive = node;
    }
}
