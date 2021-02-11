package com.dat3m.dartagnan.wmm.graphRefinement.util;

import java.util.*;
import java.util.function.Function;

public class ListUtil {

    public static <TFrom, TTo> List<TTo> mappedList(List<TFrom> source, Function<TFrom, TTo> mapping) {
        return new MappedList<>(source, mapping);
    }


    /*
    A MappedList is a read-only wrapper around a list that maps all entries using a given mapping.
     */
    private static class MappedList<TFrom, TTo> extends AbstractList<TTo> {
        private final List<TFrom> source;
        private final Function<TFrom, TTo> mapping;

        public MappedList(List<TFrom> source, Function<TFrom, TTo> mapping) {
            this.source = source;
            this.mapping = mapping;
        }

        @Override
        public int size() {
            return source.size();
        }

        @Override
        public TTo get(int index) {
            return mapping.apply(source.get(index));
        }
    }
}
