package com.dat3m.dartagnan.analysis.saturation.searchTree;

import java.util.List;
import java.util.function.Predicate;

/*
    The SearchTree is a binary decision tree.
    Its inner nodes are binary decision nodes containing a co-literal as decision parameter.
    Its leaf nodes contain the inconsistencyReasons that were found during Saturation.

    Implementation notes:
       - The SearchTree is never empty and always contains a special root node "FakeRoot".
       - Likewise, DecisionNodes are never childless and instead use "EmptyNode" as children.
 */
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
