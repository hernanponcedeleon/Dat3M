package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.core.AbstractEvent;

import java.util.function.Function;

public class Tuple implements Comparable<Tuple> {

    private final AbstractEvent first;
    private final AbstractEvent second;

    public Tuple(AbstractEvent first, AbstractEvent second) {
        this.first = first;
        this.second = second;
    }

    public AbstractEvent getFirst(){
        return first;
    }

    public AbstractEvent getSecond(){
        return second;
    }

    public String toString() {
        return "(" + first + ", " + second + ")";
    }

    @Override
    public int hashCode() {
        int a = first.getGlobalId();
        int b = second.getGlobalId();
        return  a ^ (31 * b + 0x9e3779b9 + (a << 6) + (a >> 2)); // Best hashing function ever :)
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
        return first.getGlobalId() == tObj.getFirst().getGlobalId()
                && second.getGlobalId() == tObj.getSecond().getGlobalId();
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

    public Tuple permute(Function<AbstractEvent, AbstractEvent> p) {
        return new Tuple(p.apply(first), p.apply(second));
    }

    public boolean isCrossThread() {
        return !isSameThread();
    }

    public boolean isSameThread() {
        return first.getThread() == second.getThread();
    }

    public boolean isForward() {
        return isSameThread() && first.getGlobalId() < second.getGlobalId();
    }

    public boolean isBackward() {
        return isSameThread() && first.getGlobalId() > second.getGlobalId();
    }

    public boolean isLoop() {
        return first.equals(second);
    }
}
