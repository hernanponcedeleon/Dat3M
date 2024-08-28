package com.dat3m.dartagnan.wmm.utils.graph;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Skip;
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
import java.util.*;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.stream.Collectors;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

@RunWith(Parameterized.class)
public class EventGraphStaticTest {

    private final Class<?> resultClass;
    private final Class<?> leftClass;
    private final Class<?> rightClass;

    public EventGraphStaticTest(Class<?> resultClass, Class<?> leftClass, Class<?> rightClass) {
        this.resultClass = resultClass;
        this.leftClass = leftClass;
        this.rightClass = rightClass;
    }

    @Parameterized.Parameters
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                // resultClass, leftClass, rightClass
                {MapEventGraph.class, MapEventGraph.class, MapEventGraph.class},
                {MapEventGraph.class, MapEventGraph.class, ImmutableMapEventGraph.class},
                {MapEventGraph.class, MapEventGraph.class, LazyEventGraph.class},
                {MapEventGraph.class, ImmutableMapEventGraph.class, MapEventGraph.class},
                {MapEventGraph.class, ImmutableMapEventGraph.class, ImmutableMapEventGraph.class},
                {MapEventGraph.class, ImmutableMapEventGraph.class, LazyEventGraph.class},
                {MapEventGraph.class, LazyEventGraph.class, MapEventGraph.class},
                {MapEventGraph.class, LazyEventGraph.class, ImmutableMapEventGraph.class},
                {MapEventGraph.class, LazyEventGraph.class, LazyEventGraph.class},

                {LazyEventGraph.class, MapEventGraph.class, MapEventGraph.class},
                {LazyEventGraph.class, MapEventGraph.class, ImmutableMapEventGraph.class},
                {LazyEventGraph.class, MapEventGraph.class, LazyEventGraph.class},
                {LazyEventGraph.class, ImmutableMapEventGraph.class, MapEventGraph.class},
                {LazyEventGraph.class, ImmutableMapEventGraph.class, ImmutableMapEventGraph.class},
                {LazyEventGraph.class, ImmutableMapEventGraph.class, LazyEventGraph.class},
                {LazyEventGraph.class, LazyEventGraph.class, MapEventGraph.class},
                {LazyEventGraph.class, LazyEventGraph.class, ImmutableMapEventGraph.class},
                {LazyEventGraph.class, LazyEventGraph.class, LazyEventGraph.class},

                {ImmutableMapEventGraph.class, MapEventGraph.class, MapEventGraph.class},
                {ImmutableMapEventGraph.class, MapEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableMapEventGraph.class, MapEventGraph.class, LazyEventGraph.class},
                {ImmutableMapEventGraph.class, ImmutableMapEventGraph.class, MapEventGraph.class},
                {ImmutableMapEventGraph.class, ImmutableMapEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableMapEventGraph.class, ImmutableMapEventGraph.class, LazyEventGraph.class},
                {ImmutableMapEventGraph.class, LazyEventGraph.class, MapEventGraph.class},
                {ImmutableMapEventGraph.class, LazyEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableMapEventGraph.class, LazyEventGraph.class, LazyEventGraph.class},

                {MutableEventGraph.class, MapEventGraph.class, MapEventGraph.class},
                {MutableEventGraph.class, MapEventGraph.class, ImmutableMapEventGraph.class},
                {MutableEventGraph.class, MapEventGraph.class, LazyEventGraph.class},
                {MutableEventGraph.class, ImmutableMapEventGraph.class, MapEventGraph.class},
                {MutableEventGraph.class, ImmutableMapEventGraph.class, ImmutableMapEventGraph.class},
                {MutableEventGraph.class, ImmutableMapEventGraph.class, LazyEventGraph.class},
                {MutableEventGraph.class, LazyEventGraph.class, MapEventGraph.class},
                {MutableEventGraph.class, LazyEventGraph.class, ImmutableMapEventGraph.class},
                {MutableEventGraph.class, LazyEventGraph.class, LazyEventGraph.class},

                {ImmutableEventGraph.class, MapEventGraph.class, MapEventGraph.class},
                {ImmutableEventGraph.class, MapEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableEventGraph.class, MapEventGraph.class, LazyEventGraph.class},
                {ImmutableEventGraph.class, ImmutableMapEventGraph.class, MapEventGraph.class},
                {ImmutableEventGraph.class, ImmutableMapEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableEventGraph.class, ImmutableMapEventGraph.class, LazyEventGraph.class},
                {ImmutableEventGraph.class, LazyEventGraph.class, MapEventGraph.class},
                {ImmutableEventGraph.class, LazyEventGraph.class, ImmutableMapEventGraph.class},
                {ImmutableEventGraph.class, LazyEventGraph.class, LazyEventGraph.class},
        });
    }

    @Test
    public void testUnionDisjoint() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e3),
                e2, Set.of(e1),
                e3, Set.of(e2)
        ));

        // when
        EventGraph result = getFunction(resultClass, "union").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(6, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertTrue(result.contains(e1, e3));
        assertTrue(result.contains(e2, e1));
        assertTrue(result.contains(e3, e2));
        assertEquals(Set.of(e1, e2, e3), result.getDomain());
        assertEquals(Set.of(e1, e2, e3), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(3, right.size());
        assertTrue(right.contains(e1, e3));
        assertTrue(right.contains(e2, e1));
        assertTrue(right.contains(e3, e2));
        assertEquals(Set.of(e1, e2, e3), right.getDomain());
        assertEquals(Set.of(e1, e2, e3), right.getRange());
    }

    @Test
    public void testUnionPartiallyOverlapping() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e2),
                e3, Set.of(e3)
        ));

        // when
        EventGraph result = getFunction(resultClass, "union").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(4, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertTrue(result.contains(e3, e3));
        assertEquals(Set.of(e1, e2, e3), result.getDomain());
        assertEquals(Set.of(e1, e2, e3), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(2, right.size());
        assertTrue(right.contains(e1, e2));
        assertTrue(right.contains(e3, e3));
        assertEquals(Set.of(e1, e3), right.getDomain());
        assertEquals(Set.of(e2, e3), right.getRange());
    }

    @Test
    public void testUnionEqual() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        // when
        EventGraph result = getFunction(resultClass, "union").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), result.getDomain());
        assertEquals(Set.of(e1, e2, e3), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(3, right.size());
        assertTrue(right.contains(e1, e2));
        assertTrue(right.contains(e2, e3));
        assertTrue(right.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), right.getDomain());
        assertEquals(Set.of(e1, e2, e3), right.getRange());
    }

    @Test
    public void testUnionLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of());

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        // when
        EventGraph result = getFunction(resultClass, "union").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), result.getDomain());
        assertEquals(Set.of(e1, e2, e3), result.getRange());

        assertEquals(0, left.size());
        assertEquals(Set.of(), left.getDomain());
        assertEquals(Set.of(), left.getRange());

        assertEquals(3, right.size());
        assertTrue(right.contains(e1, e2));
        assertTrue(right.contains(e2, e3));
        assertTrue(right.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), right.getDomain());
        assertEquals(Set.of(e1, e2, e3), right.getRange());
    }

    @Test
    public void testUnionRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of());

        // when
        EventGraph result = getFunction(resultClass, "union").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), result.getDomain());
        assertEquals(Set.of(e1, e2, e3), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(0, right.size());
        assertEquals(Set.of(), right.getDomain());
        assertEquals(Set.of(), right.getRange());
    }

    @Test
    public void testIntersectionDisjoint() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e3),
                e2, Set.of(e1),
                e3, Set.of(e2)
        ));

        // when
        EventGraph result = getFunction(resultClass, "intersection").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(Set.of(), result.getDomain());
        assertEquals(Set.of(), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(3, right.size());
        assertTrue(right.contains(e1, e3));
        assertTrue(right.contains(e2, e1));
        assertTrue(right.contains(e3, e2));
        assertEquals(Set.of(e1, e2, e3), right.getDomain());
        assertEquals(Set.of(e1, e2, e3), right.getRange());
    }

    @Test
    public void testIntersectionPartiallyOverlapping() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e2),
                e3, Set.of(e3)
        ));

        // when
        EventGraph result = getFunction(resultClass, "intersection").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(1, result.size());
        assertTrue(result.contains(e1, e2));
        assertEquals(Set.of(e1), result.getDomain());
        assertEquals(Set.of(e2), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(2, right.size());
        assertTrue(right.contains(e1, e2));
        assertTrue(right.contains(e3, e3));
        assertEquals(Set.of(e1, e3), right.getDomain());
        assertEquals(Set.of(e2, e3), right.getRange());
    }

    @Test
    public void testIntersectionEqual() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        // when
        EventGraph result = getFunction(resultClass, "intersection").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), result.getDomain());
        assertEquals(Set.of(e1, e2, e3), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(3, right.size());
        assertTrue(right.contains(e1, e2));
        assertTrue(right.contains(e2, e3));
        assertTrue(right.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), right.getDomain());
        assertEquals(Set.of(e1, e2, e3), right.getRange());
    }

    @Test
    public void testIntersectionLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of());

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        // when
        EventGraph result = getFunction(resultClass, "intersection").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(Set.of(), result.getDomain());
        assertEquals(Set.of(), result.getRange());

        assertEquals(0, left.size());
        assertEquals(Set.of(), left.getDomain());
        assertEquals(Set.of(), left.getRange());

        assertEquals(3, right.size());
        assertTrue(right.contains(e1, e2));
        assertTrue(right.contains(e2, e3));
        assertTrue(right.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), right.getDomain());
        assertEquals(Set.of(e1, e2, e3), right.getRange());
    }

    @Test
    public void testIntersectionRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of());

        // when
        EventGraph result = getFunction(resultClass, "intersection").apply(new EventGraph[]{left, right});

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(Set.of(), result.getDomain());
        assertEquals(Set.of(), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(0, right.size());
        assertEquals(Set.of(), right.getDomain());
        assertEquals(Set.of(), right.getRange());
    }

    @Test
    public void testDifferenceDisjoint() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e3),
                e2, Set.of(e1),
                e3, Set.of(e2)
        ));

        // when
        EventGraph result = getDifferenceFunction(resultClass).apply(left, right);

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), result.getDomain());
        assertEquals(Set.of(e1, e2, e3), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(3, right.size());
        assertTrue(right.contains(e1, e3));
        assertTrue(right.contains(e2, e1));
        assertTrue(right.contains(e3, e2));
        assertEquals(Set.of(e1, e2, e3), right.getDomain());
        assertEquals(Set.of(e1, e2, e3), right.getRange());
    }

    @Test
    public void testDifferencePartiallyOverlapping() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e2),
                e3, Set.of(e3)
        ));

        // when
        EventGraph result = getDifferenceFunction(resultClass).apply(left, right);

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(2, result.size());
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertEquals(Set.of(e2, e3), result.getDomain());
        assertEquals(Set.of(e1, e3), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(2, right.size());
        assertTrue(right.contains(e1, e2));
        assertTrue(right.contains(e3, e3));
        assertEquals(Set.of(e1, e3), right.getDomain());
        assertEquals(Set.of(e2, e3), right.getRange());
    }

    @Test
    public void testDifferenceEqual() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        // when
        EventGraph result = getDifferenceFunction(resultClass).apply(left, right);

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(Set.of(), result.getDomain());
        assertEquals(Set.of(), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(3, right.size());
        assertTrue(right.contains(e1, e2));
        assertTrue(right.contains(e2, e3));
        assertTrue(right.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), right.getDomain());
        assertEquals(Set.of(e1, e2, e3), right.getRange());
    }

    @Test
    public void testDifferenceLeftEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of());

        EventGraph right = getConstructor(rightClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        // when
        EventGraph result = getDifferenceFunction(resultClass).apply(left, right);

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(0, result.size());
        assertEquals(Set.of(), result.getDomain());
        assertEquals(Set.of(), result.getRange());

        assertEquals(0, left.size());
        assertEquals(Set.of(), left.getDomain());
        assertEquals(Set.of(), left.getRange());

        assertEquals(3, right.size());
        assertTrue(right.contains(e1, e2));
        assertTrue(right.contains(e2, e3));
        assertTrue(right.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), right.getDomain());
        assertEquals(Set.of(e1, e2, e3), right.getRange());
    }

    @Test
    public void testDifferenceRightEmpty() {
        // given
        Event e1 = new Skip();
        Event e2 = new Skip();
        Event e3 = new Skip();

        EventGraph left = getConstructor(leftClass).apply(Map.of(
                e1, Set.of(e2),
                e2, Set.of(e3),
                e3, Set.of(e1)
        ));

        EventGraph right = getConstructor(rightClass).apply(Map.of());

        // when
        EventGraph result = getDifferenceFunction(resultClass).apply(left, right);

        // then
        assertTrue(resultClass.isAssignableFrom(result.getClass()));

        assertEquals(3, result.size());
        assertTrue(result.contains(e1, e2));
        assertTrue(result.contains(e2, e3));
        assertTrue(result.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), result.getDomain());
        assertEquals(Set.of(e1, e2, e3), result.getRange());

        assertEquals(3, left.size());
        assertTrue(left.contains(e1, e2));
        assertTrue(left.contains(e2, e3));
        assertTrue(left.contains(e3, e1));
        assertEquals(Set.of(e1, e2, e3), left.getDomain());
        assertEquals(Set.of(e1, e2, e3), left.getRange());

        assertEquals(0, right.size());
        assertEquals(Set.of(), right.getDomain());
        assertEquals(Set.of(), right.getRange());
    }

    private static Function<EventGraph[], EventGraph> getFunction(Class<?> cls, String name) {
        return (operands) -> {
            try {
                Method method = cls.getMethod(name, EventGraph[].class);
                return (EventGraph) method.invoke(null, new Object[] {operands});
            } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
                throw new RuntimeException(e);
            }
        };
    }

    private static BiFunction<EventGraph, EventGraph, EventGraph> getDifferenceFunction(Class<?> cls) {
        return (left, right) -> {
            try {
                Method method = cls.getMethod("difference", EventGraph.class, EventGraph.class);
                return (EventGraph) method.invoke(null, left, right);
            } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
                throw new RuntimeException(e);
            }
        };
    }

    private static Function<Map<Event, Set<Event>>, EventGraph> getConstructor(Class<?> cls) {
        if (cls.isAssignableFrom(MapEventGraph.class)) {
            return MapEventGraph::new;
        }
        if (cls.isAssignableFrom(ImmutableMapEventGraph.class)) {
            return ImmutableMapEventGraph::new;
        }
        if (cls.isAssignableFrom(LazyEventGraph.class)) {
            return map -> new LazyEventGraph(
                    map.keySet(),
                    map.values().stream().flatMap(Collection::stream).collect(Collectors.toSet()),
                    (e1, e2) -> map.getOrDefault(e1, Set.of()).contains(e2));
        }
        throw new RuntimeException("Cannot resolve constructor for class " + cls.getSimpleName());
    }
}
