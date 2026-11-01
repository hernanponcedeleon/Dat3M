package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;

import java.math.BigInteger;
import java.util.List;
import java.util.Set;

/*
    A node of an execution graph, i.e., an event instance.
    Nodes are immutable and can be shared between different execution graphs.
    The reads-from and coherence information is stored in the graph.
 */
public final class Node {

    public enum Kind {
        INIT,           // Initial write to a location
        READ,           // Visible memory read
        WRITE,          // Visible memory write
        OTHER,          // Other visible event (e.g. fences, generic memory events)
        THREAD_START,   // Start of a spawned thread (not visible to the memory model)
        THREAD_CREATE,  // Creation of a thread (not visible to the memory model)
        THREAD_JOIN,    // Join with a thread (not visible to the memory model)
        EXCL_FAIL       // A store-exclusive that failed (not visible to the memory model)
    }

    final Kind kind;
    final int thread;           // -1 for init nodes
    final int poIndex;          // Position within the thread (counting all nodes of the thread)
    final Event event;          // null for synthetic init nodes
    final BigInteger address;   // For memory events
    final Type accessType;      // For memory events
    final Object writeValue;    // For writes (incl. init)

    // Dependencies (sources are visible nodes of the same thread)
    final Set<Node> dataDeps;
    final Set<Node> addrDeps;
    final Set<Node> ctrlDeps;

    // Direct predecessors in the exploration order (po, or dependencies; see ExplorationOrder).
    final Set<Node> ePreds;

    // For failed store-exclusives: whether the store could have succeeded instead.
    final boolean couldSucceed;

    // For RMW stores (amo) and store-exclusives (lxsx): the paired load node.
    final Node pairedLoad;
    final boolean isExclusivePair;

    // Thread management
    final int otherThread;          // THREAD_CREATE: spawned thread; THREAD_JOIN: joined thread
    final Node creator;             // THREAD_START: the THREAD_CREATE node
    final Node joinedLast;          // THREAD_JOIN: the last node of the joined thread (if any)
    final List<Object> payload;     // THREAD_CREATE: argument values; THREAD_JOIN: [return value]

    private final Set<String> syntheticTags;

    // Cache for tag queries by index (see ConsistencyChecker): bit k of tagKnown says whether tag k was queried,
    // bit k of tagValue holds the answer. Nodes are shared between graphs, so each answer is computed once.
    private long tagKnown;
    private long tagValue;

    private Node(Builder b) {
        this.kind = b.kind;
        this.thread = b.thread;
        this.poIndex = b.poIndex;
        this.event = b.event;
        this.address = b.address;
        this.accessType = b.accessType;
        this.writeValue = b.writeValue;
        this.dataDeps = b.dataDeps;
        this.addrDeps = b.addrDeps;
        this.ctrlDeps = b.ctrlDeps;
        this.ePreds = b.ePreds;
        this.couldSucceed = b.couldSucceed;
        this.pairedLoad = b.pairedLoad;
        this.isExclusivePair = b.isExclusivePair;
        this.otherThread = b.otherThread;
        this.creator = b.creator;
        this.joinedLast = b.joinedLast;
        this.payload = b.payload;
        this.syntheticTags = b.syntheticTags;
    }

    public Kind getKind() { return kind; }
    public int getThread() { return thread; }
    public Event getEvent() { return event; }
    public BigInteger getAddress() { return address; }

    public boolean isInit() { return kind == Kind.INIT; }
    public boolean isRead() { return kind == Kind.READ; }
    public boolean isWrite() { return kind == Kind.WRITE || kind == Kind.INIT; }

    // Visible nodes are the ones the memory model reasons about.
    public boolean isVisible() {
        return kind == Kind.INIT || kind == Kind.READ || kind == Kind.WRITE || kind == Kind.OTHER;
    }

    // Tag query with caching for tag indices below 64.
    boolean hasTag(int tagIndex, String tag) {
        if (tagIndex >= 64) {
            return hasTag(tag);
        }
        final long bit = 1L << tagIndex;
        if ((tagKnown & bit) == 0) {
            if (hasTag(tag)) {
                tagValue |= bit;
            }
            tagKnown |= bit;
        }
        return (tagValue & bit) != 0;
    }

    public boolean hasTag(String tag) {
        if (event != null) {
            return event.hasTag(tag);
        }
        return syntheticTags != null && syntheticTags.contains(tag);
    }

    @Override
    public String toString() {
        final String name = event != null ? "E" + event.getGlobalId() : "init";
        final String thr = thread >= 0 ? "T" + thread + "." + poIndex : "I";
        return switch (kind) {
            case INIT -> String.format("%s:init[%s]=%s", thr, hex(address), writeValue);
            case READ -> String.format("%s:%s R[%s]", thr, name, hex(address));
            case WRITE -> String.format("%s:%s W[%s]=%s", thr, name, hex(address), writeValue);
            case OTHER -> String.format("%s:%s %s", thr, name, event);
            case THREAD_START -> String.format("%s:start", thr);
            case THREAD_CREATE -> String.format("%s:create(T%d)", thr, otherThread);
            case THREAD_JOIN -> String.format("%s:join(T%d)", thr, otherThread);
            case EXCL_FAIL -> String.format("%s:%s excl-fail", thr, name);
        };
    }

    private static String hex(BigInteger address) {
        return address == null ? "?" : "0x" + address.toString(16);
    }

    // =================================================================================================

    static Builder builder(Kind kind, int thread, int poIndex, Event event) {
        return new Builder(kind, thread, poIndex, event);
    }

    static Node newInit(BigInteger address, Type type, Object value, Event initEvent, Set<String> syntheticTags) {
        final Builder b = new Builder(Kind.INIT, -1, 0, initEvent);
        b.address = address;
        b.accessType = type;
        b.writeValue = value;
        b.syntheticTags = initEvent == null ? syntheticTags : null;
        return b.build();
    }

    static final class Builder {
        private final Kind kind;
        private final int thread;
        private final int poIndex;
        private final Event event;
        BigInteger address;
        Type accessType;
        Object writeValue;
        Set<Node> dataDeps = Set.of();
        Set<Node> addrDeps = Set.of();
        Set<Node> ctrlDeps = Set.of();
        Set<Node> ePreds = Set.of();
        boolean couldSucceed;
        Node pairedLoad;
        boolean isExclusivePair;
        int otherThread = -1;
        Node creator;
        Node joinedLast;
        List<Object> payload = List.of();
        Set<String> syntheticTags;

        private Builder(Kind kind, int thread, int poIndex, Event event) {
            this.kind = kind;
            this.thread = thread;
            this.poIndex = poIndex;
            this.event = event;
        }

        Node build() {
            return new Node(this);
        }

        Kind getKind() {
            return kind;
        }
    }

    static final Set<String> SYNTHETIC_INIT_TAGS = Set.of(Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.INIT);
}
