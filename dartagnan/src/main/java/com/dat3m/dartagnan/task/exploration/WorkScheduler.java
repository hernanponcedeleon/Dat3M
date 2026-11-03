package com.dat3m.dartagnan.task.exploration;

import org.sosy_lab.common.ShutdownNotifier;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentLinkedDeque;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.locks.LockSupport;

/*
    Runs the work items of the exploration (the recursive calls of TruSt's Algorithm 1), either sequentially on an
    explicit stack (depth-first) or in parallel.

    TruSt is stateless: the exploration of a graph only depends on the graph itself (the maximality checks of backward
    revisits do not consult other graphs). Hence, work items can be run in any order and in parallel, and the set of
    visited graphs does not depend on the schedule.
    In parallel mode, each worker runs its own deque depth-first (LIFO) and steals the oldest items (the largest
    subtrees) of other workers when it runs out of work. The exploration ends when no item is pending (queued or
    running), or when it is stopped.
    Items pushed while a worker runs an item are published when the item is done: the visit of a graph may still
    modify the graph (temporarily, see TruStExplorer.isPlausibleCo) after pushing work items that read it.
 */
final class WorkScheduler {

    @FunctionalInterface
    interface WorkItem {
        void run() throws InterruptedException;
    }

    // Worker threads do not need the large stack of the main thread.
    private static final long WORKER_STACK_SIZE = 32L << 20;
    private static final int SPINS_BEFORE_PARKING = 64;
    private static final long PARK_NANOS = 20_000;

    private final int numWorkers;
    private final ShutdownNotifier shutdownNotifier;
    private volatile boolean stopped;

    // Sequential mode
    private final ArrayDeque<WorkItem> stack = new ArrayDeque<>();

    // Parallel mode
    private final List<ConcurrentLinkedDeque<WorkItem>> deques = new ArrayList<>();
    private final ThreadLocal<List<WorkItem>> pushBuffer = new ThreadLocal<>();
    private final AtomicLong pending = new AtomicLong();
    private Throwable failure;

    WorkScheduler(int numWorkers, ShutdownNotifier shutdownNotifier) {
        this.numWorkers = Math.max(1, numWorkers);
        this.shutdownNotifier = shutdownNotifier;
    }

    // Stops the exploration: pending items are dropped.
    void stop() {
        stopped = true;
    }

    // Schedules an item. Must be called from a running item.
    void push(WorkItem item) {
        if (numWorkers == 1) {
            stack.push(item);
        } else {
            pushBuffer.get().add(item);
        }
    }

    // Runs the item and all items it (transitively) pushes. Can be called only once.
    void run(WorkItem root) throws InterruptedException {
        if (numWorkers == 1) {
            stack.push(root);
            while (!stack.isEmpty() && !stopped) {
                shutdownNotifier.shutdownIfNecessary();
                stack.pop().run();
            }
        } else {
            runInParallel(root);
        }
    }

    // ================================================================================================
    // Parallel mode

    private void runInParallel(WorkItem root) throws InterruptedException {
        for (int i = 0; i < numWorkers; i++) {
            deques.add(new ConcurrentLinkedDeque<>());
        }
        pending.set(1);
        deques.get(0).add(root);
        final List<Thread> workers = new ArrayList<>();
        for (int i = 0; i < numWorkers; i++) {
            final int id = i;
            final Thread worker = new Thread(null, () -> workerLoop(id), "exploration-worker-" + i, WORKER_STACK_SIZE);
            worker.setDaemon(true);
            workers.add(worker);
            worker.start();
        }
        try {
            for (Thread worker : workers) {
                worker.join();
            }
        } catch (InterruptedException ex) {
            stopped = true;
            throw ex;
        }
        final Throwable t;
        synchronized (this) {
            t = failure;
        }
        switch (t) {
            case null -> { }
            case InterruptedException ex -> throw ex;
            case RuntimeException ex -> throw ex;
            case Error err -> throw err;
            default -> throw new IllegalStateException(t);
        }
    }

    private void workerLoop(int id) {
        final List<WorkItem> buffer = new ArrayList<>();
        pushBuffer.set(buffer);
        final ConcurrentLinkedDeque<WorkItem> own = deques.get(id);
        int idle = 0;
        while (!stopped && pending.get() > 0) {
            WorkItem item = own.pollFirst();
            if (item == null) {
                item = steal(id);
            }
            if (item == null) {
                if (++idle < SPINS_BEFORE_PARKING) {
                    Thread.onSpinWait();
                } else {
                    LockSupport.parkNanos(PARK_NANOS);
                }
                continue;
            }
            idle = 0;
            try {
                shutdownNotifier.shutdownIfNecessary();
                item.run();
                // Publish the pushed items (in push order, so that the last one is run first, as in sequential mode).
                pending.addAndGet(buffer.size());
                buffer.forEach(own::addFirst);
            } catch (Throwable t) {
                synchronized (this) {
                    if (failure == null) {
                        failure = t;
                    }
                }
                stopped = true;
            } finally {
                buffer.clear();
                pending.decrementAndGet();
            }
        }
    }

    private WorkItem steal(int id) {
        for (int k = 1; k < numWorkers; k++) {
            final WorkItem item = deques.get((id + k) % numWorkers).pollLast();
            if (item != null) {
                return item;
            }
        }
        return null;
    }
}
