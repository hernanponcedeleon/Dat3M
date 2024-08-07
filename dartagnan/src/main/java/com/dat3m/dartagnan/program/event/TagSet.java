package com.dat3m.dartagnan.program.event;

import com.google.common.base.Preconditions;

import java.util.*;

public final class TagSet extends AbstractSet<String> {

    private final List<String> sortedTags = new ArrayList<>();

    @Override
    public boolean add(String tag) {
        Preconditions.checkNotNull(tag);
        final int index = Collections.binarySearch(sortedTags, tag);
        if (index < 0) {
            sortedTags.add(~index, tag);
            return true;
        }
        return false;
    }

    @Override
    public boolean contains(Object o) {
        if (o instanceof String tag) {
            return Collections.binarySearch(sortedTags, tag) >= 0;
        }
        return false;
    }

    @Override
    public boolean remove(Object o) {
        if (o instanceof String tag) {
            final int index = Collections.binarySearch(sortedTags, tag);
            if (index >= 0) {
                sortedTags.remove(index);
                return true;
            }
        }
        return false;
    }

    @Override
    public Iterator<String> iterator() {
        return sortedTags.listIterator();
    }

    @Override
    public int size() {
        return sortedTags.size();
    }

    public TagSet copy() {
        final TagSet copy = new TagSet();
        copy.sortedTags.addAll(this.sortedTags);
        return copy;
    }
}
