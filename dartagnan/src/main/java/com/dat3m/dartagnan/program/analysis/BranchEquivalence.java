package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.utils.equivalence.AbstractEquivalence;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.google.common.base.Preconditions;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;


/* Procedure:
    (1) Decompose the program into simple branches (~ basic blocks).
    (2) Compute which branches are mutually exclusive to each other (NOTE: could also be done later).
    (3) Compute the control-flow implication relation between branches, i.e, which branches imply which other branches.
        This forms an implication graph over the program's branches.
    (4) Compute the SCCs over the implication graph. Each SCC forms a class of control-flow-equivalent branches.
        Merging the SCCs of the implication graph gives the implication graph over branch classes, which is
        represented by instances of the BranchEquivalence class.
    TODO: (5) Transitively close the merged implication graph,
              and saturate the mutual exclusion relation using the rule
                   A => B, B ~ C, C <= D   ---->   A ~ D  (where ~ denotes mutual exclusion)

    NOTE: BranchEquivalence assumes a strong forward progress model when computing equivalence:
          when an event is in the control-flow then so is one of its successors.
*/

public class BranchEquivalence extends AbstractEquivalence<Event> {
    /*
       NOTE: If the initial class or the unreachable class is empty, they will be treated (almost) non-existent:
        - That means they will not get returned by getAllEquivalenceClasses, nor will they be accessible
          through otherClass.impliedClasses or otherClass.exclusiveClasses
        - The classes are still available through getInitialClass/getUnreachableClass
          but the returned class will be:
             - empty and have NULL as representative
             - the impliedClasses will only contain themselves, the exclusiveClasses will be empty
    */

    // ============================= State ==============================

    private BranchClass initialClass;
    private BranchClass unreachableClass;

    // ============================ Public methods ==============================

    public boolean areMutuallyExclusive(Event e1, Event e2) {
        return getEquivalenceClass(e1).getExclusiveClasses().contains(getEquivalenceClass(e2));
    }

    public boolean isImplied(Event start, Event implied) {
        return getEquivalenceClass(start).getImpliedClasses().contains(getEquivalenceClass(implied));
    }

    public Class getInitialClass() { return initialClass; }

    public Class getUnreachableClass() { return unreachableClass; }

    @Override
    public Class getEquivalenceClass(Event x) {
        return super.getTypedEqClass(x);
    }

    @Override
    public Set<Class> getAllEquivalenceClasses() {
        return super.getAllTypedEqClasses();
    }

    @Override
    @SuppressWarnings("unchecked")
    public Set<Class> getNonTrivialClasses() {
        return (Set<Class>)super.getNonTrivialClasses();
    }

    private BranchEquivalence(Program program) {
        Preconditions.checkArgument(program.isUnrolled(), "The program must be unrolled first.");
        run(program);
    }

    public static BranchEquivalence fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        return new BranchEquivalence(program);
    }

    private void run(Program program) {
        final BranchDecomposition decomposition = computeBranchDecomposition(program);
        computeExclusiveBranches(decomposition);
        computeBranchImplications(decomposition);
        createBranchClasses(decomposition);
    }

    // ========================== Branching ==========================

    private record BranchDecomposition(
            Program program,
            List<Branch> branches,
            Map<Event, Branch> event2BranchMap,
            Set<Event> unreachableEvents, // these events do not have a branch
            List<Branch> postOrder // children before parents
    ) {}

    private BranchDecomposition computeBranchDecomposition(Program program) {
        final Map<Event, Branch> event2BranchMap = new HashMap<>();
        final List<Branch> branches = new ArrayList<>();
        // Branches whose events still need to be collected. We use a worklist instead of recursion,
        // because the branch structure of unrolled programs can be very deep.
        final Deque<Branch> toExtend = new ArrayDeque<>();
        for (Thread thread : program.getThreads()) {
            getOrCreateBranch(thread.getEntry(), event2BranchMap, branches, toExtend);
            while (!toExtend.isEmpty()) {
                extendBranch(toExtend.pop(), event2BranchMap, branches, toExtend);
            }
        }

        final Set<Event> unreachable = new HashSet<>();
        program.getThreadEvents().stream()
                .filter(e -> !event2BranchMap.containsKey(e))
                .forEach(unreachable::add);

        return new BranchDecomposition(program, branches, event2BranchMap, unreachable, computePostOrder(branches));
    }

    private Branch getOrCreateBranch(Event root, Map<Event, Branch> event2BranchMap, List<Branch> branches,
            Deque<Branch> toExtend) {
        final Branch existing = event2BranchMap.get(root);
        if (existing != null) {
            // <root> was already visited
            return existing;
        }
        final Branch branch = new Branch(root, branches.size());
        event2BranchMap.put(root, branch);
        branches.add(branch);
        toExtend.push(branch);
        return branch;
    }

    private void extendBranch(Branch branch, Map<Event, Branch> event2BranchMap, List<Branch> branches,
            Deque<Branch> toExtend) {
        Event succ = branch.getRoot();
        while (true) {
            switch (succ) {
                case CondJump jump -> {
                    if (jump.isGoto()) {
                        // There is only one branch we can proceed on, so we don't need to split the current branch
                        succ = jump.getLabel();
                    } else {
                        // Split into two branches...
                        final Branch b1 = getOrCreateBranch(jump.getSuccessor(), event2BranchMap, branches, toExtend);
                        final Branch b2 = getOrCreateBranch(jump.getLabel(), event2BranchMap, branches, toExtend);
                        branch.children.add(b1);
                        branch.children.add(b2);
                        b1.parents.add(branch);
                        b2.parents.add(branch);
                        return;
                    }
                }
                case BlockingEvent barrier -> {
                    final Branch succBranch = getOrCreateBranch(barrier.getSuccessor(), event2BranchMap, branches, toExtend);
                    branch.children.add(succBranch);
                    succBranch.parents.add(branch);
                    return;
                }
                default -> {
                    // No branching happened, thus we stay on the current branch
                    succ = succ.getSuccessor();
                }
            }

            if (succ == null) {
                // We reached the end of function, so the branch is done.
                return;
            } else if ((succ instanceof Label label && !label.getJumpSet().isEmpty()) || event2BranchMap.containsKey(succ)) {
                // We ran into a merge point, so the branch is done
                final Branch succBranch = getOrCreateBranch(succ, event2BranchMap, branches, toExtend);
                succBranch.parents.add(branch);
                branch.children.add(succBranch);
                return;
            } else {
                // extend the branch
                branch.events.add(succ);
                event2BranchMap.put(succ, branch);
            }
        }
    }

    private void computeExclusiveBranches(BranchDecomposition decomposition) {
        // Two branches of the same thread are mutually exclusive iff neither can reach the other.
        // We use bit sets indexed by Branch.id: the reachability information is quadratic in the number of branches,
        // which can be large for programs with many unrolled loop iterations.
        final Map<Thread, BitSet> threadBranches = new HashMap<>();
        for (Branch branch : decomposition.branches) {
            threadBranches.computeIfAbsent(branch.getRoot().getThread(), _ -> new BitSet()).set(branch.id);
        }

        // Reachability (including the branch itself), forwards in post-order and backwards in reverse post-order.
        final int numBranches = decomposition.branches.size();
        final BitSet[] reachable = new BitSet[numBranches];
        final BitSet[] reaching = new BitSet[numBranches];
        for (Branch b : decomposition.postOrder) {
            reachable[b.id] = union(b, b.children, reachable);
        }
        for (Branch b : decomposition.postOrder.reversed()) {
            reaching[b.id] = union(b, b.parents, reaching);
        }

        for (Branch b : decomposition.branches) {
            final BitSet exclusive = (BitSet) threadBranches.get(b.getRoot().getThread()).clone();
            exclusive.andNot(reachable[b.id]);
            exclusive.andNot(reaching[b.id]);
            b.exclusiveBranches.or(exclusive);
        }
    }

    private static BitSet union(Branch b, Collection<Branch> neighbours, BitSet[] sets) {
        final BitSet union = new BitSet();
        union.set(b.id);
        neighbours.forEach(n -> union.or(sets[n.id]));
        return union;
    }

    private void computeBranchImplications(BranchDecomposition decomposition) {
        for (Branch b : decomposition.postOrder) {
            if (!isEndingWithBlockingEvent(b)) {
                b.mustSucc.or(intersection(b.children, br -> br.mustSucc));
            }
        }
        for (Branch b : decomposition.postOrder.reversed()) {
            b.mustPred.or(intersection(b.parents, br -> br.mustPred));
        }

        final List<Branch> unconditionalThreadInitialBranches = new ArrayList<>();
        for (Thread thread : decomposition.program.getThreads()) {
            final ThreadStart start = thread.getEntry();
            final Branch threadInitialBranch = decomposition.event2BranchMap.get(start);

            if (start.isSpawned()) {
                final Branch creatorBranch = decomposition.event2BranchMap.get(start.getCreator());
                threadInitialBranch.mustPred.set(creatorBranch.id);
                threadInitialBranch.exclusiveBranches.or(creatorBranch.exclusiveBranches);
                creatorBranch.exclusiveBranches.stream()
                        .forEach(id -> decomposition.branches.get(id).exclusiveBranches.set(threadInitialBranch.id));
                creatorBranch.mustSucc.set(threadInitialBranch.id);
            } else {
                unconditionalThreadInitialBranches.add(threadInitialBranch);
            }
        }

        // Create an equivalence chain: t1 <=> t2 <=> t3 <=> ... <=> tn
        for (int i = 0; i < unconditionalThreadInitialBranches.size() - 1; i++) {
            final Branch b1 = unconditionalThreadInitialBranches.get(i);
            final Branch b2 = unconditionalThreadInitialBranches.get(i + 1);
            b1.mustSucc.set(b2.id);
            b2.mustPred.set(b1.id);
        }
    }

    // Post-order (children before parents) of the branch graph, which is acyclic for unrolled programs.
    // Iterative, since the branch graph of an unrolled program can be very deep.
    private static List<Branch> computePostOrder(List<Branch> branches) {
        final List<Branch> postOrder = new ArrayList<>(branches.size());
        final boolean[] visited = new boolean[branches.size()];
        final Deque<Iterator<Branch>> stack = new ArrayDeque<>();
        final Deque<Branch> path = new ArrayDeque<>();
        for (Branch root : branches) {
            if (visited[root.id]) {
                continue;
            }
            visited[root.id] = true;
            path.push(root);
            stack.push(root.children.iterator());
            while (!stack.isEmpty()) {
                final Iterator<Branch> it = stack.peek();
                if (it.hasNext()) {
                    final Branch child = it.next();
                    if (!visited[child.id]) {
                        visited[child.id] = true;
                        path.push(child);
                        stack.push(child.children.iterator());
                    }
                } else {
                    stack.pop();
                    postOrder.add(path.pop());
                }
            }
        }
        return postOrder;
    }

    // Intersection of the sets of <branches>, or the empty set if there are none.
    private static BitSet intersection(Collection<Branch> branches, java.util.function.Function<Branch, BitSet> set) {
        BitSet result = null;
        for (Branch br : branches) {
            if (result == null) {
                result = (BitSet) set.apply(br).clone();
            } else {
                result.and(set.apply(br));
            }
        }
        return result == null ? new BitSet() : result;
    }

    private boolean isEndingWithBlockingEvent(Branch branch) {
        if (!branch.events.isEmpty()) {
            return branch.events.getLast() instanceof BlockingEvent;
        }
        return false;
    }

    //========================== Equivalence class computations =========================

    private void createBranchClasses(BranchDecomposition decomposition) {
        // -------------------------- Create branch classes --------------------------
        final List<Branch> branches = decomposition.branches;
        final DependencyGraph<Branch> depGraph = DependencyGraph.from(branches, b -> b.getImpliedBranches(branches));
        // The order of the SCCs depends on hash codes. We sort them to create the classes deterministically.
        final Comparator<Branch> branchOrder = Comparator.comparingInt(b -> b.getRoot().getGlobalId());
        final List<List<Branch>> branchSCCs = depGraph.getSCCs().stream()
                .map(scc -> scc.stream().map(DependencyGraph.Node::getContent).sorted(branchOrder).toList())
                .sorted(Comparator.comparing(List::getFirst, branchOrder))
                .toList();
        final Map<Branch, BranchClass> branch2ClassMap = Maps.newIdentityHashMap();
        for (List<Branch> branchesInClass : branchSCCs) {
            final BranchClass branchClass = new BranchClass();
            branchesInClass.forEach(b -> branch2ClassMap.put(b, branchClass));
        }

        // -------------------------- Populate branch classes --------------------------
        for (List<Branch> branchesInClass : branchSCCs) {
            final BranchClass branchClass = branch2ClassMap.get(branchesInClass.getFirst());
            for (Branch branch : branchesInClass) {
                branchClass.addAllInternal(branch.events);
                branch.getImpliedBranches(branches).stream().map(branch2ClassMap::get).forEach(branchClass.impliedClasses::add);
                branch.exclusiveBranches.stream().mapToObj(branches::get).map(branch2ClassMap::get).forEach(branchClass.exclusiveClasses::add);
            }
            branchClass.representative = branchClass.stream()
                    .min(Comparator.comparingInt(Event::getGlobalId))
                    .orElseThrow();
        }

        // -------------------------- Find initial class --------------------------
        initialClass = decomposition.program.getThreads().stream()
                .map(Thread::getEntry)
                .filter(e -> !e.isSpawned())
                .map(this::<BranchClass>getTypedEqClass)
                .findFirst()
                .orElseThrow(() -> new MalformedProgramException("No unconditional threads in the program."));

        // ------------- Create special class for unreachable events -------------
        unreachableClass = new BranchClass();
        unreachableClass.addAllInternal(decomposition.unreachableEvents());
        if (unreachableClass.isEmpty()) {
            removeClass(unreachableClass);
        } else {
            unreachableClass.representative = unreachableClass.stream()
                    .min(Comparator.comparingInt(Event::getGlobalId))
                    .get();

            unreachableClass.impliedClasses.addAll(this.getAllTypedEqClasses());
            unreachableClass.exclusiveClasses.addAll(this.getAllTypedEqClasses());
            unreachableClass.exclusiveClasses.remove(unreachableClass);
            this.<BranchClass>getAllTypedEqClasses().forEach(c -> c.exclusiveClasses.add(unreachableClass));
        }

    }

    //========================== Internal data structures =========================

    public interface Class extends EquivalenceClass<Event> {
        Set<Class> getImpliedClasses();
        Set<Class> getExclusiveClasses();

        @Override
        BranchEquivalence getEquivalence();
    }

    protected class BranchClass extends EqClass implements Class {
        final Set<BranchClass> impliedClasses;
        final Set<BranchClass> exclusiveClasses;

        final Set<Class> impliedClassesView;
        final Set<Class> exclusiveClassesView;

        @Override public Set<Class> getImpliedClasses() { return impliedClassesView; }
        @Override public Set<Class> getExclusiveClasses() { return exclusiveClassesView; }

        @Override
        public BranchEquivalence getEquivalence() {
            return BranchEquivalence.this;
        }

        protected BranchClass() {
            impliedClasses = Sets.newIdentityHashSet();
            exclusiveClasses = Sets.newIdentityHashSet();

            impliedClassesView = Collections.unmodifiableSet(impliedClasses);
            exclusiveClassesView = Collections.unmodifiableSet(exclusiveClasses);

            impliedClasses.add(this);
        }
    }

    private static class Branch {
        // Index of this branch in BranchDecomposition.branches. The sets of branches below are bit sets over
        // these indices: they can contain up to quadratically many elements in total.
        final int id;
        final Set<Branch> children = new HashSet<>();
        final Set<Branch> parents = new HashSet<>();
        final BitSet mustSucc = new BitSet();
        final BitSet mustPred = new BitSet();
        final List<Event> events = new ArrayList<>();
        final BitSet exclusiveBranches = new BitSet();

        public Branch(Event root, int id) {
            this.id = id;
            mustPred.set(id);
            mustSucc.set(id);
            events.add(root);
        }

        public Event getRoot() { return events.getFirst(); }

        public List<Branch> getImpliedBranches(List<Branch> branches) {
            final BitSet implied = (BitSet) mustSucc.clone();
            implied.or(mustPred);
            return implied.stream().mapToObj(branches::get).toList();
        }

        @Override
        public String toString() {
            return String.format("%s: %s", getRoot().getGlobalId(), getRoot());
        }
    }
}
