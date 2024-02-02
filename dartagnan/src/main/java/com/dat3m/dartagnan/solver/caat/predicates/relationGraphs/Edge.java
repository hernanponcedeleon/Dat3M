package com.dat3m.dartagnan.solver.caat.predicates.relationGraphs;


import com.dat3m.dartagnan.solver.caat.predicates.AbstractDerivable;

public class Edge extends AbstractDerivable implements Comparable<Edge> {
    protected final int dId1;
    protected final int dId2;

    public int getFirst() { return dId1; }
    public int getSecond() { return dId2; }

    public Edge(int id1, int id2, int time, int derivLength) {
        super(time, derivLength);
        this.dId1 = id1;
        this.dId2 = id2;
    }

    public Edge(int id1, int id2) {
        this(id1, id2, 0, 0);
    }


    @Override
    public Edge with(int time, int derivationLength) { return new Edge(dId1, dId2, time, derivationLength); }
    @Override
    public Edge withTime(int time) { return with(time, derivLength); }
    @Override
    public Edge withDerivationLength(int derivationLength) { return with(time, derivationLength); }


    public boolean isLoop() { return dId1 == dId2; }
    public Edge inverse() { return new Edge(dId2, dId1, time, derivLength); }

    @Override
    public int compareTo(Edge o) {
        int res = this.dId1 - o.dId1;
        return res != 0 ? res : this.dId2 - o.dId2;
    }

    @Override
    public int hashCode() {
        return 127 * dId1 + dId2;
        //int a = dId1;
        //return  a ^ (31 * dId2 + 0x9e3779b9 + (a << 6) + (a >> 2)); // Best hashing function ever :)
    }


    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        return equals((Edge)obj);
    }

    public boolean equals(Edge e) {
        return this.dId1 == e.dId1 && this.dId2 == e.dId2;
    }

    @Override
    public String toString() {
        return "(" + dId1 + "," + dId2 + ")";
    }
}
