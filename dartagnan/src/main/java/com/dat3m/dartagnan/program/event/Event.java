package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.metadata.Metadata;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.metadata.MetadataCarrier;
import com.dat3m.dartagnan.verification.Context;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface Event extends Comparable<Event>, MetadataCarrier<Event> {
    int PRINT_PAD_EXTRA = 50;

    int getGlobalId();
    void setGlobalId(int id);

    int getLocalId();
    void setLocalId(int id);

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

    // ======================================== Metadata ========================================

    // Used as a snapshot of the global ID after the program has been constructed (either programmatically or via a parser).
    record OriginalId(int value) implements Metadata { }

    // Used as a snapshot of the global ID right before unrolling.
    record UnrollingId(int value) implements Metadata { }

    // Used as a snapshot of the global ID right before compilation.
    record CompilationId(int value) implements Metadata { }

    // Can be attached to events to modify how they are printed.
    // This is commonly used to print IR events in the syntax of the source language.
    @FunctionalInterface
    interface CustomPrinting extends Metadata {
        // The parameter is the event this metadata is attached to.
        // Can return an empty optional to fall back to the default string representation.
        Optional<String> stringify(Event e);
    }

    // Can be attached to loop-related events to remember the unrolling bound.
    record UnrollingBound(int value) implements Metadata { }
}
