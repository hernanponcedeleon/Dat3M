package com.dat3m.dartagnan.task.exploration;

import java.math.BigInteger;
import java.util.*;

/*
    An execution graph as used by TruSt.
    - The nodes are stored in the order they were added (this order is "<_G" in the paper).
    - Init nodes are implicit: they are part of the coherence order of every location that is accessed
      and are considered to be added before every other node.
    - The graph also stores the local state of every thread after executing its nodes.
    - Threads are identified by their instance index (see ThreadInterpreter). Spawned threads are added when their
      creation is added; instances that do not exist in the graph have no state (null).
 */
final class ExplorationGraph {

    private final ArrayList<Node> nodes;
    private final IdentityHashMap<Node, Integer> stamps;
    private final IdentityHashMap<Node, Node> rf;
    private final LinkedHashMap<BigInteger, ArrayList<Node>> co;
    private final ArrayList<ArrayList<Node>> threadNodes;
    ThreadState[] states;
    boolean truncated;
    // Some read was revisited in place (awaits) when this graph or one of its ancestors was constructed.
    boolean inPlaceRevisited;
    // If the graph was obtained from a graph whose consistency check was deferred: that graph (see TruStExplorer).
    // Not copied.
    ExplorationGraph uncheckedParent;

    ExplorationGraph(ThreadState[] initialStates) {
        this.nodes = new ArrayList<>();
        this.stamps = new IdentityHashMap<>();
        this.rf = new IdentityHashMap<>();
        this.co = new LinkedHashMap<>();
        this.threadNodes = new ArrayList<>();
        for (int i = 0; i < initialStates.length; i++) {
            threadNodes.add(new ArrayList<>());
        }
        this.states = initialStates;
    }

    private ExplorationGraph(ExplorationGraph other) {
        this.nodes = new ArrayList<>(other.nodes);
        this.stamps = new IdentityHashMap<>(other.stamps);
        this.rf = new IdentityHashMap<>(other.rf);
        this.co = new LinkedHashMap<>();
        other.co.forEach((loc, list) -> co.put(loc, new ArrayList<>(list)));
        this.threadNodes = new ArrayList<>();
        other.threadNodes.forEach(l -> threadNodes.add(new ArrayList<>(l)));
        this.states = new ThreadState[other.states.length];
        for (int i = 0; i < states.length; i++) {
            states[i] = other.states[i] == null ? null : other.states[i].copy();
        }
        this.truncated = other.truncated;
        this.inPlaceRevisited = other.inPlaceRevisited;
    }

    ExplorationGraph copy() {
        return new ExplorationGraph(this);
    }

    // ==================================== Accessors ====================================

    List<Node> getNodes() {
        return Collections.unmodifiableList(nodes);
    }

    int size() {
        return nodes.size();
    }

    List<Node> getThreadNodes(int thread) {
        return thread < threadNodes.size() ? Collections.unmodifiableList(threadNodes.get(thread)) : List.of();
    }

    Node getLastNodeOfThread(int thread) {
        final List<Node> list = getThreadNodes(thread);
        return list.isEmpty() ? null : list.get(list.size() - 1);
    }

    // The state of the thread instance, or null if it does not exist in this graph.
    ThreadState getState(int thread) {
        return thread < states.length ? states[thread] : null;
    }

    int getNumThreads() {
        return threadNodes.size();
    }

    boolean contains(Node n) {
        return n.isInit() ? co.containsKey(n.address) : stamps.containsKey(n);
    }

    // Init nodes are considered to be added before all other nodes.
    int stamp(Node n) {
        if (n.isInit()) {
            return -1;
        }
        final Integer s = stamps.get(n);
        if (s == null) {
            throw new IllegalStateException("Node " + n + " is not part of the graph.");
        }
        return s;
    }

    Node getRf(Node read) {
        return rf.get(read);
    }

    Map<Node, Node> getRfMap() {
        return Collections.unmodifiableMap(rf);
    }

    Collection<BigInteger> getLocations() {
        return co.keySet();
    }

    List<Node> getCo(BigInteger location) {
        final List<Node> list = co.get(location);
        return list == null ? List.of() : Collections.unmodifiableList(list);
    }

    Iterable<Node> getInitNodes() {
        final List<Node> inits = new ArrayList<>();
        co.values().forEach(l -> inits.add(l.get(0)));
        return inits;
    }

    // ==================================== Mutators ====================================

    // Makes room for the thread instance (without creating its state).
    void ensureThread(int thread) {
        while (threadNodes.size() <= thread) {
            threadNodes.add(new ArrayList<>());
        }
        if (states.length <= thread) {
            states = Arrays.copyOf(states, Math.max(thread + 1, 2 * states.length));
            while (threadNodes.size() < states.length) {
                threadNodes.add(new ArrayList<>());
            }
        }
    }

    void ensureLocation(Node init) {
        co.computeIfAbsent(init.address, k -> {
            final ArrayList<Node> list = new ArrayList<>();
            list.add(init);
            return list;
        });
    }

    void addNode(Node n) {
        if (n.isInit()) {
            throw new IllegalArgumentException("Init nodes are implicit.");
        }
        stamps.put(n, nodes.size());
        nodes.add(n);
        // Thread nodes are sorted by po (with the DEPENDENCIES order, nodes may fill holes).
        final ArrayList<Node> list = threadNodes.get(n.thread);
        int pos = list.size();
        while (pos > 0 && list.get(pos - 1).poIndex > n.poIndex) {
            pos--;
        }
        list.add(pos, n);
    }

    // Returns the node of thread t at the given po-position, or null if there is none.
    Node getThreadNode(int t, int poIndex) {
        if (t >= threadNodes.size()) {
            return null;
        }
        final ArrayList<Node> list = threadNodes.get(t);
        int lo = 0;
        int hi = list.size() - 1;
        while (lo <= hi) {
            final int mid = (lo + hi) >>> 1;
            final int idx = list.get(mid).poIndex;
            if (idx == poIndex) {
                return list.get(mid);
            } else if (idx < poIndex) {
                lo = mid + 1;
            } else {
                hi = mid - 1;
            }
        }
        return null;
    }

    void setRf(Node read, Node write) {
        rf.put(read, write);
    }

    // Undoes addNode(n) (and its rf edge) for the node that was added last.
    void removeLastNode(Node n) {
        if (nodes.isEmpty() || nodes.get(nodes.size() - 1) != n) {
            throw new IllegalStateException("Node " + n + " was not added last.");
        }
        nodes.remove(nodes.size() - 1);
        stamps.remove(n);
        rf.remove(n);
        final ArrayList<Node> list = threadNodes.get(n.thread);
        for (int i = list.size() - 1; i >= 0; i--) {
            if (list.get(i) == n) {
                list.remove(i);
                break;
            }
        }
    }

    // Undoes insertCoAfter(write, _).
    void removeFromCo(Node write) {
        final ArrayList<Node> list = co.get(write.address);
        for (int i = list.size() - 1; i >= 0; i--) {
            if (list.get(i) == write) {
                list.remove(i);
                return;
            }
        }
    }

    // Inserts the write immediately after "pred" in coherence order.
    void insertCoAfter(Node write, Node pred) {
        final ArrayList<Node> list = co.get(write.address);
        final int index = list.indexOf(pred);
        if (index < 0) {
            throw new IllegalStateException("Write " + pred + " is not in co.");
        }
        list.add(index + 1, write);
    }

    /*
        Restricts the graph to all nodes except the deleted ones.
        Thread states have to be recomputed by the caller for affected threads.
        Returns the set of threads that lost nodes.
     */
    Set<Integer> removeNodes(Set<Node> deleted) {
        if (deleted.isEmpty()) {
            return Set.of();
        }
        final Set<Integer> affected = new HashSet<>();
        nodes.removeIf(deleted::contains);
        stamps.clear();
        for (int i = 0; i < nodes.size(); i++) {
            stamps.put(nodes.get(i), i);
        }
        for (Node d : deleted) {
            rf.remove(d);
            affected.add(d.thread);
        }
        co.values().forEach(list -> list.removeIf(deleted::contains));
        for (int t : affected) {
            threadNodes.get(t).removeIf(deleted::contains);
        }
        return affected;
    }

    // ==================================== Prefixes ====================================

    /*
        Direct predecessors of a node in the exploration order: its E-predecessors (po or dependencies),
        its rf-source, and thread synchronization.
     */
    void forEachPorfPredecessor(Node n, java.util.function.Consumer<Node> consumer) {
        if (n.isInit()) {
            return;
        }
        n.ePreds.forEach(consumer);
        final Node source = rf.get(n);
        if (source != null && !source.isInit()) {
            consumer.accept(source);
        }
        if (n.creator != null) {
            consumer.accept(n.creator);
        }
        if (n.joinedLast != null) {
            consumer.accept(n.joinedLast);
        }
    }

    // All nodes that are (reflexively) porf-before the given nodes (init nodes excluded).
    Set<Node> porfClosure(Collection<Node> roots) {
        final Set<Node> result = Collections.newSetFromMap(new IdentityHashMap<>());
        final ArrayDeque<Node> work = new ArrayDeque<>();
        for (Node r : roots) {
            if (r != null && !r.isInit() && result.add(r)) {
                work.add(r);
            }
        }
        while (!work.isEmpty()) {
            final Node n = work.poll();
            forEachPorfPredecessor(n, p -> {
                if (result.add(p)) {
                    work.add(p);
                }
            });
        }
        return result;
    }

    // ==================================== Printing ====================================

    String toString(MemoryLayout layout) {
        final StringBuilder sb = new StringBuilder();
        for (int t = 0; t < threadNodes.size(); t++) {
            if (threadNodes.get(t).isEmpty() || states[t] == null) {
                continue;
            }
            sb.append("  Thread ").append(t).append(" [").append(states[t].status).append("]\n");
            for (Node n : threadNodes.get(t)) {
                sb.append("    ").append(describe(n, layout)).append('\n');
            }
        }
        sb.append("  Coherence:\n");
        co.forEach((loc, list) -> {
            sb.append("    ").append(layout.describe(loc)).append(": ");
            final StringJoiner joiner = new StringJoiner(" -> ");
            list.forEach(w -> joiner.add(w.isInit() ? "init(" + w.writeValue + ")" : w.thread + "." + w.poIndex + "(" + w.writeValue + ")"));
            sb.append(joiner).append('\n');
        });
        return sb.toString();
    }

    private String describe(Node n, MemoryLayout layout) {
        final String id = n.thread + "." + n.poIndex;
        return switch (n.kind) {
            case READ -> {
                final Node w = rf.get(n);
                final String src = w == null ? "?" : (w.isInit() ? "init" : w.thread + "." + w.poIndex);
                yield String.format("%s: R %s = %s   (rf from %s)   // %s", id, layout.describe(n.address),
                        w == null ? "?" : Values.convert(w.writeValue, n.accessType), src, n.event);
            }
            case WRITE -> String.format("%s: W %s = %s   // %s", id, layout.describe(n.address), n.writeValue, n.event);
            default -> String.format("%s: %s", id, n);
        };
    }
}
