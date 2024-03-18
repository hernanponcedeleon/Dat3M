package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.utils.DominatorTree;
import com.google.common.base.Preconditions;
import com.google.common.base.Predicate;
import com.google.common.collect.Iterables;
import com.google.common.collect.Sets;

import java.util.List;
import java.util.Set;

public class DominatorAnalysis {

    public static DominatorTree<Event> computePreDominatorTree(Event from, Event to) {
        Preconditions.checkArgument(from.getFunction() == to.getFunction(),
                "Cannot compute dominator tree between events of different functions.");
        final Predicate<Event> isInRange = (e -> from.getGlobalId() <= e.getGlobalId() && e.getGlobalId() <= to.getGlobalId());
        return new DominatorTree<>(from, e -> Iterables.filter(getSuccessors(e), isInRange));
    }

    public static DominatorTree<Event> computePostDominatorTree(Event from, Event to) {
        Preconditions.checkArgument(from.getFunction() == to.getFunction(),
                "Cannot compute dominator tree between events of different functions.");
        final Predicate<Event> isInRange = (e -> from.getGlobalId() <= e.getGlobalId() && e.getGlobalId() <= to.getGlobalId());
        return new DominatorTree<>(to, e -> Iterables.filter(getPredecessors(e), isInRange));
    }

    // ==============================================================================================================
    // Internals

    private static Iterable<? extends Event> getSuccessors(Event e) {
        final boolean hasSucc = (e.getSuccessor() != null && !IRHelper.isAlwaysBranching(e));
        if (e instanceof CondJump jump) {
            return hasSucc ? List.of(jump.getSuccessor(), jump.getLabel()) : List.of(jump.getLabel());
        } else {
            return hasSucc ? List.of(e.getSuccessor()) : List.of();
        }
    }

    private static Iterable<? extends Event> getPredecessors(Event e) {
        final boolean hasPred = (e.getPredecessor() != null && !IRHelper.isAlwaysBranching(e.getPredecessor()));
        if (e instanceof Label label) {
            return hasPred ? Sets.union(label.getJumpSet(), Set.of(e.getPredecessor())) : label.getJumpSet();
        } else {
            return hasPred ? List.of(e.getPredecessor()) : List.of();
        }
    }


}
