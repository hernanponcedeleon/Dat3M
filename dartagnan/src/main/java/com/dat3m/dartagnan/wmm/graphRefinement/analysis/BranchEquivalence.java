package com.dat3m.dartagnan.wmm.graphRefinement.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;

import java.util.*;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.If;

//TODO: We need to rework our approach.
// A single linear parse with "branching nodes" and "must-successor sets" seems to be not enough
// We probably also need "merge nodes" and "must-predecessor" sets
// This will require a top-down and a bottom-up parse of the Control Flow DAG
// Then we have: cf(e1) <=> cf(e2) if  (e2 \in must-succ(e1) AND e1 \in must-pred(e2) or vice versa)
public class BranchEquivalence extends AbstractEquivalence<Event> {

    private final Program program;
    private Set<Event> initialClass;

    public Program getProgram() {
        return program;
    }

    public boolean isGuaranteedEvent(Event e) {
        return initialClass.contains(e);
    }

    public Set<Event> getInitialClass() { return Collections.unmodifiableSet(initialClass); }

    public BranchEquivalence(Program program) {
        if (!program.isCompiled())
            throw new IllegalArgumentException("The program needs to be compiled first.");

        this.program = program;

        for (Thread t : program.getThreads())
            analyseBranch(t.getEntry());

        // Because on merging branches we move events from one class to a different one,
        // we might end up with empty classes.
        classMap.values().removeIf(Set::isEmpty);
        //implicationMap.keySet().removeIf(x -> getRepresentative(x) != x);
        mergeInitialBranches();
        implicationMap.keySet().removeIf(x -> getRepresentative(x) != x);
    }

    // We can merge all initial branches of threads. That is, all events that are guaranteed to be
    // part of every execution. In particular, this includes all init writes and init skips.
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

    // Only used for the following algo
    // The implicationMap maps a branch root event <e> to a set <reached> of events that
    // is guaranteed(!) to be reached along the branch.
    // NOTE: We might want to expose this map for further use
    private final Map<Event, Set<Event>> implicationMap = new HashMap<>();

    private void analyseBranch(Event e) {
        if (e == null || implicationMap.containsKey(e)) {
            // There is no branch OR the event is already the root of an analysed branch
            return;
        }

        // There are 2 cases:
        // (1) The event <e> was never visited before
        // (2) The event <e> was visited before as part of another branch
        // In either case, we start a new branch in <e>
        Representative oldRep = representativeMap.get(e);
        Representative rep = makeNewClass(e, 10);
        implicationMap.put(e, new HashSet<>());

        Event succ = e;
        do {
            // <succ> was not visited before, and hence is added to our current branch
            implicationMap.get(e).add(succ);
            addToClass(succ, rep);

            if (succ instanceof CondJump) {
                CondJump jump = (CondJump)succ;
                if (jump.isGoto()) {
                    // There is only one branch we can proceed on so we don't need to split the current branch
                    succ = jump.getLabel();
                } else {
                    // Split into two branches...
                    analyseBranch(jump.getSuccessor());
                    analyseBranch(jump.getLabel());
                    // ... and merge in case both branches have common successors
                    mergeBranches(rep, jump.getSuccessor(), jump.getLabel());
                    return;
                }
            } else if (succ instanceof If) {
                If ifElse = (If)succ;
                // Look at if and else branches...
                analyseBranch(ifElse.getSuccessorMainBranch());
                analyseBranch(ifElse.getSuccessorElseBranch());

                if (implicationMap.get(ifElse.getSuccessorMainBranch()).contains(ifElse.getExitMainBranch())
                    && implicationMap.get(ifElse.getSuccessorElseBranch()).contains(ifElse.getExitElseBranch())) {
                    /*mergeBranches(rep, ifElse.getSuccessorMainBranch(), ifElse.getSuccessorElseBranch());*/
                    // ... and if both branches always terminate, we can proceed on the main branch
                    succ = ifElse.getSuccessor();
                } else {
                    // ... if either the if or the else branch does NOT necessarily terminate,
                    // then we need to end the current branch and open a new branch starting after the if-else.
                    analyseBranch(ifElse.getSuccessor());
                    return;
                }
            } else {
                // No branching happened, thus we stay on the current branch
                succ = succ.getSuccessor();
            }

            /*if (implicationMap.containsKey(succ)) {
                // We merged into an already visited branch and can short-circuit
                implicationMap.get(e).addAll(implicationMap.get(succ));
                return;
            }*/

            Representative succRep = representativeMap.get(succ);
            if (succRep != null && !(succRep == oldRep)) {
                // The event <succ> was already visited so we short circuit
                if (!implicationMap.containsKey(succ)) {
                    // <succ> is not yet the root of a branch
                    analyseBranch(succ);
                }
                implicationMap.get(e).addAll(implicationMap.get(succ));
                return;

            }

        } while (succ != null);
    }

    // Merges the common successors of two branches into the parent branch given by a representative <rep>.
    private void mergeBranches(Representative rep, Event firstBranch, Event secondBranch) {
        HashSet<Event> commonSucc = new HashSet<>(implicationMap.get(firstBranch));
        commonSucc.retainAll(implicationMap.get(secondBranch));
        if(!commonSucc.isEmpty()) {
            // We expect all common successors to be in the same equivalence class (since we merge bottom-up)

            // NOTE: The representative of the class of common successors may itself not be
            // in the set of common successors. This can happen due to
            // early merging if there are more than 2 branches merging at the same event!

            implicationMap.keySet().removeAll(commonSucc);
            addAllToClass(commonSucc, rep);
            // Add common successors to the implication map of their new branching root
            implicationMap.get(rep.getRepresentative()).addAll(commonSucc);

            // Note: Do we need to update the representative event of the branches? Probably not, since it
            // should always be the first event, which does not get lifted to a new class.
            // And if it does get lifted, the branch class will be empty and gets removed anyway.
        }
    }

}
