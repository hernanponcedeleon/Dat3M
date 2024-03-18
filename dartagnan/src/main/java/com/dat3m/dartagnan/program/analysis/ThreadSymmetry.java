package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.equivalence.AbstractEquivalence;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;
import com.google.common.collect.Collections2;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

public class ThreadSymmetry extends AbstractEquivalence<Thread> {

    private final Program program;
    private final Map<Thread, Map<Integer, Event>> thread2id2EventMap = new HashMap<>();
    private final Map<Event, Integer> event2IdMap = new HashMap<>();

    private ThreadSymmetry(Program program, boolean createSymmetryMappings) {
        this.program = program;
        createEquivalenceClasses();
        if (createSymmetryMappings) {
            createSymmetryMappings();
        }
    }

    public static ThreadSymmetry fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        return new ThreadSymmetry(program, true);
    }

    public static ThreadSymmetry withoutSymmetryMappings(Program program) {
        return new ThreadSymmetry(program, false);
    }

    // ================= Private methods ===================

    private void createEquivalenceClasses() {
        // We put two threads into the same class only if their names and sizes match.
        final Map<String, Map<Integer, EqClass>> nameSizeMap = new HashMap<>();
        for (Thread thread : program.getThreads()) {
            nameSizeMap.computeIfAbsent(thread.getName(), key -> new HashMap<>())
                    .computeIfAbsent(thread.getEvents().size(), key -> new EqClass()).addInternal(thread);
        }
    }

    private void createSymmetryMappings() {
        for (Thread thread : program.getThreads()) {
            final List<Event> threadEvents = thread.getEvents();
            final Map<Integer, Event> id2EventMap = thread2id2EventMap.computeIfAbsent(thread, key -> new HashMap<>());
            for (int i = 0; i < threadEvents.size(); i++) {
                id2EventMap.put(i, threadEvents.get(i));
                event2IdMap.put(threadEvents.get(i), i);
            }
        }

        // Verify that all symmetric classes are indeed of the same size.
        Set<? extends EquivalenceClass<Thread>> classes = getAllEquivalenceClasses();
        for (EquivalenceClass<Thread> clazz : classes) {
            int size = thread2id2EventMap.get(clazz.getRepresentative()).size();
            for (Thread t : clazz) {
                Verify.verify(thread2id2EventMap.get(t).size() == size,
                        "Symmetric threads T%s and T%s have different number of events: %s vs. %s",
                        clazz.getRepresentative(), t, size, thread2id2EventMap.get(t).size());
            }
        }
    }

    // ================= Public methods ===================

    public Event map(Event source, Thread targetThread) {
        Preconditions.checkArgument(areEquivalent(source.getThread(), targetThread),
                "Target thread is not symmetric with source thread.");
        return thread2id2EventMap.get(targetThread).get(event2IdMap.get(source));
    }

    public Function<Event, Event> createEventPermutation(List<Thread> origPerm, List<Thread> targetPerm) {
        Preconditions.checkArgument(origPerm.size() == targetPerm.size(),
                "Target permutation has different size to original permutation.");
        if (origPerm.equals(targetPerm)) {
            return Function.identity();
        }

        return e -> {
            int index = origPerm.indexOf(e.getThread());
            return index < 0 ? e : map(e, targetPerm.get(index));
        };
    }

    public Function<Event, Event> createEventTransposition(Thread t1, Thread t2) {
        if (!areEquivalent(t1, t2)) {
            return Function.identity();
        }

        return e -> {
            Thread t = e.getThread();
            return (t == t1) ? map(e, t2) :
                    (t == t2) ? map(e, t1) : e;
        };
    }

    public List<Function<Event, Event>> createAllEventPermutations(EquivalenceClass<Thread> eqClass) {
        Preconditions.checkArgument(eqClass.getEquivalence() == this,
                "<eqClass> is not a symmetry class of this symmetry equivalence.");

        final List<Thread> symmThreads = new ArrayList<>(eqClass);
        symmThreads.sort(Comparator.comparingInt(Thread::getId));
        return Collections2.permutations(symmThreads).stream()
                .map(perm -> createEventPermutation(symmThreads, perm))
                .collect(Collectors.toList());
    }
}