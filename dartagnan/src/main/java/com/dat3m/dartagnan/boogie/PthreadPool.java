package com.dat3m.dartagnan.boogie;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dat3m.dartagnan.program.Register;

public class PthreadPool {

	private final List<Register> threads = new ArrayList<>();
	private final Map<Register, List<String>> mapPtrName = new HashMap<>();
	private final Map<Integer, Register> mapIntPtr = new HashMap<>();
	private final Map<Register, Register> mapRegPtr = new HashMap<>();
	
	public void add(Register ptr, String name) {
		threads.add(ptr);
		if(!mapPtrName.containsKey(ptr)) {
			mapPtrName.put(ptr, new ArrayList<>());
		}
		mapPtrName.get(ptr).add(name);
	}
	
	public String getNameFromPtr(Register ptr) {
		return mapPtrName.get(ptr).remove(0);
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
}
