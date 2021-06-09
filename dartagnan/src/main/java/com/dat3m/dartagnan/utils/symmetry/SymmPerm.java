package com.dat3m.dartagnan.utils.symmetry;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.Sets;

public class SymmPerm {

	private Program program;
	private Set<Event> supportSet;
	private Map<Thread, Set<Event>> split = new HashMap<>();
	private Map<Thread, Set<Set<Event>>> permutations = new HashMap<>();
	
	public SymmPerm(Program program, Set<Event> events) {
		this.program = program;
		this.supportSet = events;
		initialize();
	}
	
	private void initialize() {
		for(Thread t : supportSet.stream().map(e -> e.getThread()).collect(Collectors.toSet())) {
			split.put(t, supportSet.stream().filter(e -> e.getThread().equals(t)).collect(Collectors.toSet()));
			permutations.put(t, new HashSet<>());
			for(Thread other : program.getThreads().stream().filter(other -> other.getName().equals(t.getName())).collect(Collectors.toSet())) {
				Set<Event> newPerm = new HashSet<>();
				for(Event e : split.get(t)) {
					newPerm.add(getBySymmId(other, e.getSymmId()));
				}
				permutations.get(t).add(newPerm);
			}
		}
	}
	
	private Event getBySymmId(Thread t, String id) {
		return t.getEvents().stream().filter(e -> e.getSymmId().equals(id)).findAny().get();
	}
	
	public Set<List<Object>> getPermutations() {
		return Sets.cartesianProduct(permutations.values().stream().collect(Collectors.toSet()));
	}
	
}
