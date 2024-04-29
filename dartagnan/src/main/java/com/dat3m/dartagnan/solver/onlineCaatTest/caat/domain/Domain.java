package com.dat3m.dartagnan.solver.onlineCaatTest.caat.domain;

import java.util.Collection;

public interface Domain<T> {

    boolean resetElements(int number);
    //int fullSize();
    int size();
    int push();
    int addElement(T el);
    boolean addAll(Collection<T> els);
    Collection<T> getElements();
    int getId(Object obj);
    T getObjectById(int id);
}

