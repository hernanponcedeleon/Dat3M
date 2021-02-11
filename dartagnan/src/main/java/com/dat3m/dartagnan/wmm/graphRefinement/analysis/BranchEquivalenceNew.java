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
   (2) Put all these branches into their own equivalence class (this effectively reduces the graph)
   (3) Store an implicationMap "Branch -> Must-Succ Branches"
   (4) Reverse the graph and compute the "Branch -> Must-Pred Branches" map
        - To reverse the graph, we should construct a parent map
          while computing the branches
        - This can automatically solve the problem of dead code
   (5) Build a branch graph where two branches (b1, b2) are connected if
        - cid(b1) < cid(b2) and b2 is must-succ of b1
        - OR cid(b2) < cid(b1) and b2 is must-pred of b1
   (6) Find all SCCs which will form our equivalence classes
        - Here we use the fact that any cycle must contain a forward edge and a backward edge
         which will give use the implications (b1 => b2 and b2 => b1)
       Question: Is it possible to get weird cycles that should not be present?
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

    public BranchEquivalenceNew(Program program) {
        this.program = program;
        if (!program.isCompiled())
            throw new IllegalArgumentException("The program needs to be compiled first.");

        for (Thread t : program.getThreads()) {
            // Step (1)-(3)
            Map<Event, Branch> branchMap = new HashMap<>();
            findBranch(t.getEntry(), branchMap);
            // Step (4)
            for (Branch b : branchMap.values()) {
                computeMustPredSet(b);
            }

            for(Branch branch : branchMap.values()) {
                Representative rep = makeNewClass(branch.getRoot(), branch.events.size());
                addAllToClass(branch.events, rep);
            }

            /*
            //Step (5)-(6)
            DependencyGraph<Branch> depGraph = new DependencyGraph<>(branchMap.values());
            for (Set<DependencyGraph<Branch>.Node> scc : depGraph.getSCCs()) {
                Branch minBranch = scc.stream()
                        .min(Comparator.comparingInt(x -> x.getContent().getRoot().getCId()))
                        .get().getContent();
                Representative rep = makeNewClass(minBranch.getRoot(), scc.size());
                for (DependencyGraph<Branch>.Node node : scc) {
                    addAllToClass(node.getContent().events, rep);;
                }
            }
             */
        }

        classMap.values().removeIf(Set::isEmpty);
        mergeInitialBranches();
    }

    private void mergeInitialBranches() {

        Representative initRep = new Representative(program.getThreads().get(0).getEntry());
        initialClass = new HashSet<>(100);
        classMap.put(initRep, initialClass);
        for (Thread t : program.getThreads()) {
            Set<Event> initBranch = getEquivalenceClass(t.getEntry());
            classMap.remove(representativeMap.get(t.getEntry()));
            initialClass.addAll(initBranch);
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
        b.mustPredComputed = true;
    }

    // Representative <=> Branch
    // Maps any event to its containing branch
    //private final Map<Thread, Map<Event, Branch>> threadBranchMap = new HashMap<>();

    public Branch findBranch(Event start, Map<Event, Branch> branchMap) {
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
                    Branch b1 = findBranch(jump.getSuccessor(), branchMap);
                    Branch b2 = findBranch(jump.getLabel(), branchMap);

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
                Branch b1 = findBranch(succ, branchMap);
                b1.parents.add(b);
                b.mustSucc.addAll(b1.mustSucc);
                return b;
            } else {
                b.events.add(succ);
            }

        } while (true);
    }




    private class Branch implements Dependent<Branch> {
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
    }

}
