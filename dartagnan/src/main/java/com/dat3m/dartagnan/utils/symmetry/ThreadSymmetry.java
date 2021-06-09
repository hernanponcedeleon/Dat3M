package com.dat3m.dartagnan.utils.symmetry;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.equivalence.AbstractEquivalence;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.google.common.collect.Collections2;

import java.util.*;
import java.util.function.Function;

public class ThreadSymmetry extends AbstractEquivalence<Thread> {

    private final Program program;
    private final Map<Thread, Map<String, Event>> symmMap = new HashMap<>();

    public ThreadSymmetry(Program program) {
        this.program = program;
        createClasses();
        createMappings();
    }

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

    public Event map(Event source, Thread target) {
        if (!areEquivalent(source.getThread(), target)) {
            throw new IllegalArgumentException("Target thread is not symmetric");
        }

        return symmMap.get(target).get(source.getSymmId());
    }

    public Function<Event, Event> createPermutation(List<Thread> orig, List<Thread> target) {
        if (orig.size() != target.size()) {
            throw new IllegalArgumentException("Target permutation has different size");
        }

        return e -> {
            int index = orig.indexOf(e.getThread());
            return index < 0 ? e : map(e, target.get(index));
        };
    }

    public List<Function<Event, Event>> createAllPermutations(EquivalenceClass<Thread> eqClass) {
        if (eqClass.getEquivalence() != this) {
            throw new IllegalArgumentException("<eqClass> is not a symmetry class of this symmetry equivalence.");
        }
        List<Thread> symmThreads = new ArrayList<>(eqClass);
        symmThreads.sort(Comparator.comparingInt(Thread::getId));

        List<Function<Event, Event>> permutations = new ArrayList<>();
        for (List<Thread> perm : Collections2.permutations(symmThreads)) {
            permutations.add(createPermutation(symmThreads, perm));
        }
        return permutations;
    }


}
