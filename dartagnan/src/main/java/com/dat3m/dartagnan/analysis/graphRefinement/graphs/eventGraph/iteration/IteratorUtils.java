package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration;

import java.util.Collections;
import java.util.Iterator;
import java.util.function.Function;

public final class IteratorUtils {

    private IteratorUtils() {

    }

    public static <T> Iterator<T> empty() {
        return Collections.emptyIterator();
    }

    public static  <T> Iterator<T> singleton(T o) {
        return Collections.singleton(o).iterator();
    }

    public static <TFrom, TTo> Iterator<TTo> mappedIterator(Iterator<TFrom> source, Function<TFrom, TTo> mapping) {
        return new MappedIterator<>(source, mapping);
    }


    private static class MappedIterator<TFrom, TTo> implements Iterator<TTo> {
        private final Iterator<TFrom> source;
        private final Function<TFrom, TTo> mapping;

        public MappedIterator(Iterator<TFrom> source, Function<TFrom, TTo> mapping) {
            this.source = source;
            this.mapping = mapping;
        }

        @Override
        public boolean hasNext() {
            return source.hasNext();
        }

        @Override
        public TTo next() {
            return mapping.apply(source.next());
        }
    }


}
