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

import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;

public interface ExecutionAnalysis {

    boolean isImplied(Event start, Event implied);
    boolean areMutuallyExclusive(Event a, Event b);

    IndexedDomain<Event> eventDomain();
    Set<Event> implyingEvents(Event implied);
    Set<Event> excludingEvents(Event event);

    static ExecutionAnalysis fromConfig(Program program, ProgressModel.Hierarchy progressModel, Context context, Configuration config)
            throws InvalidConfigurationException {
        final BranchEquivalence eq = context.requires(BranchEquivalence.class);
        final var exec = new DefaultExecutionAnalysis(program, eq, progressModel);
        exec.run();
        return exec;
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
    private final IndexedDomain<Event> eventDomain;
    private final Map<Event, Set<Event>> eventsByImpliedEvent = new HashMap<>();
    private final Map<Event, Set<Event>> eventsByExcludingEvent = new HashMap<>();

    DefaultExecutionAnalysis(Program program, BranchEquivalence eq, ProgressModel.Hierarchy progressModel) {
        this.program = program;
        this.eq = eq;
        this.progressModel = progressModel;

        this.lowestIdThread = program.getThreads().stream().min(Comparator.comparingInt(Thread::getId)).get();
        final List<Event> allEventList = program.getThreadEvents();
        // Sort all visible events to the front.  This allows more compact representations in e.g. RelationAnalysis.
        allEventList.sort((a, b) -> a.hasTag(VISIBLE) ? b.hasTag(VISIBLE) ? 0 : -1 : b.hasTag(VISIBLE) ? 1 : 0);
        this.eventDomain = new IndexedDomain<>(allEventList);
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
    public IndexedDomain<Event> eventDomain() {
        return eventDomain;
    }

    @Override
    public Set<Event> implyingEvents(Event implied) {
        return eventsByImpliedEvent.get(implied);
    }

    @Override
    public Set<Event> excludingEvents(Event excluded) {
        return eventsByExcludingEvent.get(excluded);
    }

    void run() {
        computeImplyingEvents();
        computeMutuallyExclusiveEvents();
    }

    private void computeImplyingEvents() {
        final Map<Thread, IndexedSet<Event>> threadEvents = new HashMap<>();
        for (Thread thread : program.getThreads()) {
            final var events = eventDomain.newSet();
            events.addAll(thread.getEvents());
            threadEvents.put(thread, events);
        }
        // (=> & int)
        for (Thread thread : program.getThreads()) {
            final IndexedSet<Event> events = threadEvents.get(thread);
            for (Event e1 : events) {
                final IndexedSet<Event> implying = new IndexedSet<>(events);
                implying.removeIf(e2 -> !implied(e2, e1));
                eventsByImpliedEvent.put(e1, implying);
            }
        }
        // (=> & ext) = (=> & int) ; (((=> & ext); [ThreadCreate|ThreadStart]) \ id); (=> & int)
        for (Thread thread : program.getThreads()) {
            for (Thread t2 : program.getThreads()) {
                final ThreadStart s = t2.getEntry();
                for (Event e2 : thread == t2 ? List.<Event>of() : s.isSpawned() ? List.of(s, s.getCreator()) : List.of(s)) {
                    for (Event e1 : threadEvents.get(thread)) {
                        if (implied(e1, e2)) {
                            eventsByImpliedEvent.get(e2).addAll(eventsByImpliedEvent.get(e1));
                        }
                    }
                }
            }
        }
    }

    private void computeMutuallyExclusiveEvents() {
        // -x- = (=>; (-x- & int); <=)
        final Map<BranchEquivalence.Class, Set<Event>> eventsByBranch = new HashMap<>();
        for (BranchEquivalence.Class c1 : eq.getAllEquivalenceClasses()) {
            eventsByBranch.put(c1, eventDomain.newSet(c1));
        }
        for (BranchEquivalence.Class c1 : eq.getAllEquivalenceClasses()) {
            final var excludingEvents = eventDomain.newSet();
            for (BranchEquivalence.Class c2 : c1.getExclusiveClasses()) {
                excludingEvents.addAll(eventsByBranch.get(c2));
            }
            for (Event e1 : c1) {
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
