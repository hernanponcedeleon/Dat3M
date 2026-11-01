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
    Relations are bit-matrices over the universe of the graph, sets are bit-sets over the same universe.
    The universe consists of the init nodes and visible nodes of the graph, plus "phantom" elements (see below).
 */
final class ConsistencyChecker {

    private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(ConsistencyChecker.class);

    private final Wmm memoryModel;
    private final List<Thread> threads;
    private final Arch arch;
    private final List<Axiom> consistencyAxioms;
    private final List<Axiom> flaggedAxioms;
    private final Map<Relation, Set<Relation>> sccOf = new HashMap<>();
    private final Map<String, Integer> tagIndices = new HashMap<>();
    // Consistency axioms that can be checked on the events of a single location (see below).
    private final List<Axiom> perLocationAxioms = new ArrayList<>();
    private final Map<Relation, Boolean> restrictionSafe = new HashMap<>();
    private final Map<Relation, Boolean> sameLocation = new HashMap<>();

    ConsistencyChecker(Wmm memoryModel, List<Thread> threads, Arch arch, boolean checkFlagged) {
        this.memoryModel = memoryModel;
        this.threads = threads;
        this.arch = arch;
        this.consistencyAxioms = memoryModel.getAxioms().stream().filter(ax -> !ax.isFlagged()).toList();
        this.flaggedAxioms = checkFlagged
                ? memoryModel.getAxioms().stream().filter(Axiom::isFlagged).toList()
                : List.of();
        computeSCCs();
        for (Axiom axiom : consistencyAxioms) {
            final Relation r = axiom instanceof Acyclicity ? acyclicityTarget(axiom) : axiom.getRelation();
            if (!axiom.isNegated() && !r.isSet() && isRestrictionSafe(r) && isSameLocation(r)) {
                perLocationAxioms.add(axiom);
            }
        }
        logger.info("Axioms checked per location before building graphs: {}", perLocationAxioms);
    }

    // acyclic(r+) iff acyclic(r): avoid computing closures.
    private static Relation acyclicityTarget(Axiom axiom) {
        Relation relation = axiom.getRelation();
        while (relation.getDefinition() instanceof TransitiveClosure closure) {
            relation = closure.getOperand();
        }
        return relation;
    }

    /*
        Per-location checks.
        A relation is "restriction-safe" if its value on a subset U of the universe (computed as if U were the whole
        universe) equals its value restricted to U. A relation is "same-location" if it only relates events that
        access the same address. If an axiom's relation is both, then the axiom fails on the whole graph whenever it
        fails on the events of a single location (plus its init event). This gives a cheap necessary condition for
        consistency that we use to discard rf/co choices before building their graph.
        The classification is syntactic and conservative.
     */
    private boolean isRestrictionSafe(Relation r) {
        final Boolean known = restrictionSafe.get(r);
        if (known != null) {
            return known;
        }
        restrictionSafe.put(r, false); // Recursive definitions are not safe.
        final boolean safe = !sccOf.containsKey(r) && switch (r.getDefinition()) {
            // Base relations that are determined pointwise (by the two events and their rf/co edges).
            case ProgramOrder ignored -> true;
            case SameLocation ignored -> true;
            case External ignored -> true;
            case Internal ignored -> true;
            case ReadFrom ignored -> true;
            case Coherence ignored -> true;
            case SameInstruction ignored -> true;
            case AMOPairs ignored -> true;
            case LXSXPairs ignored -> true;
            case Empty ignored -> true;
            case TagSet ignored -> true;
            case Union u -> u.getOperands().stream().allMatch(this::isRestrictionSafe);
            case Intersection i -> i.getOperands().stream().allMatch(this::isRestrictionSafe);
            case Difference d -> isRestrictionSafe(d.getMinuend()) && isRestrictionSafe(d.getSubtrahend());
            case Inverse i -> isRestrictionSafe(i.getOperand());
            case SetIdentity si -> isRestrictionSafe(si.getDomain());
            case CartesianProduct cp -> isRestrictionSafe(cp.getDomain()) && isRestrictionSafe(cp.getRange());
            // Intermediate events must be in the subset: guaranteed if one side relates same-location events.
            case Composition c -> isRestrictionSafe(c.getLeftOperand()) && isRestrictionSafe(c.getRightOperand())
                    && (isSameLocation(c.getLeftOperand()) || isSameLocation(c.getRightOperand()));
            case TransitiveClosure tc -> isRestrictionSafe(tc.getOperand()) && isSameLocation(tc.getOperand());
            case Projection pr -> isRestrictionSafe(pr.getOperand()) && isSameLocation(pr.getOperand());
            default -> false;
        };
        restrictionSafe.put(r, safe);
        return safe;
    }

    private boolean isSameLocation(Relation r) {
        final Boolean known = sameLocation.get(r);
        if (known != null) {
            return known;
        }
        sameLocation.put(r, false);
        final boolean local = !sccOf.containsKey(r) && switch (r.getDefinition()) {
            case SameLocation ignored -> true;
            case ReadFrom ignored -> true;
            case Coherence ignored -> true;
            case AMOPairs ignored -> true;
            case SameInstruction ignored -> true;
            case Empty ignored -> true;
            case SetIdentity ignored -> true;
            case Union u -> u.getOperands().stream().allMatch(this::isSameLocation);
            case Intersection i -> i.getOperands().stream().anyMatch(this::isSameLocation);
            case Difference d -> isSameLocation(d.getMinuend());
            case Inverse i -> isSameLocation(i.getOperand());
            case Composition c -> isSameLocation(c.getLeftOperand()) && isSameLocation(c.getRightOperand());
            case TransitiveClosure tc -> isSameLocation(tc.getOperand());
            default -> false;
        };
        sameLocation.put(r, local);
        return local;
    }

    boolean hasPerLocationAxioms() {
        return !perLocationAxioms.isEmpty();
    }

    // Necessary condition for consistency: the per-location axioms hold on the events of the given address.
    boolean passesPerLocationAxioms(ExplorationGraph g, java.math.BigInteger address) {
        final Evaluation eval = new Evaluation(g, address);
        for (Axiom axiom : perLocationAxioms) {
            if (!eval.holds(axiom)) {
                return false;
            }
        }
        return true;
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

        // Universe: init nodes, visible nodes, and phantom elements.
        // Phantom elements represent the (non-visible) jumps that cause control dependencies:
        // Dat3M defines ctrl := idd+;ctrlDirect, where idd reaches the jump and ctrlDirect leaves it.
        private final List<Node> elements;
        private final BitSet phantoms;
        private final IdentityHashMap<Node, Integer> index;
        private final IdentityHashMap<Node, Integer> phantomIndex;
        private final int n;
        private final int words;
        private final int[] visibleIndices;

        private final Map<Relation, Object> values = new HashMap<>();

        // Lazily computed masks (word arrays over the universe) used to build base relations row by row.
        private long[] visibleMask;
        private Map<Integer, List<Integer>> threadIndices;  // Visible non-init nodes per thread, in po order
        private Map<Integer, long[]> threadMasks;

        Evaluation(ExplorationGraph g) {
            this(g, null);
        }

        // If "address" is not null, the universe only contains the events accessing that address (and no phantoms).
        Evaluation(ExplorationGraph g, java.math.BigInteger address) {
            this.g = g;
            elements = new ArrayList<>();
            phantoms = new BitSet();
            index = new IdentityHashMap<>();
            phantomIndex = new IdentityHashMap<>();
            if (address != null) {
                for (Node node : g.getCo(address)) {
                    if (node.isInit()) {
                        addElement(node, false);
                    }
                }
                for (Node node : g.getNodes()) {
                    if (node.isVisible() && address.equals(node.address)) {
                        addElement(node, false);
                    }
                }
            } else {
                for (Node init : g.getInitNodes()) {
                    addElement(init, true);
                }
                for (Node node : g.getNodes()) {
                    if (node.isVisible()) {
                        addElement(node, true);
                    }
                }
            }
            this.n = elements.size();
            this.words = Math.max(1, (n + 63) >>> 6);
            this.visibleIndices = new int[n - phantoms.cardinality()];
            int k = 0;
            for (int i = 0; i < n; i++) {
                if (!phantoms.get(i)) {
                    visibleIndices[k++] = i;
                }
            }
        }

        private void addElement(Node node, boolean withPhantom) {
            index.put(node, elements.size());
            elements.add(node);
            if (withPhantom && !node.isInit() && !node.ctrlDeps.isEmpty()) {
                phantomIndex.put(node, elements.size());
                phantoms.set(elements.size());
                elements.add(node);
            }
        }

        private long[] newMask() {
            return new long[words];
        }

        private long[] visibleMask() {
            if (visibleMask == null) {
                visibleMask = newMask();
                for (int i : visibleIndices) {
                    BitMatrix.setBit(visibleMask, i);
                }
            }
            return visibleMask;
        }

        private void computeThreadInfo() {
            if (threadIndices != null) {
                return;
            }
            threadIndices = new HashMap<>();
            threadMasks = new HashMap<>();
            for (int i : visibleIndices) {
                final Node a = elements.get(i);
                if (!a.isInit()) {
                    threadIndices.computeIfAbsent(a.thread, k -> new ArrayList<>()).add(i);
                    BitMatrix.setBit(threadMasks.computeIfAbsent(a.thread, k -> newMask()), i);
                }
            }
            threadIndices.values().forEach(list -> list.sort(Comparator.comparingInt(i -> elements.get(i).poIndex)));
        }

        // ------------------------------------------------------------------------------------------
        // Axioms

        boolean holds(Axiom axiom) {
            final Relation relation = axiom instanceof Acyclicity ? acyclicityTarget(axiom) : axiom.getRelation();
            final Object value = get(relation);
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
            computeFixpoint(scc);
            return values.get(rel);
        }

        // Fixpoint computation for a recursive component (starting from empty relations).
        private void computeFixpoint(Set<Relation> scc) {
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
            // Compositions with set filters ([S];r and r;[S]) only mask rows or columns.
            final Relation left = def.getLeftOperand();
            final Relation right = def.getRightOperand();
            if (left.getDefinition() instanceof SetIdentity filter) {
                return rel(right).restrictRows(set(filter.getDomain()));
            }
            if (right.getDefinition() instanceof SetIdentity filter) {
                return rel(left).restrictColumns(set(filter.getDomain()));
            }
            return rel(left).compose(rel(right));
        }

        @Override
        public Object visitInverse(Inverse def) {
            return rel(def.getOperand()).inverse();
        }

        @Override
        public Object visitTransitiveClosure(TransitiveClosure def) {
            final Relation operand = def.getOperand();
            return rel(operand).transitiveClosure();
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
            if (dom.isEmpty() || range.isEmpty()) {
                return result;
            }
            final long[] rangeMask = newMask();
            final long[] rangeWords = range.toLongArray();
            System.arraycopy(rangeWords, 0, rangeMask, 0, Math.min(rangeWords.length, words));
            for (int i = dom.nextSetBit(0); i >= 0; i = dom.nextSetBit(i + 1)) {
                result.orRow(i, rangeMask);
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
            final String tag = def.getTag();
            final int tagIndex = tagIndices.computeIfAbsent(tag, k -> tagIndices.size());
            final BitSet result = new BitSet(n);
            for (int i : visibleIndices) {
                if (elements.get(i).hasTag(tagIndex, tag)) {
                    result.set(i);
                }
            }
            return result;
        }

        @Override
        public Object visitProgramOrder(ProgramOrder po) {
            computeThreadInfo();
            final BitMatrix result = new BitMatrix(n);
            for (List<Integer> thread : threadIndices.values()) {
                // Walk the thread backwards, accumulating the po-later nodes.
                final long[] later = newMask();
                for (int k = thread.size() - 1; k >= 0; k--) {
                    final int i = thread.get(k);
                    result.orRow(i, later);
                    BitMatrix.setBit(later, i);
                }
            }
            return result;
        }

        @Override
        public Object visitExternal(External ext) {
            computeThreadInfo();
            final BitMatrix result = new BitMatrix(n);
            final long[] visible = visibleMask();
            for (int i : visibleIndices) {
                final Node a = elements.get(i);
                final long[] row = visible.clone();
                if (a.isInit()) {
                    row[i >>> 6] &= ~(1L << i);
                } else {
                    final long[] same = threadMasks.get(a.thread);
                    for (int w = 0; w < words; w++) {
                        row[w] &= ~same[w];
                    }
                }
                result.orRow(i, row);
            }
            return result;
        }

        @Override
        public Object visitInternal(Internal internal) {
            computeThreadInfo();
            final BitMatrix result = new BitMatrix(n);
            for (int i : visibleIndices) {
                final Node a = elements.get(i);
                if (a.isInit()) {
                    result.set(i, i);
                } else {
                    result.orRow(i, threadMasks.get(a.thread));
                }
            }
            return result;
        }

        @Override
        public Object visitSameInstruction(SameInstruction si) {
            final BitMatrix result = new BitMatrix(n);
            for (int i : visibleIndices) {
                result.set(i, i);
            }
            return result;
        }

        @Override
        public Object visitCoherence(Coherence co) {
            final BitMatrix result = new BitMatrix(n);
            for (var loc : g.getLocations()) {
                final List<Node> order = g.getCo(loc);
                final long[] later = newMask();
                for (int a = order.size() - 1; a >= 0; a--) {
                    final Integer i = index.get(order.get(a));
                    if (i == null) {
                        continue; // Not part of a restricted universe
                    }
                    result.orRow(i, later);
                    BitMatrix.setBit(later, i);
                }
            }
            return result;
        }

        @Override
        public Object visitReadFrom(ReadFrom rf) {
            final BitMatrix result = new BitMatrix(n);
            g.getRfMap().forEach((read, write) -> {
                final Integer w = index.get(write);
                final Integer r = index.get(read);
                if (w != null && r != null) {
                    result.set(w, r);
                }
            });
            return result;
        }

        @Override
        public Object visitSameLocation(SameLocation loc) {
            final BitMatrix result = new BitMatrix(n);
            final Map<Object, long[]> byAddress = new HashMap<>();
            for (int i : visibleIndices) {
                final Node a = elements.get(i);
                if (a.address != null) {
                    BitMatrix.setBit(byAddress.computeIfAbsent(a.address, k -> newMask()), i);
                }
            }
            for (int i : visibleIndices) {
                final Node a = elements.get(i);
                if (a.address != null) {
                    result.orRow(i, byAddress.get(a.address));
                }
            }
            return result;
        }

        @Override
        public Object visitAMOPairs(AMOPairs amo) {
            final BitMatrix result = new BitMatrix(n);
            for (int i : visibleIndices) {
                final Node w = elements.get(i);
                if (w.pairedLoad != null && !w.isExclusivePair && index.containsKey(w.pairedLoad)) {
                    result.set(index.get(w.pairedLoad), i);
                }
            }
            return result;
        }

        @Override
        public Object visitLXSXPairs(LXSXPairs lxsx) {
            final BitMatrix result = new BitMatrix(n);
            for (int i : visibleIndices) {
                final Node w = elements.get(i);
                if (w.pairedLoad != null && w.isExclusivePair && index.containsKey(w.pairedLoad)) {
                    result.set(index.get(w.pairedLoad), i);
                }
            }
            return result;
        }

        @Override
        public Object visitInternalDataDependency(DirectDataDependency idd) {
            final BitMatrix result = dependencies(nd -> nd.dataDeps);
            phantomIndex.forEach((owner, p) -> {
                for (Node src : owner.ctrlDeps) {
                    final Integer i = index.get(src);
                    if (i != null) {
                        result.set(i, p);
                    }
                }
            });
            return result;
        }

        @Override
        public Object visitAddressDependency(DirectAddressDependency addrDep) {
            return dependencies(nd -> nd.addrDeps);
        }

        @Override
        public Object visitControlDependency(DirectControlDependency ctrlDep) {
            final BitMatrix result = new BitMatrix(n);
            phantomIndex.forEach((owner, p) -> result.set(p, index.get(owner)));
            return result;
        }

        private BitMatrix dependencies(Function<Node, Set<Node>> deps) {
            final BitMatrix result = new BitMatrix(n);
            for (int j : visibleIndices) {
                for (Node src : deps.apply(elements.get(j))) {
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
            for (int i : visibleIndices) {
                final Node origin = elements.get(i);
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
            for (int i : visibleIndices) {
                final Node a = elements.get(i);
                if (a.isInit() || !threads.get(a.thread).hasScope()) {
                    continue;
                }
                final Thread t1 = threads.get(a.thread);
                for (int j : visibleIndices) {
                    final Node b = elements.get(j);
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
            for (int i : visibleIndices) {
                final Node a = elements.get(i);
                if (a.isInit()) {
                    continue;
                }
                final Thread t1 = threads.get(a.thread);
                if (!t1.hasSyncSet()) {
                    continue;
                }
                for (int j : visibleIndices) {
                    final Node b = elements.get(j);
                    if (!b.isInit() && b.thread != a.thread && t1.getSyncSet().contains(threads.get(b.thread))) {
                        result.set(i, j);
                    }
                }
            }
            return result;
        }
    }
}
