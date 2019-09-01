package com.dat3m.dartagnan.program.utils.slicing;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWStoreExclusiveStatus;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Jump;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;

public class Slice {
	
	Program program;
	
	public Slice(Program program) {
		this.program = program;
	}

    public Set<Event> create() {
		List<Event> processing = new ArrayList<Event>();
		processing.addAll(program.getAss().getRegs().stream().
				map(r -> ((Register)r).getModifiedBy()).flatMap(Collection::stream).
				filter(e -> !processing.contains(e)).
				collect(Collectors.toList()));
		processing.addAll(program.getAss().getAdds().stream().
				map(e -> ((Address)e).getModifiedBy()).flatMap(Collection::stream).
				filter(e -> !processing.contains(e)).
				collect(Collectors.toList()));
		Set<Event> slice = new HashSet<Event>();
		while(!processing.isEmpty()) {
			System.out.println(1);
			Event next = processing.remove(0);
			slice.add(next);
			processing.addAll(condDependsOn(program, next));
			// Every RegWriter has one of the following types and thus every case is covered
			if(next instanceof RegReaderData) {
				RegReaderData reader = (RegReaderData)next;
				Set<Event> newEvents = reader.getDataRegs().stream().
						map(e -> e.getModifiedBy()).flatMap(Collection::stream).
						filter(e -> !slice.contains(e)).
						collect(Collectors.toSet());
				processing.addAll(newEvents);
			}
			if(next instanceof Load) {
				Load load = (Load)next;
				Set<Event> newEvents = load.getMaxAddressSet().stream().
						map(e -> e.getModifiedBy()).flatMap(Collection::stream).
						filter(e -> !slice.contains(e)).
						collect(Collectors.toSet());
				processing.addAll(newEvents);
			}
			if(next instanceof RMWStoreExclusiveStatus) {
				//TODO
			}
		}
		return slice;
    }
    
    private Set<Event> condDependsOn(Program program, Event e) {
		HashSet<Event> set = new HashSet<Event>();
		set.addAll(program.getCache().getEvents(FilterBasic.get(EType.JUMP)).stream().
				filter(cj -> cj.getUId() < e.getUId() && ((Jump)cj).getLabel().getUId() > e.getUId()).
				collect(Collectors.toSet()));
		return set;
    }
}
