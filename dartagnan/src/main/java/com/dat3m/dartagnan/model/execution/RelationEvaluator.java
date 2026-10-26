package com.dat3m.dartagnan.model.execution;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Dimension;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.immutable.ImmutableMapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.google.common.base.Preconditions;

import java.util.*;

/*
    Computes the derived relations of a memory model from the contents of its base relations.
    Sets are represented as graphs containing only pairs (e, e), like in the rest of Dartagnan.

    A relation is considered "base" if it has no dependencies; its contents must be provided by the caller.
    All other relations are computed bottom-up along the dependency graph,
    recursive relations via a (monotone) fixed-point iteration over their SCC.
 */
final class RelationEvaluator {

    private RelationEvaluator() {}

    static boolean isBase(Relation relation) {
        return relation.getDependencies().isEmpty();
    }

    // Computes the given relations (and their dependencies) that are not yet contained in "known".
    // Returns "known" extended by all newly computed relations.
    static Map<Relation, EventGraph> computeDerived(Collection<Relation> relations, Map<Relation, EventGraph> known) {
        final Map<Relation, EventGraph> values = new HashMap<>(known);
        final Evaluator evaluator = new Evaluator(values);
        for (Set<DependencyGraph<Relation>.Node> scc : DependencyGraph.from(relations).getSCCs()) {
            final List<Relation> derived = scc.stream()
                    .map(DependencyGraph.Node::getContent)
                    .filter(r -> !isBase(r))
                    .toList();
            if (derived.isEmpty() || derived.stream().allMatch(values::containsKey)) {
                continue;
            }
            Preconditions.checkState(derived.size() == scc.size(), "Base relation in recursive SCC: %s", scc);
            final boolean recursive = derived.size() > 1 || derived.get(0).getDependencies().contains(derived.get(0));
            if (!recursive) {
                final Relation r = derived.get(0);
                values.put(r, freeze(r.getDefinition().accept(evaluator)));
                continue;
            }
            // Least fixed point of the recursive SCC.
            derived.forEach(r -> values.put(r, EventGraph.empty()));
            boolean changed = true;
            while (changed) {
                changed = false;
                for (Relation r : derived) {
                    final EventGraph next = freeze(r.getDefinition().accept(evaluator));
                    if (next.size() != values.get(r).size()) {
                        values.put(r, next);
                        changed = true;
                    }
                }
            }
        }
        for (Relation r : relations) {
            Preconditions.checkState(values.containsKey(r), "No value for relation %s", r);
        }
        return values;
    }

    // Checks whether the axiom holds on the given relation contents (taking negation into account).
    static boolean isSatisfied(Axiom axiom, EventGraph graph) {
        final boolean holds = switch (axiom) {
            case Emptiness _ -> graph.isEmpty();
            case Irreflexivity _ -> graph.getDomain().stream().noneMatch(e -> graph.contains(e, e));
            case Acyclicity _ -> isAcyclic(graph);
            default -> throw new UnsupportedOperationException("Unsupported axiom: " + axiom);
        };
        return holds != axiom.isNegated();
    }

    // ======================================================================================================
    // Internals

    private static EventGraph freeze(EventGraph graph) {
        return graph instanceof ImmutableMapEventGraph ? graph : ImmutableMapEventGraph.from(graph);
    }

    private static boolean isAcyclic(EventGraph graph) {
        // Iterative DFS with three colors: absent = unvisited, FALSE = on stack, TRUE = finished.
        final Map<Event, Set<Event>> out = graph.getOutMap();
        final Map<Event, Boolean> state = new HashMap<>();
        for (Event root : out.keySet()) {
            if (state.containsKey(root)) {
                continue;
            }
            final Deque<Event> nodes = new ArrayDeque<>();
            final Deque<Iterator<Event>> iterators = new ArrayDeque<>();
            nodes.push(root);
            iterators.push(out.getOrDefault(root, Set.of()).iterator());
            state.put(root, false);
            while (!nodes.isEmpty()) {
                final Iterator<Event> it = iterators.peek();
                if (!it.hasNext()) {
                    state.put(nodes.pop(), true);
                    iterators.pop();
                    continue;
                }
                final Event next = it.next();
                final Boolean s = state.get(next);
                if (s == null) {
                    state.put(next, false);
                    nodes.push(next);
                    iterators.push(out.getOrDefault(next, Set.of()).iterator());
                } else if (!s) {
                    return false;
                }
            }
        }
        return true;
    }

    private static final class Evaluator implements Constraint.Visitor<EventGraph> {

        private final Map<Relation, EventGraph> values;

        private Evaluator(Map<Relation, EventGraph> values) {
            this.values = values;
        }

        private EventGraph get(Relation r) {
            final EventGraph g = values.get(r);
            Preconditions.checkState(g != null, "Relation %s is used before it is computed", r);
            return g;
        }

        private EventGraph[] get(List<Relation> rs) {
            return rs.stream().map(this::get).toArray(EventGraph[]::new);
        }

        @Override
        public EventGraph visitDefinition(Definition def) {
            throw new UnsupportedOperationException("Cannot derive relation " + def.getDefinedRelation()
                    + " with definition " + def.getClass().getSimpleName());
        }

        @Override
        public EventGraph visitUnion(Union union) {
            return EventGraph.union(get(union.getOperands()));
        }

        @Override
        public EventGraph visitIntersection(Intersection inter) {
            return EventGraph.intersection(get(inter.getOperands()));
        }

        @Override
        public EventGraph visitDifference(Difference diff) {
            return EventGraph.difference(get(diff.getMinuend()), get(diff.getSubtrahend()));
        }

        @Override
        public EventGraph visitInverse(Inverse inv) {
            return get(inv.getOperand()).inverse();
        }

        @Override
        public EventGraph visitComposition(Composition comp) {
            final EventGraph left = get(comp.getLeftOperand());
            final Map<Event, Set<Event>> right = get(comp.getRightOperand()).getOutMap();
            final MapEventGraph result = new MapEventGraph();
            left.apply((e1, e2) -> {
                final Set<Event> range = right.get(e2);
                if (range != null && !range.isEmpty()) {
                    result.addRange(e1, range);
                }
            });
            return result;
        }

        @Override
        public EventGraph visitTransitiveClosure(TransitiveClosure trans) {
            final Map<Event, Set<Event>> out = get(trans.getOperand()).getOutMap();
            final MapEventGraph result = new MapEventGraph();
            for (Event source : out.keySet()) {
                // BFS from each source
                final Set<Event> reached = new HashSet<>();
                final Deque<Event> worklist = new ArrayDeque<>(out.get(source));
                while (!worklist.isEmpty()) {
                    final Event e = worklist.pop();
                    if (reached.add(e)) {
                        worklist.addAll(out.getOrDefault(e, Set.of()));
                    }
                }
                result.addRange(source, reached);
            }
            return result;
        }

        @Override
        public EventGraph visitSetIdentity(SetIdentity id) {
            // Sets are already represented as identity graphs.
            return get(id.getDomain());
        }

        @Override
        public EventGraph visitProduct(CartesianProduct product) {
            final Set<Event> domain = get(product.getDomain()).getDomain();
            final Set<Event> range = get(product.getRange()).getDomain();
            final MapEventGraph result = new MapEventGraph();
            if (!range.isEmpty()) {
                domain.forEach(e -> result.addRange(e, range));
            }
            return result;
        }

        @Override
        public EventGraph visitProjection(Projection projection) {
            final EventGraph operand = get(projection.getOperand());
            final Set<Event> elements = projection.getDimension() == Dimension.DOMAIN
                    ? operand.getDomain() : operand.getRange();
            final MapEventGraph result = new MapEventGraph();
            elements.forEach(e -> result.add(e, e));
            return result;
        }
    }
}
