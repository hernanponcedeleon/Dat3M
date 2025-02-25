package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.metadata.Metadata;
import com.dat3m.dartagnan.verification.Context;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Collection;
import java.util.List;
import java.util.Set;

public interface Event extends Encoder, Comparable<Event> {
    int PRINT_PAD_EXTRA = 50;

    int getGlobalId();
    void setGlobalId(int id);

    int getLocalId();
    void setLocalId(int id);

    // ============================== Metadata ==============================

    void copyAllMetadataFrom(Event other);
    void copyMetadataFrom(Event other, Class<? extends Metadata> metadataClass);
    boolean hasMetadata(Class<? extends Metadata> metadataClass);
    <T extends Metadata> T getMetadata(Class<T> metadataClass);
    <T extends Metadata> T setMetadata(T metadata);
    boolean hasEqualMetadata(Event other, Class<? extends Metadata> metadataClass);

    // ============================== Tags ==============================

    // The set of tags should not be modified directly.
    Set<String> getTags();
    boolean hasTag(String tag);
    void addTags(Collection<? extends String> tags);
    void addTags(String... tags);
    void removeTags(Collection<? extends String> tags);
    void removeTags(String... tags);

    // ============================== Control-flow ==============================

    Function getFunction();
    void setFunction(Function function);

    Thread getThread();

    Event getSuccessor();
    Event getPredecessor();

    /*
        NOTE: These methods return a list including(!) this event.
     */
    List<Event> getSuccessors();
    List<Event> getPredecessors();

    /*
        WARNING: Directly modifying successors/predecessors can lead to inconsistent state.
        Use <insertAfter> and <replaceBy> if possible.
     */
    void setSuccessor(Event event);
    void setPredecessor(Event event);

    /*
        Detaches an event from the control-flow graph, allowing it to be reinserted elsewhere.
        Use <tryDelete> if the event will not get reinserted.
     */
    void detach();
    void forceDelete(); // DANGEROUS: Deletes the event, including all events that reference it.
    boolean tryDelete(); // Deletes the event only if no other event references it.

    void insertAfter(Event toBeInserted);
    void insertBefore(Event toBeInserted);
    void replaceBy(Event replacement);
    void insertAfter(Iterable<? extends Event> toBeInserted);
    void insertBefore(Iterable<? extends Event> toBeInserted);
    void replaceBy(Iterable<? extends Event> replacement);

    // ============================== Misc ==============================

    Set<EventUser> getUsers();
    boolean registerUser(EventUser user);
    boolean removeUser(EventUser user);
    void replaceAllUsages(Event replacement);

    @Override
    int compareTo(Event e);

    Event getCopy();

    <T> T accept(EventVisitor<T> visitor);

    void runLocalAnalysis(Program program, Context context);

    // This method needs to get overwritten for conditional events.
    boolean cfImpliesExec();

    BooleanFormula encodeExec(EncodingContext ctx);
}
