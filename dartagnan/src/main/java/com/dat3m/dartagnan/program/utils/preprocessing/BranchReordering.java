package com.dat3m.dartagnan.program.utils.preprocessing;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

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

@Options(prefix = "program.preprocessing")
public class BranchReordering implements ProgramPreprocessor {

    private static final Logger logger = LogManager.getLogger(BranchReordering.class);

    @Option(name = "detReordering",
            description = "Deterministically reorders branches (only applicable if program.preprocessing.reorderBranches is TRUE).",
            secure = true)
    private boolean reorderDeterministically = true;

    public boolean reordersDeterministically() {
        return reorderDeterministically;
    }

    public void setReorderDeterministically(boolean value) {
        reorderDeterministically = value;
    }

    @Override
    public void run(Program program) {
        if (program.isUnrolled()) {
            throw new IllegalStateException("Reordering should be performed before unrolling.");
        }

        for (Thread t : program.getThreads()) {
            new ThreadReordering(t).run();
        }

        logger.info("Branches reordered");
    }

    public BranchReordering(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }




    private class ThreadReordering {
        private class MovableBranch {
            int id = 0;
            List<Event> events = new ArrayList<>();

            @Override
            public int hashCode() {
                return reorderDeterministically ? id : super.hashCode();
            }

            @Override
            public boolean equals(Object obj) {
                if (!reorderDeterministically) {
                    return super.equals(obj);
                }
                if (obj == this) {
                    return true;
                }else if (obj == null || obj.getClass() != getClass()) {
                    return false;
                }

                return id == ((MovableBranch)obj).id;
            }
        }

        private final Thread thread;
        private final List<MovableBranch> branches;
        private final Map<Event, MovableBranch> branchMap;

        public ThreadReordering(Thread t) {
            this.thread = t;
            branches = new ArrayList<>();
            branchMap = new HashMap<>();
        }

        private void computeBranchDecomposition() {
            Event exit = thread.getExit();
            MovableBranch cur = new MovableBranch();
            branches.add(cur);

            int id = 1;
            Event e = thread.getEntry();
            while (e != null) {
                cur.events.add(e);
                branchMap.put(e, cur);

                if (e.equals(exit)) {
                    break;
                }
                if (e instanceof CondJump && ((CondJump) e).isGoto()) {
                    branches.add(cur = new MovableBranch());
                    cur.id = id++;
                }
                e = e.getSuccessor();
            }
        }

        private List<MovableBranch> computeReordering(List<MovableBranch> moveables) {
            if (moveables.size() < 3) {
                return moveables;
            }

            // Construct successor map
            Map<MovableBranch, Set<MovableBranch>> successorMap = new HashMap<>();
            for (MovableBranch b : moveables) {
                successorMap.put(b, new HashSet<>());
            }

            MovableBranch startBranch = moveables.get(0);
            for (MovableBranch b : moveables) {
                for (Event e : b.events) {
                    if (e instanceof CondJump) {
                        CondJump jump = (CondJump) e;
                        MovableBranch target = branchMap.get(jump.getLabel());
                        if (target != startBranch && successorMap.containsKey(target)) {
                            successorMap.get(b).add(target);
                        }
                    }
                }
            }

            moveables = new ArrayList<>();
            DependencyGraph<MovableBranch> depGraph = DependencyGraph.fromSingleton(startBranch, successorMap);
            List<Set<DependencyGraph<MovableBranch>.Node>> sccs = Lists.reverse(depGraph.getSCCs());

            for (Set<DependencyGraph<MovableBranch>.Node> scc : sccs) {
                List<MovableBranch> branches = scc.stream().map(DependencyGraph.Node::getContent)
                        .sorted(Comparator.comparingInt(x -> x.id)).collect(Collectors.toList());
                moveables.addAll(computeReordering(branches));

            }

            return moveables;
        }

        public void run() {
            computeBranchDecomposition();
            // We fixate the last branch
            List<MovableBranch> reordering = computeReordering(branches.subList(0, branches.size() - 1));
            reordering.add(branches.get(branches.size() - 1));

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
    }

}