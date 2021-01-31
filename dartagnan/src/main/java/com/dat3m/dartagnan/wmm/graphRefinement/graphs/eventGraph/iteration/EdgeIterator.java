package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.iteration;


import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.util.EdgeDirection;

import java.util.Iterator;

// Correctly implementing this class is highly subtle and error prone.
// It is advisable to read the specifications below.
public abstract class EdgeIterator implements Iterator<Edge> {
    // NOTE: The internal naming is done as if this was a general tuple iterator
    // first ~ tail, second ~ head

    protected boolean firstIsFixed;
    protected boolean secondIsFixed;

    // If true, we iterate as follows: For all <first>: For all <second> in Seconds(first):
    // If false, we iterate as follows: For all <second>: For all <first> in Firsts(second):
    protected boolean iterateFirstThenSecond;

    // These are assigned to by the implementing subclass during iteration.
    protected EventData first;
    protected EventData second;


    /* The following 4 methods need to be implemented and follow a certain specification.
     (1) <resetX> is called iff X is currently NULL.
              - If Y is also NULL, then it is the first <resetX> call and any starting element should be
                 assigned to X. Note that this only ever happens if <autoInit> gets called.
                 Alternatively, one may establish a starting point on construction and avoid <autoInit>
                 completely.
              - If Y is not NULL, then <resetX> shall assign the first X such that (X,Y)/(Y,X) is a valid pair.
              - In either case, it is possible to assign NULL to X if no valid starting element exists.
      (2) <nextX> is called iff X is NOT NULL.
              - If Y is NULL, then <nextX> shall assign a successor to X.
                The next value for Y will be found by <resetY>(*)
              - If Y is not NULL, then <nextX> shall assign a successor to X such that (X, Y)/ (Y, X)
                is a valid pair.
              - In either case, it is possible to assign NULL to X if no valid successor exists.
      (3) The iteration stops iff both <first> and <second> are simultaneously NULL or one
          is NULL and the other one is fixed.
      (*) In cases (1) and (2) it is allowed to NOT assign NULL if no partner exists,
          but try to establish a whole new starting point by changing both X and Y, or even
          set both to NULL to terminate iteration completely.
          This can be useful when some internal structure changes need to be made to find new elements
          (e.g. some underlying data/collection needs to change to support further iteration)
    */

    protected abstract void resetFirst();
    protected abstract void resetSecond();
    protected abstract void nextFirst();
    protected abstract void nextSecond();

    // One may override this method to implement custom construction for the objects.
    // This method should never change any assignments to <first> or <second>
    protected Edge construct() {
        return new Edge(first, second);
    }


    public EdgeIterator(boolean iterateFirstThenSecond) {
        this.iterateFirstThenSecond = iterateFirstThenSecond;
        firstIsFixed = secondIsFixed = false;
    }

    public EdgeIterator(EventData fixed, boolean firstIsFixed) {
        this.secondIsFixed = !(this.firstIsFixed = firstIsFixed);
        iterateFirstThenSecond = firstIsFixed;
        if (firstIsFixed) {
            this.first = fixed;
        } else {
            this.second = fixed;
        }
    }

    public EdgeIterator(EventData fixed, EdgeDirection dir) {
        this (fixed, dir == EdgeDirection.Outgoing);
    }


    @Override
    public boolean hasNext() {
        return first != null & second != null;
    }

    @Override
    public Edge next() {
        Edge tuple = construct();
        findNext();
        return tuple;
    }

    protected final void findNext() {

        if (iterateFirstThenSecond) {
            nextSecond();
            if (second == null && !firstIsFixed) {
                nextFirstInternal();
            }
        } else {
            nextFirst();
            if (first == null && !secondIsFixed) {
                nextSecondInternal();
            }
        }
    }

    private void nextFirstInternal() {
        do {
            nextFirst();
            if (first != null)
                resetSecond();
        } while (first != null && second == null);
    }

    private void nextSecondInternal() {
        do {
            nextSecond();
            if (second != null)
                resetFirst();
        } while (second != null && first == null);
    }

    protected final void autoInit() {
        if (firstIsFixed) {
            resetSecond();
        } else if (secondIsFixed) {
            resetFirst();
        } else {
            if (iterateFirstThenSecond) {
                resetFirst();
                if (first != null) {
                    resetSecond();
                    if (second == null) {
                        nextFirstInternal();
                    }
                }
            } else {
                resetSecond();
                if (second != null) {
                    resetFirst();
                    if (first == null) {
                        nextSecondInternal();
                    }
                }
            }
        }
    }


    public final Iterable<Edge> toIterable() {
        return new OneTimeIterable<>(this);
    }

}
