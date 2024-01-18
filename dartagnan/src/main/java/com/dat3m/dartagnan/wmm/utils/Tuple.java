package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.Event;

public record Tuple(Event first, Event second) implements Comparable<Tuple> {

    public String toString() {
        return "(" + first + ", " + second + ")";
    }

    @Override
    public int hashCode() {
        int a = first.getGlobalId();
        int b = second.getGlobalId();
        return a ^ (31 * b + 0x9e3779b9 + (a << 6) + (a >> 2)); // Best hashing function ever :)
        // Alternatives:
        // --- a ^ (b + 0x9e3779b9 + (a << 6) + (a >> 2))
        // --- 31 * b + 0x9e3779b9 + (a << 6) + (a >> 2)
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        Tuple tObj = (Tuple) obj;
        return first.getGlobalId() == tObj.first().getGlobalId()
                && second.getGlobalId() == tObj.second().getGlobalId();
    }

    @Override
    public int compareTo(Tuple o) {
        int result = first.compareTo(o.first);
        return result != 0 ? result : second.compareTo(o.second);
    }

    // ================== Utility/Convenience methods ================

    public static boolean isForward(Event e1, Event e2) {
        return isSameThread(e1, e2) && e1.getGlobalId() < e2.getGlobalId();
    }

    public static boolean isCrossThread(Event e1, Event e2) {
        return e1.getThread() != null && !isSameFunction(e1, e2);
    }

    public static boolean isLoop(Event e1, Event e2) {
        return e1.equals(e2);
    }

    public static boolean isSameFunction(Event e1, Event e2) {
        return e1.getFunction() == e2.getFunction();
    }

    public static boolean isSameThread(Event e1, Event e2) {
        return e1.getThread() != null && isSameFunction(e1, e2);
    }

    public static boolean isBackward(Event e1, Event e2) {
        return isSameThread(e1, e2) && e1.getGlobalId() > e2.getGlobalId();
    }
}
