package com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain;

import com.dat3m.dartagnan.program.event.Event;

import java.util.Collection;
import java.util.HashMap;
import java.util.Set;
import java.util.TreeMap;

public class GenericDomain<T> implements Domain<T> {

    private final DenseIdBiMap<T> domainMap;

    public GenericDomain(Collection<T> domain) {
        domainMap = DenseIdBiMap.createIdentityBased(domain.size());
        for (T obj : domain) {
            domainMap.addObject(obj);
        }
    }

    public GenericDomain() {
        domainMap = new DenseIdBiMap<>();
    }

    // returns smallest unoccupied id
    public int resetElements(int clusterNum) {
        return domainMap.removeObjectsFromTop(clusterNum);
    }

    @Override
    public int size() {
        return domainMap.size();
    }

    public int push() { return domainMap.push(); }

    public int addElement(T el) { return domainMap.addObject(el); }

    public boolean addAll(Collection<T> els) {
        for (T el : els) {
            if (addElement(el) < 0) {
                return false;
            }
        }
        return true;
    }

    @Override
    public Set<T> getElements() {
        return domainMap.getKeys();
    }

    @Override
    public int getId(Object obj) {
        return domainMap.getId(obj);
    }

    @Override
    public T getObjectById(int id) {
        return domainMap.getObject(id);
    }
}
