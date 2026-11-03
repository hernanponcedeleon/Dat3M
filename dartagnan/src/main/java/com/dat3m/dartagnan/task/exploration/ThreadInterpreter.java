package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.dat3m.dartagnan.program.event.core.annotations.LoopBound;
import com.dat3m.dartagnan.program.event.core.special.StateSnapshot;
import com.dat3m.dartagnan.program.event.core.threading.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.common.ShutdownNotifier;

import java.math.BigInteger;
import java.util.*;

/*
    Executes the threads of a program on concrete values.
    Non-visible events (locals, jumps, assumes, ...) are executed eagerly.
    The interpreter stops at "scheduling points", i.e., events that become nodes of the execution graph:
    visible events (memory accesses, fences, ...) and thread management events (create, join, start).
 */
final class ThreadInterpreter {

    private static final int SHUTDOWN_CHECK_INTERVAL = 1 << 16;

    private final List<Thread> threads;
    private final Map<Thread, Integer> threadIndex = new HashMap<>();
    private final MemoryLayout layout;
    private final boolean zeroInitializedRegisters;
    private final ShutdownNotifier shutdownNotifier;
    private final ExplorationOrder order;
    private final Set<String> relaxedTags;
    private final ThreadAnalysis analysis;

    ThreadInterpreter(List<Thread> threads, MemoryLayout layout, Program program, ExplorationOrder order,
                      ThreadAnalysis analysis, ShutdownNotifier notifier) {
        this.order = order;
        this.relaxedTags = ExplorationOrder.relaxedTags(program.getArch());
        this.threads = threads;
        for (int i = 0; i < threads.size(); i++) {
            threadIndex.put(threads.get(i), i);
        }
        this.layout = layout;
        this.zeroInitializedRegisters = program.registersAreZeroInitialized();
        this.shutdownNotifier = notifier;
        this.analysis = analysis;
        collectJoinLoads();
    }

    /*
        A pthread_join is lowered (see ThreadCreation) to an atomic fetch-and-AND on the state word of the joined
        thread, followed by a ThreadJoin (waiting for its termination) and an assume that the fetched state says
        that the thread is no longer alive. If the load of the fetch-and-AND runs before the joined thread
        terminated, or if it reads an older value afterwards, it reads "alive" and the join blocks forever.
        We therefore only enable this load once the joined thread terminated, and let it read the latest write
        to the state word (the explorer does not offer older writes). Then the join never blocks.
        Older writes can only be read in executions where the join blocks, unless the state word is also
        written by pthread_detach (then a join may return early without waiting). So we do not treat joins
        specially in programs that detach threads.
     */
    private final Map<Event, Integer> joinLoads = new HashMap<>();

    private void collectJoinLoads() {
        for (Thread thread : threads) {
            for (Event e : thread.getEvents()) {
                if (e instanceof Load load && load.getResultRegister().getName().startsWith("__detachThreadState")) {
                    joinLoads.clear();
                    return;
                }
                if (!(e instanceof ThreadJoin join) || !threadIndex.containsKey(join.getJoinThread())) {
                    continue;
                }
                final List<MemoryCoreEvent> spawning = join.getJoinThread().getSpawningEvents();
                if (spawning.isEmpty()) {
                    continue;
                }
                final Expression stateAddress = spawning.get(0).getAddress();
                Event cur = join.getPredecessor();
                for (int i = 0; i < 8 && cur != null; i++, cur = cur.getPredecessor()) {
                    if (cur instanceof Load load) {
                        if (load.getAddress().equals(stateAddress)) {
                            joinLoads.put(load, indexOf(join.getJoinThread()));
                        }
                        break;
                    }
                }
            }
        }
    }

    boolean isJoinLoad(Event e) {
        return joinLoads.containsKey(e);
    }

    List<Thread> getThreads() {
        return threads;
    }

    int indexOf(Thread thread) {
        final Integer index = threadIndex.get(thread);
        if (index == null) {
            throw new UnsupportedOperationException("Unknown thread " + thread);
        }
        return index;
    }

    // ================================================================================================
    // Initial states and replay

    private ThreadState newState(int t) {
        return new ThreadState(threads.get(t).getEntry(), new ExplorationOrder.Tracker(order, relaxedTags));
    }

    ThreadState newInitialState(int t) throws InterruptedException {
        final ThreadState st = newState(t);
        advance(st);
        return st;
    }

    /*
        Recomputes the state of thread t from scratch, using the thread's nodes in the graph.
        The thread is executed up to its first event that is missing in the graph.
        (With the DEPENDENCIES order, the graph may contain po-later nodes after such a "hole".)
     */
    void replay(ExplorationGraph g, int t) throws InterruptedException {
        final ThreadState st = newState(t);
        g.states[t] = st;
        advance(st);
        catchUp(g, t, st);
    }

    // ================================================================================================
    // Scheduling points

    static boolean isSchedulingPoint(Event e, ThreadState st) {
        if (e.hasTag(Tag.VISIBLE)) {
            return true;
        }
        if (e instanceof ThreadCreate || e instanceof ThreadJoin) {
            return true;
        }
        return e instanceof ThreadStart start && start.isSpawned() && !st.started;
    }

    // Can the pending event of thread t be added to the graph?
    boolean isEnabled(ExplorationGraph g, int t) {
        final ThreadState st = g.states[t];
        if (!st.isRunning()) {
            return false;
        }
        final Event e = st.pc;
        if (e instanceof ThreadStart) {
            return findCreator(g, t) != null;
        }
        if (e instanceof ThreadJoin join) {
            final int joined = indexOf(join.getJoinThread());
            return g.states[joined].status == ThreadState.Status.TERMINATED;
        }
        final Integer joined = joinLoads.get(e);
        if (joined != null) {
            return g.states[joined].status == ThreadState.Status.TERMINATED;
        }
        return true;
    }

    // A spawned thread that was never created does not exist.
    boolean isWaitingForCreation(ExplorationGraph g, int t) {
        final ThreadState st = g.states[t];
        return st.isRunning() && st.pc instanceof ThreadStart && findCreator(g, t) == null;
    }

    private Node findCreator(ExplorationGraph g, int t) {
        final ThreadStart start = (ThreadStart) threads.get(t).getEntry();
        final ThreadCreate create = start.getCreator();
        final int creatorThread = indexOf(create.getThread());
        for (Node n : g.getThreadNodes(creatorThread)) {
            if (n.event == create) {
                return n;
            }
        }
        return null;
    }

    static boolean isWeakExclusiveStore(Event e) {
        return e instanceof RMWStoreExclusive excl && !excl.isStrong();
    }

    // ================================================================================================
    // Node creation

    /*
        Creates the node for the pending event of thread t.
        If "failExclusive" is set, the pending store-exclusive is created as a failed store.
        Returns null if the requested node is impossible (e.g. a store-exclusive that must fail).
     */
    Node makeNode(ExplorationGraph g, int t, boolean failExclusive) {
        final ThreadState st = g.states[t];
        final Event e = st.pc;
        final int poIndex = st.nextPoIndex;
        final ConcreteEvaluator eval = evaluator(st);
        final Node.Builder b = createBuilder(g, t, st, e, poIndex, eval, failExclusive);
        if (b == null) {
            return null;
        }
        b.ePreds = st.orderTracker.predecessors(b.getKind(), e, b.address, b.dataDeps, b.addrDeps,
                st.branchSources, b.pairedLoad);
        return b.build();
    }

    private Node.Builder createBuilder(ExplorationGraph g, int t, ThreadState st, Event e, int poIndex,
                                       ConcreteEvaluator eval, boolean failExclusive) {

        if (e instanceof ThreadStart) {
            final Node.Builder b = Node.builder(Node.Kind.THREAD_START, t, poIndex, e);
            b.creator = findCreator(g, t);
            return b;
        }
        if (e instanceof ThreadCreate create) {
            final int spawned = indexOf(create.getSpawnedThread());
            if (g.states[spawned].started || !g.getThreadNodes(spawned).isEmpty()) {
                throw new UnsupportedOperationException(
                        "Exploration does not support creating the same thread multiple times: " + create);
            }
            final Node.Builder b = Node.builder(Node.Kind.THREAD_CREATE, t, poIndex, e);
            b.otherThread = spawned;
            final List<Object> args = new ArrayList<>();
            create.getArguments().forEach(arg -> args.add(eval.evaluate(arg)));
            b.payload = Collections.unmodifiableList(args);
            b.dataDeps = provenance(st, create.getArguments());
            b.ctrlDeps = st.controlDependencies(e);
            return b;
        }
        if (e instanceof ThreadJoin join) {
            final int joined = indexOf(join.getJoinThread());
            final Node.Builder b = Node.builder(Node.Kind.THREAD_JOIN, t, poIndex, e);
            b.otherThread = joined;
            b.joinedLast = g.getLastNodeOfThread(joined);
            final Object ret = g.states[joined].returnValue;
            b.payload = Collections.singletonList(ret);
            b.ctrlDeps = st.controlDependencies(e);
            return b;
        }
        if (e instanceof Init) {
            throw new IllegalStateException("Unexpected init event in thread: " + e);
        }

        if (e instanceof Load load) {
            final Node.Builder b = Node.builder(Node.Kind.READ, t, poIndex, e);
            fillMemoryInfo(b, st, eval, load);
            return b;
        }
        if (e instanceof Store store) {
            if (failExclusive) {
                final Node.Builder b = Node.builder(Node.Kind.EXCL_FAIL, t, poIndex, e);
                b.ctrlDeps = st.controlDependencies(e);
                b.couldSucceed = createBuilder(g, t, st, e, poIndex, eval, false) != null;
                return b;
            }
            final Node.Builder b = Node.builder(Node.Kind.WRITE, t, poIndex, e);
            fillMemoryInfo(b, st, eval, store);
            b.writeValue = Values.convert(eval.evaluate(store.getMemValue()), store.getAccessType());
            b.dataDeps = provenance(st, List.of(store.getMemValue()));
            if (store instanceof RMWStore rmw) {
                b.pairedLoad = st.lastRmwLoad.get(rmw.getLoadEvent());
                if (b.pairedLoad == null) {
                    throw new IllegalStateException("RMW store without executed load: " + store);
                }
            } else if (store instanceof RMWStoreExclusive excl) {
                b.pairedLoad = st.lastExclusiveLoad;
                b.isExclusivePair = b.pairedLoad != null;
                if (b.pairedLoad == null && !excl.isStrong()) {
                    return null; // A store-exclusive without a matching load-exclusive fails.
                }
                if (b.pairedLoad != null && excl.doesRequireMatchingAddresses()
                        && !b.pairedLoad.address.equals(b.address)) {
                    if (!excl.isStrong()) {
                        return null;
                    }
                    b.pairedLoad = null;
                    b.isExclusivePair = false;
                }
            }
            return b;
        }
        if (e instanceof MemoryCoreEvent mem) {
            final Node.Builder b = Node.builder(Node.Kind.OTHER, t, poIndex, e);
            fillMemoryInfo(b, st, eval, mem);
            return b;
        }
        if (e.hasTag(Tag.VISIBLE)) {
            if (e instanceof ControlBarrier) {
                throw new UnsupportedOperationException("Exploration does not support control barriers: " + e);
            }
            final Node.Builder b = Node.builder(Node.Kind.OTHER, t, poIndex, e);
            b.ctrlDeps = st.controlDependencies(e);
            return b;
        }
        throw new IllegalStateException("Event " + e + " is not a scheduling point.");
    }

    private void fillMemoryInfo(Node.Builder b, ThreadState st, ConcreteEvaluator eval, MemoryCoreEvent mem) {
        final Type ptrType = TypeFactory.getInstance().getPointerType();
        b.address = (BigInteger) Values.convert(eval.evaluate(mem.getAddress()), ptrType);
        b.accessType = mem.getAccessType();
        b.addrDeps = provenance(st, List.of(mem.getAddress()));
        b.ctrlDeps = st.controlDependencies(mem);
    }

    // ================================================================================================
    // Applying nodes

    /*
        Updates the state of the node's thread after the node was added (with its rf, if it is a read).
        Afterwards, the thread continues and consumes all po-later nodes that are already in the graph.
     */
    void applyNode(ExplorationGraph g, ThreadState st, Node n) throws InterruptedException {
        applySingle(g, st, n);
        catchUp(g, n.thread, st);
    }

    private void catchUp(ExplorationGraph g, int t, ThreadState st) throws InterruptedException {
        while (st.isRunning() && st.pc != null && isSchedulingPoint(st.pc, st)) {
            final Node next = g.getThreadNode(t, st.nextPoIndex);
            if (next == null) {
                return;
            }
            checkMatches(g, t, st, next);
            applySingle(g, st, next);
        }
    }

    // Sanity check: a node that is kept in the graph must be reproduced by the thread.
    private void checkMatches(ExplorationGraph g, int t, ThreadState st, Node n) {
        if (st.pc != n.event) {
            throw new IllegalStateException(String.format(
                    "Thread %d diverged at node %s (pc: %s). The exploration order is not respected.", t, n, st.pc));
        }
        if (n.kind == Node.Kind.READ || n.kind == Node.Kind.WRITE) {
            final Node expected = makeNode(g, t, false);
            if (expected == null || !Objects.equals(expected.address, n.address)
                    || !Objects.equals(expected.writeValue, n.writeValue)) {
                throw new IllegalStateException(String.format(
                        "Thread %d computed different values for node %s. The exploration order is not respected.", t, n));
            }
        }
    }

    private void applySingle(ExplorationGraph g, ThreadState st, Node n) throws InterruptedException {
        final Event e = n.event;
        switch (n.kind) {
            case READ -> {
                final Load load = (Load) e;
                final Node source = g.getRf(n);
                if (source == null) {
                    throw new IllegalStateException("Read " + n + " has no rf-edge.");
                }
                final Register reg = load.getResultRegister();
                assign(st, reg, Values.convert(source.writeValue, reg.getType()), ImmutableSet.of(n));
                if (load.hasTag(Tag.EXCL)) {
                    st.lastExclusiveLoad = n;
                }
                if (load.hasTag(Tag.RMW)) {
                    st.lastRmwLoad.put(load, n);
                }
            }
            case WRITE -> {
                if (e instanceof RMWStoreExclusive) {
                    st.executedStatus.put(e, true);
                    st.lastExecution.put(e, n);
                    st.lastExclusiveLoad = null;
                }
            }
            case EXCL_FAIL -> {
                st.executedStatus.put(e, false);
                st.lastExclusiveLoad = null;
            }
            case THREAD_START -> {
                st.started = true;
                st.arguments = n.creator.payload;
            }
            case THREAD_JOIN -> {
                final ThreadJoin join = (ThreadJoin) e;
                final Register reg = join.getResultRegister();
                final Object ret = n.payload.get(0);
                assign(st, reg, ret == null ? ConcreteEvaluator.zeroOf(reg.getType()) : Values.convert(ret, reg.getType()),
                        ImmutableSet.of());
            }
            case OTHER, THREAD_CREATE -> { }
            case INIT -> throw new IllegalStateException();
        }
        st.orderTracker.update(n);
        st.nextPoIndex = n.poIndex + 1;
        st.pc = e.getSuccessor();
        advance(st);
    }

    // ================================================================================================
    // Execution of non-visible events

    // Executes non-visible events until the thread reaches a scheduling point, terminates, or blocks.
    void advance(ThreadState st) throws InterruptedException {
        int steps = 0;
        while (st.isRunning()) {
            final Event e = st.pc;
            if (e == null) {
                st.status = ThreadState.Status.TERMINATED;
                return;
            }
            if (isSchedulingPoint(e, st)) {
                return;
            }
            execute(st, e);
            if (++steps % SHUTDOWN_CHECK_INTERVAL == 0) {
                shutdownNotifier.shutdownIfNecessary();
            }
        }
    }

    private void execute(ThreadState st, Event e) {
        final ConcreteEvaluator eval = evaluator(st);
        Event next = e.getSuccessor();
        if (e instanceof Local local) {
            assign(st, local.getResultRegister(), eval.evaluate(local.getExpr()),
                    provenance(st, List.of(local.getExpr())));
        } else if (e instanceof CondJump jump) {
            final boolean taken = eval.evaluateBoolean(jump.getGuard());
            final Set<Node> sources = provenance(st, List.of(jump.getGuard()));
            if (!sources.isEmpty()) {
                st.branchSources = union(st.branchSources, sources);
                if (jump instanceof IfAsJump ifJump) {
                    final List<ThreadState.ScopedCtrl> scoped = new ArrayList<>(st.scopedCtrl);
                    scoped.add(new ThreadState.ScopedCtrl(Set.copyOf(ifJump.getBranchesEvents()), sources));
                    st.scopedCtrl = List.copyOf(scoped);
                } else {
                    st.ctrlSources = union(st.ctrlSources, sources);
                }
            }
            if (taken) {
                if (jump.hasTag(Tag.BOUND)) {
                    st.status = ThreadState.Status.BLOCKED;
                    st.boundReached = true;
                    return;
                }
                if (jump.hasTag(Tag.SPINLOOP)) {
                    st.status = ThreadState.Status.SPINNING;
                    // The side-effect-free iteration is the last iteration of this loop (not of an inner loop).
                    final Integer start = st.loopEntry.get(analysis.getSpinLoopHeader(jump));
                    if (start != null) {
                        st.iterationStart = start;
                    }
                    return;
                }
                next = jump.getLabel();
                if (next.getGlobalId() <= jump.getGlobalId()) {
                    // Back jump: a new loop iteration starts.
                    st.iterationStart = st.nextPoIndex;
                }
            }
        } else if (e instanceof Assume assume) {
            if (!eval.evaluateBoolean(assume.getExpr())) {
                st.status = ThreadState.Status.BLOCKED;
                return;
            }
        } else if (e instanceof Assert assertion) {
            if (!eval.evaluateBoolean(assertion.getExpression())) {
                st.status = ThreadState.Status.ERROR;
                st.violatedAssertion = assertion;
                return;
            }
        } else if (e instanceof Alloc alloc) {
            final int instance = st.allocationCounts.merge(alloc, 1, Integer::sum) - 1;
            final TypeFactory types = TypeFactory.getInstance();
            final int elementSize = Math.max(types.getMemorySizeInBytes(alloc.getAllocationType()), 1);
            final int count = eval.evaluateInteger(alloc.getArraySize()).intValueExact();
            final BigInteger address = layout.allocate(alloc, instance, elementSize * Math.max(count, 1));
            assign(st, alloc.getResultRegister(), address, ImmutableSet.of());
        } else if (e instanceof ExecutionStatus status) {
            final boolean executed = st.executedStatus.getOrDefault(status.getStatusEvent(), false);
            final Register reg = status.getResultRegister();
            final Object value = reg.getType() instanceof BooleanType ? !executed
                    : (executed ? BigInteger.ZERO : BigInteger.ONE);
            // Dat3M considers the status register to be data-dependent on the store (if tracked).
            final Node store = executed && status.doesTrackDep() ? st.lastExecution.get(status.getStatusEvent()) : null;
            assign(st, reg, value, store == null ? ImmutableSet.of() : ImmutableSet.of(store));
        } else if (e instanceof ThreadArgument arg) {
            assign(st, arg.getResultRegister(), st.arguments.get(arg.getIndex()), ImmutableSet.of());
        } else if (e instanceof ThreadReturn ret) {
            st.returnValue = ret.getValue().map(eval::evaluate).orElse(null);
        } else if (e instanceof Label label) {
            if (isLoopHead(label)) {
                // Entering the loop (or a new iteration): the current iteration starts here. Without this, the first
                // iteration of a loop would also contain the events before the loop.
                st.iterationStart = st.nextPoIndex;
                if (analysis.isSpinLoopHeader(label)) {
                    st.loopEntry.put(label, st.nextPoIndex);
                }
            }
        } else if (e instanceof LoopBound) {
            // Precedes the header of a statically side-effect-free (spin) loop, whose back jump was replaced by
            // the spinloop terminator: the (only) iteration starts here.
            st.iterationStart = st.nextPoIndex;
            if (analysis.isSpinLoopHeader(e)) {
                st.loopEntry.put(e, st.nextPoIndex);
            }
        } else if (e instanceof ThreadStart || e instanceof Skip
                || e instanceof CodeAnnotation || e instanceof InstructionBoundary || e instanceof StateSnapshot) {
            // Nothing to do
        } else {
            throw new UnsupportedOperationException(String.format(
                    "Exploration does not support event '%s' of type %s.", e, e.getClass().getSimpleName()));
        }
        st.pc = next;
    }

    // ================================================================================================
    // Helpers

    private void assign(ThreadState st, Register reg, Object value, Set<Node> prov) {
        st.registers.put(reg, Values.convert(value, reg.getType()));
        if (prov.isEmpty()) {
            st.provenance.remove(reg);
        } else {
            st.provenance.put(reg, prov);
        }
    }

    private static Set<Node> provenance(ThreadState st, Collection<? extends Expression> exprs) {
        Set<Node> result = null;
        for (Expression expr : exprs) {
            for (Register reg : expr.getRegs()) {
                final Set<Node> p = st.provenance.get(reg);
                if (p == null || p.isEmpty()) {
                    continue;
                }
                if (result == null) {
                    result = p;
                } else if (!result.containsAll(p)) {
                    result = union(result, p);
                }
            }
        }
        return result == null ? ImmutableSet.of() : result;
    }

    private static Set<Node> union(Set<Node> a, Set<Node> b) {
        if (a.isEmpty()) {
            return b;
        }
        if (b.isEmpty() || a.containsAll(b)) {
            return a;
        }
        return ImmutableSet.<Node>builder().addAll(a).addAll(b).build();
    }

    private ConcreteEvaluator evaluator(ThreadState st) {
        return new ConcreteEvaluator(new ConcreteEvaluator.Environment() {
            @Override
            public Object getRegisterValue(Register register) {
                final Object v = st.registers.get(register);
                if (v != null) {
                    return v;
                }
                // Uninitialized registers hold nondeterministic values (unless zero-initialization is enabled).
                return zeroInitializedRegisters ? ConcreteEvaluator.zeroOf(register.getType()) : Values.UNDEFINED;
            }

            @Override
            public BigInteger getAddress(MemoryObject memoryObject) {
                return layout.getAddress(memoryObject);
            }
        });
    }

    private static boolean isLoopHead(Label label) {
        for (CondJump jump : label.getJumpSet()) {
            if (jump.getGlobalId() >= label.getGlobalId()) {
                return true;
            }
        }
        return false;
    }
}
