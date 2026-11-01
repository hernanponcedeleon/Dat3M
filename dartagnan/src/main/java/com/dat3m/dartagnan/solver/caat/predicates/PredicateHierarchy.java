package com.dat3m.dartagnan.solver.caat.predicates;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateListener;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.EmptyGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived.*;
import com.dat3m.dartagnan.solver.caat.predicates.sets.derived.DifferenceSet;
import com.dat3m.dartagnan.solver.caat.predicates.sets.derived.IntersectionSet;
import com.dat3m.dartagnan.solver.caat.predicates.sets.derived.ProjectionSet;
import com.dat3m.dartagnan.solver.caat.predicates.sets.derived.UnionSet;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;

import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Collectors;


/*
    A PredicateHierarchy has the following uses:
        - it maintains the dependency structure of CAATPredicates
        - it initializes/populates derived CAATPredicates
        - it propagates changes topologically along the dependency structure
        - it maintains a set of PredicateListeners to detect changes to CAATPredicates (e.g. for constraints)
 */
public class PredicateHierarchy {
    private final Map<CAATPredicate, Set<PredicateListener>> listenersMap;
    private final DependencyGraph<CAATPredicate> dependencyGraph;
    private final PriorityQueue<Task> tasks = new PriorityQueue<>();
    private final Set<CAATPredicate> basePredicates;

    private Domain<?> domain;

    // Predicates whose changes need not be propagated (see <computeDeadPredicates>).
    private final Set<CAATPredicate> deadPredicates = new HashSet<>();

    // Caches to avoid repeated lookups during propagation and backtracking.
    private record PredInfo(DependencyGraph<CAATPredicate>.Node node, PredicateListener[] listeners,
                            boolean dead, boolean absorbing) { }
    private IdentityHashMap<CAATPredicate, PredInfo> infos;
    private PredInfo[] infoList; // In topological order

    private void ensureCaches() {
        if (infos != null) {
            return;
        }
        final List<CAATPredicate> list = getPredicateList();
        infos = new IdentityHashMap<>(list.size() * 2);
        infoList = new PredInfo[list.size()];
        for (int i = 0; i < list.size(); i++) {
            final CAATPredicate pred = list.get(i);
            final PredInfo info = new PredInfo(dependencyGraph.get(pred),
                    listenersMap.get(pred).toArray(new PredicateListener[0]),
                    deadPredicates.contains(pred), isAbsorbing(pred));
            infos.put(pred, info);
            infoList[i] = info;
        }
    }

    private void invalidateCaches() {
        infos = null;
    }

    // ============== Construction ===============

    public PredicateHierarchy(Set<CAATPredicate> predicates) {
        dependencyGraph = DependencyGraph.from(predicates);
        // The hashmap is created with a special load factor and capacity to avoid resizing.
        listenersMap = new HashMap<>(dependencyGraph.getNodeContents().size() * 4 / 3, 0.75f);
        dependencyGraph.getNodeContents().forEach(x -> listenersMap.put(x, new HashSet<>()));

        basePredicates = dependencyGraph.getNodeContents().stream()
                .filter(p -> p.getDependencies().isEmpty()).collect(Collectors.toSet());
    }

    // ========================================

    // ============= Accessors =================

    public Set<CAATPredicate> getPredicates() { return listenersMap.keySet(); }

    public Set<CAATPredicate> getBasePredicates() { return basePredicates; }

    // The list of graphs in topological order
    public List<CAATPredicate> getPredicateList() { return dependencyGraph.getNodeContents(); }

    public DependencyGraph<CAATPredicate> getDependencyGraph() {
        return dependencyGraph;
    }

    public Domain<?> getDomain() { return domain; }

    /*
        Used by the online solver to avoid useless propagation. A predicate is "dead" if it is not constrained and
            (1) it is empty in every execution, or
            (2) all its dependents are dead, or
            (3) it has static membership (its membership queries are answered statically) and each dependent is
                either dead or an intersection that has some operand without static membership
                (such intersections only need to query, but not enumerate, the static operand).
        <isEmptyBase> tells which base predicates are empty in every execution.
        Changes are never propagated into dead predicates.
     */
    public Set<CAATPredicate> computeDeadPredicates(Set<CAATPredicate> constrained, Predicate<CAATPredicate> isEmptyBase) {
        deadPredicates.clear();
        // Predicates that are empty in every execution (dependencies first)
        final Set<CAATPredicate> empty = new HashSet<>();
        for (CAATPredicate pred : getPredicateList()) {
            if (isStaticallyEmpty(pred, empty, isEmptyBase)) {
                empty.add(pred);
            }
        }
        // Dead predicates (dependents first)
        final List<CAATPredicate> preds = new ArrayList<>(getPredicateList());
        Collections.reverse(preds);
        for (CAATPredicate pred : preds) {
            if (constrained.contains(pred)) {
                continue;
            }
            final List<DependencyGraph<CAATPredicate>.Node> dependents = dependencyGraph.get(pred).getDependents();
            final boolean dead = empty.contains(pred)
                    || (!dependents.isEmpty() && dependents.stream().allMatch(d -> deadPredicates.contains(d.getContent())))
                    || (pred.hasStaticMembership() && dependents.stream().map(DependencyGraph.Node::getContent)
                            .allMatch(d -> deadPredicates.contains(d) || isAbsorbing(d)));
            if (dead) {
                deadPredicates.add(pred);
            }
        }
        invalidateCaches();
        return Collections.unmodifiableSet(deadPredicates);
    }

    private static boolean isStaticallyEmpty(CAATPredicate pred, Set<CAATPredicate> empty, Predicate<CAATPredicate> isEmptyBase) {
        final List<? extends CAATPredicate> deps = pred.getDependencies();
        if (deps.isEmpty()) {
            return pred instanceof EmptyGraph || isEmptyBase.test(pred);
        } else if (pred instanceof CompositionGraph || pred instanceof IntersectionGraph
                || pred instanceof CartesianGraph || pred instanceof IntersectionSet) {
            return deps.stream().anyMatch(empty::contains);
        } else if (pred instanceof DifferenceGraph || pred instanceof DifferenceSet) {
            return empty.contains(deps.get(0));
        } else if (pred instanceof UnionGraph || pred instanceof UnionSet || pred instanceof TransitiveGraph
                || pred instanceof InverseGraph || pred instanceof SetIdentityGraph || pred instanceof ProjectionSet) {
            return deps.stream().allMatch(empty::contains);
        }
        return false; // E.g. recursive graphs: be conservative
    }

    // Intersections that have an operand without static membership only query their static operands.
    private static boolean isAbsorbing(CAATPredicate pred) {
        return (pred instanceof IntersectionGraph || pred instanceof IntersectionSet)
                && pred.getDependencies().stream().anyMatch(o -> !o.hasStaticMembership());
    }

    // ==========================================

    // ============== Initialization =============

    public void initializeToDomain(Domain<?> domain) {
        this.domain = domain;
        for (CAATPredicate pred : getPredicateList()) {
            pred.initializeToDomain(domain);
            for (PredicateListener listener : listenersMap.get(pred)) {
                listener.onDomainInit(pred, domain);
            }
        }
    }

    // Computes the content of all derived predicates in topological order
    public void populate() {
        for (Set<DependencyGraph<CAATPredicate>.Node> scc : dependencyGraph.getSCCs()) {
            Set<CAATPredicate> recGrp = scc.stream().map(DependencyGraph.Node::getContent).collect(Collectors.toSet());
            if (recGrp.size() == 1) {
                recGrp.stream().findAny().get().repopulate();
            } else {
                populateRecursively(recGrp.stream().findAny().get(), recGrp, new HashSet<>());

                // For all recursive relations, initialize the propagation
                recGrp.stream().filter(x -> x instanceof RecursiveGraph).forEach(x -> {
                    for(CAATPredicate dep : x.getDependencies()) {
                        createPropagationTask(dep, x, new ArrayList<>(dep.setView()), 0);
                    }
                });

                // Propagate within this recursive group
                while (!tasks.isEmpty()) {
                    handleTask(tasks.poll(), true);
                }
            }
        }

        // Notify listeners about population
        for (CAATPredicate pred : getPredicateList()) {
            for (PredicateListener listener : listenersMap.get(pred)) {
                listener.onPopulation(pred);
            }
        }
    }

    private void populateRecursively(CAATPredicate pred, Set<CAATPredicate> recGroup, Set<CAATPredicate> initialized) {
        if (initialized.contains(pred) || !recGroup.contains(pred)) {
            return;
        }

        if (pred instanceof RecursiveGraph) {
            pred.repopulate();
            initialized.add(pred);
        }
        for (CAATPredicate dep : pred.getDependencies()) {
            populateRecursively(dep, recGroup, initialized);
        }
        if (!initialized.contains(pred)) {
            pred.repopulate();
            initialized.add(pred);
        }
    }

    // ==========================================

    // ============== Propagation ===============

    // Should only ever be used on base predicates
    public void addAndPropagate(CAATPredicate pred, Collection<? extends Derivable> props) {
        if (!basePredicates.contains(pred)) {
            throw new UnsupportedOperationException("Cannot directly add elements to derived predicate: " + pred.getName());
        }
        createPropagationTask(null, pred, props, 0);
        forwardPropagate();
    }

    public void backtrackTo(int time) {
        ensureCaches();
        for (PredInfo info : infoList) {
            final CAATPredicate pred = info.node.getContent();
            pred.backtrackTo(time);
            for (PredicateListener listener : info.listeners) {
                listener.onBacktrack(pred, time);
            }
        }
    }

    // --------------------------------------------

    private void forwardPropagate() {
        while (!tasks.isEmpty()) {
            handleTask(tasks.poll(), false);
        }
    }

    private void createPropagationTask(CAATPredicate from, CAATPredicate target, Collection<? extends Derivable> added, int priority) {
        if (target == null || added.isEmpty()) {
            return;
        }
        tasks.add(new Task(from, target, added, priority));
    }

    private void handleTask(Task task, boolean withinRecGroup) {
        ensureCaches();
        final CAATPredicate target = task.target;
        final Collection<? extends Derivable> newlyAdded = target.forwardPropagate(task.from, task.added);
        if (newlyAdded.isEmpty()) {
            // Nothing has changed, so we don't create new propagation tasks
            return;
        }

        final PredInfo targetInfo = infos.get(target);
        final DependencyGraph<CAATPredicate>.Node targetNode = targetInfo.node;
        for (PredicateListener listener : targetInfo.listeners) {
            listener.onChanged(target, newlyAdded);
        }

        // Within recursive groups, we limit the propagation to the same group.
        final Set<DependencyGraph<CAATPredicate>.Node> recGroup = withinRecGroup ? targetNode.getSCC() : null;
        final boolean isStaticSource = target.hasStaticMembership();
        for (DependencyGraph<CAATPredicate>.Node dependent : targetNode.getDependents()) {
            final PredInfo depInfo = infos.get(dependent.getContent());
            if ((recGroup != null && !recGroup.contains(dependent))
                    || depInfo.dead || (isStaticSource && depInfo.absorbing)) {
                continue;
            }
            tasks.add(new Task(target, dependent.getContent(), newlyAdded, dependent.getTopologicalIndex()));
        }
    }

    // ==========================================

    // ============== Listeners =================

    public boolean addListener(CAATPredicate pred, PredicateListener listener) {
        if (!listenersMap.containsKey(pred)) {
            return false;
        }
        invalidateCaches();
        return listenersMap.get(pred).add(listener);
    }

    public boolean removeListener(CAATPredicate pred, PredicateListener listener) {
        if (!listenersMap.containsKey(pred)) {
            return false;
        }
        invalidateCaches();
        return listenersMap.get(pred).remove(listener);
    }

    public boolean removeListener(PredicateListener listener) {
        invalidateCaches();
        boolean changed = false;
        for (Set<PredicateListener> listeners : listenersMap.values()) {
            changed |= listeners.remove(listener);
        }
        return changed;
    }


    public void clearListeners() {
        invalidateCaches();
        listenersMap.values().forEach(Set::clear);
    }

    // ================= Internal structures ===================


    private record Task(CAATPredicate from, CAATPredicate target, Collection<? extends Derivable> added,
                        int priority) implements Comparable<Task> {

        @Override
            public int compareTo(Task o) {
                return this.priority - o.priority;
            }

        }
}
