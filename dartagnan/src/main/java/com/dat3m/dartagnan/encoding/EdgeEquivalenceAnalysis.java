package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.task.Context;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Dimension;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.EDGE_EQUIVALENCE;

/*
    Finds edges of derived relations that are exactly equivalent to another edge, so that they can be
    encoded by the formula of that edge instead of getting their own variable.

    An edge r(e1, e2) is normally encoded as a fresh variable together with a clause relating it to the
    definition of r. If the definition of r at (e1, e2) is exactly a single edge s(e3, e4), e.g.
        r := s^-1          r(e1, e2) == s(e2, e1)
        r := s | t         r(e1, e2) == s(e1, e2)   if t(e1, e2) is impossible
        r := s \ t         r(e1, e2) == s(e1, e2)   if t(e1, e2) is impossible
        r := [s]           r(e1, e1) == s(e1, e1)
        r := domain(s)     r(e1, e1) == s(e1, e)    if e is the only possible successor (symmetric for range)
        r := s ; t         r(e1, e2) == s(e1, e)    if e is the only possible intermediate event
                                                    and t(e, e2) is a droppable must-edge (see below)
        r := [s] * [t]     r(e1, e2) == s(e1, e1)   if t(e2, e2) is a droppable must-edge
        r := s & t         r(e1, e2) == s(e1, e2)   if t(e1, e2) is a droppable must-edge
    then s(e3, e4) is the equivalent edge of r(e1, e2): EncodingContext.edge() returns the formula of s(e3, e4)
    for r(e1, e2). The definition clause of r(e1, e2) is still encoded, but it becomes a tautology
    (e.g. "l <=> l"), which the solver removes. Chains collapse, because the equivalent edge is itself obtained
    via EncodingContext.edge().

    An edge r(e1, e2) has an equivalent edge only if
        - r is not (mutually) recursive (to guarantee termination when resolving equivalent edges),
        - (e1, e2) is an active, non-trivial edge (may but not must) of r, and
        - the equivalent edge is encoded as a constant or a literal (a non-trivial edge, an impossible edge,
          or a must-edge whose execution is a single event).
    The equivalent edge is the exact semantics of r and hence sound under any approximation of r.

    Must-edges: a conjunction of a kept edge k(a, b) and a must-edge m(c, d) is equivalent to k(a, b) alone,
    if k(a, b) implies the execution of c and d (m(c, d) is encoded as exec(c) /\ exec(d)). This is the case if
        - c and d are implied (ExecutionAnalysis) by a or b, whose execution is in turn implied by k(a, b).
        - k is not self-supporting, i.e. neither a transitive closure nor a recursive relation, nor derived
          from one. Their encoding only requires the edges to be a fixed point of the definition, not
          necessarily the least one, so an edge can support itself (e.g. via a cycle) even if its events
          are not executed.
    NOTE: Equivalent edges are computed for all definitions. EncodingContext ignores them for relations whose
     definition is not encoded (e.g. cut definitions in refinement), so that those stay free variables.
 */
@Options
public final class EdgeEquivalenceAnalysis {

    private static final Logger logger = LoggerFactory.getLogger(EdgeEquivalenceAnalysis.class);

    public enum Mode {
        // Every non-trivial edge gets its own variable.
        NONE,
        // Edges whose definition is exactly a constant or a literal are encoded by it.
        LITERALS,
    }

    // An edge of a relation.
    record Edge(Relation relation, Event first, Event second) {}

    @Option(name = EDGE_EQUIVALENCE,
            description = "Encodes edges of derived relations by an equivalent edge instead of introducing " +
                    "a new variable: NONE (never) or LITERALS (edges whose definition is exactly " +
                    "a constant or a literal).",
            secure = true)
    private Mode mode = Mode.LITERALS;

    private final RelationAnalysis ra;
    private final ExecutionAnalysis exec;
    private final Map<Relation, Map<Event, Map<Event, Edge>>> equivalents = new HashMap<>();

    private EdgeEquivalenceAnalysis(RelationAnalysis ra, ExecutionAnalysis exec) {
        this.ra = ra;
        this.exec = exec;
    }

    public static EdgeEquivalenceAnalysis fromConfig(Wmm memoryModel, Context analysisContext, Configuration config)
            throws InvalidConfigurationException {
        final EdgeEquivalenceAnalysis analysis = new EdgeEquivalenceAnalysis(analysisContext.requires(RelationAnalysis.class),
                analysisContext.requires(ExecutionAnalysis.class));
        config.inject(analysis);
        logger.info("{}: {}", EDGE_EQUIVALENCE, analysis.mode);
        if (analysis.mode != Mode.NONE) {
            analysis.run(memoryModel, analysisContext.requires(ActiveSetAnalysis.class));
            final int count = analysis.equivalents.values().stream()
                    .flatMap(m -> m.values().stream()).mapToInt(Map::size).sum();
            logger.info("#Edges with an equivalent edge: {}", count);
        }
        return analysis;
    }

    // Returns the edge that the edge (e1, e2) of the relation is equivalent to, if there is one.
    Optional<Edge> getEquivalent(Relation relation, Event e1, Event e2) {
        return Optional.ofNullable(equivalents.getOrDefault(relation, Map.of())
                .getOrDefault(e1, Map.of())
                .get(e2));
    }

    boolean hasEquivalents(Relation relation) {
        return equivalents.containsKey(relation);
    }

    // ====================================================================================
    // Computation

    private void run(Wmm memoryModel, ActiveSetAnalysis activeSets) {
        final Set<Relation> recursive = new HashSet<>();
        final Set<Relation> selfSupporting = new HashSet<>();
        for (Set<DependencyGraph<Relation>.Node> scc : DependencyGraph.from(memoryModel.getRelations()).getSCCs()) {
            final Set<Relation> stratum = new HashSet<>();
            scc.forEach(n -> stratum.add(n.getContent()));
            if (stratum.size() > 1 || stratum.stream().anyMatch(r -> r.getDependencies().contains(r))) {
                recursive.addAll(stratum);
            }
            if (!Collections.disjoint(stratum, recursive)
                    || stratum.stream().anyMatch(r -> r.getDefinition() instanceof TransitiveClosure
                            || r.getDependencies().stream().anyMatch(selfSupporting::contains))) {
                selfSupporting.addAll(stratum);
            }
        }

        final EquivalentFinder finder = new EquivalentFinder(selfSupporting);
        for (Constraint c : memoryModel.getConstraints()) {
            if (!(c instanceof Definition def) || recursive.contains(def.getDefinedRelation())) {
                continue;
            }
            final EquivalentFunction equivalentFunction = def.accept(finder);
            if (equivalentFunction == null) {
                continue;
            }
            final Relation r = def.getDefinedRelation();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(r);
            final EventGraph may = k.getMaySet();
            final EventGraph must = k.getMustSet();
            final Map<Event, Map<Event, Edge>> map = new HashMap<>();
            activeSets.getActiveSet(def).apply((e1, e2) -> {
                if (!may.contains(e1, e2) || must.contains(e1, e2)) {
                    return;
                }
                final Edge t = equivalentFunction.get(e1, e2);
                if (t != null && isLiteral(t)) {
                    map.computeIfAbsent(e1, _ -> new HashMap<>()).put(e2, t);
                }
            });
            if (!map.isEmpty()) {
                equivalents.put(r, map);
            }
        }
    }

    // Mirrors EncodingContext.edge() and EncodingContext.execution(Event, Event).
    private boolean isLiteral(Edge t) {
        final RelationAnalysis.Knowledge k = ra.getKnowledge(t.relation());
        if (!k.getMaySet().contains(t.first(), t.second()) || !k.getMustSet().contains(t.first(), t.second())) {
            // Constant false or an edge variable (or, transitively, its equivalent edge).
            return true;
        }
        final Event x = t.first();
        final Event y = t.second();
        return x.equals(y) || exec.isImplied(x, y) || exec.isImplied(y, x);
    }

    @FunctionalInterface
    private interface EquivalentFunction {
        // Returns the edge that is exactly the definition at the non-trivial edge (e1, e2), or null.
        Edge get(Event e1, Event e2);
    }

    private final class EquivalentFinder implements Constraint.Visitor<EquivalentFunction> {

        private final Set<Relation> selfSupporting;

        private EquivalentFinder(Set<Relation> selfSupporting) {
            this.selfSupporting = selfSupporting;
        }

        private EventGraph may(Relation r) { return ra.getKnowledge(r).getMaySet(); }
        private EventGraph must(Relation r) { return ra.getKnowledge(r).getMustSet(); }

        // Returns the edge that r1(a, b) /\ r2(c, d) is equivalent to, if one of them is a droppable must-edge.
        private Edge conjunction(Relation r1, Event a, Event b, Relation r2, Event c, Event d) {
            if (isDroppable(r2, c, d, r1, a, b)) {
                return new Edge(r1, a, b);
            }
            if (isDroppable(r1, a, b, r2, c, d)) {
                return new Edge(r2, c, d);
            }
            return null;
        }

        // Returns true if the must-edge m(c, d) is implied by the kept edge k(a, b).
        private boolean isDroppable(Relation m, Event c, Event d, Relation k, Event a, Event b) {
            return must(m).contains(c, d) && !selfSupporting.contains(k)
                    && isImplied(a, b, c) && isImplied(a, b, d);
        }

        // Returns true if the execution of e is implied by an edge between a and b.
        private boolean isImplied(Event a, Event b, Event e) {
            return isImpliedBy(a, e) || isImpliedBy(b, e);
        }

        // An edge only implies the control flow of its events, which implies their execution if cfImpliesExec().
        private boolean isImpliedBy(Event x, Event e) {
            return x.cfImpliesExec() && (x.equals(e) || exec.isImplied(x, e));
        }

        @Override
        public EquivalentFunction visitConstraint(Constraint constraint) {
            return null;
        }

        @Override
        public EquivalentFunction visitInverse(Inverse inv) {
            final Relation r1 = inv.getOperand();
            return (e1, e2) -> new Edge(r1, e2, e1);
        }

        @Override
        public EquivalentFunction visitSetIdentity(SetIdentity id) {
            final Relation domain = id.getDomain();
            return (e1, e2) -> e1.equals(e2) ? new Edge(domain, e1, e1) : null;
        }

        @Override
        public EquivalentFunction visitUnion(Union union) {
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
                return single == null ? null : new Edge(single, e1, e2);
            };
        }

        @Override
        public EquivalentFunction visitDifference(Difference diff) {
            final Relation minuend = diff.getMinuend();
            final EventGraph maySubtrahend = may(diff.getSubtrahend());
            return (e1, e2) -> maySubtrahend.contains(e1, e2) ? null : new Edge(minuend, e1, e2);
        }

        @Override
        public EquivalentFunction visitComposition(Composition comp) {
            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            final Map<Event, Set<Event>> out1 = may(r1).getOutMap();
            final EventGraph may2 = may(r2);
            return (e1, e2) -> {
                Event single = null;
                for (Event e : out1.getOrDefault(e1, Set.of())) {
                    if (may2.contains(e, e2)) {
                        if (single != null) {
                            return null;
                        }
                        single = e;
                    }
                }
                return single == null ? null : conjunction(r1, e1, single, r2, single, e2);
            };
        }

        @Override
        public EquivalentFunction visitProduct(CartesianProduct prod) {
            final Relation domain = prod.getDomain();
            final Relation range = prod.getRange();
            return (e1, e2) -> conjunction(domain, e1, e1, range, e2, e2);
        }

        @Override
        public EquivalentFunction visitIntersection(Intersection inter) {
            final List<Relation> operands = inter.getOperands();
            return (e1, e2) -> {
                Relation single = null;
                for (Relation r : operands) {
                    if (!must(r).contains(e1, e2)) {
                        if (single != null) {
                            return null;
                        }
                        single = r;
                    }
                }
                if (single == null) {
                    return null;
                }
                // The intersection is the single non-must operand, if every must operand is droppable.
                for (Relation r : operands) {
                    if (r != single && !isDroppable(r, e1, e2, single, e1, e2)) {
                        return null;
                    }
                }
                return new Edge(single, e1, e2);
            };
        }

        @Override
        public EquivalentFunction visitProjection(Projection proj) {
            final Relation r1 = proj.getOperand();
            final boolean dom = proj.getDimension() == Dimension.DOMAIN;
            final Map<Event, Set<Event>> altMap = dom ? may(r1).getOutMap() : may(r1).getInMap();
            return (e1, e2) -> {
                final Set<Event> alts = altMap.getOrDefault(e1, Set.of());
                if (alts.size() != 1) {
                    return null;
                }
                final Event alt = alts.iterator().next();
                return dom ? new Edge(r1, e1, alt) : new Edge(r1, alt, e1);
            };
        }
    }
}
