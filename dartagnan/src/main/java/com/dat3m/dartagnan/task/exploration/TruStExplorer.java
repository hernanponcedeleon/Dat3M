package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.ShutdownNotifier;

import java.math.BigInteger;
import java.util.*;

/*
    Stateless model checking based on

        Michalis Kokologiannakis, Iason Marmanis, Vladimir Gladstein, Viktor Vafeiadis.
        "Truly Stateless, Optimal Dynamic Partial Order Reduction". POPL 2022.

    The exploration follows Algorithm 1 of the paper, but uses an explicit work stack instead of recursion
    so that (potentially infinite) executions do not overflow the call stack.

    Programs are explored without loop unrolling. If the program has infinite executions, the exploration
    does not terminate, unless a bound on the number of events per thread is given.
 */
public final class TruStExplorer {

    private static final Logger logger = LoggerFactory.getLogger(TruStExplorer.class);

    // ================================================================================================
    // Results

    public enum ViolationKind { ASSERTION, PROGRAM_SPEC, CAT_SPEC, TERMINATION }

    public record Violation(ViolationKind kind, String description, String witness) {}

    public static final class Statistics {
        long visitedGraphs;
        long inconsistentGraphs;
        long completeExecutions;
        long blockedExecutions;
        long truncatedExecutions;
        long filteredExecutions;
        long backwardRevisits;

        public long getVisitedGraphs() { return visitedGraphs; }
        public long getInconsistentGraphs() { return inconsistentGraphs; }
        public long getCompleteExecutions() { return completeExecutions; }
        public long getBlockedExecutions() { return blockedExecutions; }
        public long getTruncatedExecutions() { return truncatedExecutions; }
        public long getFilteredExecutions() { return filteredExecutions; }
        public long getBackwardRevisits() { return backwardRevisits; }

        @Override
        public String toString() {
            return String.format("""
                            Complete executions: %d
                            Blocked executions: %d
                            Truncated executions: %d
                            Filtered executions: %d
                            Inconsistent graphs: %d
                            Visited graphs: %d
                            Backward revisits: %d""",
                    completeExecutions, blockedExecutions, truncatedExecutions, filteredExecutions,
                    inconsistentGraphs, visitedGraphs, backwardRevisits);
        }
    }

    // ================================================================================================
    // Configuration and state

    private final Program program;
    private final EnumSet<Property> properties;
    private final int maxEventsPerThread;
    private final boolean printExecutions;
    private final boolean stopOnReachability;
    private final ShutdownNotifier shutdownNotifier;

    private final MemoryLayout layout;
    private final ThreadInterpreter interpreter;
    private final ConsistencyChecker checker;
    private final Map<Thread, Integer> threadIndex = new HashMap<>();
    // The first load of a spawned thread must read from the store of its creator (thread synchronization).
    private final Map<Event, Event> spawningLoadToStore = new HashMap<>();

    private final Statistics stats = new Statistics();
    private final ArrayDeque<WorkItem> stack = new ArrayDeque<>();
    private Violation violation;
    private boolean specificationReached;
    private String reachabilityWitness;
    private final Set<String> outcomes = new LinkedHashSet<>();
    private boolean stop;

    @FunctionalInterface
    private interface WorkItem {
        void run() throws InterruptedException;
    }

    public TruStExplorer(Program program, Wmm memoryModel, EnumSet<Property> properties, ExplorationOrder order,
                         int maxEventsPerThread, boolean printExecutions, ShutdownNotifier shutdownNotifier) {
        this.program = program;
        this.properties = properties;
        this.maxEventsPerThread = maxEventsPerThread;
        this.printExecutions = printExecutions;
        this.stopOnReachability = !printExecutions;
        this.shutdownNotifier = shutdownNotifier;

        final List<Thread> threads = program.getThreads().stream()
                .filter(t -> t.getEvents().stream().noneMatch(Init.class::isInstance))
                .toList();
        for (int i = 0; i < threads.size(); i++) {
            threadIndex.put(threads.get(i), i);
            final List<? extends Event> spawning = threads.get(i).getSpawningEvents();
            if (spawning.size() == 2) {
                spawningLoadToStore.put(spawning.get(0), spawning.get(1));
            }
        }
        this.layout = new MemoryLayout(program);
        this.interpreter = new ThreadInterpreter(threads, layout, program, order, shutdownNotifier);
        this.checker = new ConsistencyChecker(memoryModel, threads, program.getArch(),
                properties.contains(Property.CAT_SPEC));
    }

    public Statistics getStatistics() { return stats; }
    public Optional<Violation> getViolation() { return Optional.ofNullable(violation); }
    public boolean isSpecificationReached() { return specificationReached; }
    public String getReachabilityWitness() { return reachabilityWitness; }
    public Set<String> getOutcomes() { return outcomes; }

    // Exploration is complete if no execution was cut off by the event bound.
    public boolean isExhaustive() {
        return stats.truncatedExecutions == 0;
    }

    // ================================================================================================
    // Main loop

    public void run() throws InterruptedException {
        final int numThreads = interpreter.getThreads().size();
        final ThreadState[] initial = new ThreadState[numThreads];
        for (int t = 0; t < numThreads; t++) {
            initial[t] = interpreter.newInitialState(t);
        }
        final ExplorationGraph g0 = new ExplorationGraph(initial);
        stack.push(() -> visit(g0));
        while (!stack.isEmpty() && !stop) {
            shutdownNotifier.shutdownIfNecessary();
            stack.pop().run();
        }
        logger.info("Exploration finished.\n{}", stats);
    }

    // ================================================================================================
    // Visit (Algorithm 1)

    private void visit(ExplorationGraph g) throws InterruptedException {
        stats.visitedGraphs++;

        // Line 4: consistency check
        final ConsistencyChecker.Result result = checker.check(g);
        if (!result.consistent()) {
            stats.inconsistentGraphs++;
            return;
        }
        if (result.violatedFlag() != null) {
            reportCatViolation(g, result.violatedFlag());
            return;
        }

        // Assertion violations (errors)
        for (int t = 0; t < g.states.length; t++) {
            final ThreadState st = g.states[t];
            if (st.status == ThreadState.Status.ERROR) {
                if (properties.contains(Property.PROGRAM_SPEC)) {
                    reportViolation(ViolationKind.ASSERTION, String.format("Assertion violation in thread %s: %s",
                            interpreter.getThreads().get(t), st.violatedAssertion), g);
                    return;
                }
                // We are not interested in assertions: the thread is considered blocked.
                st.status = ThreadState.Status.BLOCKED;
            }
        }

        // Line 5: pick the next event
        final int t = pickNextThread(g);
        if (t < 0) {
            handleFullGraph(g);
            return;
        }

        final Event e = g.states[t].pc;
        if (e instanceof Load) {
            visitRead(g, t);
        } else if (e instanceof Store && !(e instanceof Init)) {
            visitWrite(g, t);
        } else {
            final Node node = interpreter.makeNode(g, t, false);
            stack.push(() -> {
                final ExplorationGraph g2 = g.copy();
                addNode(g2, node);
                visit(g2);
            });
        }
    }

    // Returns the thread of the next event to add, or -1 if the graph is full.
    // The truncation flag is recomputed: it is only meaningful for full graphs (where all threads are inspected).
    private int pickNextThread(ExplorationGraph g) {
        g.truncated = false;
        for (int t = 0; t < g.states.length; t++) {
            if (!interpreter.isEnabled(g, t)) {
                continue;
            }
            if (maxEventsPerThread > 0 && g.states[t].nextPoIndex >= maxEventsPerThread) {
                g.truncated = true;
                continue;
            }
            return t;
        }
        return -1;
    }

    private void addNode(ExplorationGraph g, Node node) throws InterruptedException {
        g.addNode(node);
        interpreter.applyNode(g, g.states[node.thread], node);
    }

    // ------------------------------------------------------------------------------------------------
    // Lines 10-12: reads

    private void visitRead(ExplorationGraph g, int t) {
        final Node read = interpreter.makeNode(g, t, false);
        g.ensureLocation(layout.getInitNode(read.address, read.accessType));
        final List<Node> writes = new ArrayList<>(g.getCo(read.address));
        final Event spawningStore = spawningLoadToStore.get(read.event);
        if (spawningStore != null) {
            writes.removeIf(w -> w.event != spawningStore);
        }
        // Push in reverse order so that writes are explored in coherence order.
        for (int i = writes.size() - 1; i >= 0; i--) {
            final Node write = writes.get(i);
            stack.push(() -> {
                final ExplorationGraph g2 = g.copy();
                g2.addNode(read);
                g2.setRf(read, write);
                interpreter.applyNode(g2, g2.states[t], read);
                visit(g2);
            });
        }
    }

    // ------------------------------------------------------------------------------------------------
    // Lines 13-18: writes

    private void visitWrite(ExplorationGraph g, int t) {
        final Event e = g.states[t].pc;
        final Node write = interpreter.makeNode(g, t, false);

        // Weak store-exclusives may fail spuriously (or must fail if they have no matching load-exclusive).
        if (ThreadInterpreter.isWeakExclusiveStore(e)) {
            final Node failed = interpreter.makeNode(g, t, true);
            stack.push(() -> {
                final ExplorationGraph g2 = g.copy();
                addNode(g2, failed);
                visit(g2);
            });
        }
        if (write == null) {
            return;
        }

        g.ensureLocation(layout.getInitNode(write.address, write.accessType));

        // Line 15-18: backward revisits (pushed first, so they are explored after the forward cases)
        // The (strict) prefix of the write w.r.t. the exploration order and rf.
        final Set<Node> prefix = g.porfClosure(write.ePreds);
        final List<WorkItem> revisits = new ArrayList<>();
        for (Node read : g.getNodes()) {
            if (!read.isRead() || !read.address.equals(write.address) || prefix.contains(read)
                    || spawningLoadToStore.containsKey(read.event)) {
                continue;
            }
            final int readStamp = g.stamp(read);
            final Set<Node> deleted = Collections.newSetFromMap(new IdentityHashMap<>());
            for (Node n : g.getNodes()) {
                if (g.stamp(n) > readStamp && !prefix.contains(n)) {
                    deleted.add(n);
                }
            }
            if (!isMaximalExtension(g, read, deleted, prefix)) {
                continue;
            }
            revisits.add(() -> backwardRevisit(g, write, read, deleted));
        }
        for (int i = revisits.size() - 1; i >= 0; i--) {
            stack.push(revisits.get(i));
        }

        // Line 14: VisitCOs
        pushCoPlacements(g, write);
    }

    // Pushes one work item per possible co-placement of the write (Line 22).
    private void pushCoPlacements(ExplorationGraph g, Node write) {
        final List<Node> writes = new ArrayList<>(g.getCo(write.address));
        for (final Node pred : writes) {
            stack.push(() -> {
                final ExplorationGraph g2 = g.copy();
                g2.insertCoAfter(write, pred);
                addNode(g2, write);
                visit(g2);
            });
        }
    }

    private void backwardRevisit(ExplorationGraph g, Node write, Node read, Set<Node> deleted)
            throws InterruptedException {
        stats.backwardRevisits++;
        final ExplorationGraph g2 = g.copy();
        final Set<Integer> affected = new HashSet<>(g2.removeNodes(deleted));
        g2.addNode(write);
        g2.setRf(read, write);
        affected.add(read.thread);
        affected.add(write.thread);
        for (int thread : affected) {
            interpreter.replay(g2, thread);
        }
        // The write is not yet placed in coherence order: we explore all placements.
        final List<Node> writes = new ArrayList<>(g2.getCo(write.address));
        for (int i = writes.size() - 1; i >= 0; i--) {
            final Node pred = writes.get(i);
            stack.push(() -> {
                final ExplorationGraph g3 = g2.copy();
                g3.insertCoAfter(write, pred);
                visit(g3);
            });
        }
    }

    // ------------------------------------------------------------------------------------------------
    // Maximal extension check (Definition 3.3 and procedure IsMaximallyAdded)

    private boolean isMaximalExtension(ExplorationGraph g, Node read, Set<Node> deleted, Set<Node> prefix) {
        if (!isMaximallyAdded(g, read, prefix)) {
            return false;
        }
        for (Node e : deleted) {
            if (!isMaximallyAdded(g, e, prefix)) {
                return false;
            }
        }
        return true;
    }

    private boolean isMaximallyAdded(ExplorationGraph g, Node e, Set<Node> prefix) {
        final int stamp = g.stamp(e);
        if (e.isWrite()) {
            // No read in Previous may read from e (otherwise, the revisit would undo a previous revisit).
            for (Map.Entry<Node, Node> entry : g.getRfMap().entrySet()) {
                if (entry.getValue() == e && isPrevious(g, entry.getKey(), stamp, prefix)) {
                    return false;
                }
            }
        }
        if (e.kind == Node.Kind.EXCL_FAIL) {
            // The maximal (canonical) way to add a store-exclusive is to let it succeed, if possible.
            return !e.couldSucceed;
        }
        final Node w;
        if (e.isRead()) {
            w = g.getRf(e);
        } else if (e.isWrite()) {
            w = e;
        } else {
            return true;
        }
        if (!isPrevious(g, w, stamp, prefix)) {
            return false;
        }
        final List<Node> co = g.getCo(w.address);
        final int pos = co.indexOf(w);
        for (int i = pos + 1; i < co.size(); i++) {
            if (isPrevious(g, co.get(i), stamp, prefix)) {
                return false;
            }
        }
        return true;
    }

    private static boolean isPrevious(ExplorationGraph g, Node n, int stamp, Set<Node> prefix) {
        return n.isInit() || g.stamp(n) <= stamp || prefix.contains(n);
    }

    // ================================================================================================
    // Full graphs

    private void handleFullGraph(ExplorationGraph g) {
        boolean finished = true;
        final List<Integer> spinning = new ArrayList<>();
        for (int t = 0; t < g.states.length; t++) {
            final ThreadState st = g.states[t];
            switch (st.status) {
                case TERMINATED -> { }
                case RUNNING -> {
                    if (!interpreter.isWaitingForCreation(g, t)) {
                        finished = false;
                    }
                }
                case SPINNING -> {
                    finished = false;
                    spinning.add(t);
                }
                case BLOCKED, ERROR -> finished = false;
            }
        }

        final boolean boundReached = Arrays.stream(g.states).anyMatch(st -> st.boundReached);
        if (g.truncated || boundReached) {
            stats.truncatedExecutions++;
            return;
        }
        if (!finished) {
            stats.blockedExecutions++;
            if (properties.contains(Property.TERMINATION) && !spinning.isEmpty() && isLivenessViolation(g, spinning)) {
                reportViolation(ViolationKind.TERMINATION, "Threads " + spinning.stream()
                        .map(i -> interpreter.getThreads().get(i).toString()).toList()
                        + " are stuck in side-effect-free loops.", g);
            }
            return;
        }

        stats.completeExecutions++;
        if (printExecutions) {
            final String desc = g.toString(layout);
            outcomes.add(desc);
            logger.info("Execution #{}:\n{}", stats.completeExecutions, desc);
        }

        if (!properties.contains(Property.PROGRAM_SPEC)) {
            return;
        }
        final Expression filter = program.getFilterSpecification();
        final ConcreteEvaluator finalEval = finalStateEvaluator(g);
        if (filter != null && !finalEval.evaluateBoolean(filter)) {
            stats.filteredExecutions++;
            return;
        }
        final Expression spec = program.getSpecification();
        if (spec == null) {
            return;
        }
        final boolean holds = finalEval.evaluateBoolean(spec);
        switch (program.getSpecificationType()) {
            case EXISTS -> {
                if (holds && !specificationReached) {
                    specificationReached = true;
                    reachabilityWitness = g.toString(layout);
                    if (stopOnReachability) {
                        stop = true;
                    }
                }
            }
            case FORALL -> {
                if (!holds) {
                    reportViolation(ViolationKind.PROGRAM_SPEC, "Final state violates the specification.", g);
                }
            }
            case NOT_EXISTS -> {
                if (holds) {
                    reportViolation(ViolationKind.PROGRAM_SPEC, "Final state satisfies the forbidden condition.", g);
                }
            }
            case ASSERT -> { }
        }
    }

    // A spinning thread is stuck if all reads of its last iteration read from coherence-maximal writes.
    private boolean isLivenessViolation(ExplorationGraph g, List<Integer> spinning) {
        for (int t : spinning) {
            final int start = g.states[t].iterationStart;
            for (Node n : g.getThreadNodes(t)) {
                if (n.isRead() && n.poIndex >= start) {
                    final List<Node> co = g.getCo(n.address);
                    if (co.get(co.size() - 1) != g.getRf(n)) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    private ConcreteEvaluator finalStateEvaluator(ExplorationGraph g) {
        return new ConcreteEvaluator(new ConcreteEvaluator.Environment() {
            @Override
            public Object getRegisterValue(Register register) {
                final Integer t = threadIndex.get((Thread) register.getFunction());
                final Object v = t == null ? null : g.states[t].registers.get(register);
                return v != null ? v : ConcreteEvaluator.zeroOf(register.getType());
            }

            @Override
            public BigInteger getAddress(MemoryObject memoryObject) {
                return layout.getAddress(memoryObject);
            }

            @Override
            public Object getFinalMemoryValue(FinalMemoryValue value) {
                final BigInteger address = layout.getAddress(value.getMemoryObject(), value.getOffset());
                final List<Node> co = g.getCo(address);
                final Node last = co.isEmpty() ? layout.getInitNode(address, value.getType()) : co.get(co.size() - 1);
                return Values.convert(last.writeValue, value.getType());
            }
        });
    }

    // ================================================================================================
    // Violations

    private void reportCatViolation(ExplorationGraph g, Axiom axiom) {
        reportViolation(ViolationKind.CAT_SPEC, "Flagged axiom " + axiom.getNameOrTerm() + " is violated.", g);
    }

    private void reportViolation(ViolationKind kind, String description, ExplorationGraph g) {
        if (violation == null) {
            violation = new Violation(kind, description, g.toString(layout));
        }
        stop = true;
    }
}
