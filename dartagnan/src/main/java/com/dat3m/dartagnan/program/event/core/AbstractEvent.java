package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.metadata.CustomPrinting;
import com.dat3m.dartagnan.program.event.metadata.Metadata;
import com.dat3m.dartagnan.program.event.metadata.MetadataMap;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.*;

public abstract class AbstractEvent implements Event {

    protected final MetadataMap metadataMap = new MetadataMap();
    protected final Set<String> tags;
    protected Function function; // The thread this event belongs to
    // This id is dynamically changing during processing.
    protected transient int globalId = -1; // (Global) ID within a program
    private transient AbstractEvent successor;
    private transient AbstractEvent predecessor;
    private final Set<EventUser> currentUsers = new HashSet<>();

    protected AbstractEvent() {
        tags = new HashSet<>();
    }

    protected AbstractEvent(AbstractEvent other) {
        copyAllMetadataFrom(other);
        this.tags = other.tags; // TODO: Dangerous code! A Copy-on-Write Set should be used (e.g. PersistentSet/Map)
        this.function = other.function;
    }

    @Override
    public int getGlobalId() { return globalId; }
    @Override
    public void setGlobalId(int id) { this.globalId = id; }

    @Override
    public Function getFunction() { return function; }

    @Override
    public void setFunction(Function function) {
        this.function = Preconditions.checkNotNull(function);
    }

    @Override
    public Thread getThread() {
        return getFunction() instanceof Thread ? (Thread) getFunction() : null;
    }

    // ============================================ Users ============================================

    @Override
    public Set<EventUser> getUsers() { return this.currentUsers; }

    @Override
    public boolean registerUser(EventUser user) { return this.currentUsers.add(user); }

    @Override
    public boolean removeUser(EventUser user) { return this.currentUsers.remove(user); }

    // ============================================ Metadata ============================================

    @Override
    public boolean hasMetadata(Class<? extends Metadata> metadataClass) { return metadataMap.contains(metadataClass); }
    @Override
    public <T extends Metadata> T getMetadata(Class<T> metadataClass) { return metadataMap.get(metadataClass); }
    @Override
    public <T extends Metadata> T setMetadata(T metadata) { return metadataMap.put(metadata); }

    @Override
    public void copyAllMetadataFrom(Event other) {
        ((AbstractEvent) other).metadataMap.getAllMetadata().forEach(this.metadataMap::put);
    }

    @Override
    public void copyMetadataFrom(Event other, Class<? extends Metadata> metadataClass) {
        other.setMetadata(other.getMetadata(metadataClass));
    }

    @Override
    public boolean hasEqualMetadata(Event other, Class<? extends Metadata> metadataClass) {
        return Objects.equals(getMetadata(metadataClass), other.getMetadata(metadataClass));
    }

    // TODO: Remove this
    @Override
    public Event setCFileInformation(int line, String sourceCodeFilePath) {
        setMetadata(new SourceLocation(sourceCodeFilePath, line));
        return this;
    }

    // ===============================================================================================

    // ============================================ Tags =============================================

    // The set of tags should not be modified directly.
    @Override
    public Set<String> getTags() { return tags; }
    @Override
    public boolean hasTag(String tag) { return tag != null && tags.contains(tag); }
    @Override
    public void addTags(Collection<? extends String> tags) { this.tags.addAll(tags); }
    @Override
    public void addTags(String... tags) { addTags(Arrays.asList(tags)); }
    @Override
    public void removeTags(Collection<? extends String> tags) { this.tags.removeAll(tags); }
    @Override
    public void removeTags(String... tags) { removeTags(Arrays.asList(tags)); }

    // ===============================================================================================

    // ======================================== Control-flow =========================================

    @Override
    public Event getSuccessor() { return successor; }
    @Override
    public void setSuccessor(Event ev) { successor = (AbstractEvent) ev; }

    @Override
    public Event getPredecessor() { return predecessor; }
    @Override
    public void setPredecessor(Event ev) { predecessor = (AbstractEvent) ev; }

    @Override
    public final List<Event> getSuccessors() {
        List<Event> events = new ArrayList<>();
        Event cur = this;
        while (cur != null) {
            events.add(cur);
            cur = cur.getSuccessor();
        }
        return events;
    }

    @Override
    public final List<Event> getPredecessors() {
        List<Event> events = new ArrayList<>();
        Event cur = this;
        while (cur != null) {
            events.add(cur);
            cur = cur.getPredecessor();
        }
        return events;
    }

    /*
        Detaches this event from the control-flow graph.
        This does not properly delete the event, and it may be reinserted elsewhere.
        TODO: We need to special-case handle detaching the entry/exit event of a function.
     */
    @Override
    public void detach() {
        Preconditions.checkState(function == null || (this != function.getEntry() && this != function.getExit()),
                "Cannot detach the entry or exit event %s of function %s", this, getFunction());
        if (this.predecessor != null) {
            this.predecessor.successor = successor;
        }
        if (this.successor != null) {
            this.successor.predecessor = predecessor;
        }
        this.function = null;
        this.predecessor = null;
        this.successor = null;
    }

    @Override
    public void forceDelete() {
        if (this instanceof EventUser user) {
            user.getReferencedEvents().forEach(e -> e.removeUser(user));
        }
        this.detach();

        for (Event user : currentUsers) {
            user.forceDelete();
        }
    }

    @Override
    public boolean tryDelete() {
        if (this.currentUsers.isEmpty()) {
            this.forceDelete();
            return true;
        } else {
            return false;
        }
    }

    @Override
    public void insertAfter(Event toBeInserted) {
        Preconditions.checkNotNull(toBeInserted);
        insertBetween((AbstractEvent) toBeInserted, function, this, successor);
        if (function.getExit() == this) {
            function.updateExit(toBeInserted);
        }
    }

    @Override
    public void insertAfter(List<Event> toBeInserted) {
        Event cur = this;
        for (Event next : toBeInserted) {
            cur.insertAfter(next);
            cur = next;
        }
    }

    @Override
    public void replaceBy(Event replacement) {
        if (replacement == this) {
            return;
        }
        Preconditions.checkState(currentUsers.isEmpty(), "Cannot replace event that is still in use.");
        this.insertAfter(replacement);
        this.forceDelete();
    }

    private static void insertBetween(AbstractEvent toBeInserted, Function func, AbstractEvent pred, AbstractEvent succ) {
        assert (pred == null || pred.successor == succ) && (succ == null || succ.predecessor == pred);
        assert (toBeInserted != pred && toBeInserted != succ);
        toBeInserted.detach();
        toBeInserted.function = func;
        toBeInserted.predecessor = pred;
        toBeInserted.successor = succ;

        if (pred != null) {
            pred.successor = toBeInserted;
        }
        if (succ != null) {
            succ.predecessor = toBeInserted;
        }
    }

    // ===============================================================================================

    protected abstract String defaultString();

    @Override
    public final String toString() {
        final CustomPrinting stringProvider = getMetadata(CustomPrinting.class);
        final Optional<String> customString = Optional.ofNullable(stringProvider).flatMap(o -> o.stringify(this));
        return customString.orElseGet(this::defaultString);
    }

    // ======================================== Miscellaneous ========================================

    @Override
    public int compareTo(Event e) {
        if (e == this) {
            return 0;
        }
        int result = Integer.compare(this.getGlobalId(), e.getGlobalId());
        if (result == 0) {
            final String error = String.format("Events %s and %s are different but have the same global id %d",
                    this, e, e.getGlobalId());
            throw new IllegalStateException(error);
        }
        return result;
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        // WARNING: This should get overwritten by any event that reads Expressions
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitEvent(this);
    }

    @Override
    public void runLocalAnalysis(Program program, Context context) { }

    // This method needs to get overwritten for conditional events.
    @Override
    public boolean cfImpliesExec() { return true; }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().makeTrue();
    }
}