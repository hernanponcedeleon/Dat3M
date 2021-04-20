package com.dat3m.dartagnan.program.utils.preprocessing;
import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;

import java.util.*;
import java.util.stream.Collectors;

/*
    This class performs reordering of code as follows
    (1) The linear sequence of parsed code is decomposed into "moveable" branches:
        - Moveable branches have the property that any permutation of these branches
          exhibits the same control flow behaviour (with the exception that the final branch must stay fixed)
    (2) These branches are rearranged to minimize the number of backjumps
        - A backjump can cause a loop or just a "fake loop"
        - We want to retain true loops but reduce the number of fake loops
        - True loops are retained in form of backjumps while fake loops are removed by rearranging branches
    (3) In the case of loops, this procedure is repeated recursively within each loop
 */

//TODO: Add support for Ifs
public class BranchReordering {

	private final Thread thread;
    private final List<MoveableBranch> branches;
    private final Map<Event, MoveableBranch> branchMap;

    public BranchReordering(Thread t) {
        this.thread = t;
        branches = new ArrayList<>();
        branchMap = new HashMap<>();
    }

    private void computeBranchDecomposition() {
        Event exit = thread.getExit();
        MoveableBranch cur = new MoveableBranch();
        branches.add(cur);

        int id = 1;
        Event e = thread.getEntry();
        while (e != null) {
            cur.events.add(e);
            branchMap.put(e, cur);

            if (e.equals(exit)) { break; }
            //TODO add support for Ifs
            if (e instanceof CondJump && ((CondJump)e).isGoto()) {
                branches.add(cur = new MoveableBranch());
                cur.id = id++;
            }
            e = e.getSuccessor();
        }
    }

    private List<MoveableBranch> computeReordering(List<MoveableBranch> moveables) {
        if (moveables.size() < 3) {
            return moveables;
        }

        // Construct successor map
        Map<MoveableBranch, Set<MoveableBranch>> successorMap = new HashMap<>();
        for (MoveableBranch b : moveables) {
            successorMap.put(b, new HashSet<>());
        }

        MoveableBranch startBranch = moveables.get(0);
        for (MoveableBranch b : moveables) {
            for (Event e : b.events) {
                if (e instanceof CondJump) {
                    CondJump jump = (CondJump) e;
                    MoveableBranch target = branchMap.get(jump.getLabel());
                    if (target != startBranch && successorMap.containsKey(target)) {
                        successorMap.get(b).add(target);
                    }
                }
            }
        }

        moveables = new ArrayList<>();
        DependencyGraph<MoveableBranch> depGraph = DependencyGraph.fromSingleton( startBranch, successorMap);
        List<Set<DependencyGraph<MoveableBranch>.Node>> sccs = Lists.reverse(depGraph.getSCCs());

        for (Set<DependencyGraph<MoveableBranch>.Node> scc : sccs) {
            List<MoveableBranch> branches = scc.stream().map(DependencyGraph.Node::getContent)
                    .sorted(Comparator.comparingInt(x -> x.id)).collect(Collectors.toList());
            moveables.addAll(computeReordering(branches));

        }

        return moveables;
    }

    public void apply() {
        computeBranchDecomposition();
        // We fixate the last branch
        List<MoveableBranch> reordering = computeReordering(branches.subList(0, branches.size() - 1));
        reordering.add(branches.get(branches.size()- 1));

        Iterable<Event> reorderedEvents = Iterables.concat(reordering.stream().map(x -> x.events).collect(Collectors.toList()));
        Event pred = null;
        int id = thread.getEntry().getOId();
        for (Event next : reorderedEvents) {
            next.setOId(id++);
            if (pred != null) {
                pred.setSuccessor(next);
            }
            pred = next;
        }
        assert pred == thread.getExit();
    }

    private static class MoveableBranch {
        int id = 0;
        List<Event> events = new ArrayList<>();
        
        @Override
        public int hashCode() {
            return GlobalSettings.DETERMINISTIC_REORDERING ? id : super.hashCode();
        }

        @Override
        public boolean equals(Object obj) {
            if (!GlobalSettings.DETERMINISTIC_REORDERING) {
                return super.equals(obj);
            }
            if (obj == this) {
                return true;
            }else if (obj == null || obj.getClass() != getClass()) {
                return false;
            }

            return id == ((MoveableBranch)obj).id;
        }
    }
}