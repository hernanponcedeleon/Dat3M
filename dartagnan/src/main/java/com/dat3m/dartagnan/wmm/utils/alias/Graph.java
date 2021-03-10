package com.dat3m.dartagnan.wmm.utils.alias;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Address;
import com.google.common.collect.ImmutableSet;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class Graph {

    private final Map<Object, Set<Object>> edges = new HashMap<>();
    private final Map<Object, Set<Address>> addresses = new HashMap<>();
    private final Map<Register, Set<MemEvent>> events = new HashMap<>();
    private final Map<Register, Map<Integer, SSAReg>> ssa = new HashMap<>();

    boolean addEdge(Object v1, Object v2){
        edges.putIfAbsent(v1, new HashSet<>());
        return edges.get(v1).add(v2);
    }

    Set<Object> getEdges(Object v){
        return edges.getOrDefault(v, ImmutableSet.of());
    }

    void addAddress(Object v, Address a){
        addresses.putIfAbsent(v, new HashSet<>());
        addresses.get(v).add(a);
    }

    boolean addAllAddresses(Object v, Set<Address> s){
        addresses.putIfAbsent(v, new HashSet<>());
        return addresses.get(v).addAll(s);
    }

    Set<Address> getAddresses(Object v){
        return addresses.getOrDefault(v, ImmutableSet.of());
    }

    void addEvent(Register r, MemEvent e){
        events.putIfAbsent(r, new HashSet<>());
        events.get(r).add(e);
    }

    Set<MemEvent> getEvents(Register r){
        return events.getOrDefault(r, ImmutableSet.of());
    }

    SSAReg getSSAReg(Register r, int i){
        ssa.putIfAbsent(r, new HashMap<>());
        ssa.get(r).putIfAbsent(i, new SSAReg(i, r));
        return ssa.get(r).get(i);
    }
}
