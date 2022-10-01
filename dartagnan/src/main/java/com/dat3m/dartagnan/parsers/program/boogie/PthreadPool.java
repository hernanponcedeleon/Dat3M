package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PthreadPool {

	private final List<Register> threads = new ArrayList<>();
	private final Map<Register, List<String>> mapPtrName = new HashMap<>();
	private final Map<Register, List<Integer>> mapPtrCreator = new HashMap<>();
	private final Map<Integer, Register> mapIntPtr = new HashMap<>();
	private final Map<Register, Register> mapRegPtr = new HashMap<>();
	// This is needed during the compilation pass to match a Start 
	// with its corresponding Create. Both events access the same address, 
	// i.e. the communication channel (cc), which we only use for modeling 
	// purposes. During the compilation of Start the Create was already 
	// compiled and thus we use an annotation event which remains after the compilation."
	private final Map<String, Event> mapCcMatcher = new HashMap<>();
	
	public void add(Register ptr, String name, int creator) {
		threads.add(ptr);
		mapPtrName.computeIfAbsent(ptr, key -> new ArrayList<>()).add(name);
		mapPtrCreator.computeIfAbsent(ptr, key -> new ArrayList<>()).add(creator);
	}
	
	public String getNameFromPtr(Register ptr) {
		return mapPtrName.get(ptr).remove(0);
	}

	public Integer getCreatorFromPtr(Register ptr) {
		return mapPtrCreator.get(ptr).get(0);
	}

	public void addIntPtr(Integer i, Register ptr) {
		mapIntPtr.put(i, ptr);
	}
	
	public Register getPtrFromInt(Integer i) {
		return mapIntPtr.get(i);
	}

	public void addRegPtr(Register reg, Register ptr) {
		mapRegPtr.put(reg, ptr);
	}
	
	public Register getPtrFromReg(Register reg) {
		return mapRegPtr.get(reg);
	}
	
	public boolean canCreate() {
		return !threads.isEmpty();
	}
	
	public Register next() {
		return threads.remove(0);
	}

	public void addMatcher(String cc, Event e) {
		mapCcMatcher.put(cc, e);
	}

	public Event getMatcher(String cc) {
		return mapCcMatcher.get(cc);
	}

}
