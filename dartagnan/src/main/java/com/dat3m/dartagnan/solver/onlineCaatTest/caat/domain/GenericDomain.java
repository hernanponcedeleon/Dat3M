package com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain;

import java.util.Collection;
import java.util.Set;

public class GenericDomain<T> implements Domain<T> {

    private final DenseIdBiMap<T> domainMap;

    public GenericDomain(Collection<T> domain) {
        domainMap = DenseIdBiMap.createIdentityBased(domain.size());
        for (T obj : domain) {
            domainMap.addObject(obj);
        }
    }

    @Override
    public int size() {
        return domainMap.size();
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
