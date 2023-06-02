package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.DETERMINISTIC_REORDERING;

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

@Options
public class BranchReordering implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(BranchReordering.class);

    // =========================== Configurables ===========================

    @Option(name = DETERMINISTIC_REORDERING,
            description = "Deterministically reorders branches. Non-deterministic reordering may be used for testing.",
            secure = true)
    private boolean reorderDeterministically = true;

    // =====================================================================

    private BranchReordering() { }

    private BranchReordering(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static BranchReordering fromConfig(Configuration config) throws InvalidConfigurationException {
        return new BranchReordering(config);
    }

    public static BranchReordering newInstance() {
        return new BranchReordering();
    }


    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(), "Reordering should be performed before unrolling.");

        program.getThreads().forEach(t -> new ThreadReordering(t).run());
        // We need to reassign Ids, because they do not match with the ordering of the code now.
        EventIdReassignment.newInstance().run(program);
        logger.info("Branches reordered");
        logger.info("{}: {}", DETERMINISTIC_REORDERING, reorderDeterministically);
    }

    private class ThreadReordering {
        private class MovableBranch {
            int id = 0;
            final List<Event> events = new ArrayList<>();

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
                } else if (obj == null || obj.getClass() != getClass()) {
                    return false;
                }

                return id == ((MovableBranch)obj).id;
            }
        }

        private final Thread thread;
        private final List<MovableBranch> branches = new ArrayList<>();
        private final Map<Event, MovableBranch> eventBranchMap = new HashMap<>();

        public ThreadReordering(Thread t) {
            this.thread = t;
        }

        private void computeBranchDecomposition() {
            final Event exit = thread.getExit();

            MovableBranch curBranch = new MovableBranch();
            branches.add(curBranch);
            int id = 1;
            Event e = thread.getEntry();
            while (e != null) {
                curBranch.events.add(e);
                eventBranchMap.put(e, curBranch);

                if (e.equals(exit)) {
                    break;
                }
                if (e instanceof CondJump && ((CondJump) e).isGoto()) {
                    curBranch = new MovableBranch();
                    curBranch.id = id++;
                    branches.add(curBranch);
                }
                e = e.getSuccessor();
            }
        }

        private List<MovableBranch> computeReordering(final List<MovableBranch> movables) {
            if (movables.size() < 3) {
                return new ArrayList<>(movables);
            }
            final MovableBranch startBranch = movables.get(0);
            final Map<Event, MovableBranch> eventBranchMap = this.eventBranchMap;

            // Construct successor map of branches
            final Map<MovableBranch, Set<MovableBranch>> successorMap = new HashMap<>();
            for (MovableBranch b : movables) {
                successorMap.put(b, new HashSet<>());
            }
            for (MovableBranch branch : movables) {
                for (Event e : branch.events) {
                    if (e instanceof CondJump) {
                        final CondJump jump = (CondJump) e;
                        final MovableBranch targetBranch = eventBranchMap.get(jump.getLabel());
                        if (targetBranch != startBranch && successorMap.containsKey(targetBranch)) {
                            successorMap.get(branch).add(targetBranch);
                        }
                    }
                }
            }

            // Compute the actual reordering of the branches
            final DependencyGraph<MovableBranch> depGraph = DependencyGraph.fromSingleton(startBranch, successorMap);
            final List<Set<DependencyGraph<MovableBranch>.Node>> sccs = Lists.reverse(depGraph.getSCCs());
            final List<MovableBranch> reorderedBranches = new ArrayList<>();
            for (Set<DependencyGraph<MovableBranch>.Node> scc : sccs) {
                final List<MovableBranch> branchesInScc = scc.stream().map(DependencyGraph.Node::getContent)
                        .sorted(Comparator.comparingInt(x -> x.id)).collect(Collectors.toList());
                reorderedBranches.addAll(computeReordering(branchesInScc));

            }

            return reorderedBranches;
        }

        public void run() {
            computeBranchDecomposition();
            final List<MovableBranch> branches = this.branches;
            // Reorder branches but keep the last branch fixed.
            final List<MovableBranch> reordering = computeReordering(branches.subList(0, branches.size() - 1));
            reordering.add(branches.get(branches.size() - 1));
            final Iterable<Event> reorderedEvents = reordering.stream().flatMap(x -> x.events.stream())::iterator;

            Event pred = null;
            for (Event next : reorderedEvents) {
                next.setPredecessor(pred);
                pred = next;
            }
            assert pred == thread.getExit();
        }
    }
}