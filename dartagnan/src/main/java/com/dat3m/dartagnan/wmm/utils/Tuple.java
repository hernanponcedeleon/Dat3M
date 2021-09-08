package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.Event;

public class Tuple implements Comparable<Tuple> {

    private final Event first;
    private final Event second;

    public Tuple(Event first, Event second) {
        this.first = first;
        this.second = second;
    }

    public Event getFirst(){
        return first;
    }

    public Event getSecond(){
        return second;
    }

    public String toString() {
        return "(" + first + ", " + second + ")";
    }

    @Override
    public int hashCode() {
        int a = first.getCId();
        int b = second.getCId();
        return  a ^ (31 * b + 0x9e3779b9 + (a << 6) + (a >> 2)); // Best hashing function ever :)
        // Alternatives:
        // --- a ^ (b + 0x9e3779b9 + (a << 6) + (a >> 2))
        // --- 31 * b + 0x9e3779b9 + (a << 6) + (a >> 2)
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        Tuple tObj = (Tuple) obj;
        return first.getCId() == tObj.getFirst().getCId()
                && second.getCId() == tObj.getSecond().getCId();
    }

    @Override
    public int compareTo(Tuple o) {
        int result = first.compareTo(o.first);
        return result != 0 ? result : second.compareTo(o.second);
    }


    // ================== Utility/Convenience methods ================
    public Tuple getInverse() {
    	return new Tuple(second, first);
    }

    public boolean isCrossThread() {
        return !isSameThread();
    }

    public boolean isSameThread() {
        return first.getThread() == second.getThread();
    }

    public boolean isForward() {
        return isSameThread() && first.getCId() < second.getCId();
    }

    public boolean isBackward() {
        return isSameThread() && first.getCId() > second.getCId();
    }

    public boolean isLoop() {
        return first.equals(second);
    }
}
