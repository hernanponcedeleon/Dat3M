package com.dat3m.dartagnan.wmm.graphRefinement.searchTree;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

public class SearchTree {

    private final FakeRoot fakeRoot = new FakeRoot();

    public SearchNode getRoot() {
        return fakeRoot.getTrueRoot();
    }

    public void setRoot(SearchNode newRoot) {
        getRoot().replaceBy(newRoot);
    }

    public List<? extends SearchNode> findNodes(Predicate<SearchNode> pred) {
        return getRoot().findNodes(pred);
    }


    public SearchTree copy() {
        SearchTree copy = new SearchTree();
        copy.getRoot().replaceBy(getRoot().copy());
        return copy;
    }
}
