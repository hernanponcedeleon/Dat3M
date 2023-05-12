package com.dat3m.dartagnan.programNew.event;

import com.dat3m.dartagnan.programNew.event.core.control.Label;

import java.util.List;
import java.util.Set;

/*
    Interface for all (direct) branching instructions.
    In LLVM, even indirect jumps have to list all possible destinations explicitly, so
    they are also covered by this interface.
    For indirect jumps in assembly/litmus code, we might need a different interface or need to figure out
    all possible targets (in the worst case, all labels are possible targets).
 */
public interface BranchingEvent extends Event, EventUser {

    // Returns a full list of all possible successors of this event.
    // There are no implicit successors: even for conditional jumps, the "else-case" must be listed explicitly.
    List<Label> getBranchingTargets();

    @Override
    default Set<Event> getReferencedEvents() {
        return Set.copyOf(getBranchingTargets());
    }
}
