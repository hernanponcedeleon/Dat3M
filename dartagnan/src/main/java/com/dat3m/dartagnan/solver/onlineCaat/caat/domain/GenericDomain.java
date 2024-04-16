package com.dat3m.dartagnan.solver.onlineCaat.caat.domain;

import java.util.Collection;
import java.util.Set;

public class GenericDomain<T> implements Domain<T> {

    private final DenseIdBiMap<T> domainMap;
    //private final int fullSize;

    public GenericDomain(Collection<T> domain) {
        domainMap = DenseIdBiMap.createIdentityBased(domain.size());
        //fullSize = domain.size();
        for (T obj : domain) {
            domainMap.addObject(obj);
        }
    }

    public GenericDomain() {
        domainMap = new DenseIdBiMap<>();
    }

    @Override
    public boolean resetElements(int clusterNum) {
        return domainMap.removeObjectsFromTop(clusterNum);
    }

    /*@Override
    public int fullSize() {
        return fullSize;
    }*/

    @Override
    public int size() {
        return domainMap.size();
    }

    @Override
    public int push() { return domainMap.push(); }

    @Override
    public int addElement(T el) { return domainMap.addObject(el); }

    @Override
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
