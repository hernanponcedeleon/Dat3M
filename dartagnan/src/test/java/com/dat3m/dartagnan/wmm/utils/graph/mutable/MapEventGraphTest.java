package com.dat3m.dartagnan.wmm.utils.graph.mutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import org.junit.Test;

import java.util.Map;
import java.util.Set;

import static org.junit.Assert.*;

// TODO: Convert into a generic MutableEventGraphTest
public class MapEventGraphTest {

    @Test
    public void testCopyConstructor() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        MapEventGraph first = new MapEventGraph();
        first.add(e1, e2);

        // when
        MapEventGraph second = MapEventGraph.from(first);

        // then
        assertEquals(1, second.size());

        // when
        second.remove(e1, e2);
        second.add(e2, e1);

        // then
        assertEquals(1, first.size());
        assertTrue(first.contains(e1, e2));
        assertEquals(1, second.size());
        assertTrue(second.contains(e2, e1));
    }

    @Test
    public void testIsEmptyWhenRemoved() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);
        eventGraph.remove(e1, e2);

        // then
        assertTrue(eventGraph.isEmpty());
    }

    @Test
    public void testSizeEmptyRemoval() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);
        eventGraph.remove(e1, e2);

        // then
        assertEquals(0, eventGraph.size());
    }

    @Test
    public void testSizeNotEmptyDuplicates() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e1, e2);
        eventGraph.add(e1, e2);

        // then
        assertEquals(1, eventGraph.size());
    }

    @Test
    public void testSizeNotEmptyRemoval() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e1, e3);
        eventGraph.add(e2, e3);
        eventGraph.remove(e1, e3);

        // then
        assertEquals(2, eventGraph.size());
    }

    @Test
    public void testSizeNotEmptyRemovalAlt() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e1, e3);
        eventGraph.add(e2, e3);
        eventGraph.remove(e2, e3);

        // then
        assertEquals(2, eventGraph.size());
    }

    @Test
    public void testContainsRemoved() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e1);
        eventGraph.remove(e1, e2);

        // then
        assertFalse(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e2, e1));
    }

    @Test
    public void testInverseModifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        MapEventGraph original = new MapEventGraph();
        original.add(e1, e2);

        MapEventGraph inverse = original.inverse();

        // when
        inverse.add(e3, e3);

        // then
        assertEquals(1, original.size());
        assertTrue(original.contains(e1, e2));

        assertEquals(2, inverse.size());
        assertTrue(inverse.contains(e2, e1));
        assertTrue(inverse.contains(e3, e3));
    }

    @Test
    public void testFilterModifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        MapEventGraph original = new MapEventGraph();
        original.add(e1, e2);

        MapEventGraph filtered = original.filter((x, y) -> true);

        // when
        filtered.add(e3, e3);

        // then
        assertEquals(1, original.size());
        assertTrue(original.contains(e1, e2));

        assertEquals(2, filtered.size());
        assertTrue(filtered.contains(e1, e2));
        assertTrue(filtered.contains(e3, e3));
    }

    @Test
    public void testOutMapUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e3);

        // when
        Map<Event, Set<Event>> map = eventGraph.getOutMap();

        // then
        assertThrows(UnsupportedOperationException.class, () -> map.remove(e1));
        assertThrows(UnsupportedOperationException.class, () -> map.remove(e3));

        Set<Event> newSet = Set.of(e3);
        assertThrows(UnsupportedOperationException.class, () -> map.put(e3, newSet));
        assertThrows(UnsupportedOperationException.class, () -> map.computeIfAbsent(e3, x -> newSet));

        Set<Event> oldSet = map.get(e1);
        assertThrows(UnsupportedOperationException.class, () -> oldSet.remove(e2));
        assertThrows(UnsupportedOperationException.class, () -> oldSet.add(e3));
    }

    @Test
    public void testInMapUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e3);

        // when
        Map<Event, Set<Event>> map = eventGraph.getOutMap();

        // then
        assertThrows(UnsupportedOperationException.class, () -> map.remove(e2));
        assertThrows(UnsupportedOperationException.class, () -> map.remove(e1));

        Set<Event> newSet = Set.of(e1);
        assertThrows(UnsupportedOperationException.class, () -> map.put(e1, newSet));
        assertThrows(UnsupportedOperationException.class, () -> map.computeIfAbsent(e1, x -> newSet));

        Set<Event> oldSet = map.get(e2);
        assertThrows(UnsupportedOperationException.class, () -> oldSet.remove(e1));
        assertThrows(UnsupportedOperationException.class, () -> oldSet.add(e3));
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testGetDomainUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);

        Set<Event> set = eventGraph.getDomain();

        // when
        set.add(e2);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testGetRangeUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);

        Set<Event> set = eventGraph.getRange();

        // when
        set.add(e1);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testGetRangeEventUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        MapEventGraph eventGraph = new MapEventGraph();
        eventGraph.add(e1, e2);

        Set<Event> set = eventGraph.getRange(e1);

        // when
        set.add(e1);
    }
}
