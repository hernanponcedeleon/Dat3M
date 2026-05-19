package com.dat3m.dartagnan.utils.dependable;

import java.util.Collection;

public interface Dependent<T> {
    Collection<? extends T> getDependencies();
}
