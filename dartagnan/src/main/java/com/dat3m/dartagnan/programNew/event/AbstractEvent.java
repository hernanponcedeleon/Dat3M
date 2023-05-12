package com.dat3m.dartagnan.programNew.event;

import com.dat3m.dartagnan.programNew.Function;
import com.dat3m.dartagnan.programNew.meta.Metadata;
import com.dat3m.dartagnan.programNew.meta.MetadataMap;

import java.util.HashSet;
import java.util.Set;

public abstract class AbstractEvent implements Event {

    protected Function containingFunction;
    private AbstractEvent predecessor;
    private AbstractEvent successor;
    private MetadataMap metadataMap;
    private Set<EventUser> currentUsers = new HashSet<>();

    protected int globalId;
    protected Set<String> tags;

    protected AbstractEvent() { }

    @Override
    public final Function getContainingFunction() {
        return containingFunction;
    }
    @Override
    public final Event getPredecessor() { return predecessor; }
    @Override
    public final Event getSuccessor() { return successor; }

    @Override
    public int getGlobalId() { return globalId; }
    @Override
    public void setGlobalId(int id) { this.globalId = Math.max(-1, id); }

    @Override
    public Set<String> getTags() { return tags; }
    @Override
    public void addTag(String tag) { tags.add(tag); }
    @Override
    public boolean hasTag(String tag) { return tags.contains(tag); }

    @Override
    public Set<EventUser> getUsers() { return currentUsers; }

    //TODO: Possibly delete this
    private void setPredecessor(Event event) {
        final AbstractEvent ev = (AbstractEvent) event;
        if (predecessor != null) {
            predecessor.successor = null;
        }
        if (ev != null) {
            if (ev.successor != null){
                ev.successor.predecessor = null;
            }
            ev.successor = this;
            ev.containingFunction = this.containingFunction;
        }
        predecessor = ev;
    }

    private void setSuccessor(Event event) {
        final AbstractEvent ev = (AbstractEvent) event;
        if (successor != null) {
            successor.predecessor = null;
        }
        if (ev != null) {
            if (ev.predecessor != null){
                ev.predecessor.successor = null;
            }
            ev.predecessor = this;
            ev.containingFunction = this.containingFunction;
        }
        successor = ev;
    }

    @Override
    public void detach() {
        if (predecessor != null) {
            predecessor.successor = successor;
        }
        if (successor != null) {
            successor.predecessor = predecessor;
        }
        this.containingFunction = null;
        this.predecessor = null;
        this.successor = null;
    }

    public boolean tryDelete() {
        if (!this.currentUsers.isEmpty()) {
            return false;
        }
        if (this instanceof EventUser user) {
            user.getReferencedEvents().forEach(e -> e.removeUser(user));
        }
        detach();
        return true;
    }

    @Override
    public void insertAfter(Event toBeInserted) {
        insertBetween((AbstractEvent) toBeInserted, containingFunction, this, successor);
    }

    @Override
    public void insertBefore(Event toBeInserted) {
        insertBetween((AbstractEvent) toBeInserted, containingFunction, predecessor, this);
    }

    private static void insertBetween(AbstractEvent toBeInserted, Function func, AbstractEvent pred, AbstractEvent succ) {
        toBeInserted.detach();
        toBeInserted.containingFunction = func;
        toBeInserted.predecessor = pred;
        toBeInserted.successor = succ;

        if (pred != null) {
            pred.successor = toBeInserted;
        }
        if (succ != null) {
            succ.predecessor = toBeInserted;
        }
    }

    @Override
    public boolean hasMetadata(Class<? extends Metadata> metadataClass) {
        return metadataMap != null && metadataMap.contains(metadataClass);
    }

    @Override
    public <T extends Metadata> T getMetadata(Class<T> metadataClass) {
        return metadataMap == null ? null : metadataMap.get(metadataClass);
    }

    @Override
    public <T extends Metadata> T setMetadata(T metadata) {
        if (metadataMap == null) {
            metadataMap = new MetadataMap();
        }
        return metadataMap.put(metadata);
    }
}
