package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.utils.equivalence.AbstractEquivalence;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.google.common.base.Preconditions;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.ALWAYS_SPLIT_ON_JUMPS;
import static com.dat3m.dartagnan.configuration.OptionNames.MERGE_BRANCHES;

/* Procedure:
   (1) Find all simple branches using
        - Branching events (Jumps, ifs)
        - Merging events (events with at least 1 non-trivial listener or successors of If-nodes)
       The branches of the CFG can be reduced to a single node.
       In the following we work on this reduced CFG.
   (2) Compute the Must-Successors of each branch
        - This CANNOT be done during step (1), if If-Statements are involved
   (3) Compute the Must-Predecessors of each branch
        - Towards this, we compute backward edges during (1)
        - Essentially, we run the Must-Successor computation on the dual graph
   (4) Build a branch graph with edges b1 -> b2 IFF
        - b2 is must-pred or must-succ of b1
   (5) Find all SCCs which will form our equivalence classes
        - Here we use the fact that any cycle must contain a forward edge and a backward edge
         which will give use the implications (b1 => b2 and b2 => b1)
   (6) Merge all initial classes
   (7) Compute the class of all unreachable events.
   BONUS: Compute which branches are mutually exclusive

   TODO: Currently we compute "reachable branches" which is a notion that badly interacts with merging of branches.
         Instead, we should more directly work on exclusive branches/branch classes as those are well-bahaved under merging.
         Furthermore, with proper cf-semantics for thread spawning, we cannot analyze the control-flow of
         threads in isolation anymore.
         Without fixing this, we fail to detect mutual exclusion across threads for now.
         (e.g., two threads are mutually exclusive, if their corresponding ThreadCreate events are mutually exclusive).
*/

@Options
public class BranchEquivalence extends AbstractEquivalence<Event> {
    /*
       NOTE: If the initial class or the unreachable class is empty, they will be treated (almost) non-existent:
        - That means they will not get returned by getAllEquivalenceClasses, nor will they be accessible
          through otherClass.impliedClasses or otherClass.exclusiveClasses
        - The classes are still available through getInitialClass/getUnreachableClass
          but the returned class will be:
             - empty and have NULL as representative
             - the reachable-/impliedClasses will only contain themselves, the exclusiveClasses will be empty
    */

    private static final Logger logger = LogManager.getLogger(BranchEquivalence.class);

    // ============================= State ==============================

    private final Program program;
    private BranchClass initialClass;
    private BranchClass unreachableClass;

    // =========================== Configurables ===========================

    @Option(name = ALWAYS_SPLIT_ON_JUMPS,
            description = "Splits control flow branches even on unconditional jumps.",
            secure = true)
    private boolean alwaysSplitOnJump = false;

    @Option(name = MERGE_BRANCHES,
            description = "Merges branches with equivalent control-flow behaviour.",
            secure = true)
    private boolean mergeBranches = true;

    // ============================ Public methods ==============================

    public Program getProgram() {
        return program;
    }

    public boolean isGuaranteedEvent(Event e) {
        return initialClass.contains(e);
    }

    public boolean isUnreachableEvent(Event e) { return unreachableClass.contains(e); }

    public boolean areMutuallyExclusive(Event e1, Event e2) {
        return getEquivalenceClass(e1).getExclusiveClasses().contains(getEquivalenceClass(e2));
    }

    public boolean isImplied(Event start, Event implied) {
        return getEquivalenceClass(start).getImpliedClasses().contains(getEquivalenceClass(implied));
    }

    public Set<Class> getExclusiveClasses(Event e) {
        return (this.<BranchClass>getTypedEqClass(e)).getExclusiveClasses();
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

    private BranchEquivalence(Program program, Configuration config) throws InvalidConfigurationException {
        Preconditions.checkArgument(program.isUnrolled(), "The program must be unrolled first.");
        this.program = program;
        config.inject(this);

        logger.info("{}: {}", ALWAYS_SPLIT_ON_JUMPS, alwaysSplitOnJump);
        logger.info("{}: {}", MERGE_BRANCHES, mergeBranches);

        run();
    }

    public static BranchEquivalence fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        return new BranchEquivalence(program, config);
    }

    private void run() {

        // Step (1)
        final BranchDecomposition decomposition = computeBranchDecomposition(program);
        computeExclusiveBranches(decomposition);
        // Step (2)-(3)
        computeBranchImplications(decomposition);
        // Step (4)-(7)
        createBranchClasses(decomposition);
    }

    public void removeUnreachableClass() {
        if (removeClass(unreachableClass)) {
            unreachableClass.internalSet.clear();
            unreachableClass.representative = null;
            this.<BranchClass>getAllTypedEqClasses().forEach(x -> x.exclusiveClasses.remove(unreachableClass));
        }
    }

    public void removeUnreachableEvent(Event e) {
        unreachableClass.removeInternal(e);
        if (unreachableClass.isEmpty()) {
            removeUnreachableClass();
        }
    }

    //========================== Branching Property =========================

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
                if (!alwaysSplitOnJump && jump.isGoto()) {
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
        for (Thread thread : program.getThreads()) {
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
        // Step (2)-(3)
        for (Branch b : decomposition.branches) {
            computeMustPredSet(b);
            computeMustSuccSet(b);
        }

        final List<Branch> unconditionalThreadInitialBranches = new ArrayList<>();
        for (Thread thread : decomposition.program.getThreads()) {
            final ThreadStart start = (ThreadStart) thread.getEntry();
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

        // Create a chain: t1 <=> t2 <=> t3 <=> ... <=> tn
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
                    .min(Comparator.comparingInt(Event::getGlobalId)).get();
        }

        // -------------------------- Find initial class --------------------------
        initialClass = program.getThreads().stream()
                        .map(e -> (ThreadStart)e.getEntry())
                        .filter( e -> !e.isSpawned())
                        .map(this::<BranchClass>getTypedEqClass)
                        .findFirst().get();

        // ------------- Create special class for unreachable events -------------
        unreachableClass = new BranchClass();
        unreachableClass.addAllInternal(decomposition.unreachableEvents());
        if (unreachableClass.isEmpty()) {
            removeClass(unreachableClass);
        } else {
            unreachableClass.representative = unreachableClass.stream()
                    .min(Comparator.comparingInt(Event::getGlobalId)).get();
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
        final Set<BranchClass> reachableClasses;
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
            reachableClasses = Sets.newIdentityHashSet();
            exclusiveClasses = Sets.newIdentityHashSet();

            impliedClassesView = Collections.unmodifiableSet(impliedClasses);
            exclusiveClassesView = Collections.unmodifiableSet(exclusiveClasses);

            impliedClasses.add(this);
            reachableClasses.add(this);
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


        public Collection<Branch> getImpliedBranches() {
            return Sets.union(mustSucc, mustPred);
        }

        public Event getRoot() {
            return events.get(0);
        }

        @Override
        public String toString() {
            return String.format("%s: %s", getRoot().getGlobalId(), getRoot());
        }
    }
}