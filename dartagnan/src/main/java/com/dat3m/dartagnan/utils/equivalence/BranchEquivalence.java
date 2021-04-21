package com.dat3m.dartagnan.utils.equivalence;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.google.common.collect.Sets;

import java.util.*;

/* Procedure:
   (1) Find all simple branches using
        - Branching events (Jumps, ifs)
        - Merging events (events with at least 1 non-trivial listener or successors of If-nodes)
       The branches of the CFG can be reduced to a single node.
       In the following we work on this reduced CFG.
   (2) Compute the Must-Successors of each branch
        - This CANNOT be done during step (1), if If-Statements are involves
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
*/

public class BranchEquivalence extends AbstractEquivalence<Event> {
    /*
       NOTE: If the initial class or the unreachable class is empty, they will be treated (almost) non-existent:
        - That means they will not get returned by getAllEquivalenceClasses, nor will they be accessible
          through otherClass.impliedClasses or otherClass.exclusiveClasses
        - The classes are still available through getInitialClass/getUnreachbleClass
          but the returned class will be:
             - empty and have NULL as representative
             - the reachable-/impliedClasses will only contain themselves, the exclusiveClasses will be empty
    */


    // ============================= State ==============================

    private final Program program;
    private BranchClass initialClass;
    private BranchClass unreachableClass;

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

    public boolean isReachableFrom(Event start, Event target) {
        return start.getThread() == target.getThread() && start.getCId() <= target.getCId() && getEquivalenceClass(start).getReachableClasses().contains(getEquivalenceClass(target));
    }

    public boolean isAfter(Event a, Event b) {
        if (a.is(EType.INIT)) {
            return !b.is(EType.INIT);
        }
        return a.getThread() == b.getThread() && a.getCId() > b.getCId() && isImplied(b, a);
    }

    public boolean isBefore(Event a, Event b) {
        return isAfter(b, a);
    }

    public Set<Event> getExclusiveEvents(Event e) {
        return new ExclusiveSet(e);
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

    public BranchEquivalence(Program program) {
        this.program = program;
        if (!program.isCompiled())
            throw new IllegalArgumentException("The program needs to be compiled first.");

        Map<Thread, Map<Event, Branch>> threadBranches = new HashMap<>();
        for (Thread t : program.getThreads()) {
            // Step (1)
            Map<Event, Branch> branchMap = new HashMap<>();
            Map<Event, Branch> finalBranchMap = new HashMap<>();
            threadBranches.put(t, branchMap);
            computeBranches(t.getEntry(), branchMap, finalBranchMap);
            // Step (2)-(3)
            for (Branch b : branchMap.values()) {
                computeMustPredSet(b);
                computeMustSuccSet(b);
                computeReachableBranches(b);
            }
            //Step (4)-(5)
            createBranchClasses(branchMap);
        }
        // Step (6)
        mergeInitialClasses();
        // Step (7)
        computeUnreachableClass();
        //Bonus
        computeExclusiveClasses(threadBranches);
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

    //========================== Branching Analysis =========================

    private Branch computeBranches(Event start, Map<Event, Branch> branchMap, Map<Event, Branch> finalBranchMap) {
        if ( branchMap.containsKey(start)) {
            // <start> was already visited
            return branchMap.get(start);
        }

        Branch b = new Branch(start);
        branchMap.put(start, b);
        Event succ = start;
        do {
            if (succ instanceof CondJump) {
                CondJump jump = (CondJump) succ;
                if (!GlobalSettings.ALWAYS_SPLIT_ON_JUMP && jump.isGoto()) {
                    // There is only one branch we can proceed on so we don't need to split the current branch
                    succ = jump.getLabel();
                } else {
                    // Split into two branches...
                    Branch b1 = computeBranches(jump.getSuccessor(), branchMap, finalBranchMap);
                    Branch b2 = computeBranches(jump.getLabel(), branchMap, finalBranchMap);
                    b1.parents.add(b);
                    b.children.add(b1);
                    b2.parents.add(b);
                    b.children.add(b2);
                    return b;
                }
            } else if (succ instanceof If) {
                If ifElse = (If)succ;
                Branch bSucc = null;

                if (ifElse.getSuccessor() != null) {
                    // There is this odd case that a final If has no successor
                    bSucc = computeBranches(ifElse.getSuccessor(), branchMap, finalBranchMap);
                }
                // Look at if and else branches...
                Branch bMain = computeBranches(ifElse.getSuccessorMainBranch(), branchMap, finalBranchMap);
                Branch bElse = computeBranches(ifElse.getSuccessorElseBranch(), branchMap, finalBranchMap);

                b.children.add(bMain);
                bMain.parents.add(b);
                b.children.add(bElse);
                bElse.parents.add(b);

                // Get the last branch from the if/else branches ...
                Branch bMainFinal = finalBranchMap.get(ifElse.getExitMainBranch());
                Branch bElseFinal = finalBranchMap.get(ifElse.getExitElseBranch());
                // ... and connect them with the successor branch of the if
                if (bMainFinal != null && bSucc != null) {
                    bSucc.parents.add(bMainFinal);
                    bMainFinal.children.add(bSucc);
                }
                if (bElseFinal != null && bSucc != null) {
                    bSucc.parents.add(bElseFinal);
                    bElseFinal.children.add(bSucc);
                }
                return b;
            } else {
                // No branching happened, thus we stay on the current branch
                succ = succ.getSuccessor();
            }

            if (succ == null) {
                finalBranchMap.put(b.events.get(b.events.size() - 1), b);
                return b;
            } else if (!succ.getListeners().isEmpty() || branchMap.containsKey(succ)) {
                // We ran into a merge point
                Branch b1 = computeBranches(succ, branchMap, finalBranchMap);
                b1.parents.add(b);
                b.children.add(b1);
                return b;
            } else {
                b.events.add(succ);
            }
        } while (true);
    }

    private void computeMustPredSet(Branch b) {
        if (b.mustPredComputed)
            return;

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
        if (b.mustSuccComputed)
            return;

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

    private void computeReachableBranches(Branch b) {
        if (b.reachableBranchesComputed)
            return;

        for (Branch child : b.children) {
            computeReachableBranches(child);
            b.reachableBranches.addAll(child.reachableBranches);
        }

        b.reachableBranchesComputed = true;
    }

    //========================== Equivalence class computations =========================

    private void computeExclusiveClasses(Map<Thread, Map<Event, Branch>> threadBranches) {
        for (Thread t : program.getThreads()) {
            computeReachableBranches(threadBranches.get(t).get(t.getEntry()));
        }
        Set<BranchClass> branchClasses = getAllTypedEqClasses();
        for (BranchClass c1 : branchClasses) {
            Set<BranchClass> excl = c1.exclusiveClasses;

            if (c1 == initialClass) {
                if (!unreachableClass.isEmpty()) {
                    excl.add(unreachableClass);
                }
                continue;
            } else if (c1 == unreachableClass) {
                excl.addAll(branchClasses);
                excl.remove(unreachableClass);
                continue;
            }


            for (BranchClass c2 : branchClasses) {
                if (c2 == unreachableClass) {
                    excl.add(unreachableClass);
                    continue;
                } else if (c2 == initialClass || c2 == c1) {
                    continue;
                }

                Event e1 = c1.getRepresentative();
                Event e2 = c2.getRepresentative();
                if ( e1.getThread() == e2.getThread() && e1.getCId() < e2.getCId()) {
                    if (!c1.reachableClasses.contains(c2)) {
                        excl.add(c2);
                        c2.exclusiveClasses.add(c1);
                    }
                }

            }
        }
    }

    private void computeUnreachableClass() {
        unreachableClass = new BranchClass();
        for (Thread t : program.getThreads()) {
            // Add all unreachable nodes
            t.getCache().getEvents(FilterBasic.get(EType.ANY)).stream()
                    .filter(x -> !hasClass(x)).forEach(unreachableClass::addInternal);
        }

        if (unreachableClass.isEmpty()) {
            removeClass(unreachableClass);
        } else {
            unreachableClass.representative = unreachableClass.stream()
                    .min(Comparator.comparingInt(Event::getCId)).get();
        }
    }

    private void createBranchClasses(Map<Event, Branch> branchMap) {
        List<BranchClass> newClasses;
        if (GlobalSettings.MERGE_BRANCHES) {
            DependencyGraph<Branch> depGraph = DependencyGraph.from(branchMap.values(), Branch::getImpliedBranches);
            newClasses = new ArrayList<>(depGraph.getSCCs().size());
            for (Set<DependencyGraph<Branch>.Node> scc : depGraph.getSCCs()) {
                BranchClass eq = new BranchClass();
                newClasses.add(eq);
                scc.forEach(b -> eq.addAllInternal(b.getContent().events));
                eq.representative = eq.stream()
                        .min(Comparator.comparingInt(Event::getCId)).get();
            }
        } else {
            newClasses = new ArrayList<>();
            for (Branch b : branchMap.values()) {
                if (hasClass(b.getRoot())) {
                    continue;
                }
                BranchClass eq = new BranchClass();
                newClasses.add(eq);
                eq.addAllInternal(b.events);
                eq.representative = b.getRoot();
            }
        }

        // Update reachable and implied classes
        for (BranchClass branchClass : newClasses) {
            Branch rootBranch = branchMap.get(branchClass.getRepresentative());
            for (Branch reachable : rootBranch.reachableBranches) {
                branchClass.reachableClasses.add(getTypedEqClass(reachable.getRoot()));
            }
            for (Branch implied : rootBranch.getImpliedBranches()) {
                branchClass.impliedClasses.add(getTypedEqClass(implied.getRoot()));
            }
        }
    }

    private void mergeInitialClasses() {
        if (GlobalSettings.MERGE_BRANCHES) {
            initialClass = getTypedEqClass(program.getThreads().get(0).getEntry());
            Set<BranchClass> mergedClasses = new HashSet<>();
            for (int i = 1; i < program.getThreads().size(); i++) {
                BranchClass c = getTypedEqClass(program.getThreads().get(i).getEntry());
                mergeClasses(initialClass, c);
                mergedClasses.add(c);
                initialClass.reachableClasses.addAll(c.reachableClasses);
                initialClass.reachableClasses.remove(c);

                initialClass.impliedClasses.addAll(c.impliedClasses);
                initialClass.impliedClasses.remove(c);
            }

            for (BranchClass c : this.<BranchClass>getAllTypedEqClasses()) {
                if (c != initialClass) {
                    if (c.reachableClasses.removeAll(mergedClasses)) {
                        c.reachableClasses.add(initialClass);
                    }
                    if (c.impliedClasses.removeAll(mergedClasses)) {
                        c.impliedClasses.add(initialClass);
                    }
                }
            }
        } else {
            initialClass = new BranchClass();
            removeClass(initialClass);
        }
    }


    //========================== Internal data structures =========================

    public interface Class extends EquivalenceClass<Event> {
        Set<Class> getImpliedClasses();
        Set<Class> getReachableClasses();
        Set<Class> getExclusiveClasses();

        @Override
        BranchEquivalence getEquivalence();
    }

    protected class BranchClass extends EqClass implements Class {
        final Set<BranchClass> impliedClasses;
        final Set<BranchClass> reachableClasses;
        final Set<BranchClass> exclusiveClasses;

        final Set<Class> impliedClassesView;
        final Set<Class> reachableClassesView;
        final Set<Class> exclusiveClassesView;

        public Set<Class> getImpliedClasses() { return impliedClassesView; }
        public Set<Class> getReachableClasses() { return reachableClassesView; }
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
            reachableClassesView = Collections.unmodifiableSet(reachableClasses);
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
            return getRoot().toString();
        }
    }

    private class ExclusiveSet extends AbstractSet<Event> {

        final Set<Class> classes;
        final int size;

        public ExclusiveSet(Event e) {
            classes = getEquivalenceClass(e).getExclusiveClasses();
            int size = 0;
            for (Class c : classes) {
                size += c.size();
            }
            this.size = size;
        }

        @Override
        public boolean contains(Object o) {
            if (!(o instanceof Event)) {
                return false;
            }
            return classes.contains(classMap.get(o));
        }

        @Override
        public Iterator<Event> iterator() {
            return new Iter();
        }

        @Override
        public int size() {
            return size;
        }


        private class Iter implements Iterator<Event> {

            private final Iterator<Class> outer;
            private Iterator<Event> inner;

            public Iter() {
                outer = classes.iterator();
                hasNext();
            }

            @Override
            public boolean hasNext() {
                if (inner != null && inner.hasNext()) {
                    return true;
                }
                if (outer.hasNext()) {
                    inner = outer.next().iterator();
                    return true;
                }
                return false;
             }

            @Override
            public Event next() {
                return inner.next();
            }
        }
    }
}