package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.equivalence.AbstractEquivalence;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.google.common.base.Preconditions;
import com.google.common.collect.Collections2;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

public class ThreadSymmetry extends AbstractEquivalence<Thread> {

    private final Program program;
    private final Map<Thread, Map<String, Event>> symmMap = new HashMap<>();

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
        Map<String, EqClass> nameMap = new HashMap<>();
        for (Thread thread : program.getThreads()) {
            nameMap.computeIfAbsent(thread.getName(), key -> new EqClass()).addInternal(thread);
        }
    }

    private void createMappings() {
        for (Thread thread : program.getThreads()) {
            Map<String, Event> mapping = symmMap.computeIfAbsent(thread, key -> new HashMap<>());
            thread.getEvents().forEach(e -> mapping.put(e.getSymmId(), e));
        }
    }

    // ================= Public methods ===================

    public Event map(Event source, Thread target) {
    	Preconditions.checkArgument(areEquivalent(source.getThread(), target), 
    			"Target thread is not symmetric with source thread.");
        return symmMap.get(target).get(source.getSymmId());
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