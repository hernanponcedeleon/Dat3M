package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;
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
    private final Map<Thread, Map<Integer, Event>> symmMap = new HashMap<>();

    private ThreadSymmetry(Program program, boolean createMappings) {
        this.program = program;
        createClasses();
        if (createMappings) {
            createMappings();
        }
    }

    public static ThreadSymmetry fromConfig(Program program, Configuration config) throws InvalidConfigurationException {
        return new ThreadSymmetry(program, true);
    }

    public static ThreadSymmetry withoutMappings(Program program) {
        return new ThreadSymmetry(program, false);
    }

    // ================= Private methods ===================

    private void createClasses() {

        Map<String, Map<Integer, EqClass>> nameMap = new HashMap<>();
        for (Thread thread : program.getThreads()) {
            nameMap.computeIfAbsent(thread.getName(), key -> new HashMap<>())
                    .computeIfAbsent(thread.getEvents().size(), key -> new EqClass()).addInternal(thread);
        }
    }

    private void createMappings() {
        for (Thread thread : program.getThreads()) {
            Map<Integer, Event> mapping = symmMap.computeIfAbsent(thread, key -> new HashMap<>());
            thread.getEvents().forEach(e -> mapping.put(e.getLocalId(), e));
        }

        Set<? extends EquivalenceClass<Thread>> classes = getAllEquivalenceClasses();
        for (EquivalenceClass<Thread> clazz : classes) {
            int size = symmMap.get(clazz.getRepresentative()).size();
            for (Thread t : clazz) {
                if (symmMap.get(t).size() == size) {
                    Verify.verify(symmMap.get(t).size() == size,
                            "Symmetric threads T%s and T%s have different number of events: %s vs. %s",
                            clazz.getRepresentative(), t, size, symmMap.get(t).size());
                }
            }
        }
    }

    // ================= Public methods ===================

    public Event map(Event source, Thread target) {
    	Preconditions.checkArgument(areEquivalent(source.getThread(), target), 
    			"Target thread is not symmetric with source thread.");
        return symmMap.get(target).get(source.getLocalId());
    }

    public Function<Event, Event> createPermutation(List<Thread> orig, List<Thread> target) {
    	Preconditions.checkArgument(orig.size() == target.size(), "Target permutation has different size");
        if (orig.equals(target)) {
            return Function.identity();
        }

        return e -> {
            int index = orig.indexOf(e.getThread());
            return index < 0 ? e : map(e, target.get(index));
        };
    }

    public Function<Event, Event> createTransposition(Thread t1, Thread t2) {
        if (!areEquivalent(t1, t2)) {
            return Function.identity();
        }

        return e -> {
            Thread t = e.getThread();
            return (t == t1) ? map(e, t2) :
                    (t == t2) ? map(e, t1) : e;
        };
    }

    public List<Function<Event, Event>> createAllPermutations(EquivalenceClass<Thread> eqClass) {
    	Preconditions.checkArgument(eqClass.getEquivalence() == this, 
    			"<eqClass> is not a symmetry class of this symmetry equivalence.");

        List<Thread> symmThreads = new ArrayList<>(eqClass);
        symmThreads.sort(Comparator.comparingInt(Thread::getId));
        return Collections2.permutations(symmThreads).stream()
                .map(perm -> createPermutation(symmThreads, perm))
                .collect(Collectors.toList());
    }
}