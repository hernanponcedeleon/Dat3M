package com.dat3m.dartagnan.prototype.program.event;

import com.dat3m.dartagnan.prototype.program.Function;
import com.dat3m.dartagnan.prototype.program.meta.Metadata;

import java.util.Set;


/*
    Events roughly model instructions/statements of the program, i.e.,
    parts of the program that can naturally be associated with a program counter, program location,
    or more generally with a point in the control-flow graph.

    REQUIREMENTS: All implementations of Event must inherit from AbstractEvent.
 */
public interface Event {

    Function getContainingFunction();
    Event getPredecessor();
    Event getSuccessor();

    int getGlobalId();
    void setGlobalId(int id);

    Set<String> getTags();
    void addTag(String tag);
    boolean hasTag(String tag);

    void insertAfter(Event toBeInserted);
    void insertBefore(Event toBeInserted);

    // Detaches this event from its containing function.
    // Reconnects the (syntactic) predecessor to the successor (pred -> this -> succ ===> pred -> succ)
    void detach();

    Event getCopy(/* CopyContext */);

    boolean hasMetadata(Class<? extends Metadata> metadataClass);
    <T extends Metadata> T getMetadata(Class<T> metadataClass);
    <T extends Metadata> T setMetadata(T metadata);

    Set<EventUser> getUsers();
    boolean registerUser(EventUser user);
    boolean removeUser(EventUser user);

}
