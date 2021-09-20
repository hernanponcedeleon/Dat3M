package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs;

import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.utils.Tuple;

// An untyped edge.
// This is just a decoration for Tuple to use EventData instead of Event.
// Additionally, it contains information used for Saturation.
public class Edge implements Comparable<Edge> {

    private final EventData first;
    private final EventData second;
    //private final Timestamp time;
    private final int time;
    private final int derivLength;

    public Edge(EventData first, EventData second, int time, int derivLength) {
        this.first = first;
        this.second = second;
        this.time = time;
        this.derivLength = derivLength;
    }

    public Edge(EventData first, EventData second, int time) {
        this (first, second, time, 0);
    }

    public Edge(EventData first, EventData second) {
        this (first, second, 0, 0);
    }

    public EventData getFirst(){
        return first;
    }
    public EventData getSecond(){
        return second;
    }
    public int getTime() {
        return time;
    }

    public int getDerivationLength() { return derivLength; }

    public String toString() {
        return "(" + first.toString() + ", " + second.toString() + ")";
    }

    public Tuple toTuple() {
        return new Tuple(first.getEvent(), second.getEvent());
    }
    public Edge inverse() { return new Edge(second, first, time, derivLength); }


    public boolean isInternal() { return first.getThread() == second.getThread();}
    public boolean isExternal() {
        return !isInternal();
    }

    public boolean isBackwardEdge() {
        return isInternal() && first.getLocalId() > second.getLocalId();
    }
    public boolean isForwardEdge() {
        return isInternal() && first.getLocalId() < second.getLocalId();
    }
    public boolean isLoop() { return first.equals(second); }
    public boolean isLocEdge()  { return first.isMemoryEvent() && second.isMemoryEvent()
            && first.getAccessedAddress().equals(second.getAccessedAddress()); }

    public Edge withTime(int time) { return new Edge(first, second, time, derivLength); }
    public Edge withDerivLength(int derivLength) { return new Edge(first, second, time, derivLength); }
    public Edge with(int time, int derivLength) { return new Edge(first, second, time, derivLength); }

    @Override
    public int hashCode() {
        int a = first.getId();
        int b = second.getId();
        return  a ^ (31 * b + 0x9e3779b9 + (a << 6) + (a >> 2)); // Best hashing function ever :)
    }


    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        Edge other = (Edge) obj;
        return first.equals(other.first) && second.equals(other.second);
    }

    @Override
    public int compareTo(Edge o) {
        int result = first.compareTo(o.first);
        return result != 0 ? result : second.compareTo(o.second);
    }
}