package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.event.core.Event;

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
}
