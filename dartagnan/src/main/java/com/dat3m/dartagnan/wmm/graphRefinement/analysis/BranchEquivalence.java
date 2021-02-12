package com.dat3m.dartagnan.wmm.graphRefinement.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.Dependent;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;

import java.util.*;

/* Procedure:
   (1) Find all branches using
        - Branching events (Jumps, ifs)
        - Merging events (events with at least 1 non-trivial listener or successors of If-nodes)
       The branches of the CFG can be reduced to a single node.
       In the following we work in this reduced CFG.
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

    private final Program program;

    private Representative initialClassRep;
    private Set<Event> initialClass;
    private Representative unreachClassRep;
    private Set<Event> unreachableClass;

    public Program getProgram() {
        return program;
    }

    public boolean isGuaranteedEvent(Event e) {
        return initialClass.contains(e);
    }

    public boolean isUnreachableEvent(Event e) { return unreachableClass.contains(e); }

    public boolean areMutualExclusive(Event e1, Event e2) {
        return exclusiveMap.get(representativeMap.get(e1)).contains(representativeMap.get(e2));
    }

    public Set<Event> getExclusiveEvents(Event e) {
        return new ExclusiveSet(e);
    }

    public Set<Event> getInitialClass() { return Collections.unmodifiableSet(initialClass); }

    public Set<Event> getUnreachableClass() { return Collections.unmodifiableSet(unreachableClass); }


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
            }
            //Step (4)-(5)
            mergeThreadBranches(branchMap.values());
        }
        // Step (6)
        mergeInitialBranches();
        // Step (7)
        computeUnreachableClass();

        //Bonus
        computeExclusiveClasses(threadBranches);
    }

    private Map<Representative, Set<Representative>> exclusiveMap;
    private void computeExclusiveClasses(Map<Thread, Map<Event, Branch>> threadBranches) {
        for (Thread t : program.getThreads()) {
            computeReachableBranches(threadBranches.get(t).get(t.getEntry()));
        }
        exclusiveMap = new HashMap<>();
        for (Representative r1 : classMap.keySet()) {

            Set<Representative> excl = new HashSet<>();
            exclusiveMap.put(r1, excl);

            if (r1 == initialClassRep) {
                if (unreachClassRep != null) {
                    excl.add(unreachClassRep);
                }
                continue;
            } else if (r1 == unreachClassRep) {
                excl.addAll(classMap.keySet());
                excl.remove(unreachClassRep);
                continue;
            }


            for (Representative r2 : classMap.keySet()) {
                if (r2 == unreachClassRep) {
                    excl.add(unreachClassRep);
                    continue;
                } else if (r2 == initialClassRep) {
                    continue;
                }

                Event e1 = r1.getRepresentative();
                Event e2 = r2.getRepresentative();
                if ( e1.getThread() == e2.getThread()) {
                    Map<Event, Branch> branchMap = threadBranches.get(e1.getThread());
                    if (e1.getCId() > e2.getCId()) {
                        Event temp = e1;
                        e1 = e2;
                        e2 = temp;
                    }
                    Branch b1 = branchMap.get(e1);
                    Branch b2 = branchMap.get(e2);

                    if (!b1.reachableBranches.contains(b2)) {
                        excl.add(r2);
                    }
                }

            }
        }
    }

    private void computeUnreachableClass() {
        unreachableClass = new HashSet<>();
        for (Thread t : program.getThreads()) {
            t.getCache().getEvents(FilterBasic.get(EType.ANY)).stream()
                    .filter(x -> !representativeMap.containsKey(x)).forEach(unreachableClass::add);
        }
        if (!unreachableClass.isEmpty()) {
            Event minEvent = unreachableClass.stream().findFirst().get();
            Representative rep = new Representative(minEvent);
            classMap.put(rep, unreachableClass);
            for (Event e : unreachableClass) {
                representativeMap.put(e, rep);
                if (e.getCId() < minEvent.getCId()) {
                    minEvent = e;
                }
            }
            makeRepresentative(minEvent);
            unreachClassRep = rep;
        }
    }

    private void mergeThreadBranches(Collection<Branch> branches) {
        DependencyGraph<Branch> depGraph = new DependencyGraph<>(branches);
        for (Set<DependencyGraph<Branch>.Node> scc : depGraph.getSCCs()) {
            Event minEvent = null;
            Set<Event> eqClass = new HashSet<>();

            for (DependencyGraph<Branch>.Node node : scc) {
                Branch b = node.getContent();
                eqClass.addAll(b.events);
                Event root = b.getRoot();
                if (minEvent == null || root.getCId() < minEvent.getCId()) {
                    minEvent = root;
                }
            }

            Representative rep = new Representative(minEvent);
            classMap.put(rep, eqClass);
            for (Event e : eqClass) {
                representativeMap.put(e, rep);
            }
        }
    }

    private void mergeInitialBranches() {
        Representative initRep = representativeMap.get(program.getThreads().get(0).getEntry());
        initialClassRep = initRep;
        initialClass = classMap.get(initRep);
        for (int i = 1; i < program.getThreads().size(); i++) {
            Event entry = program.getThreads().get(i).getEntry();
            Set<Event> initBranch = getEquivalenceClass(entry);
            initialClass.addAll(initBranch);
            classMap.remove(representativeMap.get(entry));
            for (Event e : initBranch)
                representativeMap.put(e, initRep);
        }
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




    public Branch computeBranches(Event start, Map<Event, Branch> branchMap, Map<Event, Branch> finalBranchMap) {
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
                if (jump.isGoto()) {
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
                    // There is this odd case that a final If
                    // has no successor
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

    private void computeReachableBranches(Branch b) {
        if (b.reachableBranchesComputed)
            return;

        for (Branch child : b.children) {
            computeReachableBranches(child);
            b.reachableBranches.addAll(child.reachableBranches);
        }

        b.reachableBranchesComputed = true;
    }

    private static class Branch implements Dependent<Branch> {
        //Representative representative;
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


        @Override
        public Collection<Branch> getDependencies() {
            Set<Branch> branches = new HashSet<>(mustSucc);
            branches.addAll(mustPred);
            return branches;
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

        final Set<Representative> reps;
        final int size;

        @Override
        public boolean contains(Object o) {
            if (!(o instanceof Event)) {
                return false;
            }
            Event e = (Event)o;
            Representative rep = representativeMap.get(e);
            return reps.contains(rep);
        }

        public ExclusiveSet(Event e) {
            reps = exclusiveMap.get(representativeMap.get(e));
            int size = 0;
            for (Representative rep : reps) {
                size += rep.getEquivalenceClass().size();
            }
            this.size = size;
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

            private final Iterator<Representative> outer;
            private Iterator<Event> inner;

            public Iter() {
                outer = reps.iterator();
                hasNext();
            }

            @Override
            public boolean hasNext() {
                if (inner != null && inner.hasNext()) {
                    return true;
                }
                if (outer.hasNext()) {
                    inner = outer.next().getEquivalenceClass().iterator();
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
