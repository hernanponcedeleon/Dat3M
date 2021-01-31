package com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

@SuppressWarnings("ALL")
public class TimedCollection<T extends Timeable> extends AbstractTimedCollection<T> {

    private final ArrayList<T> list;

    public TimedCollection() {
        super();
        list = new ArrayList<>();
    }

    private void validate() {
        if (maxTime.isValid())
            return;
        list.removeIf(Timeable::isInvalid);
        minSize = 0;
        maxTime = Timestamp.ZERO;
        for (T item : list) {
            maxTime = Timestamp.max(maxTime, item.getTime());
        }
    }

    @Override
    public int getMaxSize() {
        return list.size();
    }

    @Override
    public int size() {
        validate();
        return list.size();
    }

    @Override
    public boolean isEmpty() {
        if (minSize > 0)
            return false;
        validate();
        return list.size() == 0;
    }

    @Override
    public boolean contains(Object o) {
        for (T e : this) {
            if (e.equals(o))
                return true;
        }
        return false;
    }

    @Override
    public Iterator<T> iterator() {
        return maxTime.isValid() ? list.iterator() : new TimedIterator();
    }

    @Override
    public Object[] toArray() {
        validate();
        return list.toArray();
    }

    @Override
    public <T1> T1[] toArray(T1[] a) {
        validate();
        return list.toArray(a);
    }

    @Override
    public boolean add(T t) {
        return super.add(t) && list.add(t);
    }

    @Override
    public void clear() {
        super.clear();
        list.clear();
    }

    private class TimedIterator implements Iterator<T> {
        int index = -1;
        T item;
        Timestamp curMax = Timestamp.ZERO;

        public TimedIterator() {
            findNext();
        }

        private void findNext() {
            int i = index + 1;
            final ArrayList<T> l = list;
            int size = l.size();

            while (i < size) {
                item = l.get(i);
                if (item.isInvalid()) {
                    Collections.swap(l, i, --size);
                    l.remove(size);
                } else {
                    curMax = Timestamp.max(curMax, item.getTime());
                    index = i;
                    return;
                }
            }
            item = null;
            maxTime = curMax;
        }


        @Override
        public boolean hasNext() {
            return item != null;
        }

        @Override
        public T next() {
            T next = item;
            findNext();
            return next;
        }
    }
}
