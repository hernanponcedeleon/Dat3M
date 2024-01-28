package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import org.junit.Test;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static org.junit.Assert.*;

public class EventGraphTest {

    @Test
    public void testCopyConstructor() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        EventGraph first = new EventGraph();
        first.add(e1, e2);

        // when
        EventGraph second = new EventGraph(first);

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
    public void testIsEmptyWhenEmpty() {
        // when
        EventGraph eventGraph = new EventGraph();

        // then
        assertTrue(eventGraph.isEmpty());
    }

    @Test
    public void testIsEmptyWhenNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);

        // then
        assertFalse(eventGraph.isEmpty());
    }

    @Test
    public void testIsEmptyWhenRemoved() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.remove(e1, e2);

        // then
        assertTrue(eventGraph.isEmpty());
    }

    @Test
    public void testSizeEmpty() {
        // when
        EventGraph eventGraph = new EventGraph();

        // then
        assertEquals(0, eventGraph.size());
    }

    @Test
    public void testSizeEmptyRemoval() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.remove(e1, e2);

        // then
        assertEquals(0, eventGraph.size());
    }

    @Test
    public void testSizeNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e1, e3);
        eventGraph.add(e2, e3);

        // then
        assertEquals(3, eventGraph.size());
    }

    @Test
    public void testSizeNotEmptyInverse() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e1);

        // then
        assertEquals(2, eventGraph.size());
    }

    @Test
    public void testSizeNotEmptyIdentity() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e1);
        eventGraph.add(e2, e2);
        eventGraph.add(e3, e3);

        // then
        assertEquals(3, eventGraph.size());
    }

    @Test
    public void testSizeNotEmptyDuplicates() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
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
        EventGraph eventGraph = new EventGraph();
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
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e1, e3);
        eventGraph.add(e2, e3);
        eventGraph.remove(e2, e3);

        // then
        assertEquals(2, eventGraph.size());
    }

    @Test
    public void testContainsEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();

        // then
        assertFalse(eventGraph.contains(e1, e2));
    }

    @Test
    public void testContainsNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e3, e3);

        // then
        assertTrue(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e3, e3));
        assertFalse(eventGraph.contains(e1, e1));
        assertFalse(eventGraph.contains(e1, e3));
        assertFalse(eventGraph.contains(e2, e1));
    }

    @Test
    public void testContainsRemoved() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e1);
        eventGraph.remove(e1, e2);

        // then
        assertFalse(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e2, e1));
    }

    @Test
    public void testAdd() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        boolean result = eventGraph.add(e1, e2);

        // then
        assertTrue(result);
        assertTrue(eventGraph.contains(e1, e2));
        assertFalse(eventGraph.contains(e2, e1));
        assertEquals(1, eventGraph.size());
    }

    @Test
    public void testAddRepeated() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        boolean result1 = eventGraph.add(e1, e2);
        boolean result2 = eventGraph.add(e1, e2);

        // then
        assertTrue(result1);
        assertFalse(result2);
        assertTrue(eventGraph.contains(e1, e2));
        assertFalse(eventGraph.contains(e2, e1));
        assertEquals(1, eventGraph.size());
    }

    @Test
    public void testRemoveEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        boolean result = eventGraph.remove(e1, e2);

        // then
        assertFalse(result);
        assertFalse(eventGraph.contains(e1, e2));
        assertFalse(eventGraph.contains(e2, e1));
        assertEquals(0, eventGraph.size());
    }

    @Test
    public void testRemove() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e1);
        boolean result = eventGraph.remove(e1, e2);

        // then
        assertTrue(result);
        assertFalse(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e2, e1));
        assertEquals(1, eventGraph.size());
    }

    @Test
    public void testRemoveRepeated() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e1);
        boolean result1 = eventGraph.remove(e1, e2);
        boolean result2 = eventGraph.remove(e1, e2);

        // then
        assertTrue(result1);
        assertFalse(result2);
        assertFalse(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e2, e1));
        assertEquals(1, eventGraph.size());
    }

    @Test
    public void testAddAll() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e3);
        second.add(e3, e3);
        boolean result = first.addAll(second);

        // then
        assertTrue(result);

        assertEquals(5, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e1, e3));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));
        assertTrue(first.contains(e3, e3));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e3));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testAddAllPartial() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e3, e3);
        boolean result = first.addAll(second);

        // then
        assertTrue(result);

        assertEquals(4, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));
        assertTrue(first.contains(e3, e3));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testAddAllNone() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e3, e1);
        boolean result = first.addAll(second);

        // then
        assertFalse(result);

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testAddLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);
        boolean result = first.addAll(second);

        // then
        assertTrue(result);

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testAddRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        boolean result = first.addAll(second);

        // then
        assertFalse(result);

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(0, second.size());
    }

    @Test
    public void testRemoveAll() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        boolean result = first.removeAll(second);

        // then
        assertTrue(result);

        assertEquals(1, first.size());
        assertTrue(first.contains(e3, e1));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
    }

    @Test
    public void testRemoveAllPartial() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e3, e3);
        boolean result = first.removeAll(second);

        // then
        assertTrue(result);

        assertEquals(2, first.size());
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testRemoveAllNone() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e3);
        second.add(e3, e3);
        boolean result = first.removeAll(second);

        // then
        assertFalse(result);

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e3));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testRemoveAllEmptied() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);
        second.add(e3, e3);
        boolean result = first.removeAll(second);

        // then
        assertTrue(result);

        assertEquals(0, first.size());

        assertEquals(4, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testRemoveAllLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);
        boolean result = first.removeAll(second);

        // then
        assertFalse(result);

        assertEquals(0, first.size());

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testRemoveAllRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        boolean result = first.removeAll(second);

        // then
        assertFalse(result);

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(0, second.size());
    }

    @Test
    public void testRetainAll() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        boolean result = first.retainAll(second);

        // then
        assertTrue(result);

        assertEquals(2, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
    }

    @Test
    public void testRetainAllPartial() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e3, e3);
        boolean result = first.retainAll(second);

        // then
        assertTrue(result);

        assertEquals(1, first.size());
        assertTrue(first.contains(e1, e2));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testRetainAllNone() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);
        second.add(e3, e3);
        boolean result = first.retainAll(second);

        // then
        assertFalse(result);

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(4, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testRetainAllEmptied() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        second.add(e3, e3);
        boolean result = first.retainAll(second);

        // then
        assertTrue(result);

        assertEquals(0, first.size());

        assertEquals(1, second.size());
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testRetainAllLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);
        boolean result = first.retainAll(second);

        // then
        assertFalse(result);

        assertEquals(0, first.size());

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testRetainAllRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);
        EventGraph second = new EventGraph();
        boolean result = first.retainAll(second);

        // then
        assertTrue(result);

        assertEquals(0, first.size());

        assertEquals(0, second.size());
    }

    @Test
    public void testInverse() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();
        Event e4 = new Skip();
        Event e5 = new Skip();

        // when
        EventGraph original = new EventGraph();
        original.add(e1, e2);
        original.add(e2, e1);
        original.add(e3, e4);
        original.add(e5, e5);
        EventGraph inverse = original.inverse();

        // then
        assertEquals(4, inverse.size());
        assertTrue(inverse.contains(e1, e2));
        assertTrue(inverse.contains(e2, e1));
        assertTrue(inverse.contains(e4, e3));
        assertTrue(inverse.contains(e5, e5));

        assertEquals(4, original.size());
        assertTrue(original.contains(e1, e2));
        assertTrue(original.contains(e2, e1));
        assertTrue(original.contains(e3, e4));
        assertTrue(original.contains(e5, e5));
    }

    @Test
    public void testInverseModifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph original = new EventGraph();
        original.add(e1, e2);

        EventGraph inverse = original.inverse();

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
    public void testInverseEmpty() {
        // given
        EventGraph original = new EventGraph();

        // when
        EventGraph inverse = original.inverse();

        // then
        assertTrue(original.isEmpty());
        assertTrue(inverse.isEmpty());
    }

    @Test
    public void testFilterLoop() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph original = new EventGraph();
        original.add(e1, e1);
        original.add(e1, e2);
        original.add(e2, e1);
        original.add(e3, e3);
        EventGraph filtered = original.filter(Object::equals);

        // then
        assertEquals(2, filtered.size());
        assertTrue(filtered.contains(e1, e1));
        assertTrue(filtered.contains(e3, e3));

        assertEquals(4, original.size());
        assertTrue(original.contains(e1, e1));
        assertTrue(original.contains(e1, e2));
        assertTrue(original.contains(e2, e1));
        assertTrue(original.contains(e3, e3));
    }

    @Test
    public void testFilterNoLoop() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph original = new EventGraph();
        original.add(e1, e1);
        original.add(e1, e2);
        original.add(e2, e1);
        original.add(e3, e3);
        EventGraph filtered = original.filter((x, y) -> !x.equals(y));

        // then
        assertEquals(2, filtered.size());
        assertTrue(filtered.contains(e1, e2));
        assertTrue(filtered.contains(e2, e1));

        assertEquals(4, original.size());
        assertTrue(original.contains(e1, e1));
        assertTrue(original.contains(e1, e2));
        assertTrue(original.contains(e2, e1));
        assertTrue(original.contains(e3, e3));
    }

    @Test
    public void testFilterModifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph original = new EventGraph();
        original.add(e1, e2);

        EventGraph filtered = original.filter((x, y) -> true);

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
    public void testFilterEmpty() {
        // given
        EventGraph original = new EventGraph();

        // when
        EventGraph filtered = original.filter(Object::equals);

        // then
        assertTrue(original.isEmpty());
        assertTrue(filtered.isEmpty());
    }

    @Test
    public void testOutMap() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e1);
        eventGraph.add(e1, e3);
        eventGraph.add(e3, e2);
        eventGraph.add(e3, e3);

        // when
        Map<Event, Set<Event>> actual = eventGraph.getOutMap();

        // then
        Map<Event, Set<Event>> expected = Map.of(e1, Set.of(e2, e3), e2, Set.of(e1), e3, Set.of(e2, e3));
        assertEquals(expected, actual);
        assertEquals(Set.of(e2, e3), actual.get(e1));
        assertEquals(Set.of(e1, e2, e3), actual.keySet());
    }

    @Test
    public void testOutMapUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph eventGraph = new EventGraph();
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
    public void testInMap() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e1);
        eventGraph.add(e1, e3);
        eventGraph.add(e3, e2);
        eventGraph.add(e3, e3);

        // when
        Map<Event, Set<Event>> actual = eventGraph.getInMap();

        // then
        Map<Event, Set<Event>> expected = Map.of(e1, Set.of(e2), e2, Set.of(e1, e3), e3, Set.of(e1, e3));
        assertEquals(expected, actual);
        assertEquals(Set.of(e1, e3), actual.get(e2));
        assertEquals(Set.of(e1, e2, e3), actual.keySet());
    }

    @Test
    public void testInMapUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph eventGraph = new EventGraph();
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

    @Test
    public void testGetDomain() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();
        Event e4 = new Skip();
        Event e5 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e1);
        eventGraph.add(e3, e4);
        eventGraph.add(e5, e5);
        Set<Event> domain = eventGraph.getDomain();

        // then
        assertEquals(Set.of(e1, e2, e3, e5), domain);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testGetDomainUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);

        Set<Event> set = eventGraph.getDomain();

        // when
        set.add(e2);
    }

    @Test
    public void testGetDomainEmpty() {
        // given
        EventGraph eventGraph = new EventGraph();

        // when
        Set<Event> domain = eventGraph.getDomain();

        // then
        assertTrue(domain.isEmpty());
    }

    @Test
    public void testGetRange() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();
        Event e4 = new Skip();
        Event e5 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e2, e1);
        eventGraph.add(e3, e4);
        eventGraph.add(e5, e5);
        Set<Event> range = eventGraph.getRange();

        // then
        assertEquals(Set.of(e1, e2, e4, e5), range);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testGetRangeUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);

        Set<Event> set = eventGraph.getRange();

        // when
        set.add(e1);
    }

    @Test
    public void testGetRangeEmpty() {
        // given
        EventGraph eventGraph = new EventGraph();

        // when
        Set<Event> range = eventGraph.getRange();

        // then
        assertTrue(range.isEmpty());
    }

    @Test
    public void testGetRangeEvent() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();
        Event e4 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e1, e3);
        eventGraph.add(e2, e1);
        eventGraph.add(e3, e3);

        // then
        assertEquals(Set.of(e2,e3), eventGraph.getRange(e1));
        assertEquals(Set.of(e1), eventGraph.getRange(e2));
        assertEquals(Set.of(e3), eventGraph.getRange(e3));
        assertEquals(Set.of(), eventGraph.getRange(e4));
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testGetRangeEventUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);

        Set<Event> set = eventGraph.getRange(e1);

        // when
        set.add(e1);
    }

    @Test
    public void testGetRangeEventEmpty() {
        // given
        Event e = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();

        // then
        assertTrue(eventGraph.getRange(e).isEmpty());
    }

    @Test
    public void testAddRangeEvent() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e3, e3);

        // when
        assertFalse(eventGraph.addRange(e1, Set.of(e2)));
        assertTrue(eventGraph.addRange(e1, Set.of(e2, e3)));
        assertFalse(eventGraph.addRange(e3, Set.of(e3)));
        assertTrue(eventGraph.addRange(e3, Set.of(e1, e3)));
        assertFalse(eventGraph.addRange(e1, Set.of()));

        // then
        assertEquals(4, eventGraph.size());
        assertTrue(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e1, e3));
        assertTrue(eventGraph.contains(e3, e1));
        assertTrue(eventGraph.contains(e3, e3));
    }

    @Test
    public void testRemoveIf() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e1, e3);
        eventGraph.add(e2, e1);
        eventGraph.add(e3, e3);
        eventGraph.removeIf(Object::equals);

        // then
        assertEquals(3, eventGraph.size());
        assertTrue(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e1, e3));
        assertTrue(eventGraph.contains(e2, e1));
    }

    @Test
    public void testRemoveIfEmpty() {
        // given
        EventGraph eventGraph = new EventGraph();

        // when
        eventGraph.removeIf(Object::equals);

        // then
        assertTrue(eventGraph.isEmpty());
    }

    @Test
    public void testApply() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph eventGraph = new EventGraph();
        eventGraph.add(e1, e2);
        eventGraph.add(e3, e3);

        // when
        Set<Event> result = new HashSet<>(Set.of(e1, e2, e3));
        eventGraph.apply((x, y) -> {
            if (x.equals(y)) {
                result.remove(x);
            }
        });

        // then
        assertEquals(Set.of(e1, e2), result);

        assertEquals(2, eventGraph.size());
        assertTrue(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e3, e3));
    }

    @Test
    public void testApplyEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph eventGraph = new EventGraph();

        // when
        Set<Event> result = new HashSet<>(Set.of(e1, e2, e3));
        eventGraph.apply((x, y) -> {
            if (x.equals(y)) {
                result.remove(x);
            }
        });

        // then
        assertEquals(Set.of(e1, e2, e3), result);
        assertTrue(eventGraph.isEmpty());
    }

    @Test
    public void testUnionDisjoint() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();
        second.add(e1, e3);
        second.add(e2, e1);
        second.add(e3, e2);

        // when
        EventGraph result = EventGraph.union(first, second);

        // then
        assertEquals(6, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertTrue(result.contains(e1, e3));
        assertTrue(result.contains(e2, e1));
        assertTrue(result.contains(e3, e2));

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e3));
        assertTrue(second.contains(e2, e1));
        assertTrue(second.contains(e3, e2));
    }

    @Test
    public void testUnionPartiallyOverlapping() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e3, e3);

        // when
        EventGraph result = EventGraph.union(first, second);

        // then
        assertEquals(4, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertTrue(result.contains(e3, e3));

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testUnionEqual() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);

        // when
        EventGraph result = EventGraph.union(first, second);

        // then
        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testUnionLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();

        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);

        // when
        EventGraph result = EventGraph.union(first, second);

        // then
        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));

        assertEquals(0, first.size());

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testUnionRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();

        // when
        EventGraph result = EventGraph.union(first, second);

        // then
        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(0, second.size());
    }

    @Test
    public void testIntersectionDisjoint() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();
        second.add(e1, e3);
        second.add(e2, e1);
        second.add(e3, e2);

        // when
        EventGraph result = EventGraph.intersection(first, second);

        // then
        assertEquals(0, result.size());

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e3));
        assertTrue(second.contains(e2, e1));
        assertTrue(second.contains(e3, e2));
    }

    @Test
    public void testIntersectionPartiallyOverlapping() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e3, e3);

        // when
        EventGraph result = EventGraph.intersection(first, second);

        // then
        assertEquals(1, result.size());
        assertTrue(result.contains(e1, e2));

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testIntersectionEqual() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);

        // when
        EventGraph result = EventGraph.intersection(first, second);

        // then
        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testIntersectionLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();

        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);

        // when
        EventGraph result = EventGraph.intersection(first, second);

        // then
        assertEquals(0, result.size());

        assertEquals(0, first.size());

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testIntersectionRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();

        // when
        EventGraph result = EventGraph.intersection(first, second);

        // then
        assertEquals(0, result.size());

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(0, second.size());
    }

    @Test
    public void testDifferenceDisjoint() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();
        second.add(e1, e3);
        second.add(e2, e1);
        second.add(e3, e2);

        // when
        EventGraph result = EventGraph.difference(first, second);

        // then
        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e3));
        assertTrue(second.contains(e2, e1));
        assertTrue(second.contains(e3, e2));
    }

    @Test
    public void testDifferencePartiallyOverlapping() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e3, e3);

        // when
        EventGraph result = EventGraph.difference(first, second);

        // then
        assertEquals(2, result.size());
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(2, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e3, e3));
    }

    @Test
    public void testDifferenceEqual() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);

        // when
        EventGraph result = EventGraph.difference(first, second);

        // then
        assertEquals(0, result.size());

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testDifferenceLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();

        EventGraph second = new EventGraph();
        second.add(e1, e2);
        second.add(e2, e3);
        second.add(e3, e1);

        // when
        EventGraph result = EventGraph.difference(first, second);

        // then
        assertEquals(0, result.size());

        assertEquals(0, first.size());

        assertEquals(3, second.size());
        assertTrue(second.contains(e1, e2));
        assertTrue(second.contains(e2, e3));
        assertTrue(second.contains(e3, e1));
    }

    @Test
    public void testDifferenceRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph first = new EventGraph();
        first.add(e1, e2);
        first.add(e2, e3);
        first.add(e3, e1);

        EventGraph second = new EventGraph();

        // when
        EventGraph result = EventGraph.difference(first, second);

        // then
        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));

        assertEquals(3, first.size());
        assertTrue(first.contains(e1, e2));
        assertTrue(first.contains(e2, e3));
        assertTrue(first.contains(e3, e1));

        assertEquals(0, second.size());
    }
}
