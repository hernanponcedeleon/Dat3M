package com.dat3m.dartagnan.wmm.utils.graph.immutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.junit.Test;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static org.junit.Assert.*;

// TODO: Convert into a generic ImmutableEmptyGraphTest
// TODO: Test cases for static set operators
public class EmptyEventGraphTest {

    @Test
    public void testIsSingleton() {
        // when
        EventGraph first = EventGraph.empty();
        EventGraph second = EventGraph.empty();

        // then
        assertSame(first, second);
    }

    @Test
    public void testIsEmpty() {
        // when
        EventGraph empty = EventGraph.empty();

        // then
        assertTrue(empty.isEmpty());
    }

    @Test
    public void testSize() {
        // when
        EventGraph empty = EventGraph.empty();

        // then
        assertEquals(0, empty.size());
    }

    @Test
    public void testContains() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph empty = EventGraph.empty();

        // then
        assertFalse(empty.contains(e1, e2));
    }

    @Test
    public void testInverse() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        EventGraph inverse = empty.inverse();

        // then
        assertSame(empty, inverse);
    }

    @Test
    public void testFilter() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        EventGraph inverse = empty.filter((x, y) -> true);

        // then
        assertSame(empty, inverse);
    }

    @Test
    public void testOutMap() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        Map<Event, Set<Event>> map = empty.getOutMap();

        // then
        assertTrue(map.isEmpty());
    }

    @Test
    public void testInMap() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        Map<Event, Set<Event>> map = empty.getInMap();

        // then
        assertTrue(map.isEmpty());
    }

    @Test
    public void testGetDomain() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        Set<Event> set = empty.getDomain();

        // then
        assertTrue(set.isEmpty());
    }

    @Test
    public void testGetRange() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        Set<Event> set = empty.getRange();

        // then
        assertTrue(set.isEmpty());
    }

    @Test
    public void testGetRangeEvent() {
        // given
        Event e = new Skip();
        EventGraph empty = EventGraph.empty();

        // when
        Set<Event> set = empty.getRange(e);

        // then
        assertTrue(set.isEmpty());
    }

    @Test
    public void testApply() {
        // given
        EventGraph empty = EventGraph.empty();
        Set<Event> set = new HashSet<>();

        // when
        empty.apply((x, y) -> {
            if (x.equals(y)) {
                set.add(x);
            }
        });

        // then
        assertTrue(set.isEmpty());
    }
}
