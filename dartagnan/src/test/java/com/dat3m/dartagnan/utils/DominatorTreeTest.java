package com.dat3m.dartagnan.utils;

import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

public class DominatorTreeTest {

    // Graph: 0 -> 1 -> 3, 0 -> 2 -> 3, and an unreachable node 4 -> 3.
    private static final Map<Integer, List<Integer>> SUCCESSORS = Map.of(
            0, List.of(1, 2),
            1, List.of(3),
            2, List.of(3),
            3, List.of(),
            4, List.of(3)
    );

    private static DominatorTree<Integer> tree() {
        return new DominatorTree<>(0, SUCCESSORS::get);
    }

    @Test
    public void reachableNodes() {
        final DominatorTree<Integer> tree = tree();
        assertTrue(tree.isDominatedBy(3, 0));
        assertTrue(tree.isDominatedBy(3, 3));
        assertFalse(tree.isDominatedBy(3, 1));
        assertFalse(tree.isDominatedBy(0, 1));
        assertEquals(0, (int) tree.getImmediateDominator(3));
        assertEquals(0, (int) tree.getNearestCommonDominator(1, 2));
        assertEquals(List.of(3, 0), ImmutableList.copyOf(tree.getDominators(3)));
    }

    @Test
    public void unreachableNodes() {
        final DominatorTree<Integer> tree = tree();
        assertFalse(tree.contains(4));
        assertFalse(tree.isDominatedBy(4, 0));
        assertFalse(tree.isDominatedBy(3, 4));
        assertNull(tree.getImmediateDominator(4));
        assertNull(tree.getNearestCommonDominator(4, 3));
        assertNull(tree.getNearestCommonDominator(3, 4));
        assertFalse(tree.getDominators(4).iterator().hasNext());
    }
}
