package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.Dimension;

import java.util.*;
import java.util.function.Function;

/*
    Evaluates a CAT memory model on a concrete execution graph.
    Relations are bit-matrices over the visible nodes of the graph (plus "phantom" elements, see below),
    sets are bit-sets over the same universe.
 */
final class ConsistencyChecker {

    private final Wmm memoryModel;
    private final List<Thread> threads;
    private final Arch arch;
    private final List<Axiom> consistencyAxioms;
    private final List<Axiom> flaggedAxioms;
    private final Map<Relation, Set<Relation>> sccOf = new HashMap<>();

    ConsistencyChecker(Wmm memoryModel, List<Thread> threads, Arch arch, boolean checkFlagged) {
        this.memoryModel = memoryModel;
        this.threads = threads;
        this.arch = arch;
        this.consistencyAxioms = memoryModel.getAxioms().stream().filter(ax -> !ax.isFlagged()).toList();
        this.flaggedAxioms = checkFlagged
                ? memoryModel.getAxioms().stream().filter(Axiom::isFlagged).toList()
                : List.of();
        computeSCCs();
    }

    private void computeSCCs() {
        final DependencyGraph<Relation> dependencyGraph = DependencyGraph.from(memoryModel.getRelations());
        for (Set<DependencyGraph<Relation>.Node> component : dependencyGraph.getSCCs()) {
            final Set<Relation> members = new HashSet<>();
            component.forEach(n -> members.add(n.getContent()));
            final Relation some = members.iterator().next();
            final boolean isRecursive = members.size() > 1 || some.getDependencies().contains(some);
            if (isRecursive) {
                members.forEach(r -> sccOf.put(r, members));
            }
        }
    }

    record Result(boolean consistent, Axiom violatedFlag) {}

    Result check(ExplorationGraph g) {
        final Evaluation eval = new Evaluation(g);
        for (Axiom axiom : consistencyAxioms) {
            if (!eval.holds(axiom)) {
                return new Result(false, null);
            }
        }
        for (Axiom axiom : flaggedAxioms) {
            // A flagged axiom signals a violation if it holds.
            if (eval.holds(axiom)) {
                return new Result(true, axiom);
            }
        }
        return new Result(true, null);
    }

    // =====================================================================================================

    private final class Evaluation implements Definition.Visitor<Object> {

        private final ExplorationGraph g;
        private final List<Node> nodes = new ArrayList<>();
        private final IdentityHashMap<Node, Integer> index = new IdentityHashMap<>();
        private final int n;            // Size of the universe: visible nodes followed by phantom jump elements
        private final int numVisible;
        // Phantom elements represent the (non-visible) jumps that cause control dependencies:
        // Dat3M defines ctrl := idd+;ctrlDirect, where idd reaches the jump and ctrlDirect leaves it.
        private final List<Node> phantomOwners = new ArrayList<>();
        private final Map<Relation, Object> values = new HashMap<>();

        Evaluation(ExplorationGraph g) {
            this.g = g;
            for (Node init : g.getInitNodes()) {
                add(init);
            }
            for (Node node : g.getNodes()) {
                if (node.isVisible()) {
                    add(node);
                }
            }
            this.numVisible = nodes.size();
            for (Node node : List.copyOf(nodes)) {
                if (!node.ctrlDeps.isEmpty()) {
                    phantomOwners.add(node);
                }
            }
            this.n = numVisible + phantomOwners.size();
        }

        private void add(Node node) {
            index.put(node, nodes.size());
            nodes.add(node);
        }

        boolean holds(Axiom axiom) {
            final Object value = get(axiom.getRelation());
            final boolean base;
            if (axiom instanceof Acyclicity) {
                base = ((BitMatrix) value).isAcyclic();
            } else if (axiom instanceof Irreflexivity) {
                base = ((BitMatrix) value).isIrreflexive();
            } else if (axiom instanceof Emptiness) {
                base = value instanceof BitSet s ? s.isEmpty() : ((BitMatrix) value).isEmpty();
            } else {
                throw new UnsupportedOperationException("Unsupported axiom " + axiom);
            }
            return base != axiom.isNegated();
        }

        // ------------------------------------------------------------------------------------------
        // Relation evaluation with fixpoints for recursive relations

        Object get(Relation rel) {
            final Object cached = values.get(rel);
            if (cached != null) {
                return cached;
            }
            final Set<Relation> scc = sccOf.get(rel);
            if (scc == null) {
                final Object value = rel.getDefinition().accept(this);
                values.put(rel, value);
                return value;
            }
            // Fixpoint computation for the recursive component (starting from empty relations).
            for (Relation r : scc) {
                values.put(r, r.isSet() ? new BitSet(n) : new BitMatrix(n));
            }
            boolean changed = true;
            while (changed) {
                changed = false;
                for (Relation r : scc) {
                    final Object newValue = r.getDefinition().accept(this);
                    if (!newValue.equals(values.get(r))) {
                        changed = true;
                        values.put(r, newValue);
                    }
                }
            }
            return values.get(rel);
        }

        private BitSet set(Relation r) {
            return (BitSet) get(r);
        }

        private BitMatrix rel(Relation r) {
            return (BitMatrix) get(r);
        }

        // ------------------------------------------------------------------------------------------
        // Derived relations

        @Override
        public Object visitDefinition(Definition def) {
            throw new UnsupportedOperationException(String.format(
                    "Exploration does not support relation %s of type %s.", def.getDefinedRelation().getNameOrTerm(),
                    def.getClass().getSimpleName()));
        }

        @Override
        public Object visitUnion(Union def) {
            if (def.getDefinedRelation().isSet()) {
                final BitSet result = new BitSet(n);
                def.getOperands().forEach(r -> result.or(set(r)));
                return result;
            }
            final BitMatrix result = new BitMatrix(n);
            def.getOperands().forEach(r -> result.or(rel(r)));
            return result;
        }

        @Override
        public Object visitIntersection(Intersection def) {
            final List<Relation> ops = def.getOperands();
            if (def.getDefinedRelation().isSet()) {
                final BitSet result = (BitSet) set(ops.get(0)).clone();
                ops.subList(1, ops.size()).forEach(r -> result.and(set(r)));
                return result;
            }
            final BitMatrix result = rel(ops.get(0)).copy();
            ops.subList(1, ops.size()).forEach(r -> result.and(rel(r)));
            return result;
        }

        @Override
        public Object visitDifference(Difference def) {
            if (def.getDefinedRelation().isSet()) {
                final BitSet result = (BitSet) set(def.getMinuend()).clone();
                result.andNot(set(def.getSubtrahend()));
                return result;
            }
            final BitMatrix result = rel(def.getMinuend()).copy();
            result.andNot(rel(def.getSubtrahend()));
            return result;
        }

        @Override
        public Object visitComposition(Composition def) {
            return rel(def.getLeftOperand()).compose(rel(def.getRightOperand()));
        }

        @Override
        public Object visitInverse(Inverse def) {
            return rel(def.getOperand()).inverse();
        }

        @Override
        public Object visitTransitiveClosure(TransitiveClosure def) {
            return rel(def.getOperand()).transitiveClosure();
        }

        @Override
        public Object visitSetIdentity(SetIdentity def) {
            final BitSet s = set(def.getDomain());
            final BitMatrix result = new BitMatrix(n);
            for (int i = s.nextSetBit(0); i >= 0; i = s.nextSetBit(i + 1)) {
                result.set(i, i);
            }
            return result;
        }

        @Override
        public Object visitProduct(CartesianProduct def) {
            final BitSet dom = set(def.getDomain());
            final BitSet range = set(def.getRange());
            final BitMatrix result = new BitMatrix(n);
            for (int i = dom.nextSetBit(0); i >= 0; i = dom.nextSetBit(i + 1)) {
                for (int j = range.nextSetBit(0); j >= 0; j = range.nextSetBit(j + 1)) {
                    result.set(i, j);
                }
            }
            return result;
        }

        @Override
        public Object visitProjection(Projection def) {
            final BitMatrix v = rel(def.getOperand());
            return def.getDimension() == Dimension.DOMAIN ? v.domain() : v.range();
        }

        // ------------------------------------------------------------------------------------------
        // Base relations (only over visible nodes; phantom elements only appear in dependencies)

        @Override
        public Object visitEmpty(Empty def) {
            return def.getDefinedRelation().isSet() ? new BitSet(n) : new BitMatrix(n);
        }

        @Override
        public Object visitTagSet(TagSet def) {
            final BitSet result = new BitSet(n);
            for (int i = 0; i < numVisible; i++) {
                if (nodes.get(i).hasTag(def.getTag())) {
                    result.set(i);
                }
            }
            return result;
        }

        @Override
        public Object visitProgramOrder(ProgramOrder po) {
            final BitMatrix result = new BitMatrix(n);
            for (int i = 0; i < numVisible; i++) {
                final Node a = nodes.get(i);
                if (a.isInit()) {
                    continue;
                }
                for (int j = 0; j < numVisible; j++) {
                    final Node b = nodes.get(j);
                    if (b.thread == a.thread && !b.isInit() && a.poIndex < b.poIndex) {
                        result.set(i, j);
                    }
                }
            }
            return result;
        }

        @Override
        public Object visitExternal(External ext) {
            final BitMatrix result = new BitMatrix(n);
            for (int i = 0; i < numVisible; i++) {
                for (int j = 0; j < numVisible; j++) {
                    if (!sameThread(nodes.get(i), nodes.get(j))) {
                        result.set(i, j);
                    }
                }
            }
            return result;
        }

        @Override
        public Object visitInternal(Internal internal) {
            final BitMatrix result = new BitMatrix(n);
            for (int i = 0; i < numVisible; i++) {
                for (int j = 0; j < numVisible; j++) {
                    if (sameThread(nodes.get(i), nodes.get(j))) {
                        result.set(i, j);
                    }
                }
            }
            return result;
        }

        private boolean sameThread(Node a, Node b) {
            if (a.isInit() || b.isInit()) {
                return a == b;
            }
            return a.thread == b.thread;
        }

        @Override
        public Object visitSameInstruction(SameInstruction si) {
            final BitMatrix result = new BitMatrix(n);
            for (int i = 0; i < numVisible; i++) {
                result.set(i, i);
            }
            return result;
        }

        @Override
        public Object visitCoherence(Coherence co) {
            final BitMatrix result = new BitMatrix(n);
            for (var loc : g.getLocations()) {
                final List<Node> order = g.getCo(loc);
                for (int a = 0; a < order.size(); a++) {
                    final int i = index.get(order.get(a));
                    for (int b = a + 1; b < order.size(); b++) {
                        result.set(i, index.get(order.get(b)));
                    }
                }
            }
            return result;
        }

        @Override
        public Object visitReadFrom(ReadFrom rf) {
            final BitMatrix result = new BitMatrix(n);
            g.getRfMap().forEach((read, write) -> result.set(index.get(write), index.get(read)));
            return result;
        }

        @Override
        public Object visitSameLocation(SameLocation loc) {
            final BitMatrix result = new BitMatrix(n);
            final Map<Object, List<Integer>> byAddress = new HashMap<>();
            for (int i = 0; i < numVisible; i++) {
                final Node a = nodes.get(i);
                if (a.address != null) {
                    byAddress.computeIfAbsent(a.address, k -> new ArrayList<>()).add(i);
                }
            }
            for (List<Integer> group : byAddress.values()) {
                for (int i : group) {
                    for (int j : group) {
                        result.set(i, j);
                    }
                }
            }
            return result;
        }

        @Override
        public Object visitAMOPairs(AMOPairs amo) {
            final BitMatrix result = new BitMatrix(n);
            for (int i = 0; i < numVisible; i++) {
                final Node w = nodes.get(i);
                if (w.pairedLoad != null && !w.isExclusivePair) {
                    result.set(index.get(w.pairedLoad), i);
                }
            }
            return result;
        }

        @Override
        public Object visitLXSXPairs(LXSXPairs lxsx) {
            final BitMatrix result = new BitMatrix(n);
            for (int i = 0; i < numVisible; i++) {
                final Node w = nodes.get(i);
                if (w.pairedLoad != null && w.isExclusivePair) {
                    result.set(index.get(w.pairedLoad), i);
                }
            }
            return result;
        }

        @Override
        public Object visitInternalDataDependency(DirectDataDependency idd) {
            final BitMatrix result = dependencies(nd -> nd.dataDeps);
            for (int p = 0; p < phantomOwners.size(); p++) {
                for (Node src : phantomOwners.get(p).ctrlDeps) {
                    final Integer i = index.get(src);
                    if (i != null) {
                        result.set(i, numVisible + p);
                    }
                }
            }
            return result;
        }

        @Override
        public Object visitAddressDependency(DirectAddressDependency addrDep) {
            return dependencies(nd -> nd.addrDeps);
        }

        @Override
        public Object visitControlDependency(DirectControlDependency ctrlDep) {
            final BitMatrix result = new BitMatrix(n);
            for (int p = 0; p < phantomOwners.size(); p++) {
                result.set(numVisible + p, index.get(phantomOwners.get(p)));
            }
            return result;
        }

        private BitMatrix dependencies(Function<Node, Set<Node>> deps) {
            final BitMatrix result = new BitMatrix(n);
            for (int j = 0; j < numVisible; j++) {
                for (Node src : deps.apply(nodes.get(j))) {
                    final Integer i = index.get(src);
                    if (i != null) {
                        result.set(i, j);
                    }
                }
            }
            return result;
        }

        @Override
        public Object visitCASDependency(CASDependency casDep) {
            final BitMatrix result = new BitMatrix(n);
            for (int i = 0; i < numVisible; i++) {
                final Node origin = nodes.get(i);
                if (origin.isInit() || !origin.hasTag(Tag.IMM.CASDEPORIGIN)) {
                    continue;
                }
                final Node succ = g.getThreadNode(origin.thread, origin.poIndex + 1);
                if (succ != null) {
                    final Integer j = index.get(succ);
                    if (j != null && succ.event == origin.event.getSuccessor()) {
                        result.set(i, j);
                    }
                }
            }
            return result;
        }

        @Override
        public Object visitLinuxCriticalSections(LinuxCriticalSections rscs) {
            final BitMatrix result = new BitMatrix(n);
            for (int t = 0; t < g.getNumThreads(); t++) {
                final Deque<Node> openLocks = new ArrayDeque<>();
                for (Node node : g.getThreadNodes(t)) {
                    if (!node.isVisible()) {
                        continue;
                    }
                    if (node.hasTag(Tag.Linux.RCU_LOCK)) {
                        openLocks.push(node);
                    } else if (node.hasTag(Tag.Linux.RCU_UNLOCK) && !openLocks.isEmpty()) {
                        result.set(index.get(openLocks.pop()), index.get(node));
                    }
                }
            }
            return result;
        }

        @Override
        public Object visitSameScope(SameScope sc) {
            final String specificScope = sc.getSpecificScope();
            final BitMatrix result = new BitMatrix(n);
            for (int i = 0; i < numVisible; i++) {
                final Node a = nodes.get(i);
                if (a.isInit() || !threads.get(a.thread).hasScope()) {
                    continue;
                }
                final Thread t1 = threads.get(a.thread);
                for (int j = 0; j < numVisible; j++) {
                    final Node b = nodes.get(j);
                    if (b.isInit() || !threads.get(b.thread).hasScope()) {
                        continue;
                    }
                    final Thread t2 = threads.get(b.thread);
                    final boolean related;
                    if (specificScope != null) {
                        related = t1.getScopeHierarchy().canSyncAtScope(t2.getScopeHierarchy(), specificScope);
                    } else {
                        final String s1 = Tag.getScopeTag(a.event, arch);
                        final String s2 = Tag.getScopeTag(b.event, arch);
                        related = !s1.isEmpty() && !s2.isEmpty()
                                && t1.getScopeHierarchy().canSyncAtScope(t2.getScopeHierarchy(), s1)
                                && t2.getScopeHierarchy().canSyncAtScope(t1.getScopeHierarchy(), s2);
                    }
                    if (related) {
                        result.set(i, j);
                    }
                }
            }
            return result;
        }

        @Override
        public Object visitSyncWith(SyncWith syncWith) {
            final BitMatrix result = new BitMatrix(n);
            for (int i = 0; i < numVisible; i++) {
                final Node a = nodes.get(i);
                if (a.isInit()) {
                    continue;
                }
                final Thread t1 = threads.get(a.thread);
                if (!t1.hasSyncSet()) {
                    continue;
                }
                for (int j = 0; j < numVisible; j++) {
                    final Node b = nodes.get(j);
                    if (!b.isInit() && b.thread != a.thread && t1.getSyncSet().contains(threads.get(b.thread))) {
                        result.set(i, j);
                    }
                }
            }
            return result;
        }
    }
}
