package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.Event;

public class Tuple implements Comparable<Tuple> {

    private Event first;
    private Event second;

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
        //return "(" + first.getCId() + ", " + second.getCId() + ")";

    }

    public Tuple getInverse() { return new Tuple(second, first); }

    @Override
    public int hashCode() {
        return (first.getCId() << 16) + second.getCId();
    }
    // Notes on hashCode: Java's hashtable uses powers of two as capacity
    // for which modulo operations can be replaced by efficient bit masking.
    // Since this only ever looks into the lower bits of the hash code,
    // the above hashCode function would be really bad since the entry <first> gets ignored
    // for all hashtables with size <= 2^16.
    // To compensate this flaw, Java's hashmap computes its hashcode by
    // (key.hashCode) ^ ((key.hashCode) >>> 16). This effectively translates to
    // hashCode = <first.getCId> ^ <second.getCId> for tables with <= 2^16 entries.
    // This hashing function is associative (i.e. reversed tuples have the same hashcode)
    // and all same-entry tuples get mapped to 0. These are bad properties.
    // Instead, we should multiply <first.getCId> by some prime,
    // ideally a Mersenne Prime p like 31 or 8191 for which multiplication is fast. This also
    // produces unique hashCodes for all pairs if the compilation Id is bounded by p,
    // a highly likely case if p = 8191.


    public static int toHashCode(int a, int b){
        return (a << 16) + b;
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
        if(result == 0){
            return second.compareTo(o.second);
        }
        return result;
    }
}
