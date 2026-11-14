package com.dat3m.dartagnan.utils.collections;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static org.junit.Assert.*;

public class IndexedSetTest {

    @Test
    public void simpleCollection() {
        final List<Object> objects = newObjectList(1 + 2 * Long.SIZE);
        final var dom = new IndexedDomain<>(objects);
        // Test the empty set.
        testEmptySetSemantics(dom.emptySet());
        testEmptySetSemantics(dom.newSet());
        testEmptySetSemantics(dom.newSet(Set.of()));
        // Test a new set.
        final IndexedSet<?> soonEmpty = dom.newSet();
        soonEmpty.exchange(0, true);
        soonEmpty.exchange(0, false);
        testEmptySetSemantics(soonEmpty);
        soonEmpty.exchange(0, true);
        soonEmpty.exchange(1, true);
        soonEmpty.exchange(0, false);
        soonEmpty.exchange(1, false);
        testEmptySetSemantics(soonEmpty);
        // Test a filled set.
        final IndexedSet<Object> some = dom.newSet();
        for (int i = 1; i < objects.size(); i += i) {
            final boolean old = some.exchange(i, true);
            assertFalse(old);
        }
        assertFalse(some.isEmpty());
        assertEquals(8, some.size());
        assertTrue(some.iterator().hasNext());
        for (int i = 1; i < objects.size(); i += i) {
            assertTrue(some.contains(objects.get(i)));
        }
        final var someList = new ArrayList<>(some);
        assertEquals(8, someList.size());
        for (int i = 1; i < objects.size(); i += i) {
            assertTrue(some.contains(objects.get(i)));
        }
        final IndexedSet<Object> all = dom.newSet(objects);
        assertEquals(Set.copyOf(objects), all);
        final var someComplement = new IndexedSet<>(all);
        someComplement.removeAll(some);
        assertEquals(objects.size(), some.size() + someComplement.size());
        for (Object o : objects) {
            assertNotEquals(some.contains(o), someComplement.contains(o));
        }
    }

    @Test
    public void smallDomain() {
        final var emptyDomain = new IndexedDomain<>(List.of());
        testEmptySetSemantics(emptyDomain.emptySet());
        testEmptySetSemantics(emptyDomain.newSet());
        testEmptySetSemantics(emptyDomain.fullSet());
        final var singletonDomain = new IndexedDomain<>(List.of(new Object()));
        testEmptySetSemantics(singletonDomain.emptySet());
        assertEquals(Set.of(singletonDomain.element(0)), singletonDomain.fullSet());
        final IndexedSet<Object> set = singletonDomain.newSet();
        testEmptySetSemantics(set);
        set.add(singletonDomain.element(0));
        assertEquals(singletonDomain.fullSet(), set);
        set.remove(singletonDomain.element(0));
        testEmptySetSemantics(set);
        set.addAll(singletonDomain.fullSet());
        assertEquals(singletonDomain.fullSet(), set);
    }

    @Test
    public void operationsWithCompatibleDomains() {
        final List<Object> objects = newObjectList(1 + Long.SIZE);
        final var largerDomain = new IndexedDomain<>(objects);
        final var smallerDomain = new IndexedDomain<>(objects.subList(0, Long.SIZE));
        assertTrue(largerDomain.isCompatibleWith(smallerDomain));
        assertTrue(largerDomain.fullSet().containsAll(smallerDomain.fullSet()));
        final var smallerSet = new IndexedSet<>(smallerDomain.fullSet());
        smallerSet.removeAll(largerDomain.fullSet());
        testEmptySetSemantics(smallerSet);
        smallerSet.addAll(smallerDomain.fullSet());
        smallerSet.retainAll(largerDomain.fullSet());
        assertEquals(smallerDomain.fullSet(), smallerSet);
        final var largerSet = new IndexedSet<>(largerDomain.fullSet());
        largerSet.removeAll(smallerDomain.fullSet());
        assertEquals(Set.of(objects.getLast()), largerSet);
        largerSet.retainAll(smallerDomain.fullSet());
        testEmptySetSemantics(largerSet);
        largerSet.addAll(smallerDomain.fullSet());
        assertEquals(smallerDomain.fullSet(), largerSet);
    }

    private void testEmptySetSemantics(Set<?> set) {
        assertTrue(set.isEmpty());
        assertEquals(0, set.size());
        assertFalse(set.iterator().hasNext());
        assertTrue(set.containsAll(Set.of()));
        assertFalse(set.contains(new Object()));
    }

    private List<Object> newObjectList(int size) {
        final var elements = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            elements.add(new Object());
        }
        return elements;
    }
}
