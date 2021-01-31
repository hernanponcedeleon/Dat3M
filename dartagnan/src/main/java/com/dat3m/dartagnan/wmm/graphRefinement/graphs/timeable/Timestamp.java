package com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable;

// Timestamps are intentionally mutable and should NOT be used as
// keys in a hashtable. They will most likely NOT give expected results.
public class Timestamp implements Comparable<Timestamp> {
    public static final Timestamp ZERO = new Timestamp(0);
    public static final Timestamp INVALID = new Timestamp(Integer.MAX_VALUE);

    private int time;

    public int getTime() { return time; }
    public boolean isValid() { return time < Integer.MAX_VALUE; }
    public boolean isInvalid() { return time == Integer.MAX_VALUE; }
    public boolean isInitial() { return time == 0;}

    public Timestamp(int time) {
        this.time = time;
    }

    public Timestamp next() {
        return isInvalid() ? INVALID :  new Timestamp(time + 1);
    }

    public void invalidate() {
        // We don't allow invalidation of ZERO stamps
        if (!this.equals(ZERO))
            time = Integer.MAX_VALUE;
    }

    @Override
    public int compareTo(Timestamp o) {
        return this.time - o.time;
    }

    @Override
    public int hashCode() {
        // Just to satisfy the specification of hashCode and equals.
        // DON'T EVER USE THIS CLASS AS A KEY
        return time;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null || getClass() != obj.getClass() )
            return false;
        return compareTo((Timestamp)obj) == 0;
    }

    public boolean equals(Timestamp t) {
        return this.time == t.time;
    }

    @Override
    public String toString() {
        return Integer.toString(time);
    }

    public static Timestamp min(Timestamp a, Timestamp b) {
        return a.time < b.time ? a : b;
    }

    public static Timestamp max(Timestamp a, Timestamp b) {
        return a.time >= b.time ? a : b;
    }
}
