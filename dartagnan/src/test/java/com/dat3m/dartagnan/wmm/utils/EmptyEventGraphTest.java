package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import org.junit.Test;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static org.junit.Assert.*;

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

    @Test(expected = UnsupportedOperationException.class)
    public void testAdd() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph.empty().add(e1, e2);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testRemove() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph.empty().remove(e1, e2);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testAddAll() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph nonEmpty = new EventGraph();
        nonEmpty.add(e1, e2);

        // when
        EventGraph.empty().addAll(nonEmpty);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testAddAllEmpty() {
        // when
        EventGraph.empty().addAll(EventGraph.empty());
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testRemoveAll() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph nonEmpty = new EventGraph();
        nonEmpty.add(e1, e2);

        // when
        EventGraph.empty().removeAll(nonEmpty);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testRemoveAllEmpty() {
        // when
        EventGraph.empty().removeAll(EventGraph.empty());
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testRetainAll() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph nonEmpty = new EventGraph();
        nonEmpty.add(e1, e2);

        // when
        EventGraph.empty().retainAll(nonEmpty);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testRetainAllEmpty() {
        // when
        EventGraph.empty().retainAll(EventGraph.empty());
    }

    @Test
    public void testInverse() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        EventGraph inverse = empty.inverse();

        // then
        assertTrue(inverse.isEmpty());
        assertNotSame(empty, inverse);
    }

    @Test
    public void testInverseModifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        EventGraph empty = EventGraph.empty();
        EventGraph inverse = empty.inverse();

        // when
        inverse.add(e1, e2);

        // then
        assertFalse(empty.contains(e1, e2));
        assertTrue(inverse.contains(e1, e2));
    }

    @Test
    public void testFilterTrue() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        EventGraph inverse = empty.filter((x, y) -> true);

        // then
        assertTrue(inverse.isEmpty());
        assertNotSame(empty, inverse);
    }

    @Test
    public void testFilterFalse() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        EventGraph inverse = empty.filter((x, y) -> false);

        // then
        assertTrue(inverse.isEmpty());
        assertNotSame(empty, inverse);
    }

    @Test
    public void testFilterModifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        EventGraph empty = EventGraph.empty();
        EventGraph inverse = empty.filter((x, y) -> true);

        // when
        inverse.add(e1, e2);

        // then
        assertFalse(empty.contains(e1, e2));
        assertTrue(inverse.contains(e1, e2));
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

    @Test(expected = UnsupportedOperationException.class)
    public void testOutMapUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph empty = EventGraph.empty();
        Map<Event, Set<Event>> map = empty.getOutMap();

        // when
        map.put(e1, Set.of(e2));
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

    @Test(expected = UnsupportedOperationException.class)
    public void testInMapUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph empty = EventGraph.empty();
        Map<Event, Set<Event>> map = empty.getInMap();

        // when
        map.put(e1, Set.of(e2));
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

    @Test(expected = UnsupportedOperationException.class)
    public void testGetDomainUnmodifiable() {
        // given
        Event e = new Skip();
        EventGraph empty = EventGraph.empty();
        Set<Event> set = empty.getDomain();

        // when
        set.add(e);
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

    @Test(expected = UnsupportedOperationException.class)
    public void testGetRangeUnmodifiable() {
        // given
        Event e = new Skip();
        EventGraph empty = EventGraph.empty();
        Set<Event> set = empty.getRange();

        // when
        set.add(e);
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

    @Test(expected = UnsupportedOperationException.class)
    public void testGetRangeEventUnmodifiable() {
        // given
        Event e = new Skip();
        EventGraph empty = EventGraph.empty();
        Set<Event> set = empty.getRange(e);

        // when
        set.add(e);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testRemoveIfTrue() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        empty.removeIf((x, y) -> true);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testRemoveIfFalse() {
        // given
        EventGraph empty = EventGraph.empty();

        // when
        empty.removeIf((x, y) -> false);
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
