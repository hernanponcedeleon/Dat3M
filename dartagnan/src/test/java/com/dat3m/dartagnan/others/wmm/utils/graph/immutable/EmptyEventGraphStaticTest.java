package com.dat3m.dartagnan.others.wmm.utils.graph.immutable;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableMapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.LazyEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Collection;
import java.util.Map;
import java.util.Set;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.stream.Collectors;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

@RunWith(Parameterized.class)
public class EmptyEventGraphStaticTest {

    private final Class<?> resultClass;
    private final Class<?> emptyClass;
    private final Class<?> nonEmptyClass;

    public EmptyEventGraphStaticTest(Class<?> resultClass, Class<?> emptyClass, Class<?> nonEmptyClass) {
        this.resultClass = resultClass;
        this.emptyClass = emptyClass;
        this.nonEmptyClass = nonEmptyClass;
    }

    @Parameterized.Parameters
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                // resultClass, emptyClass, nonEmptyClass
                {MapEventGraph.class, LazyEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {MapEventGraph.class, LazyEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {MapEventGraph.class, LazyEventGraph.EmptyEventGraph.class, LazyEventGraph.class},
                {MapEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {MapEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {MapEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, LazyEventGraph.class},

                {LazyEventGraph.class, LazyEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {LazyEventGraph.class, LazyEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {LazyEventGraph.class, LazyEventGraph.EmptyEventGraph.class, LazyEventGraph.class},
                {LazyEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {LazyEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {LazyEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, LazyEventGraph.class},

                {ImmutableMapEventGraph.class, LazyEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {ImmutableMapEventGraph.class, LazyEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableMapEventGraph.class, LazyEventGraph.EmptyEventGraph.class, LazyEventGraph.class},
                {ImmutableMapEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {ImmutableMapEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableMapEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, LazyEventGraph.class},

                {MutableEventGraph.class, LazyEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {MutableEventGraph.class, LazyEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {MutableEventGraph.class, LazyEventGraph.EmptyEventGraph.class, LazyEventGraph.class},
                {MutableEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {MutableEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {MutableEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, LazyEventGraph.class},

                {ImmutableEventGraph.class, LazyEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {ImmutableEventGraph.class, LazyEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableEventGraph.class, LazyEventGraph.EmptyEventGraph.class, LazyEventGraph.class},
                {ImmutableEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, MapEventGraph.class},
                {ImmutableEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableEventGraph.class, ImmutableMapEventGraph.EmptyEventGraph.class, LazyEventGraph.class},
        });
    }

    @Test
    public void testUnionLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph empty = makeEventGraph(emptyClass, Map.of());
        EventGraph nonEmpty = makeEventGraph(nonEmptyClass, Map.of(
                e1, Set.of(e2)
        ));

        // when
        EventGraph result = getFunction(resultClass, "union").apply(new EventGraph[]{empty, nonEmpty});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(1, result.size());
        assertTrue(result.contains(e1, e2));
        assertEquals(Set.of(e1), result.getDomain());
        assertEquals(Set.of(e2), result.getRange());

        assertEquals(0, empty.size());

        assertEquals(1, nonEmpty.size());
        assertTrue(nonEmpty.contains(e1, e2));
        assertEquals(Set.of(e1), nonEmpty.getDomain());
        assertEquals(Set.of(e2), nonEmpty.getRange());
    }

    @Test
    public void testUnionRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph empty = makeEventGraph(emptyClass, Map.of());
        EventGraph nonEmpty = makeEventGraph(nonEmptyClass, Map.of(
                e1, Set.of(e2)
        ));

        // when
        EventGraph result = getFunction(resultClass, "union").apply(new EventGraph[]{nonEmpty, empty});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(1, result.size());
        assertTrue(result.contains(e1, e2));
        assertEquals(Set.of(e1), result.getDomain());
        assertEquals(Set.of(e2), result.getRange());

        assertEquals(0, empty.size());

        assertEquals(1, nonEmpty.size());
        assertTrue(nonEmpty.contains(e1, e2));
        assertEquals(Set.of(e1), nonEmpty.getDomain());
        assertEquals(Set.of(e2), nonEmpty.getRange());
    }

    @Test
    public void testUnionBothEmpty() {
        // given
        EventGraph empty = makeEventGraph(emptyClass, Map.of());
        EventGraph anotherEmpty = makeEventGraph(nonEmptyClass, Map.of());

        // when
        EventGraph result = getFunction(resultClass, "union").apply(new EventGraph[]{empty, anotherEmpty});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(0, empty.size());
        assertEquals(0, anotherEmpty.size());
    }

    @Test
    public void testIntersectionLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph empty = makeEventGraph(emptyClass, Map.of());
        EventGraph nonEmpty = makeEventGraph(nonEmptyClass, Map.of(
                e1, Set.of(e2)
        ));

        // when
        EventGraph result = getFunction(resultClass, "intersection").apply(new EventGraph[]{empty, nonEmpty});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(Set.of(), result.getDomain());
        assertEquals(Set.of(), result.getRange());

        assertEquals(0, empty.size());
        assertEquals(Set.of(), empty.getDomain());
        assertEquals(Set.of(), empty.getRange());

        assertEquals(1, nonEmpty.size());
        assertTrue(nonEmpty.contains(e1, e2));
        assertEquals(Set.of(e1), nonEmpty.getDomain());
        assertEquals(Set.of(e2), nonEmpty.getRange());
    }

    @Test
    public void testIntersectionRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph empty = makeEventGraph(emptyClass, Map.of());
        EventGraph nonEmpty = makeEventGraph(nonEmptyClass, Map.of(
                e1, Set.of(e2)
        ));

        // when
        EventGraph result = getFunction(resultClass, "intersection").apply(new EventGraph[]{nonEmpty, empty});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(Set.of(), result.getDomain());
        assertEquals(Set.of(), result.getRange());

        assertEquals(0, empty.size());
        assertEquals(Set.of(), empty.getDomain());
        assertEquals(Set.of(), empty.getRange());

        assertEquals(1, nonEmpty.size());
        assertTrue(nonEmpty.contains(e1, e2));
        assertEquals(Set.of(e1), nonEmpty.getDomain());
        assertEquals(Set.of(e2), nonEmpty.getRange());
    }

    @Test
    public void testIntersectionBothEmpty() {
        // given
        EventGraph empty = makeEventGraph(emptyClass, Map.of());
        EventGraph anotherEmpty = makeEventGraph(nonEmptyClass, Map.of());

        // when
        EventGraph result = getFunction(resultClass, "intersection").apply(new EventGraph[]{empty, anotherEmpty});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(0, empty.size());
        assertEquals(0, anotherEmpty.size());
    }

    @Test
    public void testDifferenceLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph empty = makeEventGraph(emptyClass, Map.of());
        EventGraph nonEmpty = makeEventGraph(nonEmptyClass, Map.of(
                e1, Set.of(e2)
        ));

        // when
        EventGraph result = getDifferenceFunction(resultClass).apply(empty, nonEmpty);

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(Set.of(), result.getDomain());
        assertEquals(Set.of(), result.getRange());

        assertEquals(0, empty.size());
        assertEquals(Set.of(), empty.getDomain());
        assertEquals(Set.of(), empty.getRange());

        assertEquals(1, nonEmpty.size());
        assertTrue(nonEmpty.contains(e1, e2));
        assertEquals(Set.of(e1), nonEmpty.getDomain());
        assertEquals(Set.of(e2), nonEmpty.getRange());
    }

    @Test
    public void testDifferenceRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();

        EventGraph empty = makeEventGraph(emptyClass, Map.of());
        EventGraph nonEmpty = makeEventGraph(nonEmptyClass, Map.of(
                e1, Set.of(e2)
        ));

        // when
        EventGraph result = getDifferenceFunction(resultClass).apply(nonEmpty, empty);

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(1, result.size());
        assertTrue(result.contains(e1, e2));
        assertEquals(Set.of(e1), result.getDomain());
        assertEquals(Set.of(e2), result.getRange());

        assertEquals(1, nonEmpty.size());
        assertTrue(nonEmpty.contains(e1, e2));
        assertEquals(Set.of(e1), nonEmpty.getDomain());
        assertEquals(Set.of(e2), nonEmpty.getRange());

        assertEquals(0, empty.size());
        assertEquals(Set.of(), empty.getDomain());
        assertEquals(Set.of(), empty.getRange());
    }

    @Test
    public void testDifferenceBothEmpty() {
        // given
        EventGraph empty = makeEventGraph(emptyClass, Map.of());
        EventGraph anotherEmpty = makeEventGraph(nonEmptyClass, Map.of());

        // when
        EventGraph result = getDifferenceFunction(resultClass).apply(empty, anotherEmpty);

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(0, empty.size());
        assertEquals(0, anotherEmpty.size());
    }

    private Function<EventGraph[], EventGraph> getFunction(Class<?> cls, String name) {
        return (operands) -> {
            try {
                Method method = cls.getMethod(name, EventGraph[].class);
                return (EventGraph) method.invoke(null, new Object[]{operands});
            } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
                throw new RuntimeException(e);
            }
        };
    }

    private BiFunction<EventGraph, EventGraph, EventGraph> getDifferenceFunction(Class<?> cls) {
        return (left, right) -> {
            try {
                Method method = cls.getMethod("difference", EventGraph.class, EventGraph.class);
                return (EventGraph) method.invoke(null, left, right);
            } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
                throw new RuntimeException(e);
            }
        };
    }

    private EventGraph makeEventGraph(Class<?> cls, Map<Event, Set<Event>> data) {
        if (cls.isMemberClass() && cls.isAssignableFrom(ImmutableMapEventGraph.EmptyEventGraph.class)) {
            assertTrue(data.isEmpty());
            return ImmutableMapEventGraph.empty();
        }
        if (cls.isMemberClass() && cls.isAssignableFrom(LazyEventGraph.EmptyEventGraph.class)) {
            assertTrue(data.isEmpty());
            return LazyEventGraph.empty();
        }
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
