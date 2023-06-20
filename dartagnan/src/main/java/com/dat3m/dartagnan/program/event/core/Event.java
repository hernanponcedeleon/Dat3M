package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.metadata.Metadata;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.verification.Context;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

public interface Event extends Encoder, Comparable<Event> {
    int PRINT_PAD_EXTRA = 50;

    int getGlobalId();
    void setGlobalId(int id);

    void copyAllMetadataFrom(Event other);
    void copyMetadataFrom(Event other, Class<? extends Metadata> metadataClass);
    boolean hasMetadata(Class<? extends Metadata> metadataClass);
    <T extends Metadata> T getMetadata(Class<T> metadataClass);
    <T extends Metadata> T setMetadata(T metadata);
    boolean hasEqualMetadata(Event other, Class<? extends Metadata> metadataClass);

    // TODO: Remove this
    Event setCFileInformation(int line, String sourceCodeFilePath);

    // The set of tags should not be modified directly.
    Set<String> getTags();
    boolean hasTag(String tag);
    void addTags(Collection<? extends String> tags);
    void addTags(String... tags);
    void removeTags(Collection<? extends String> tags);
    void removeTags(String... tags);

    Event getSuccessor();
    Event getPredecessor();

    List<Event> getSuccessors();
    List<Event> getPredecessors();

    void setSuccessor(Event event);
    void setPredecessor(Event event);

    Thread getThread();
    void setThread(Thread thread);

    void delete();
    void insertAfter(Event toBeInserted);
    void insertAfter(List<Event> toBeInserted);
    void replaceBy(Event replacement);

    Set<EventUser> getUsers();
    boolean registerUser(EventUser user);
    boolean removeUser(EventUser user);

    @Override
    int compareTo(Event e);

    Event getCopy();

    void updateReferences(Map<Event, Event> updateMapping);

    <T> T accept(EventVisitor<T> visitor);

    void runLocalAnalysis(Program program, Context context);

    // This method needs to get overwritten for conditional events.
    boolean cfImpliesExec();

    BooleanFormula encodeExec(EncodingContext ctx);
}
