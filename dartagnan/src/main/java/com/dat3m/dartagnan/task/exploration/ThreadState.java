package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Assert;

import java.util.*;

/*
    The local state of a thread: program counter, register values, and dynamic dependency information.
    The state is a deterministic function of the thread's nodes in the graph (and the values they read),
    so it can always be recomputed by replaying the thread.
 */
final class ThreadState {

    enum Status {
        RUNNING,        // The thread has a pending event (pc)
        TERMINATED,     // The thread has finished
        BLOCKED,        // The thread is blocked forever (failed assume)
        SPINNING,       // The thread is blocked in a side-effect-free loop iteration
        ERROR           // The thread violated an assertion
    }

    Event pc;
    Status status = Status.RUNNING;
    boolean started;

    final Map<Register, Object> registers;
    // For each register, the visible nodes its value (transitively) depends on.
    final Map<Register, Set<Node>> provenance;
    // Visible nodes whose values were used by executed (conditional) jumps.
    Set<Node> ctrlSources;
    // Control dependencies of IfAsJump events: they only extend to the branch events.
    List<ScopedCtrl> scopedCtrl;
    // Visible nodes that influenced any executed branch (including IfAsJump).
    // Unlike the model-level ctrl dependencies, these extend to ALL po-later events, because the
    // control flow (and thus the existence and po-position of later events) depends on them.
    Set<Node> branchSources;

    // Pairing of RMW / exclusive events
    final Map<Event, Node> lastRmwLoad;
    Node lastExclusiveLoad;
    final Map<Event, Boolean> executedStatus;
    final Map<Event, Node> lastExecution;

    // Number of executions of each allocation site
    final Map<Event, Integer> allocationCounts;

    Object returnValue;
    List<Object> arguments = List.of();
    Assert violatedAssertion;
    // The thread reached the unrolling bound of a (thread-creating) loop.
    boolean boundReached;

    // Position (poIndex) where the current loop iteration started.
    int iterationStart;

    // The po-index of the pending event: all po-earlier events of the thread are in the graph.
    int nextPoIndex;
    // Computes the exploration-order predecessors of new nodes.
    ExplorationOrder.Tracker orderTracker;

    record ScopedCtrl(Set<Event> scope, Set<Node> sources) {}

    ThreadState(Event entry, ExplorationOrder.Tracker tracker) {
        this.pc = entry;
        this.orderTracker = tracker;
        this.registers = new HashMap<>();
        this.provenance = new HashMap<>();
        this.ctrlSources = Set.of();
        this.scopedCtrl = List.of();
        this.branchSources = Set.of();
        this.lastRmwLoad = new HashMap<>();
        this.executedStatus = new HashMap<>();
        this.lastExecution = new HashMap<>();
        this.allocationCounts = new HashMap<>();
    }

    private ThreadState(ThreadState other) {
        this.pc = other.pc;
        this.status = other.status;
        this.started = other.started;
        this.registers = new HashMap<>(other.registers);
        this.provenance = new HashMap<>(other.provenance);
        this.ctrlSources = other.ctrlSources;
        this.scopedCtrl = other.scopedCtrl;
        this.branchSources = other.branchSources;
        this.lastRmwLoad = new HashMap<>(other.lastRmwLoad);
        this.lastExclusiveLoad = other.lastExclusiveLoad;
        this.executedStatus = new HashMap<>(other.executedStatus);
        this.lastExecution = new HashMap<>(other.lastExecution);
        this.allocationCounts = new HashMap<>(other.allocationCounts);
        this.returnValue = other.returnValue;
        this.arguments = other.arguments;
        this.violatedAssertion = other.violatedAssertion;
        this.boundReached = other.boundReached;
        this.iterationStart = other.iterationStart;
        this.nextPoIndex = other.nextPoIndex;
        this.orderTracker = other.orderTracker.copy();
    }

    ThreadState copy() {
        return new ThreadState(this);
    }

    boolean isRunning() {
        return status == Status.RUNNING;
    }

    Set<Node> controlDependencies(Event e) {
        if (scopedCtrl.isEmpty()) {
            return ctrlSources;
        }
        Set<Node> result = null;
        for (ScopedCtrl sc : scopedCtrl) {
            if (sc.scope().contains(e)) {
                if (result == null) {
                    result = new HashSet<>(ctrlSources);
                }
                result.addAll(sc.sources());
            }
        }
        return result == null ? ctrlSources : result;
    }
}
