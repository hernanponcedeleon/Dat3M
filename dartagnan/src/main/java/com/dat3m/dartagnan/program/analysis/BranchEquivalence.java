package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
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
import java.util.stream.Collectors;

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
            Set<Event> unreachableEvents // these events do not have a branch
    ) {}

    private BranchDecomposition computeBranchDecomposition(Program program) {
        final Map<Event, Branch> event2BranchMap = new HashMap<>();
        final List<Branch> branches = new ArrayList<>();
        for (Thread thread : program.getThreads()) {
            computeBranchDecomposition(thread.getEntry(), event2BranchMap, branches);
        }

        final Set<Event> unreachable = new HashSet<>();
        program.getThreadEvents().stream()
                .filter(e -> !event2BranchMap.containsKey(e))
                .forEach(unreachable::add);

        return new BranchDecomposition(program, branches, event2BranchMap, unreachable);
    }

    private Branch computeBranchDecomposition(Event root, Map<Event, Branch> event2BranchMap, List<Branch> branches) {
        if (event2BranchMap.containsKey(root)) {
            // <root> was already visited
            return event2BranchMap.get(root);
        }

        final Branch branch = new Branch(root);
        event2BranchMap.put(root, branch);
        branches.add(branch);
        Event succ = root;
        while (true) {
            if (succ instanceof CondJump jump) {
                if (jump.isGoto()) {
                    // There is only one branch we can proceed on, so we don't need to split the current branch
                    succ = jump.getLabel();
                } else {
                    // Split into two branches...
                    final Branch b1 = computeBranchDecomposition(jump.getSuccessor(), event2BranchMap, branches);
                    final Branch b2 = computeBranchDecomposition(jump.getLabel(), event2BranchMap, branches);
                    branch.children.add(b1);
                    branch.children.add(b2);
                    b1.parents.add(branch);
                    b2.parents.add(branch);
                    return branch;
                }
            } else {
                // No branching happened, thus we stay on the current branch
                succ = succ.getSuccessor();
            }

            if (succ == null) {
                // We reached the end of function, so the branch is done.
                return branch;
            } else if ((succ instanceof Label label && !label.getJumpSet().isEmpty()) || event2BranchMap.containsKey(succ)) {
                // We ran into a merge point, so the branch is done
                final Branch succBranch = computeBranchDecomposition(succ, event2BranchMap, branches);
                succBranch.parents.add(branch);
                branch.children.add(succBranch);
                return branch;
            } else {
                // extend the branch
                branch.events.add(succ);
                event2BranchMap.put(succ, branch);
            }
        }
    }

    private void computeExclusiveBranches(BranchDecomposition decomposition) {
        final Map<Thread, List<Branch>> threadBranches = new HashMap<>();
        for (Thread thread : decomposition.program.getThreads()) {
            threadBranches.put(thread, new ArrayList<>());
        }
        for (Branch branch : decomposition.branches) {
            threadBranches.get(branch.getRoot().getThread()).add(branch);
        }

        for (List<Branch> branches : threadBranches.values()) {
            branches.sort(Comparator.comparingInt(b -> b.getRoot().getGlobalId()));
            branches.forEach(this::computeReachableBranches);

            for (int i = 0; i < branches.size(); i++) {
                for (int j = i + 1; j < branches.size(); j++) {
                    final Branch b1 = branches.get(i);
                    final Branch b2 = branches.get(j);

                    if (!b1.reachableBranches.contains(b2) && !b2.reachableBranches.contains(b1)) {
                        b1.exclusiveBranches.add(b2);
                        b2.exclusiveBranches.add(b1);
                    }
                }
            }
        }
    }

    private void computeReachableBranches(Branch b) {
        if (b.reachableBranchesComputed) {
            return;
        }

        for (Branch child : b.children) {
            computeReachableBranches(child);
            b.reachableBranches.addAll(child.reachableBranches);
        }

        b.reachableBranchesComputed = true;
    }

    private void computeBranchImplications(BranchDecomposition decomposition) {
        for (Branch b : decomposition.branches) {
            computeMustPredSet(b);
            computeMustSuccSet(b);
        }

        final List<Branch> unconditionalThreadInitialBranches = new ArrayList<>();
        for (Thread thread : decomposition.program.getThreads()) {
            final ThreadStart start = thread.getEntry();
            final Branch threadInitialBranch = decomposition.event2BranchMap.get(start);

            if (start.isSpawned()) {
                final Branch creatorBranch = decomposition.event2BranchMap.get(start.getCreator());
                threadInitialBranch.mustPred.add(creatorBranch);
                threadInitialBranch.exclusiveBranches.addAll(creatorBranch.exclusiveBranches);
                if (!start.mayFailSpuriously()) {
                    creatorBranch.mustSucc.add(threadInitialBranch);
                }
            } else {
                unconditionalThreadInitialBranches.add(threadInitialBranch);
            }
        }

        // Create an equivalence chain: t1 <=> t2 <=> t3 <=> ... <=> tn
        for (int i = 0; i < unconditionalThreadInitialBranches.size() - 1; i++) {
            final Branch b1 = unconditionalThreadInitialBranches.get(i);
            final Branch b2 = unconditionalThreadInitialBranches.get(i + 1);
            b1.mustSucc.add(b2);
            b2.mustPred.add(b1);
        }
    }

    private void computeMustPredSet(Branch b) {
        if (b.mustPredComputed) {
            return;
        }

        Set<Branch> commonPred = null;
        for (Branch br : b.parents) {
            computeMustPredSet(br);
            if (commonPred == null) {
                commonPred = new HashSet<>(br.mustPred);
            } else {
                commonPred.retainAll(br.mustPred);
            }
        }
        if (commonPred != null) {
            b.mustPred.addAll(commonPred);
        }
        b.mustPredComputed = true;
    }

    private void computeMustSuccSet(Branch b) {
        if (b.mustSuccComputed) {
            return;
        }

        Set<Branch> commonSucc = null;
        for (Branch br : b.children) {
            computeMustSuccSet(br);
            if (commonSucc == null) {
                commonSucc = new HashSet<>(br.mustSucc);
            } else {
                commonSucc.retainAll(br.mustSucc);
            }
        }
        if (commonSucc != null) {
            b.mustSucc.addAll(commonSucc);
        }
        b.mustSuccComputed = true;
    }

    //========================== Equivalence class computations =========================

    private void createBranchClasses(BranchDecomposition decomposition) {
        // -------------------------- Create branch classes --------------------------
        final DependencyGraph<Branch> depGraph = DependencyGraph.from(decomposition.branches, Branch::getImpliedBranches);
        final Map<Branch, BranchClass> branch2ClassMap = Maps.newIdentityHashMap();
        final Map<BranchClass, Set<Branch>> class2BranchesMap = Maps.newIdentityHashMap();
        for (Set<DependencyGraph<Branch>.Node> scc : depGraph.getSCCs()) {
            final BranchClass branchClass = new BranchClass();
            final Set<Branch> branchesInClass = scc.stream().map(DependencyGraph.Node::getContent).collect(Collectors.toSet());
            branchesInClass.forEach(b -> branch2ClassMap.put(b, branchClass));
            class2BranchesMap.put(branchClass, branchesInClass);
        }

        // -------------------------- Populate branch classes --------------------------
        for (BranchClass branchClass : class2BranchesMap.keySet()) {
            for (Branch branch : class2BranchesMap.get(branchClass)) {
                branchClass.addAllInternal(branch.events);
                branch.getImpliedBranches().stream().map(branch2ClassMap::get).forEach(branchClass.impliedClasses::add);
                branch.exclusiveBranches.stream().map(branch2ClassMap::get).forEach(branchClass.exclusiveClasses::add);
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

        public Set<Class> getImpliedClasses() { return impliedClassesView; }
        public Set<Class> getExclusiveClasses() { return exclusiveClassesView; }

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
        final Set<Branch> children = new HashSet<>();
        final Set<Branch> parents = new HashSet<>();
        final Set<Branch> mustSucc = new HashSet<>();
        final Set<Branch> mustPred = new HashSet<>();
        final List<Event> events = new ArrayList<>();
        final Set<Branch> reachableBranches = new HashSet<>();
        final Set<Branch> exclusiveBranches = new HashSet<>();

        boolean mustPredComputed = false;
        boolean mustSuccComputed = false;
        boolean reachableBranchesComputed = false;

        public Branch(Event root) {
            mustPred.add(this);
            mustSucc.add(this);
            reachableBranches.add(this);
            events.add(root);
        }

        public Event getRoot() { return events.get(0); }

        public Collection<Branch> getImpliedBranches() { return Sets.union(mustSucc, mustPred);}

        @Override
        public String toString() {
            return String.format("%s: %s", getRoot().getGlobalId(), getRoot());
        }
    }
}