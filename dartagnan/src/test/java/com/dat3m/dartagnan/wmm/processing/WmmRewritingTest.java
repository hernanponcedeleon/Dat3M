package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.frontend.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import org.junit.Test;

import java.nio.file.Path;
import java.util.*;

import static org.junit.Assert.*;

/*
    Checks that EliminateRecursion and SimplifyClosures preserve the semantics of relations,
    by evaluating the least fixed point of all definitions on random interpretations of free relations.
 */
public class WmmRewritingTest {

    private record Edge(int from, int to) { }

    private static final String PPO_SYSTEM = """
            let rec ii = ii0 | ci | (ic;ci) | (ii;ii)
            and ic = ic0 | ii | cc | (ic;cc) | (ii;ic)
            and ci = ci0 | (ci;ii) | (cc;ci)
            and cc = cc0 | ci | (ci;ic) | (cc;cc)
            """;

    // ---------------------------------------------------------------------------------------------
    // EliminateRecursion

    @Test
    public void mutualRecursionIsKept() {
        // Only single recursive relations are rewritten, e.g. Power's ppo stays recursive.
        checkEquivalence("let ii0 = newRelation()\nlet ci0 = newRelation()\nlet cc0 = newRelation()\nlet ic0 = 0\n"
                + PPO_SYSTEM, List.of("ii", "ic", "ci", "cc"), false);
        checkEquivalence("""
                let a = newRelation()
                let b = newRelation()
                let c = newRelation()
                let rec x = a | b;y
                and y = c | a;x | y
                """, List.of("x", "y"), false);
    }

    @Test
    public void rightLinear() {
        checkEquivalence("""
                let a = newRelation()
                let b = newRelation()
                let c = newRelation()
                let rec x = a | b;x | (c;a;x) | c
                """, List.of("x"), true);
    }

    @Test
    public void ptxObservationLike() {
        // ptx-v6.0.cat: let rec observation = (morally-strong & rf) | (observation; rmw; observation)
        checkEquivalence("""
                let c = newRelation()
                let k = newRelation()
                let rec x = c | (x;k;x)
                """, List.of("x"), true);
    }

    @Test
    public void leftLinear() {
        checkEquivalence("""
                let a = newRelation()
                let b = newRelation()
                let rec x = a | x;b | (x;a;b)
                """, List.of("x"), true);
    }

    @Test
    public void transitiveClosureLike() {
        checkEquivalence("""
                let a = newRelation()
                let b = newRelation()
                let rec x = a | (x;b;x) | (b;x) | (x;a)
                """, List.of("x"), true);
    }

    @Test
    public void nonRegularIsKept() {
        // a^n x c^n is not regular: the recursion must be left untouched.
        checkEquivalence("""
                let a = newRelation()
                let b = newRelation()
                let c = newRelation()
                let rec x = a | (b;x;c)
                """, List.of("x"), false);
    }

    @Test
    public void powerPpoIsKept() throws Exception {
        // Power's ppo is mutually recursive and therefore left untouched.
        final Wmm wmm = new ParserCat().parse(Path.of("../cat/power.cat"));
        WmmProcessingManager.newInstance().run(wmm);
        for (String name : List.of("ii", "ic", "ci", "cc")) {
            assertTrue(name + " should stay recursive", wmm.getRelation(name).isRecursive());
        }
    }

    // ---------------------------------------------------------------------------------------------
    // SimplifyClosures

    @Test
    public void closureOfTransitiveRelation() {
        final String model = """
                let a = newRelation()
                let b = newRelation()
                let c = newRelation()
                let hb = a | b | c
                let pb = (a | (b;a));hb*
                let p = pb*;c
                """;
        checkEquivalence(model, List.of("hb", "pb", "p"), true);
        final Wmm wmm = new ParserCat().parse(model);
        SimplifyClosures.newInstance().run(wmm);
        final Relation pb = wmm.getRelation("pb");
        assertTrue(wmm.getRelations().stream().noneMatch(r ->
                r.getDefinition() instanceof TransitiveClosure tc && tc.getOperand() == pb));
    }

    @Test
    public void powerPropbaseClosureIsRemoved() throws Exception {
        final Wmm wmm = new ParserCat().parse(Path.of("../cat/power.cat"));
        SimplifyClosures.newInstance().run(wmm);
        final Relation propbase = wmm.getRelation("propbase");
        assertTrue(wmm.getRelations().stream().noneMatch(r ->
                r.getDefinition() instanceof TransitiveClosure tc && tc.getOperand() == propbase));
    }

    @Test
    public void irreflexiveRecursiveClosureBecomesAcyclic() {
        final Wmm wmm = new ParserCat().parse("""
                let f = newRelation()
                let g = newRelation()
                let rec x = f | (x;x)
                irreflexive x as ax
                acyclic g | x+ as ax2
                """);
        final Relation f = wmm.getRelation("f");
        final Relation g = wmm.getRelation("g");
        WmmProcessingManager.newInstance().run(wmm);
        // Ignore the axioms coming from stdlib.cat
        final List<Axiom> axioms = wmm.getAxioms().stream()
                .filter(a -> "ax".equals(a.getName()) || "ax2".equals(a.getName())).toList();
        assertEquals(2, axioms.size());
        for (Axiom ax : axioms) {
            assertTrue(ax instanceof Acyclicity);
        }
        final Axiom ax = axioms.stream().filter(a -> "ax".equals(a.getName())).findFirst().orElseThrow();
        assertSame(f, ax.getRelation());
        final Axiom ax2 = axioms.stream().filter(a -> "ax2".equals(a.getName())).findFirst().orElseThrow();
        assertTrue(ax2.getRelation().getDefinition() instanceof Union u
                && Set.copyOf(u.getOperands()).equals(Set.of(f, g)));
        assertFalse(axioms.stream().anyMatch(Irreflexivity.class::isInstance));
    }

    @Test
    public void aarch64ObBecomesAcyclicity() throws Exception {
        // aarch64.cat states "let rec ob = obs; si | lob | haz-ob | ob; ob" and "irreflexive ob".
        // This must become "acyclic (obs; si | lob | haz-ob)" without any recursion or closure.
        final Wmm wmm = new ParserCat().parse(Path.of("../cat/aarch64.cat"));
        WmmProcessingManager.newInstance().run(wmm);
        assertTrue(wmm.getRelations().stream().noneMatch(Relation::isRecursive));
        final Axiom external = wmm.getAxioms().stream()
                .filter(a -> "external".equals(a.getName())).findFirst().orElseThrow();
        assertTrue(external instanceof Acyclicity);
        assertTrue(external.getRelation().getDefinition() instanceof Union u
                && u.getOperands().size() == 3
                && u.getOperands().stream().noneMatch(o -> o.getDefinition() instanceof TransitiveClosure));
        assertTrue(((Union) external.getRelation().getDefinition()).getOperands().contains(wmm.getRelation("lob")));
        // The only remaining closure is the built-in transitive data dependency.
        assertEquals(1, wmm.getRelations().stream()
                .filter(r -> r.getDefinition() instanceof TransitiveClosure).count());
    }

    // ---------------------------------------------------------------------------------------------
    // Semantic check

    private static void checkEquivalence(String model, List<String> names, boolean expectNoRecursion) {
        final Random random = new Random(0);
        for (int round = 0; round < 200; round++) {
            final Wmm original = new ParserCat().parse(model);
            final Wmm rewritten = new ParserCat().parse(model);
            EliminateRecursion.newInstance().run(rewritten);
            SimplifyClosures.newInstance().run(rewritten);
            MergeEquivalentRelations.newInstance().run(rewritten);
            FlattenAssociatives.newInstance().run(rewritten);
            if (round == 0) {
                assertEquals(!expectNoRecursion, rewritten.getRelations().stream().anyMatch(Relation::isRecursive));
            }

            final int n = 1 + random.nextInt(6);
            final double density = 0.1 + 0.3 * random.nextDouble();
            final Map<String, Set<Edge>> freeValues = new HashMap<>();
            final Map<Relation, Set<Edge>> v1 = evaluate(original, n, density, random, freeValues);
            final Map<Relation, Set<Edge>> v2 = evaluate(rewritten, n, density, random, freeValues);
            for (String name : names) {
                assertEquals("Relation " + name + " differs in round " + round,
                        v1.get(original.getRelation(name)), v2.get(rewritten.getRelation(name)));
            }
        }
    }

    // Least fixed point by Kleene iteration over all definitions.
    private static Map<Relation, Set<Edge>> evaluate(Wmm wmm, int n, double density, Random random,
                                                     Map<String, Set<Edge>> freeValues) {
        final Map<Relation, Set<Edge>> val = new HashMap<>();
        for (Relation r : wmm.getRelations()) {
            if (r.getDefinition() instanceof Free) {
                final String name = r.getName().orElseThrow();
                val.put(r, freeValues.computeIfAbsent(name, k -> randomRelation(n, density, random)));
            } else {
                val.put(r, Set.of());
            }
        }
        boolean changed = true;
        while (changed) {
            changed = false;
            for (Relation r : wmm.getRelations()) {
                final Set<Edge> next = step(r.getDefinition(), val, n);
                if (next != null && !next.equals(val.get(r))) {
                    val.put(r, next);
                    changed = true;
                }
            }
        }
        return val;
    }

    private static Set<Edge> step(Definition def, Map<Relation, Set<Edge>> val, int n) {
        if (def instanceof Union u) {
            final Set<Edge> res = new HashSet<>();
            u.getOperands().forEach(o -> res.addAll(val.get(o)));
            return res;
        } else if (def instanceof Intersection i) {
            final Set<Edge> res = new HashSet<>(val.get(i.getOperands().getFirst()));
            i.getOperands().forEach(o -> res.retainAll(val.get(o)));
            return res;
        } else if (def instanceof Composition c) {
            return compose(val.get(c.getLeftOperand()), val.get(c.getRightOperand()));
        } else if (def instanceof TransitiveClosure tc) {
            final Set<Edge> inner = val.get(tc.getOperand());
            Set<Edge> res = new HashSet<>(inner);
            while (true) {
                final Set<Edge> next = new HashSet<>(res);
                next.addAll(compose(res, inner));
                if (next.equals(res)) { return res; }
                res = next;
            }
        } else if (def instanceof SetIdentity || def instanceof TagSet) {
            final Set<Edge> res = new HashSet<>();
            for (int i = 0; i < n; i++) { res.add(new Edge(i, i)); }
            return res;
        } else if (def instanceof Empty || def instanceof Free || def instanceof Definition.Undefined) {
            return null;
        }
        // Relations not used in the tested models (e.g., anarchic core relations)
        return null;
    }

    private static Set<Edge> compose(Set<Edge> a, Set<Edge> b) {
        final Set<Edge> res = new HashSet<>();
        for (Edge x : a) {
            for (Edge y : b) {
                if (x.to() == y.from()) { res.add(new Edge(x.from(), y.to())); }
            }
        }
        return res;
    }

    private static Set<Edge> randomRelation(int n, double density, Random random) {
        final Set<Edge> res = new HashSet<>();
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (random.nextDouble() < density) { res.add(new Edge(i, j)); }
            }
        }
        return res;
    }
}
