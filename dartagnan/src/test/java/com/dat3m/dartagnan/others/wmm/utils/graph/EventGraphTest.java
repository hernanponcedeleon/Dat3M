package com.dat3m.dartagnan.others.wmm.utils.graph;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableMapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.LazyEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class EventGraphTest {

    private final Class<?> cls;

    public EventGraphTest(Class<?> cls) {
        this.cls = cls;
    }

    @Parameterized.Parameters
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {MapEventGraph.class},
                {ImmutableMapEventGraph.class},
                {LazyEventGraph.class},
        });
    }

    @Test
    public void testIsEmptyWhenEmpty() {
        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of());

        // then
        assertTrue(eventGraph.isEmpty());
    }

    @Test
    public void testIsEmptyWhenNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2)
        ));

        // then
        assertFalse(eventGraph.isEmpty());
    }

    @Test
    public void testSizeEmpty() {
        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of());

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
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2, e3),
                e2, Set.of(e3)
        ));

        // then
        assertEquals(3, eventGraph.size());
    }

    @Test
    public void testSizeNotEmptyInverse() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e1)
        ));

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
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e1),
                e2, Set.of(e2),
                e3, Set.of(e3)
        ));

        // then
        assertEquals(3, eventGraph.size());
    }

    @Test
    public void testContainsEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of());

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
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e3, Set.of(e3)
        ));

        // then
        assertTrue(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e3, e3));
        assertFalse(eventGraph.contains(e1, e1));
        assertFalse(eventGraph.contains(e1, e3));
        assertFalse(eventGraph.contains(e2, e1));
    }

    @Test
    public void testInverseEmpty() {
        // given
        EventGraph original = makeEventGraph(cls, Map.of());

        // when
        EventGraph inverse = original.inverse();

        // then
        assertEquals(original.getClass(), inverse.getClass());
        assertTrue(original.isEmpty());
        assertTrue(inverse.isEmpty());
    }

    @Test
    public void testInverseNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();
        Event e4 = new Skip();
        Event e5 = new Skip();

        // when
        EventGraph original = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e1),
                e3, Set.of(e4),
                e5, Set.of(e5)
        ));
        EventGraph inverse = original.inverse();

        // then
        assertEquals(original.getClass(), inverse.getClass());

        assertEquals(4, original.size());
        assertTrue(original.contains(e1, e2));
        assertTrue(original.contains(e2, e1));
        assertTrue(original.contains(e3, e4));
        assertTrue(original.contains(e5, e5));

        assertEquals(4, inverse.size());
        assertTrue(inverse.contains(e1, e2));
        assertTrue(inverse.contains(e2, e1));
        assertTrue(inverse.contains(e4, e3));
        assertTrue(inverse.contains(e5, e5));
    }

    @Test
    public void testFilterEmpty() {
        // given
        EventGraph original = makeEventGraph(cls, Map.of());

        // when
        EventGraph filtered = original.filter((x, y) -> true);

        // then
        assertEquals(original.getClass(), filtered.getClass());
        assertTrue(filtered.isEmpty());
        assertEquals(Set.of(), filtered.getDomain());
        assertEquals(Set.of(), filtered.getRange());

        assertTrue(original.isEmpty());
        assertEquals(Set.of(), original.getDomain());
        assertEquals(Set.of(), original.getRange());
    }

    @Test
    public void testFilterIdentity() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph original = makeEventGraph(cls, Map.of(
                e1, Set.of(e1, e2),
                e2, Set.of(e1),
                e3, Set.of(e3)
        ));
        EventGraph filtered = original.filter(Object::equals);

        // then
        assertEquals(original.getClass(), filtered.getClass());

        assertEquals(2, filtered.size());
        assertTrue(filtered.contains(e1, e1));
        assertTrue(filtered.contains(e3, e3));
        assertEquals(Set.of(e1, e3), filtered.getDomain());
        assertEquals(Set.of(e1, e3), filtered.getRange());

        assertEquals(4, original.size());
        assertTrue(original.contains(e1, e1));
        assertTrue(original.contains(e1, e2));
        assertTrue(original.contains(e2, e1));
        assertTrue(original.contains(e3, e3));
        assertEquals(Set.of(e1, e2, e3), original.getDomain());
        assertEquals(Set.of(e1, e2, e3), original.getRange());
    }

    @Test
    public void testFilterNoIdentity() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph original = makeEventGraph(cls, Map.of(
                e1, Set.of(e1, e2),
                e2, Set.of(e1),
                e3, Set.of(e3)
        ));
        EventGraph filtered = original.filter((x, y) -> !x.equals(y));

        // then
        assertEquals(original.getClass(), filtered.getClass());

        assertEquals(2, filtered.size());
        assertTrue(filtered.contains(e1, e2));
        assertTrue(filtered.contains(e2, e1));
        assertEquals(Set.of(e1, e2), filtered.getDomain());
        assertEquals(Set.of(e1, e2), filtered.getRange());

        assertEquals(4, original.size());
        assertTrue(original.contains(e1, e1));
        assertTrue(original.contains(e1, e2));
        assertTrue(original.contains(e2, e1));
        assertTrue(original.contains(e3, e3));
        assertEquals(Set.of(e1, e2, e3), original.getDomain());
        assertEquals(Set.of(e1, e2, e3), original.getRange());
    }

    @Test
    public void testOutMap() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2, e3),
                e2, Set.of(e1),
                e3, Set.of(e2, e3)
        ));
        Map<Event, Set<Event>> actual = eventGraph.getOutMap();

        // then
        Map<Event, Set<Event>> expected = Map.of(
                e1, Set.of(e2, e3),
                e2, Set.of(e1),
                e3, Set.of(e2, e3)
        );
        assertEquals(expected, actual);
    }

    @Test
    public void testOutMapUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2)
        ));

        // when
        Map<Event, Set<Event>> map = eventGraph.getOutMap();

        // then
        assertThrows(UnsupportedOperationException.class, () -> map.remove(e1));

        Set<Event> newSet = Set.of(e1);
        assertThrows(UnsupportedOperationException.class, () -> map.put(e2, newSet));
        assertThrows(UnsupportedOperationException.class, () -> map.computeIfAbsent(e2, x -> newSet));

        Set<Event> oldSet = map.get(e1);
        assertThrows(UnsupportedOperationException.class, () -> oldSet.remove(e2));
        assertThrows(UnsupportedOperationException.class, () -> oldSet.add(e1));
    }

    @Test
    public void testInMap() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2, e3),
                e2, Set.of(e1),
                e3, Set.of(e2, e3)
        ));
        Map<Event, Set<Event>> actual = eventGraph.getInMap();

        // then
        Map<Event, Set<Event>> expected = Map.of(
                e1, Set.of(e2),
                e2, Set.of(e1, e3),
                e3, Set.of(e1, e3)
        );
        assertEquals(expected, actual);
    }

    @Test
    public void testInMapUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e2, Set.of(e1)
        ));

        // when
        Map<Event, Set<Event>> map = eventGraph.getInMap();

        // then
        assertThrows(UnsupportedOperationException.class, () -> map.remove(e1));

        Set<Event> newSet = Set.of(e1);
        assertThrows(UnsupportedOperationException.class, () -> map.put(e2, newSet));
        assertThrows(UnsupportedOperationException.class, () -> map.computeIfAbsent(e2, x -> newSet));

        Set<Event> oldSet = map.get(e1);
        assertThrows(UnsupportedOperationException.class, () -> oldSet.remove(e2));
        assertThrows(UnsupportedOperationException.class, () -> oldSet.add(e1));
    }

    @Test
    public void testGetDomainEmpty() {
        // given
        EventGraph eventGraph = makeEventGraph(cls, Map.of());

        // when
        Set<Event> domain = eventGraph.getDomain();

        // then
        assertTrue(domain.isEmpty());
    }

    @Test
    public void testGetDomainNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();
        Event e4 = new Skip();
        Event e5 = new Skip();

        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e1),
                e3, Set.of(e4),
                e5, Set.of(e5)
        ));
        Set<Event> domain = eventGraph.getDomain();

        // then
        assertEquals(Set.of(e1, e2, e3, e5), domain);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testGetDomainUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2)
        ));

        Set<Event> set = eventGraph.getDomain();

        // when
        set.add(e2);
    }

    @Test
    public void testGetRangeEmpty() {
        // given
        EventGraph eventGraph = makeEventGraph(cls, Map.of());

        // when
        Set<Event> range = eventGraph.getRange();

        // then
        assertTrue(range.isEmpty());
    }

    @Test
    public void testGetRangeNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();
        Event e4 = new Skip();
        Event e5 = new Skip();

        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e1),
                e3, Set.of(e4),
                e5, Set.of(e5)
        ));
        Set<Event> range = eventGraph.getRange();

        // then
        assertEquals(Set.of(e1, e2, e4, e5), range);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testGetRangeUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2)
        ));

        Set<Event> set = eventGraph.getRange();

        // when
        set.add(e1);
    }

    @Test
    public void testGetRangeEventEmpty() {
        // given
        Event e = new Skip();

        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of());

        // then
        assertTrue(eventGraph.getRange(e).isEmpty());
    }

    @Test
    public void testGetRangeEventNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();
        Event e4 = new Skip();

        // when
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2, e3, e4),
                e2, Set.of(e1),
                e3, Set.of(e3)
        ));

        // then
        assertEquals(Set.of(e2, e3, e4), eventGraph.getRange(e1));
        assertEquals(Set.of(e1), eventGraph.getRange(e2));
        assertEquals(Set.of(e3), eventGraph.getRange(e3));
        assertEquals(Set.of(), eventGraph.getRange(e4));
    }

    @Test(expected = UnsupportedOperationException.class)
    public void testGetRangeEventUnmodifiable() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2)
        ));

        Set<Event> set = eventGraph.getRange(e1);

        // when
        set.add(e1);
    }

    @Test
    public void testApplyEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph eventGraph = makeEventGraph(cls, Map.of());

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
    public void testApplyNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e3, Set.of(e3)
        ));

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

    private EventGraph makeEventGraph(Class<?> cls, Map<Event, Set<Event>> data) {
        if (cls.isAssignableFrom(MapEventGraph.class)) {
            return new MapEventGraph(data);
        }
        if (cls.isAssignableFrom(ImmutableMapEventGraph.class)) {
            return new ImmutableMapEventGraph(data);
        }
        if (cls.isAssignableFrom(LazyEventGraph.class)) {
            Set<Event> range = data.values().stream().flatMap(Collection::stream).collect(Collectors.toSet());
            return new LazyEventGraph(data.keySet(), range, (e1, e2) -> data.getOrDefault(e1, Set.of()).contains(e2));
        }
        throw new RuntimeException("Cannot resolve constructor for class " + cls.getSimpleName());
    }
}
