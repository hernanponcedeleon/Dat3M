package com.dat3m.dartagnan.analysis.graphRefinement.searchTree;

import com.dat3m.dartagnan.analysis.graphRefinement.GraphRefinement;

import java.util.List;
import java.util.function.Predicate;

public class SearchTree {

    private final FakeRoot fakeRoot = new FakeRoot();
    private final GraphRefinement refinement;

    public GraphRefinement getRefinement() {
        return refinement;
    }

    public SearchTree(GraphRefinement refinement) {
        this.refinement = refinement;
    }

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
        SearchTree copy = new SearchTree(refinement);
        copy.getRoot().replaceBy(getRoot().copy());
        return copy;
    }
}
