package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class IRHelper {

    private IRHelper() {}

    public static Set<Event> bulkDelete(Set<Event> toBeDeleted) {
        final Set<Event> nonDeleted = new HashSet<>();
        for (Event e : toBeDeleted) {
            if (toBeDeleted.containsAll(e.getUsers())) {
                e.forceDelete();
            } else {
                nonDeleted.add(e);
            }
        }
        return nonDeleted;
    }

    public static List<Event> getEventsFromTo(Event from, Event to) {
        Preconditions.checkArgument(from.getFunction() == to.getFunction());
        final List<Event> events = new ArrayList<>();
        Event cur = from;
        do {
            events.add(cur);
            if (cur == to) {
                break;
            }
            cur = cur.getSuccessor();
        } while (cur != null);
        assert cur != null;

        return events;
    }

    /*
        Returns true if the syntactic successor of <e> (e.getSuccessor()) is not (generally) a semantic successor,
        because <e> always jumps/branches/terminates etc.
     */
    public static boolean isAlwaysBranching(Event e) {
        return e instanceof Return
                || e instanceof AbortIf abort && abort.getCondition() instanceof BoolLiteral b && b.getValue()
                || e instanceof CondJump jump && jump.isGoto();
    }
}
