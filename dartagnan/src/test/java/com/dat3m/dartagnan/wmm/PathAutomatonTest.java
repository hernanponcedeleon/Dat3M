package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.solver.propagators.PathAutomaton;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.Intersection;
import com.dat3m.dartagnan.wmm.definition.TransitiveClosure;
import com.dat3m.dartagnan.wmm.definition.Union;
import org.junit.Test;

import java.util.*;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.ID;
import static org.junit.Assert.*;

public class PathAutomatonTest {

    private final Wmm wmm = new Wmm();
    private final Relation a = wmm.newRelation("a");
    private final Relation b = wmm.newRelation("b");
    private final Relation c = wmm.newRelation("c");

    private Relation union(Relation... ops) {
        return wmm.addDefinition(new Union(wmm.newRelation(), ops));
    }

    private Relation seq(Relation r1, Relation r2) {
        return wmm.addDefinition(new Composition(wmm.newRelation(), r1, r2));
    }

    private Relation plus(Relation r) {
        return wmm.addDefinition(new TransitiveClosure(wmm.newRelation(), r));
    }

    private Relation opt(Relation r) {
        return union(r, wmm.getOrCreatePredefinedRelation(ID));
    }

    private PathAutomaton build(Axiom axiom) {
        return PathAutomaton.fromAxiom(axiom, 64).orElseThrow();
    }

    // Simulates the automaton on a word of atoms.
    private static boolean accepts(PathAutomaton aut, Relation... word) {
        Set<Integer> cur = Set.of(aut.getInitialState());
        for (Relation r : word) {
            final int letter = aut.getAlphabet().indexOf(r);
            if (letter < 0) {
                return false;
            }
            final Set<Integer> next = new HashSet<>();
            cur.forEach(q -> Arrays.stream(aut.getSuccessors(q, letter)).forEach(next::add));
            cur = next;
        }
        return cur.stream().anyMatch(aut::isFinal);
    }

    @Test
    public void acyclicAtom() {
        final PathAutomaton aut = build(new Acyclicity(a));
        assertEquals(List.of(a), aut.getAlphabet());
        assertEquals(2, aut.getNumStates());
        assertFalse(accepts(aut));
        assertTrue(accepts(aut, a));
        assertTrue(accepts(aut, a, a, a));
    }

    @Test
    public void acyclicUnion() {
        final PathAutomaton aut = build(new Acyclicity(union(a, b)));
        assertEquals(2, aut.getNumStates());
        assertTrue(accepts(aut, a, b, b, a));
        assertTrue(accepts(aut, b));
        assertFalse(accepts(aut, c));
    }

    @Test
    public void irreflexiveCompositionWithClosure() {
        // irreflexive(a;b+;c)
        final PathAutomaton aut = build(new Irreflexivity(seq(a, seq(plus(b), c))));
        assertEquals(Set.of(a, b, c), new HashSet<>(aut.getAlphabet()));
        assertEquals(4, aut.getNumStates());
        assertTrue(accepts(aut, a, b, c));
        assertTrue(accepts(aut, a, b, b, b, c));
        assertFalse(accepts(aut, a, c));
        assertFalse(accepts(aut, a, b));
        assertFalse(accepts(aut, b, c));
        assertFalse(accepts(aut, a, b, c, a, b, c));
    }

    @Test
    public void acyclicCompositionIsClosed() {
        // acyclic(a;b) = irreflexive((a;b)+)
        final PathAutomaton aut = build(new Acyclicity(seq(a, b)));
        assertTrue(accepts(aut, a, b));
        assertTrue(accepts(aut, a, b, a, b));
        assertFalse(accepts(aut, a, b, a));
        assertFalse(accepts(aut, b, a));
    }

    @Test
    public void optionalUsesIdentityAsLetter() {
        // irreflexive(a;b?) = irreflexive(a;(b|id))
        final Relation id = wmm.getOrCreatePredefinedRelation(ID);
        final PathAutomaton aut = build(new Irreflexivity(seq(a, opt(b))));
        assertTrue(accepts(aut, a, b));
        assertTrue(accepts(aut, a, id));
        assertFalse(accepts(aut, a));
        assertFalse(accepts(aut, id));
    }

    @Test
    public void nonRegularOperatorsAreAtoms() {
        final Relation inter = wmm.addDefinition(new Intersection(wmm.newRelation(), a, b));
        final PathAutomaton aut = build(new Acyclicity(union(inter, c)));
        assertEquals(Set.of(inter, c), new HashSet<>(aut.getAlphabet()));
    }

    @Test
    public void unsupportedAxioms() {
        assertTrue(PathAutomaton.fromAxiom(new Emptiness(a), 64).isEmpty());
        assertTrue(PathAutomaton.fromAxiom(new Acyclicity(a, true, false), 64).isEmpty());
        assertTrue(PathAutomaton.fromAxiom(new Acyclicity(a, false, true), 64).isEmpty());
        // Nothing to gain for irreflexivity of an atom
        assertTrue(PathAutomaton.fromAxiom(new Irreflexivity(a), 64).isEmpty());
    }

    @Test
    public void reduceUnfoldingDepthIfTooLarge() {
        // (a;b;c);(a;b;c) needs 7 states if fully unfolded
        final Relation abc = seq(a, seq(b, c));
        final Relation abcabc = seq(abc, abc);
        assertEquals(7, build(new Irreflexivity(abcabc)).getNumStates());

        final PathAutomaton reduced = PathAutomaton.fromAxiom(new Irreflexivity(abcabc), 4).orElseThrow();
        assertEquals(List.of(abc), reduced.getAlphabet());
        assertEquals(3, reduced.getNumStates());
        assertTrue(accepts(reduced, abc, abc));

        // Acyclicity axioms can always fall back to the relation itself as the only atom.
        final PathAutomaton atomic = PathAutomaton.fromAxiom(new Acyclicity(abcabc), 2).orElseThrow();
        assertEquals(List.of(abcabc), atomic.getAlphabet());
        assertEquals(2, atomic.getNumStates());
    }
}
