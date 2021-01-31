package com.dat3m.dartagnan.wmm.graphRefinement.graphs.dataStructures;

import java.util.Collection;

// NOT USED YET.
public interface Backtrackable {

    void backtrack(int to);
    boolean createBacktrackPoint(int identifier);
    int getCurrentBacktrackPoint();

    default int getLeastBacktrackPoint() { return 0; }

}
