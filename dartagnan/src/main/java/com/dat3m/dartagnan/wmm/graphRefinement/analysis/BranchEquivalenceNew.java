package com.dat3m.dartagnan.wmm.graphRefinement.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.Dependent;

import java.util.*;

//TODO: We need to rework our approach.
// A single linear parse with "branching nodes" and "must-successor sets" seems to be not enough
// We probably also need "merge nodes" and "must-predecessor" sets
// This will require a top-down and a bottom-up parse of the Control Flow DAG
// Then we have: cf(e1) <=> cf(e2) if  (e2 \in must-succ(e1) AND e1 \in must-pred(e2) or vice versa)

/* New procedure:
  (1) Find all branches using
    - Branching nodes (Jumps, ifs)
    - Merging nodes (nodes with at least 1 non-trivial listener)
   (2) Put all these branches into their own equivalence class
        - This effectively computes a CFG where each branch is merged into a single node
   (3) Compute the Must-Successors of each branch
        - This can be done during step (1)
   (4) Compute the Must-Predecessors of each branch
        - Towards this, we compute backward edges during (1)
        - Essentially, we run the Must-Successor computation on the dual graph
   (5) Build a branch graph with edges b1 -> b2 IFF
        - b2 is must-pred or must-succ of b1
   (6) Find all SCCs which will form our equivalence classes
        - Here we use the fact that any cycle must contain a forward edge and a backward edge
         which will give use the implications (b1 => b2 and b2 => b1)
*/
public class BranchEquivalenceNew extends AbstractEquivalence<Event> {

    private final Program program;

    private Set<Event> initialClass;

    public Program getProgram() {
        return program;
    }

    public boolean isGuaranteedEvent(Event e) {
        return initialClass.contains(e);
    }

    public Set<Event> getInitialClass() { return Collections.unmodifiableSet(initialClass); }


    private Map<Thread, Collection<Branch>> threadBranches = new HashMap<>();
    public BranchEquivalenceNew(Program program) {
        this.program = program;
        if (!program.isCompiled())
            throw new IllegalArgumentException("The program needs to be compiled first.");

        for (Thread t : program.getThreads()) {
            // Step (1)-(3)
            Map<Event, Branch> branchMap = new HashMap<>();
            threadBranches.put(t, branchMap.values());
            computeBranches(t.getEntry(), branchMap);
            // Step (4)
            for (Branch b : branchMap.values()) {
                computeMustPredSet(b);
            }
            //Step (5)-(6)
            mergeThreadBranches(branchMap.values());

        }

        classMap.values().removeIf(Set::isEmpty);
        mergeInitialBranches();
    }

    private void mergeThreadBranches(Collection<Branch> branches) {
        DependencyGraph<Branch> depGraph = new DependencyGraph<>(branches);
        for (Set<DependencyGraph<Branch>.Node> scc : depGraph.getSCCs()) {
            /*Branch minBranch = scc.stream()
                    .min(Comparator.comparingInt(x -> x.getContent().getRoot().getCId()))
                    .get().getContent();*/
            Representative rep = null;
            Event minEvent = null;
            for (DependencyGraph<Branch>.Node node : scc) {
                Branch b = node.getContent();
                Event root = b.getRoot();
                if (rep == null) {
                    rep = makeNewClass(root, b.events.size() + scc.size());
                }
                if (minEvent == null || root.getCId() < minEvent.getCId()) {
                    minEvent = root;
                }
                addAllToClass(node.getContent().events, rep);;
            }
            makeRepresentative(minEvent);
        }
    }

    private void mergeInitialBranches() {
        Representative initRep = representativeMap.get(program.getThreads().get(0).getEntry());
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


    public Branch computeBranches(Event start, Map<Event, Branch> branchMap) {
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
                    Branch b1 = computeBranches(jump.getSuccessor(), branchMap);
                    Branch b2 = computeBranches(jump.getLabel(), branchMap);

                    b1.parents.add(b);
                    b2.parents.add(b);
                    HashSet<Branch> mustSucc = new HashSet<>(b1.mustSucc);
                    mustSucc.retainAll(b2.mustSucc);
                    b.mustSucc.addAll(mustSucc);
                    return b;
                }
            } else if (succ instanceof If) {
                throw new UnsupportedOperationException();
            } else {
                // No branching happened, thus we stay on the current branch
                succ = succ.getSuccessor();
            }

            if (succ == null) {
                return b;
            } else if (!succ.getListeners().isEmpty()) {
                // We ran into a merge point
                Branch b1 = computeBranches(succ, branchMap);
                b1.parents.add(b);
                b.mustSucc.addAll(b1.mustSucc);
                return b;
            } else {
                b.events.add(succ);
            }

        } while (true);
    }




    private static class Branch implements Dependent<Branch> {
        //Representative representative;
        final Set<Branch> parents = new HashSet<>();
        final Set<Branch> mustSucc = new HashSet<>();
        final Set<Branch> mustPred = new HashSet<>();
        final List<Event> events = new ArrayList<>();

        boolean mustPredComputed = false;

        public Branch(Event root) {
            mustPred.add(this);
            mustSucc.add(this);
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

}
