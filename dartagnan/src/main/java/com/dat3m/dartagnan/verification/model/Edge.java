package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.utils.timeable.Timeable;
import com.dat3m.dartagnan.utils.timeable.Timestamp;

// An untyped edge.
// This is just a decoration for Tuple to use EventData instead of Event
// Addtionally, it contains timing information used for refinement
public class Edge implements Comparable<Edge>, Timeable {

    private final EventData first;
    private final EventData second;
    private Timestamp time;

    public Edge(EventData first, EventData second, Timestamp time) {
        this.first = first;
        this.second = second;
        this.time = time;
    }

    public Edge(EventData first, EventData second) {
        this (first, second, Timestamp.ZERO);
    }

    public EventData getFirst(){
        return first;
    }

    public EventData getSecond(){
        return second;
    }

    public String toString() {
        //return "(" + first + ", " + second + ")";
        return "(" + first.toString() + ", " + second.toString() + ")";
    }

    public Timestamp getTime() {
        return time;
    }

    public Edge getInverse() { return new Edge(second, first, time); }

    public boolean isCrossEdge() {
        return !first.getThread().equals(second.getThread());
    }

    public boolean isBackwardEdge() {
        return !isCrossEdge() && first.getLocalId() > second.getLocalId();
    }

    public boolean isForwardEdge() {
        return !isCrossEdge() && first.getLocalId() < second.getLocalId();
    }

    public boolean isLoop() {
        return first.equals(second);
    }

    public boolean isLocEdge()  { return first.isMemoryEvent() && second.isMemoryEvent()
            && first.getAccessedAddress() == second.getAccessedAddress(); }

    public void normalizeTime() {
        if (time.isInitial())
            time = Timestamp.ZERO;
        else if (time.isInvalid())
            time = Timestamp.INVALID;
    }

    public Edge withTimestamp(Timestamp t) {
        return new Edge(first, second, t);
    }

    @Override
    public int hashCode() {
        return (first.getId() * 8191) + second.getId();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        Edge other = (Edge) obj;
        return first.equals(other.first)
                && second.equals(other.second);
    }

    @Override
    public int compareTo(Edge o) {
        int result = first.compareTo(o.first);
        if(result == 0){
            return second.compareTo(o.second);
        }
        return result;
    }
}