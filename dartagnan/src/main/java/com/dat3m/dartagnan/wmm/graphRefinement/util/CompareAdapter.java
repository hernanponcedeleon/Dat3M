package com.dat3m.dartagnan.wmm.graphRefinement.util;

import java.util.Comparator;
import java.util.Objects;


/*
The CompareAdapter wraps an object and provides a Comparable implementation to
implement comparison methods externally

Notes: The equals and compareTo methods are not symmetric, if two Adapaters with different comparators are compared.
 */
public final class CompareAdapter<T> implements Comparable<CompareAdapter<T>>{

    public final Comparator<? super T> comparator;
    public final T item;

    public CompareAdapter(T item, Comparator<? super T> comparator) {
        if (item == null || comparator == null)
            throw new NullPointerException("Null values are not allowed.");
        this.item = item;
        this.comparator = comparator;
    }

    @Override
    public int compareTo(CompareAdapter<T> o) {
        return comparator.compare(item, o.item);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(item);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this)
            return true;
        else if (obj == null || obj.getClass() != this.getClass())
            return false;

        CompareAdapter<T> other = (CompareAdapter<T>)obj;
        return other.item == this.item || comparator.compare(this.item, other.item) == 0;


    }

    @Override
    public String toString() {
        return item.toString();
    }
}
