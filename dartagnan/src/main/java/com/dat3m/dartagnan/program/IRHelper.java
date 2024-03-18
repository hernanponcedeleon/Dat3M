package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;

import java.util.HashSet;
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
