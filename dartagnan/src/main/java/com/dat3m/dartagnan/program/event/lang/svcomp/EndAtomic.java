package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;

import static com.dat3m.dartagnan.program.event.Tag.RMW;
import static com.dat3m.dartagnan.program.event.Tag.SVCOMP.SVCOMPATOMIC;

public class EndAtomic extends AbstractEvent implements EventUser {

    private static final Logger logger = LogManager.getLogger(EndAtomic.class);

    protected BeginAtomic begin;
    protected transient List<Event> enclosedEvents;

    public EndAtomic(BeginAtomic begin) {
        this.begin = begin;
        addTags(RMW, SVCOMPATOMIC);
        this.begin.registerUser(this);
    }

    protected EndAtomic(EndAtomic other) {
        super(other);
        this.begin = other.begin;
        this.begin.registerUser(this);
    }

    public BeginAtomic getBegin() {
        return begin;
    }

    public List<Event> getBlock() {
        Preconditions.checkState(getFunction().getProgram().isCompiled(), "The program needs to get compiled first");
        return enclosedEvents;
    }

    @Override
    public void runLocalAnalysis(Program program, Context context) {
        findEnclosedEvents(context.requires(BranchEquivalence.class));
    }

    private void findEnclosedEvents(BranchEquivalence eq) {
        enclosedEvents = new ArrayList<>();
        if (eq.areMutuallyExclusive(begin, this) || this.getLocalId() < begin.getLocalId()) {
            logger.warn("BeginAtomic" + begin.getLocalId() + "can't reach EndAtomic " + this.getLocalId());
        }

        Event e = begin.getSuccessor();
        while (e.getLocalId() < this.getLocalId()) {
            if (!eq.areMutuallyExclusive(begin, e)) {
                if (!eq.isImplied(e, begin)) {
                    logger.warn(e + " is inside atomic block but can be reached from the outside");
                }
                enclosedEvents.add(e);
                e.addTags(RMW);
            }
            e = e.getSuccessor();
        }

        enclosedEvents.sort(Comparator.naturalOrder());
        enclosedEvents = ImmutableList.copyOf(enclosedEvents);
    }

    @Override
    public String defaultString() {
        return "end_atomic()";
    }

    @Override
    public EndAtomic getCopy() {
        return new EndAtomic(this);
    }

    @Override
    public void updateReferences(Map<Event, Event> updateMapping) {
        this.begin = (BeginAtomic) EventUser.moveUserReference(this, this.begin, updateMapping);
    }

    @Override
    public Set<Event> getReferencedEvents() {
        return Set.of(begin);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitEndAtomic(this);
    }
}