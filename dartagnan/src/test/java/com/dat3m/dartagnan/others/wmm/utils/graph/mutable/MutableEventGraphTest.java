package com.dat3m.dartagnan.others.wmm.utils.graph.mutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.Set;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class MutableEventGraphTest {

    private final Class<?> cls;

    public MutableEventGraphTest(Class<?> cls) {
        this.cls = cls;
    }

    @Parameterized.Parameters
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {MapEventGraph.class},
        });
    }

    @Test
    public void testAddEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of());

        // when
        boolean result = eventGraph.add(e1, e2);

        // then
        assertTrue(result);
        assertFalse(eventGraph.isEmpty());
        assertEquals(1, eventGraph.size());
        assertTrue(eventGraph.contains(e1, e2));
    }

    @Test
    public void testAddNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2)
        ));

        // when
        boolean result = eventGraph.add(e1, e1);

        // then
        assertTrue(result);
        assertFalse(eventGraph.isEmpty());
        assertEquals(2, eventGraph.size());
        assertTrue(eventGraph.contains(e1, e1));
        assertTrue(eventGraph.contains(e1, e2));
    }

    @Test
    public void testAddRepeated() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2)
        ));

        // when
        boolean result1 = eventGraph.add(e1, e2);
        boolean result2 = eventGraph.add(e1, e1);
        boolean result3 = eventGraph.add(e1, e1);

        // then
        assertFalse(result1);
        assertTrue(result2);
        assertFalse(result3);
        assertFalse(eventGraph.isEmpty());
        assertEquals(2, eventGraph.size());
        assertTrue(eventGraph.contains(e1, e2));
        assertFalse(eventGraph.contains(e2, e1));
    }

    @Test
    public void testRemoveEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of());

        // when
        boolean result = eventGraph.remove(e1, e2);

        // then
        assertFalse(result);
        assertTrue(eventGraph.isEmpty());
        assertEquals(0, eventGraph.size());
        assertFalse(eventGraph.contains(e1, e2));
    }

    @Test
    public void testRemoveNonEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e1)
        ));

        // when
        boolean result = eventGraph.remove(e1, e2);

        // then
        assertTrue(result);
        assertFalse(eventGraph.isEmpty());
        assertEquals(1, eventGraph.size());
        assertFalse(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e2, e1));
    }

    @Test
    public void testRemoveNonEmptyAllEdges() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e1)
        ));

        // when
        boolean result1 = eventGraph.remove(e1, e2);
        boolean result2 = eventGraph.remove(e2, e1);

        // then
        assertTrue(result1);
        assertTrue(result2);
        assertTrue(eventGraph.isEmpty());
        assertEquals(0, eventGraph.size());
        assertFalse(eventGraph.contains(e1, e2));
        assertFalse(eventGraph.contains(e2, e1));
    }

    @Test
    public void testRemoveRepeated() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e1)
        ));

        // when
        boolean result1 = eventGraph.remove(e1, e2);
        boolean result2 = eventGraph.remove(e1, e2);
        boolean result3 = eventGraph.remove(e1, e1);

        // then
        assertTrue(result1);
        assertFalse(result2);
        assertFalse(result3);
        assertFalse(eventGraph.isEmpty());
        assertEquals(1, eventGraph.size());
        assertFalse(eventGraph.contains(e1, e2));
        assertTrue(eventGraph.contains(e2, e1));
    }

    @Test
    public void testAddAllDisjoint() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e3),
                e3, Set.of(e3)
        ));
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
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e3, Set.of(e3)
        ));
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
    public void testAddAllOverlapping() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e3, Set.of(e1)
        ));
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
    public void testAddAllLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of());
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
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
    public void testAddAllRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of());
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
    public void testRemoveAllOverlapping() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3)
        ));
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
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e3, Set.of(e3)
        ));
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
    public void testRemoveAllDisjoint() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e3),
                e3, Set.of(e3)
        ));
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
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1, e3)
        ));
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
        MutableEventGraph first = makeEventGraph(cls, Map.of());
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
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
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of());
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
    public void testRetainAllOverlappingSubset() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3)
        ));
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
    public void testRetainAllOverlappingSuperset() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1, e3)
        ));
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
    public void testRetainAllPartial() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e3, Set.of(e3)
        ));
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
    public void testRetainAllEmptied() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        // when
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e3, Set.of(e3)
        ));
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
        MutableEventGraph first = makeEventGraph(cls, Map.of());
        MutableEventGraph second = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
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
        MutableEventGraph first = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));
        MutableEventGraph second = makeEventGraph(cls, Map.of());
        boolean result = first.retainAll(second);

        // then
        assertTrue(result);

        assertEquals(0, first.size());

        assertEquals(0, second.size());
    }

    @Test
    public void testAddRangeEvent() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2),
                e3, Set.of(e3)
        ));

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
        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of(
                e1, Set.of(e2, e3),
                e2, Set.of(e1),
                e3, Set.of(e3)
        ));
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
        MutableEventGraph eventGraph = makeEventGraph(cls, Map.of());

        // when
        eventGraph.removeIf(Object::equals);

        // then
        assertTrue(eventGraph.isEmpty());
    }

    private MutableEventGraph makeEventGraph(Class<?> cls, Map<Event, Set<Event>> data) {
        if (cls.isAssignableFrom(MapEventGraph.class)) {
            return new MapEventGraph(data);
        }
        throw new RuntimeException("Cannot resolve constructor for class " + cls.getSimpleName());
    }
}
