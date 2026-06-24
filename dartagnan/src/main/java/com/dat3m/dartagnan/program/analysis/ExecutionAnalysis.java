package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.utils.collections.IndexedDomain;
import com.dat3m.dartagnan.utils.collections.IndexedSet;
import com.dat3m.dartagnan.verification.Context;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public interface ExecutionAnalysis {

    boolean isImplied(Event start, Event implied);
    boolean areMutuallyExclusive(Event a, Event b);

    Set<Event> implyingEvents(Event implied);
    Set<Event> excludingEvents(Event event);

    static ExecutionAnalysis fromConfig(Program program, ProgressModel.Hierarchy progressModel, Context context, Configuration config)
            throws InvalidConfigurationException {
        final EventDomainRepository eventDomainRepository = context.requires(EventDomainRepository.class);
        final BranchEquivalence eq = context.requires(BranchEquivalence.class);
        return new DefaultExecutionAnalysis(program, eventDomainRepository, eq, progressModel);
    }
}

/*
    NOTE: The BranchEquivalence computes cf-equivalence/implication assuming a strong progress model.
    However, we can "weaken" the BranchEquivalence results after the fact based on the assumed progress model.
 */
class DefaultExecutionAnalysis implements ExecutionAnalysis {

    private final Program program;
    private final BranchEquivalence eq;
    private final ProgressModel.Hierarchy progressModel;
    private final Thread lowestIdThread; // For HSA
    private final Map<Event, Set<Event>> eventsByImpliedEvent = new HashMap<>();
    private final Map<Event, Set<Event>> eventsByExcludingEvent = new HashMap<>();

    DefaultExecutionAnalysis(Program program, EventDomainRepository domainRepository, BranchEquivalence eq,
            ProgressModel.Hierarchy progressModel) {
        this.program = program;
        this.eq = eq;
        this.progressModel = progressModel;

        this.lowestIdThread = program.getThreads().stream().min(Comparator.comparingInt(Thread::getId)).get();

        computeResults(domainRepository.getDomain(EventDomainRepository.DomainBound.ALL));
    }

    @Override
    public boolean isImplied(Event start, Event implied) {
        return eventsByImpliedEvent.get(implied).contains(start);
    }

    @Override
    public boolean areMutuallyExclusive(Event a, Event b) {
        // The concept of mutual exclusion is identical under all progress models.
        return eventsByExcludingEvent.get(a).contains(b);
    }

    @Override
    public Set<Event> implyingEvents(Event implied) {
        return eventsByImpliedEvent.get(implied);
    }

    @Override
    public Set<Event> excludingEvents(Event excluded) {
        return eventsByExcludingEvent.get(excluded);
    }

    private void computeResults(IndexedDomain<Event> eventDomain) {
        computeImplyingEvents(eventDomain);
        computeMutuallyExclusiveEvents(eventDomain);
    }

    private void computeImplyingEvents(IndexedDomain<Event> eventDomain) {
        // (=> & int)
        for (Thread thread : program.getThreads()) {
            final IndexedSet<Event> events = eventDomain.newSet(thread.getEvents());
            for (Event e1 : events) {
                final IndexedSet<Event> implying = new IndexedSet<>(events);
                implying.removeIf(e2 -> !implied(e2, e1));
                eventsByImpliedEvent.put(e1, implying);
            }
        }
        // (=> & ext) = (=> & int) ; (((=> & ext); [ThreadCreate|ThreadStart]) \ id); (=> & int)
        for (Thread t1 : program.getThreads()) {
            final List<Event> e1List = t1.getEvents();
            for (Thread t2 : program.getThreads()) {
                if (t1 == t2) {
                    continue;
                }
                final ThreadStart s = t2.getEntry();
                final List<Event> e2List = s.isSpawned() ? List.of(s, s.getCreator()) : List.of(s);
                for (Event e1 : e1List) {
                    for (Event e2 : e2List) {
                        if (implied(e1, e2)) {
                            eventsByImpliedEvent.get(e2).addAll(eventsByImpliedEvent.get(e1));
                        }
                    }
                }
            }
        }
        for (Map.Entry<Event, Set<Event>> entry : eventsByImpliedEvent.entrySet()) {
            entry.setValue(((IndexedSet<Event>) entry.getValue()).toUnmodifiableCopy());
        }
    }

    private void computeMutuallyExclusiveEvents(IndexedDomain<Event> eventDomain) {
        // -x- = (=>; (-x- & int); <=)
        final Map<Event, Set<Event>> eventsByRepresentative = new HashMap<>();
        for (BranchEquivalence.Class class1 : eq.getAllEquivalenceClasses()) {
            eventsByRepresentative.put(class1.getRepresentative(), eventDomain.newSet(class1));
        }
        for (BranchEquivalence.Class class1 : eq.getAllEquivalenceClasses()) {
            final var excludingEvents = eventDomain.newSet();
            for (BranchEquivalence.Class class2 : class1.getExclusiveClasses()) {
                excludingEvents.addAll(eventsByRepresentative.get(class2.getRepresentative()));
            }
            for (Event e1 : class1) {
                eventsByExcludingEvent.put(e1, excludingEvents.toUnmodifiableCopy());
            }
        }
    }

    private boolean implied(Event start, Event implied) {
        if (start == implied) {
            return true;
        }
        final boolean weakestImplication = (implied.cfImpliesExec() && eq.isImplied(start, implied));
        if (!weakestImplication) {
            // If weakest implication does not hold, the events are unrelated under all progress models.
            return false;
        }
        final boolean sameThread = start.getThread() == implied.getThread();
        final boolean strongestImplication = /* weakestImplication && */
                sameThread && start.getGlobalId() > implied.getGlobalId();
        if (strongestImplication) {
            // If strongest implication does hold, then all progress models will give this implication
            return true;
        }

        if (!progressModel.isUniform()) {
            // For mixed-hierarchy models, we only rely on strongest implication.
            return strongestImplication; // FALSE
        }

        // weakest implication holds but not strongest & model is uniform: progress model decides
        final boolean implication = switch (progressModel.getDefaultProgress()) {
            case FAIR -> weakestImplication; // TRUE
            case HSA -> implied.getThread() == lowestIdThread;
            case OBE -> sameThread;
            case HSA_OBE -> sameThread || implied.getThread() == lowestIdThread;
            case LOBE -> start.getThread().getId() >= implied.getThread().getId()
                    && !IRHelper.isInitThread(start.getThread());
            case UNFAIR -> strongestImplication; // FALSE
        };
        return implication;
    }
}
