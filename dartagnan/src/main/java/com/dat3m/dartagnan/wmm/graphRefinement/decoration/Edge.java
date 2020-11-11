package com.dat3m.dartagnan.wmm.graphRefinement.decoration;

import com.dat3m.dartagnan.program.event.Event;

// An untyped edge.
// This is just a decoration for Tuple to use EventData instead of Event
public class Edge implements Comparable<Edge> {

    private EventData first;
    private EventData second;

    public Edge(EventData first, EventData second) {
        this.first = first;
        this.second = second;
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

    public Edge getInverse() { return new Edge(second, first); }

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

    @Override
    public int hashCode() {
        return (first.getId() << 16) + second.getId();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        Edge other= (Edge) obj;
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