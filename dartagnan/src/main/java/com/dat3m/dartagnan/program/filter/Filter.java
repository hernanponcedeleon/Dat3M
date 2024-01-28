package com.dat3m.dartagnan.program.filter;

import com.dat3m.dartagnan.program.event.Event;

import java.util.HashMap;
import java.util.Map;

/*
TODO: Filters are currently used in two distinct settings:
    (1) as general ways to extract program-events
    (2) as unary predicates in the Wmm
  These two use-cases have conflicting requirements:
    Use-case (1) needs the "apply"-method but not require named filters.
    Use-case (2) requires named filters, but cannot (in general) support an "apply"-method (dynamic unary predicates).

    SOLUTION: Use-case (1) is rather rare and can be replaced by explicit checking for tags
    (e.g. getEvents().stream().filter(e -> e.hasTag(TAG1) &&/|| e.hasTag(TAG2)).
    With only use-case (2), Filters can be lifted to proper unary predicates
    (no "apply"-method, but lower and upper bounds (must/may) instead).

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