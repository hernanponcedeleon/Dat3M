package com.dat3m.dartagnan.wmm.utils.graph.immutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class EmptyEventGraphTest {

    private final Class<?> cls;

    public EmptyEventGraphTest(Class<?> cls) {
        this.cls = cls;
    }

    @Parameterized.Parameters
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {ImmutableMapEventGraph.EmptyEventGraph.class},
                {LazyEventGraph.EmptyEventGraph.class},
        });
    }

    private static EventGraph makeEventGraph(Class<?> cls) {
        if (cls.isAssignableFrom(ImmutableMapEventGraph.EmptyEventGraph.class)) {
            return ImmutableMapEventGraph.empty();
        }
        if (cls.isAssignableFrom(LazyEventGraph.EmptyEventGraph.class)) {
            return LazyEventGraph.empty();
        }
        throw new RuntimeException("Cannot resolve constructor for class " + cls.getSimpleName());
    }

    @Test
    public void testIsSingleton() {
        // when
        EventGraph first = makeEventGraph(cls);
        EventGraph second = makeEventGraph(cls);

        // then
        assertSame(first, second);
    }

    @Test
    public void testIsEmpty() {
        // when
        EventGraph empty = makeEventGraph(cls);

        // then
        assertTrue(empty.isEmpty());
    }

    @Test
    public void testSize() {
        // when
        EventGraph empty = makeEventGraph(cls);

        // then
        assertEquals(0, empty.size());
    }

    @Test
    public void testContains() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        // when
        EventGraph empty = makeEventGraph(cls);

        // then
        assertFalse(empty.contains(e1, e2));
    }

    @Test
    public void testInverse() {
        // given
        EventGraph empty = makeEventGraph(cls);

        // when
        EventGraph inverse = empty.inverse();

        // then
        assertSame(empty, inverse);
    }

    @Test
    public void testFilter() {
        // given
        EventGraph empty = makeEventGraph(cls);

        // when
        EventGraph inverse = empty.filter((x, y) -> true);

        // then
        assertSame(empty, inverse);
    }

    @Test
    public void testOutMap() {
        // given
        EventGraph empty = makeEventGraph(cls);

        // when
        Map<Event, Set<Event>> map = empty.getOutMap();

        // then
        assertTrue(map.isEmpty());
    }

    @Test
    public void testInMap() {
        // given
        EventGraph empty = makeEventGraph(cls);

        // when
        Map<Event, Set<Event>> map = empty.getInMap();

        // then
        assertTrue(map.isEmpty());
    }

    @Test
    public void testGetDomain() {
        // given
        EventGraph empty = makeEventGraph(cls);

        // when
        Set<Event> set = empty.getDomain();

        // then
        assertTrue(set.isEmpty());
    }

    @Test
    public void testGetRange() {
        // given
        EventGraph empty = makeEventGraph(cls);

        // when
        Set<Event> set = empty.getRange();

        // then
        assertTrue(set.isEmpty());
    }

    @Test
    public void testGetRangeEvent() {
        // given
        Event e = new Skip();
        EventGraph empty = makeEventGraph(cls);

        // when
        Set<Event> set = empty.getRange(e);

        // then
        assertTrue(set.isEmpty());
    }

    @Test
    public void testApply() {
        // given
        EventGraph empty = makeEventGraph(cls);
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
