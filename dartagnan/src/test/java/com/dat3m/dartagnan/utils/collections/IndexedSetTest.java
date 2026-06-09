package com.dat3m.dartagnan.utils.collections;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Set;

import static org.junit.Assert.*;

public class IndexedSetTest {

    @Test
    public void simpleCollection() {
        final var objects = new Object[129];
        for (int i = 0; i < objects.length; i++) {
            objects[i] = new Object();
        }
        final var dom = new IndexedDomain<>(Arrays.asList(objects));
        // Test the empty set.
        final IndexedSet<?> empty = dom.newSet();
        assertTrue(empty.isEmpty());
        assertEquals(0, empty.size());
        assertFalse(empty.iterator().hasNext());
        // Test a filled set.
        final IndexedSet<?> some = dom.newSet();
        for (int i = 1; i < objects.length; i += i) {
            final boolean old = some.exchange(i, true);
            assertFalse(old);
        }
        assertFalse(some.isEmpty());
        assertEquals(8, some.size());
        assertTrue(some.iterator().hasNext());
        for (int i = 1; i < objects.length; i += i) {
            assertTrue(some.contains(objects[i]));
        }
        final var someList = new ArrayList<>(some);
        assertEquals(8, someList.size());
        for (int i = 1; i < objects.length; i += i) {
            assertTrue(some.contains(objects[i]));
        }
        final IndexedSet<?> all = dom.newSet(Arrays.asList(objects));
        assertEquals(Set.of(objects), all);
        final var someComplement = new IndexedSet<>(all);
        someComplement.removeAll(some);
        assertEquals(objects.length, some.size() + someComplement.size());
        for (Object o : objects) {
            assertNotEquals(some.contains(o), someComplement.contains(o));
        }
    }
}
