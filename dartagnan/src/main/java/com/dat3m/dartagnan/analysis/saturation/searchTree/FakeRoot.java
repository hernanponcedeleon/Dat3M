package com.dat3m.dartagnan.analysis.saturation.searchTree;

// A FakeRoot is a root decision node with no decision literal and only
// one positive child. It is used as a convenience to avoid empty trees.
class FakeRoot extends DecisionNode {

    public FakeRoot() {
        super(null);
        negative = null;
    }

    public SearchNode getTrueRoot() {
        return positive;
    }

}
