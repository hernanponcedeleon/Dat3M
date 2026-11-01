package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.Empty;
import com.dat3m.dartagnan.wmm.definition.TransitiveClosure;
import com.dat3m.dartagnan.wmm.definition.Union;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.stream.Collectors;

/*
    Replaces a recursively defined relation by an equivalent non-recursive definition, whenever possible.

    We only handle a single recursive relation X whose definition uses union and composition.
    Unfolding the definition yields a set of words over X and the (non-recursive) relations it refers to.
    The least fixed point assigns to X the union over all words of the corresponding grammar,
    each word interpreted as the composition of its letters.
    If every word has one of the shapes
        c        (no X)
        a;X      (X only at the end)
        X;b      (X only at the beginning)
        X;k;X    (X at both ends, k possibly empty)
    then X is the least solution of X = C | A;X | X;B | X;K;X, which is
        X = A*;C;(B | K;A*;C)*
    Derivation trees of this system read left to right as one block A*;C followed by any number of steps,
    each either B or K;A*;C. Every word of the closed form is derivable as well.

    This covers, e.g., the ob definition of AArch64 (X = F | X;X, hence X = F+) and the observation
    definition of PTX v6.0 (X = C | X;rmw;X, hence X = C;(rmw;C)*).
    Mutual recursion (e.g. the ppo definition of Power) and any other recursion are left untouched.

    NOTE: The rewriting is exact, i.e., the resulting relation is equivalent to the recursive one.
 */
public class EliminateRecursion implements WmmProcessor {

    private static final Logger logger = LoggerFactory.getLogger(EliminateRecursion.class);

    // Bound to avoid blow-ups when unfolding a definition.
    private static final int MAX_WORDS = 1000;

    private EliminateRecursion() { }

    public static EliminateRecursion newInstance() {
        return new EliminateRecursion();
    }

    @Override
    public void run(Wmm wmm) {
        final List<Relation> relations = List.copyOf(wmm.getRelations());
        final DependencyGraph<Relation> depGraph = DependencyGraph.from(relations);
        for (Set<DependencyGraph<Relation>.Node> scc : depGraph.getSCCs()) {
            final Set<Relation> component = scc.stream()
                    .map(DependencyGraph.Node::getContent)
                    .collect(Collectors.toCollection(LinkedHashSet::new));
            final boolean isCyclic = component.size() > 1 || component.stream()
                    .anyMatch(r -> r.getDependencies().contains(r));
            if (isCyclic) {
                new SccRewriter(wmm, relations, component).run();
            }
        }
    }

    // ============================================================================================
    // Words of the grammar: null stands for the recursive relation X.

    private static boolean isVar(Relation letter) {
        return letter == null;
    }

    private static int countVars(List<Relation> word) {
        return (int) word.stream().filter(EliminateRecursion::isVar).count();
    }

    // ============================================================================================
    // Symbolic relation expressions (with identity as an explicit element).

    private sealed interface Expr permits Zero, One, Atom, Plus, Sum, Product { }
    private record Zero() implements Expr { }
    private record One() implements Expr { }
    private record Atom(Relation relation) implements Expr { }
    private record Plus(Expr operand) implements Expr { }
    private record Sum(Set<Expr> operands) implements Expr { }
    private record Product(List<Expr> operands) implements Expr { }

    private static final Expr ZERO = new Zero();
    private static final Expr ONE = new One();

    private static Expr sum(Expr a, Expr b) {
        if (a instanceof Zero) { return b; }
        if (b instanceof Zero) { return a; }
        final Set<Expr> ops = new LinkedHashSet<>();
        for (Expr e : List.of(a, b)) {
            if (e instanceof Sum s) { ops.addAll(s.operands()); } else { ops.add(e); }
        }
        // Absorption: x | x+ = x+
        final List<Expr> absorbed = ops.stream().filter(e -> ops.contains(new Plus(e))).toList();
        absorbed.forEach(ops::remove);
        return ops.size() == 1 ? ops.iterator().next() : new Sum(Collections.unmodifiableSet(ops));
    }

    private static Expr product(Expr a, Expr b) {
        if (a instanceof Zero || b instanceof Zero) { return ZERO; }
        if (a instanceof One) { return b; }
        if (b instanceof One) { return a; }
        final List<Expr> ops = new ArrayList<>(factors(a));
        for (Expr f : factors(b)) {
            Expr cur = f;
            Expr merged;
            while (!ops.isEmpty() && (merged = mergeFactors(ops.getLast(), cur)) != null) {
                ops.removeLast();
                cur = merged;
            }
            ops.add(cur);
        }
        return ops.size() == 1 ? ops.getFirst() : new Product(List.copyOf(ops));
    }

    private static List<Expr> factors(Expr e) {
        return e instanceof Product p ? p.operands() : List.of(e);
    }

    // Returns the product x;y if it simplifies to a single factor, otherwise null.
    private static Expr mergeFactors(Expr x, Expr y) {
        final Expr xStar = starBase(x), yStar = starBase(y);
        final Expr xPlus = x instanceof Plus p ? p.operand() : null;
        final Expr yPlus = y instanceof Plus p ? p.operand() : null;
        if (x.equals(yStar) || y.equals(xStar)) {
            return plus(x.equals(yStar) ? x : y);       // x;x* = x*;x = x+
        }
        if (xPlus != null && xPlus.equals(yStar)) { return x; }   // x+;x* = x+
        if (xStar != null && xStar.equals(yPlus)) { return y; }   // x*;x+ = x+
        if (xStar != null && xStar.equals(yStar)) { return x; }   // x*;x* = x*
        return null;
    }

    // Returns x if e = x* (i.e., 1 | x+), otherwise null.
    private static Expr starBase(Expr e) {
        if (e instanceof Sum s && s.operands().size() == 2 && s.operands().contains(ONE)) {
            for (Expr o : s.operands()) {
                if (o instanceof Plus p) { return p.operand(); }
            }
        }
        return null;
    }

    private static Expr plus(Expr e) {
        if (e instanceof Zero || e instanceof One || e instanceof Plus) { return e; }
        if (e instanceof Sum s && s.operands().contains(ONE)) {
            // (1 | x)+ = 1 | x+
            Expr rest = ZERO;
            for (Expr o : s.operands()) {
                if (!(o instanceof One)) { rest = sum(rest, o); }
            }
            return sum(ONE, plus(rest));
        }
        return new Plus(e);
    }

    private static Expr star(Expr e) {
        return sum(ONE, plus(e));
    }

    private static Expr toExpr(List<Relation> word) {
        Expr e = ONE;
        for (Relation letter : word) {
            e = product(e, new Atom(letter));
        }
        return e;
    }

    // ============================================================================================

    private static final class SccRewriter {

        private final Wmm wmm;
        private final Set<Relation> component;
        // Relations of the component that are recursive or observable from outside of it.
        private final List<Relation> vars = new ArrayList<>();

        SccRewriter(Wmm wmm, List<Relation> allRelations, Set<Relation> component) {
            this.wmm = wmm;
            this.component = component;
            final Set<Relation> observed = new HashSet<>();
            for (Relation r : allRelations) {
                if (!component.contains(r)) { observed.addAll(r.getDependencies()); }
            }
            for (Constraint c : wmm.getConstraints()) {
                if (!(c instanceof Definition)) { observed.addAll(c.getConstrainedRelations()); }
            }
            for (Relation r : allRelations) {
                if (component.contains(r) && (r.isRecursive() || r.hasName() || observed.contains(r))) {
                    vars.add(r);
                }
            }
        }

        void run() {
            final String names = vars.stream().map(Relation::getNameOrTerm).collect(Collectors.joining(", "));
            final Expr solution = vars.size() == 1 ? solve() : null;
            if (solution == null || !materialize(vars.getFirst(), solution)) {
                logger.info("Could not eliminate recursion in {}", names);
                return;
            }
            logger.info("Eliminated recursion in {}", names);
        }

        // Returns A*;C;(B | K;A*;C)* if X = C | A;X | X;B | X;K;X, otherwise null.
        private Expr solve() {
            final Set<List<Relation>> words = extractWords();
            if (words == null) { return null; }
            Expr c = ZERO, a = ZERO, b = ZERO, k = ZERO;
            for (List<Relation> w : words) {
                final int numVars = countVars(w);
                final boolean startsWithVar = isVar(w.getFirst());
                final boolean endsWithVar = isVar(w.getLast());
                if (numVars == 0) {
                    c = sum(c, toExpr(w));
                } else if (numVars == 1 && endsWithVar) {
                    a = sum(a, toExpr(w.subList(0, w.size() - 1)));
                } else if (numVars == 1 && startsWithVar) {
                    b = sum(b, toExpr(w.subList(1, w.size())));
                } else if (numVars == 2 && startsWithVar && endsWithVar) {
                    k = sum(k, toExpr(w.subList(1, w.size() - 1)));
                } else {
                    return null;
                }
            }
            final Expr aStarC = product(star(a), c);
            return product(aStarC, star(sum(b, product(k, aStarC))));
        }

        // ---------------------------- Word extraction ----------------------------

        // Unfolds the definition of X into words, excluding the trivial word "X".
        private Set<List<Relation>> extractWords() {
            for (Relation r : component) {
                if (!r.isRelation()) { return null; }
                final Definition def = r.getDefinition();
                if (!(def instanceof Union || def instanceof Composition)) { return null; }
            }
            final Set<List<Relation>> words = expandDefinition(vars.getFirst(), new HashSet<>());
            if (words != null) {
                words.remove(Collections.singletonList((Relation) null));
            }
            return words;
        }

        private Set<List<Relation>> expand(Relation r, Set<Relation> stack) {
            if (r == vars.getFirst()) { return Set.of(Collections.singletonList(null)); }
            if (!component.contains(r)) {
                // The empty relation contributes no words.
                return r.getDefinition() instanceof Empty ? Set.of() : Set.of(List.of(r));
            }
            return expandDefinition(r, stack);
        }

        private Set<List<Relation>> expandDefinition(Relation r, Set<Relation> stack) {
            if (!stack.add(r)) { return null; }
            final Definition def = r.getDefinition();
            final Set<List<Relation>> result = new LinkedHashSet<>();
            if (def instanceof Union union) {
                for (Relation op : union.getOperands()) {
                    final Set<List<Relation>> ws = expand(op, stack);
                    if (ws == null) { return null; }
                    result.addAll(ws);
                }
            } else if (def instanceof Composition comp) {
                final Set<List<Relation>> left = expand(comp.getLeftOperand(), stack);
                final Set<List<Relation>> right = left == null ? null : expand(comp.getRightOperand(), stack);
                if (right == null) { return null; }
                for (List<Relation> l : left) {
                    for (List<Relation> rr : right) {
                        final List<Relation> w = new ArrayList<>(l);
                        w.addAll(rr);
                        result.add(Collections.unmodifiableList(w));
                    }
                }
            } else {
                return null;
            }
            stack.remove(r);
            return result.size() > MAX_WORDS ? null : result;
        }

        // ---------------------------- Materialization ----------------------------

        // A materialized expression: a relation (null if empty) plus a flag whether the identity is included.
        private record Materialized(Relation relation, boolean hasId) { }

        private final Map<Expr, Materialized> cache = new HashMap<>();

        private boolean materialize(Relation var, Expr solution) {
            final Materialized result = materialize(solution);
            if (result.hasId()) {
                // Cannot happen, since every word contains a letter. We bail out to be safe.
                return false;
            }
            final Relation rel = result.relation();
            wmm.removeDefinition(var);
            wmm.addDefinition(rel == null ? new Empty(var) : new Union(var, rel));
            var.clearRecursive();
            return true;
        }

        private Materialized materialize(Expr e) {
            final Materialized cached = cache.get(e);
            if (cached != null) { return cached; }
            final Materialized result = switch (e) {
                case Zero z -> new Materialized(null, false);
                case One o -> new Materialized(null, true);
                case Atom a -> new Materialized(a.relation(), false);
                case Plus p -> {
                    final Materialized m = materialize(p.operand());
                    yield new Materialized(m.relation() == null ? null : closure(m.relation()), m.hasId());
                }
                case Sum s -> {
                    final Set<Relation> ops = new LinkedHashSet<>();
                    boolean hasId = false;
                    for (Expr o : s.operands()) {
                        final Materialized m = materialize(o);
                        if (m.relation() != null) { ops.add(m.relation()); }
                        hasId |= m.hasId();
                    }
                    yield new Materialized(union(ops), hasId);
                }
                case Product p -> {
                    Materialized acc = materialize(p.operands().getFirst());
                    for (Expr o : p.operands().subList(1, p.operands().size())) {
                        acc = compose(acc, materialize(o));
                    }
                    yield acc;
                }
            };
            cache.put(e, result);
            return result;
        }

        // (a | id?);(b | id?) = a;b | (id in b ? a) | (id in a ? b) | (id in both ? id)
        private Materialized compose(Materialized x, Materialized y) {
            final Set<Relation> ops = new LinkedHashSet<>();
            if (x.relation() != null && y.relation() != null) {
                ops.add(wmm.addDefinition(new Composition(wmm.newRelation(), x.relation(), y.relation())));
            }
            if (y.hasId() && x.relation() != null) { ops.add(x.relation()); }
            if (x.hasId() && y.relation() != null) { ops.add(y.relation()); }
            return new Materialized(union(ops), x.hasId() && y.hasId());
        }

        private Relation union(Set<Relation> ops) {
            if (ops.isEmpty()) { return null; }
            if (ops.size() == 1) { return ops.iterator().next(); }
            return wmm.addDefinition(new Union(wmm.newRelation(), ops.toArray(Relation[]::new)));
        }

        private Relation closure(Relation r) {
            return wmm.addDefinition(new TransitiveClosure(wmm.newRelation(), r));
        }
    }
}
