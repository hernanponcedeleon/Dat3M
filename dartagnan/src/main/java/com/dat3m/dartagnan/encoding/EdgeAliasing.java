package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Dimension;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FunctionDeclaration;
import org.sosy_lab.java_smt.api.visitors.DefaultBooleanFormulaVisitor;

import java.util.*;

/*
    Edge aliasing: an edge (e1, e2) of a derived relation r is normally encoded as a fresh variable r(e1, e2)
    together with a clause relating it to the definition of r, e.g.
        rf(x, y) => rf^-1(y, x)
        rf^-1(y, x) /\ co(y, z) => fr(x, z)
    If the definition of r at (e1, e2) is small (e.g. a single literal), we instead let the edge encoder of r
    return that formula directly, and the definition clause is dropped:
        rf(x, y) /\ co(y, z) => fr(x, z)
    Since every consumer obtains edge formulas via EncodingContext.edge(), they all see the substituted formula
    and no intermediate variable is ever created. Chains collapse transitively, because operand edges are
    themselves obtained via EncodingContext.edge().
    The definition clauses of aliased edges are skipped by WmmEncoder (see getEncodedSet()), while the edges
    themselves stay in the active set, so that the operand edges they refer to remain encoded.

    The substitution r(e1, e2) := def(e1, e2) is the exact semantics of r and thus sound independent of the
    approximation (polarity) used to encode the definition otherwise. The only exception is the dropping of
    implied must-conjuncts, which can over-approximate r, but only where that is sound (see AliasBuilder.and()).

    An edge can only be aliased if
        - the definition of r is actually encoded (cut definitions in refinement must stay free variables),
        - r is not (mutually) recursive (to guarantee termination of the substitution),
        - (e1, e2) is a non-trivial edge (may but not must), and
        - the definition of r at (e1, e2) has a simple form (see the visitor below).
    Whether such an edge is actually aliased is decided by an EdgeAliasPolicy
    (by default, only if the definition is equivalent to a constant or a literal).
 */
final class EdgeAliasing {

    // Returns the formula that the non-trivial edge (e1, e2) is substituted by, or null if it is not aliased.
    interface Alias {
        BooleanFormula get(Event e1, Event e2);
    }

    private EdgeAliasing() {}

    static Map<Relation, Alias> compute(EncodingContext ctx, Collection<? extends Constraint> encodedConstraints,
                                        EdgeAliasPolicy policy) {
        final Set<Relation> recursive = new HashSet<>();
        final Set<Relation> relations = ctx.getTask().getMemoryModel().getRelations();
        for (Set<DependencyGraph<Relation>.Node> scc : DependencyGraph.from(relations).getSCCs()) {
            if (scc.size() > 1 || scc.stream().anyMatch(n -> n.getDependencies().contains(n))) {
                scc.forEach(n -> recursive.add(n.getContent()));
            }
        }

        final BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        final AliasBuilder builder = new AliasBuilder(ctx);
        final Map<Relation, Alias> aliases = new HashMap<>();
        for (Constraint c : encodedConstraints) {
            if (!(c instanceof Definition def) || recursive.contains(def.getDefinedRelation())) {
                continue;
            }
            final Alias alias = def.accept(builder);
            if (alias != null) {
                final Relation r = def.getDefinedRelation();
                aliases.put(r, cached((e1, e2) -> {
                    final BooleanFormula f = alias.get(e1, e2);
                    return f != null && policy.accept(r, e1, e2, f, shape(bmgr, f)) ? f : null;
                }));
            }
        }
        return aliases;
    }

    private static EdgeAliasPolicy.Shape shape(BooleanFormulaManager bmgr, BooleanFormula f) {
        if (bmgr.isTrue(f) || bmgr.isFalse(f)) {
            return EdgeAliasPolicy.Shape.CONSTANT;
        }
        final boolean literal = bmgr.visit(f, new DefaultBooleanFormulaVisitor<>() {
            @Override
            protected Boolean visitDefault() { return false; }
            @Override
            public Boolean visitAtom(BooleanFormula atom, FunctionDeclaration<BooleanFormula> decl) { return true; }
            @Override
            public Boolean visitNot(BooleanFormula operand) { return bmgr.visit(operand, IS_ATOM); }
        });
        return literal ? EdgeAliasPolicy.Shape.LITERAL : EdgeAliasPolicy.Shape.OTHER;
    }

    private static final DefaultBooleanFormulaVisitor<Boolean> IS_ATOM = new DefaultBooleanFormulaVisitor<>() {
        @Override
        protected Boolean visitDefault() { return false; }
        @Override
        public Boolean visitAtom(BooleanFormula atom, FunctionDeclaration<BooleanFormula> decl) { return true; }
    };

    private static Alias cached(Alias alias) {
        final Map<Event, Map<Event, Optional<BooleanFormula>>> cache = new HashMap<>();
        return (e1, e2) -> cache.computeIfAbsent(e1, _ -> new HashMap<>())
                .computeIfAbsent(e2, _ -> Optional.ofNullable(alias.get(e1, e2)))
                .orElse(null);
    }

    // NOTE: The aliases are evaluated lazily, i.e., only after EncodingContext has stored them.
    //  This is required, because they obtain the edges of the operands via EncodingContext.edge(),
    //  which must already return aliased edges for chains to collapse.
    private static final class AliasBuilder implements Constraint.Visitor<Alias> {

        private final EncodingContext ctx;
        private final RelationAnalysis ra;
        private final ExecutionAnalysis exec;
        private final BooleanFormulaManager bmgr;

        private AliasBuilder(EncodingContext ctx) {
            this.ctx = ctx;
            this.ra = ctx.getAnalysisContext().requires(RelationAnalysis.class);
            this.exec = ctx.getAnalysisContext().requires(ExecutionAnalysis.class);
            this.bmgr = ctx.getBooleanFormulaManager();
        }

        private EventGraph may(Relation r) { return ra.getKnowledge(r).getMaySet(); }
        private EventGraph must(Relation r) { return ra.getKnowledge(r).getMustSet(); }
        private BooleanFormula edge(Relation r, Event e1, Event e2) { return ctx.edge(r).encode(e1, e2); }

        // Encodes r1(a, b) /\ r2(c, d). If one of the edges is a must-edge (i.e. encoded as the execution of its
        // events) whose execution is implied by the events of the other edge, that conjunct is dropped.
        // This is exact if the edge literal of the other edge implies the execution of its events. This holds
        // for relations whose definition is encoded as "edge => def", but not for over-approximated relations
        // (encoded as "def => edge") whose edge literals are unconstrained from above. However, the polarity
        // of the operands follows the one of the defined relation, so in that case the defined relation only
        // needs to be over-approximated as well, which the dropped form does.
        // (cf. the must-edge optimization of compositions in da545df6c)
        private BooleanFormula and(Relation r1, Event a, Event b, Relation r2, Event c, Event d) {
            if (must(r2).contains(c, d) && implied(a, b, c) && implied(a, b, d)) {
                return edge(r1, a, b);
            }
            if (must(r1).contains(a, b) && implied(c, d, a) && implied(c, d, b)) {
                return edge(r2, c, d);
            }
            return bmgr.and(edge(r1, a, b), edge(r2, c, d));
        }

        private boolean implied(Event x, Event y, Event e) {
            return e == x || e == y || exec.isImplied(x, e) || exec.isImplied(y, e);
        }

        @Override
        public Alias visitConstraint(Constraint constraint) {
            return null;
        }

        @Override
        public Alias visitInverse(Inverse inv) {
            final Relation r1 = inv.getOperand();
            return (e1, e2) -> edge(r1, e2, e1);
        }

        @Override
        public Alias visitSetIdentity(SetIdentity id) {
            final Relation domain = id.getDomain();
            return (e1, e2) -> e1 == e2 ? edge(domain, e1, e1) : bmgr.makeFalse();
        }

        @Override
        public Alias visitProduct(CartesianProduct prod) {
            final Relation domain = prod.getDomain();
            final Relation range = prod.getRange();
            return (e1, e2) -> and(domain, e1, e1, range, e2, e2);
        }

        @Override
        public Alias visitUnion(Union union) {
            final List<Relation> operands = union.getOperands();
            return (e1, e2) -> {
                Relation single = null;
                for (Relation r : operands) {
                    if (may(r).contains(e1, e2)) {
                        if (single != null) {
                            return null;
                        }
                        single = r;
                    }
                }
                return single == null ? bmgr.makeFalse() : edge(single, e1, e2);
            };
        }

        @Override
        public Alias visitIntersection(Intersection inter) {
            final List<Relation> operands = inter.getOperands();
            return (e1, e2) -> {
                Relation single = null;
                for (Relation r : operands) {
                    if (!may(r).contains(e1, e2)) {
                        return bmgr.makeFalse();
                    }
                    if (!must(r).contains(e1, e2)) {
                        if (single != null) {
                            return null;
                        }
                        single = r;
                    }
                }
                // If all operands contain a must-edge, then so does the intersection (never aliased).
                return single == null ? null : edge(single, e1, e2);
            };
        }

        @Override
        public Alias visitDifference(Difference diff) {
            final Relation minuend = diff.getMinuend();
            final Relation subtrahend = diff.getSubtrahend();
            return (e1, e2) -> may(subtrahend).contains(e1, e2) ? null : edge(minuend, e1, e2);
        }

        @Override
        public Alias visitComposition(Composition comp) {
            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            final EventGraph may2 = may(r2);
            final Supplier<Map<Event, Set<Event>>> out1 = Suppliers.memoize(() -> may(r1).getOutMap());
            return (e1, e2) -> {
                Event single = null;
                for (Event e : out1.get().getOrDefault(e1, Set.of())) {
                    if (may2.contains(e, e2)) {
                        if (single != null) {
                            return null;
                        }
                        single = e;
                    }
                }
                return single == null ? bmgr.makeFalse() : and(r1, e1, single, r2, single, e2);
            };
        }

        @Override
        public Alias visitProjection(Projection proj) {
            final Relation r1 = proj.getOperand();
            final boolean dom = proj.getDimension() == Dimension.DOMAIN;
            final Supplier<Map<Event, Set<Event>>> altMap = Suppliers.memoize(() -> {
                final EventGraph may1 = may(r1);
                return dom ? may1.getOutMap() : may1.getInMap();
            });
            return (e1, e2) -> {
                final Set<Event> alts = altMap.get().getOrDefault(e1, Set.of());
                if (alts.size() != 1) {
                    return alts.isEmpty() ? bmgr.makeFalse() : null;
                }
                final Event alt = alts.iterator().next();
                return dom ? edge(r1, e1, alt) : edge(r1, alt, e1);
            };
        }
    }
}
