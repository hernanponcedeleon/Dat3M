package com.dat3m.dartagnan.program.filter;

import com.dat3m.dartagnan.program.event.Event;

import java.util.HashMap;
import java.util.Map;

/*
Filters are used as general ways to extract program-events.
*/
public abstract class Filter {

    protected String name;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public abstract boolean apply(Event event);

    // ================================= Factory =================================

    protected static final Map<Filter, Filter> canonicalizer = new HashMap<>();

    public static TagFilter byTag(String tag) {
        return (TagFilter) canonicalizer.computeIfAbsent(new TagFilter(tag), key -> key);
    }

    public static IntersectionFilter intersection(Filter a, Filter b) {
        return (IntersectionFilter) canonicalizer.computeIfAbsent(new IntersectionFilter(a, b), key -> key);
    }

    public static DifferenceFilter difference(Filter a, Filter b) {
        return (DifferenceFilter) canonicalizer.computeIfAbsent(new DifferenceFilter(a, b), key -> key);
    }

    public static UnionFilter union(Filter a, Filter b) {
        return (UnionFilter) canonicalizer.computeIfAbsent(new UnionFilter(a, b), key -> key);
    }
}