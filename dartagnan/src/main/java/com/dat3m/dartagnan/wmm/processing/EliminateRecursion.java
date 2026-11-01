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
    Replaces recursively defined relations by equivalent non-recursive definitions, whenever possible.

    A group of mutually recursive relations that only uses union and composition can be seen as a
    context-free grammar whose terminals are the (non-recursive) relations it refers to.
    The least fixed point assigns to each recursive relation the union over all words of its language,
    each word interpreted as the composition of its letters.
    Whenever the language of the grammar is regular, we can replace the recursion by an equivalent
    regular expression built from union, composition and transitive closure.

    Deciding regularity of context-free grammars is undecidable, so we only detect the following
    sufficient (syntactic) conditions:
      (1) Right-linear systems:  X_i = c_i | U_j a_ij;X_j       with solution  x = A*;c
      (2) Left-linear systems:   X_i = c_i | U_j X_j;b_ji       with solution  x = c;B*
      (3) Matrix systems: the n = k*k variables can be arranged into a k x k matrix M such that
              M = C | A;M | M;B | M;K;M
          for constant matrices A, B, C, K (with id-entries allowed), which has solution
              M = A*;C;(B | K;A*;C)*
          This covers the ppo definition of Power, where M = [[ii, ic], [ci, cc]].
    Any other recursion is left untouched.

    NOTE: The rewriting is exact, i.e., the resulting relations are equivalent to the recursive ones.
 */
public class EliminateRecursion implements WmmProcessor {

    private static final Logger logger = LoggerFactory.getLogger(EliminateRecursion.class);

    // Bounds to avoid blow-ups when extracting/solving the grammar.
    private static final int MAX_WORDS = 1000;
    private static final int MAX_MATRIX_DIMENSION = 3;

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
    // Words of the grammar

    private sealed interface Sym permits Var, Letter { }
    private record Var(int index) implements Sym { }
    private record Letter(Relation relation) implements Sym { }

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

    // ---------------------------- Matrices over Expr ----------------------------

    private static Expr[][] zeroMatrix(int n, int m) {
        final Expr[][] r = new Expr[n][m];
        for (Expr[] row : r) { Arrays.fill(row, ZERO); }
        return r;
    }

    private static Expr[][] multiply(Expr[][] a, Expr[][] b) {
        final int n = a.length, k = b.length, m = b[0].length;
        final Expr[][] r = zeroMatrix(n, m);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                for (int l = 0; l < k; l++) {
                    r[i][j] = sum(r[i][j], product(a[i][l], b[l][j]));
                }
            }
        }
        return r;
    }

    private static Expr[][] add(Expr[][] a, Expr[][] b) {
        final Expr[][] r = zeroMatrix(a.length, a[0].length);
        for (int i = 0; i < a.length; i++) {
            for (int j = 0; j < a[0].length; j++) {
                r[i][j] = sum(a[i][j], b[i][j]);
            }
        }
        return r;
    }

    // Reflexive-transitive closure of a square matrix (Kleene's algorithm).
    private static Expr[][] star(Expr[][] a) {
        final int n = a.length;
        Expr[][] r = a;
        for (int k = 0; k < n; k++) {
            final Expr[][] next = zeroMatrix(n, n);
            final Expr loop = star(r[k][k]);
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    if (i == k && j == k) {
                        next[i][j] = plus(r[k][k]);
                    } else if (i == k) {
                        next[i][j] = product(loop, r[k][j]);             // r_kj | r_kk;r_kk*;r_kj
                    } else if (j == k) {
                        next[i][j] = product(r[i][k], loop);             // r_ik | r_ik;r_kk*;r_kk
                    } else {
                        next[i][j] = sum(r[i][j], product(r[i][k], product(loop, r[k][j])));
                    }
                }
            }
            r = next;
        }
        for (int i = 0; i < n; i++) {
            r[i][i] = sum(r[i][i], ONE);
        }
        return r;
    }

    private static Expr toExpr(List<Sym> word) {
        Expr e = ONE;
        for (Sym s : word) {
            e = product(e, new Atom(((Letter) s).relation()));
        }
        return e;
    }

    private static Expr toExpr(Collection<List<Sym>> words) {
        Expr e = ZERO;
        for (List<Sym> w : words) { e = sum(e, toExpr(w)); }
        return e;
    }

    // ============================================================================================

    private static final class SccRewriter {

        private final Wmm wmm;
        private final Set<Relation> component;
        private final List<Relation> vars = new ArrayList<>();
        // words.get(i) is the set of words defining vars.get(i) (excluding the trivial word "X_i").
        private final List<Set<List<Sym>>> words = new ArrayList<>();

        SccRewriter(Wmm wmm, List<Relation> allRelations, Set<Relation> component) {
            this.wmm = wmm;
            this.component = component;
            // Variables are the relations of the SCC that are recursive or observable from outside.
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
            if (!extractGrammar()) {
                logger.debug("Could not extract grammar for recursive relations {}", names);
                return;
            }
            String method = "right-linear";
            Expr[] solution = solveRightLinear();
            if (solution == null) {
                method = "left-linear";
                solution = solveLeftLinear();
            }
            if (solution == null) {
                method = "matrix";
                solution = solveMatrix();
            }
            if (solution == null || !materialize(solution)) {
                logger.info("Could not eliminate recursion in {}", names);
                return;
            }
            logger.info("Eliminated recursion in {} ({} system)", names, method);
        }

        // ---------------------------- Grammar extraction ----------------------------

        private boolean extractGrammar() {
            for (Relation r : component) {
                if (!r.isRelation()) { return false; }
                final Definition def = r.getDefinition();
                if (!(def instanceof Union || def instanceof Composition)) { return false; }
            }
            for (int i = 0; i < vars.size(); i++) {
                final Set<List<Sym>> ws = expandDefinition(vars.get(i), new HashSet<>());
                if (ws == null) { return false; }
                ws.remove(List.<Sym>of(new Var(i)));
                words.add(ws);
            }
            return true;
        }

        private Set<List<Sym>> expand(Relation r, Set<Relation> stack) {
            final int index = vars.indexOf(r);
            if (index >= 0) { return Set.of(List.of(new Var(index))); }
            if (!component.contains(r)) {
                // The empty relation contributes no words.
                return r.getDefinition() instanceof Empty ? Set.of() : Set.of(List.of(new Letter(r)));
            }
            return expandDefinition(r, stack);
        }

        private Set<List<Sym>> expandDefinition(Relation r, Set<Relation> stack) {
            if (!stack.add(r)) { return null; }
            final Definition def = r.getDefinition();
            Set<List<Sym>> result = new LinkedHashSet<>();
            if (def instanceof Union union) {
                for (Relation op : union.getOperands()) {
                    final Set<List<Sym>> ws = expand(op, stack);
                    if (ws == null) { return null; }
                    result.addAll(ws);
                }
            } else if (def instanceof Composition comp) {
                final Set<List<Sym>> left = expand(comp.getLeftOperand(), stack);
                final Set<List<Sym>> right = left == null ? null : expand(comp.getRightOperand(), stack);
                if (right == null) { return null; }
                for (List<Sym> l : left) {
                    for (List<Sym> rr : right) {
                        final List<Sym> w = new ArrayList<>(l);
                        w.addAll(rr);
                        result.add(List.copyOf(w));
                    }
                }
            } else {
                return null;
            }
            stack.remove(r);
            return result.size() > MAX_WORDS ? null : result;
        }

        private static int countVars(List<Sym> word) {
            return (int) word.stream().filter(Var.class::isInstance).count();
        }

        // ---------------------------- Linear systems ----------------------------

        private Expr[] solveRightLinear() {
            final int n = vars.size();
            final Expr[][] a = zeroMatrix(n, n);
            final Expr[][] c = zeroMatrix(n, 1);
            for (int i = 0; i < n; i++) {
                for (List<Sym> w : words.get(i)) {
                    final int numVars = countVars(w);
                    if (numVars == 0) {
                        c[i][0] = sum(c[i][0], toExpr(w));
                    } else if (numVars == 1 && w.getLast() instanceof Var v) {
                        a[i][v.index()] = sum(a[i][v.index()], toExpr(w.subList(0, w.size() - 1)));
                    } else {
                        return null;
                    }
                }
            }
            final Expr[][] x = multiply(star(a), c);
            final Expr[] result = new Expr[n];
            for (int i = 0; i < n; i++) { result[i] = x[i][0]; }
            return result;
        }

        private Expr[] solveLeftLinear() {
            final int n = vars.size();
            final Expr[][] b = zeroMatrix(n, n);
            final Expr[][] c = zeroMatrix(1, n);
            for (int i = 0; i < n; i++) {
                for (List<Sym> w : words.get(i)) {
                    final int numVars = countVars(w);
                    if (numVars == 0) {
                        c[0][i] = sum(c[0][i], toExpr(w));
                    } else if (numVars == 1 && w.getFirst() instanceof Var v) {
                        b[v.index()][i] = sum(b[v.index()][i], toExpr(w.subList(1, w.size())));
                    } else {
                        return null;
                    }
                }
            }
            final Expr[][] x = multiply(c, star(b));
            return x[0];
        }

        // ---------------------------- Matrix systems ----------------------------

        private Expr[] solveMatrix() {
            final int n = vars.size();
            final int k = (int) Math.round(Math.sqrt(n));
            if (k * k != n || k > MAX_MATRIX_DIMENSION) { return null; }
            final int[] cellOf = new int[n];
            for (int i = 0; i < n; i++) { cellOf[i] = i; }
            do {
                final Expr[] result = trySolveMatrix(k, cellOf);
                if (result != null) { return result; }
            } while (nextPermutation(cellOf));
            return null;
        }

        // Tries to solve the system as M = C | A;M | M;B | M;K;M where variable i is placed at cell cellOf[i].
        private Expr[] trySolveMatrix(int k, int[] cellOf) {
            final int n = vars.size();
            final int[] varAt = new int[n];
            for (int i = 0; i < n; i++) { varAt[cellOf[i]] = i; }
            final List<List<Set<List<Sym>>>> c = emptyWordMatrix(k);
            final List<List<Set<List<Sym>>>> a = emptyWordMatrix(k);
            final List<List<Set<List<Sym>>>> b = emptyWordMatrix(k);
            final List<List<Set<List<Sym>>>> kk = emptyWordMatrix(k);

            // Classify the words.
            for (int x = 0; x < n; x++) {
                final int p = cellOf[x] / k, q = cellOf[x] % k;
                for (List<Sym> w : words.get(x)) {
                    final int numVars = countVars(w);
                    final boolean startsWithVar = w.getFirst() instanceof Var;
                    final boolean endsWithVar = w.getLast() instanceof Var;
                    if (numVars == 0) {
                        c.get(p).get(q).add(w);
                    } else if (numVars == 1 && endsWithVar && cellOf[((Var) w.getLast()).index()] % k == q) {
                        final int r = cellOf[((Var) w.getLast()).index()] / k;
                        a.get(p).get(r).add(w.subList(0, w.size() - 1));
                    } else if (numVars == 1 && startsWithVar && cellOf[((Var) w.getFirst()).index()] / k == p) {
                        final int r = cellOf[((Var) w.getFirst()).index()] % k;
                        b.get(r).get(q).add(w.subList(1, w.size()));
                    } else if (numVars == 2 && startsWithVar && endsWithVar
                            && cellOf[((Var) w.getFirst()).index()] / k == p
                            && cellOf[((Var) w.getLast()).index()] % k == q) {
                        final int r = cellOf[((Var) w.getFirst()).index()] % k;
                        final int s = cellOf[((Var) w.getLast()).index()] / k;
                        kk.get(r).get(s).add(w.subList(1, w.size() - 1));
                    } else {
                        return null;
                    }
                }
            }

            // Check that the system is exactly M = C | A;M | M;B | M;K;M.
            for (int x = 0; x < n; x++) {
                final int p = cellOf[x] / k, q = cellOf[x] % k;
                final Set<List<Sym>> expected = new HashSet<>(c.get(p).get(q));
                for (int r = 0; r < k; r++) {
                    final Var left = new Var(varAt[p * k + r]);
                    final Var right = new Var(varAt[r * k + q]);
                    for (List<Sym> w : a.get(p).get(r)) { expected.add(concat(w, List.of(right))); }
                    for (List<Sym> w : b.get(r).get(q)) { expected.add(concat(List.of(left), w)); }
                    for (int s = 0; s < k; s++) {
                        final Var right2 = new Var(varAt[s * k + q]);
                        for (List<Sym> w : kk.get(r).get(s)) {
                            expected.add(concat(concat(List.of(left), w), List.of(right2)));
                        }
                    }
                }
                expected.remove(List.<Sym>of(new Var(x)));
                if (!expected.equals(words.get(x))) { return null; }
            }

            // M = A*;C;(B | K;A*;C)*
            final Expr[][] aStar = star(toExprMatrix(a));
            final Expr[][] aStarC = multiply(aStar, toExprMatrix(c));
            final Expr[][] loop = add(toExprMatrix(b), multiply(toExprMatrix(kk), aStarC));
            final Expr[][] m = multiply(aStarC, star(loop));
            final Expr[] result = new Expr[n];
            for (int x = 0; x < n; x++) { result[x] = m[cellOf[x] / k][cellOf[x] % k]; }
            return result;
        }

        private static List<List<Set<List<Sym>>>> emptyWordMatrix(int k) {
            final List<List<Set<List<Sym>>>> m = new ArrayList<>();
            for (int i = 0; i < k; i++) {
                final List<Set<List<Sym>>> row = new ArrayList<>();
                for (int j = 0; j < k; j++) { row.add(new LinkedHashSet<>()); }
                m.add(row);
            }
            return m;
        }

        private static Expr[][] toExprMatrix(List<List<Set<List<Sym>>>> m) {
            final int k = m.size();
            final Expr[][] r = new Expr[k][k];
            for (int i = 0; i < k; i++) {
                for (int j = 0; j < k; j++) { r[i][j] = toExpr(m.get(i).get(j)); }
            }
            return r;
        }

        private static List<Sym> concat(List<Sym> a, List<Sym> b) {
            final List<Sym> r = new ArrayList<>(a);
            r.addAll(b);
            return List.copyOf(r);
        }

        private static boolean nextPermutation(int[] a) {
            int i = a.length - 2;
            while (i >= 0 && a[i] >= a[i + 1]) { i--; }
            if (i < 0) { return false; }
            int j = a.length - 1;
            while (a[j] <= a[i]) { j--; }
            swap(a, i, j);
            for (int l = i + 1, r = a.length - 1; l < r; l++, r--) { swap(a, l, r); }
            return true;
        }

        private static void swap(int[] a, int i, int j) {
            final int t = a[i];
            a[i] = a[j];
            a[j] = t;
        }

        // ---------------------------- Materialization ----------------------------

        // A materialized expression: a relation (null if empty) plus a flag whether the identity is included.
        private record Materialized(Relation relation, boolean hasId) { }

        private final Map<Expr, Materialized> cache = new HashMap<>();

        private boolean materialize(Expr[] solution) {
            final Materialized[] results = new Materialized[vars.size()];
            for (int i = 0; i < vars.size(); i++) {
                results[i] = materialize(solution[i]);
                if (results[i].hasId()) {
                    // Cannot happen, since every word contains a letter. We bail out to be safe.
                    return false;
                }
            }
            for (int i = 0; i < vars.size(); i++) {
                final Relation var = vars.get(i);
                final Relation rel = results[i].relation();
                wmm.removeDefinition(var);
                wmm.addDefinition(rel == null ? new Empty(var) : new Union(var, rel));
                var.clearRecursive();
            }
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
