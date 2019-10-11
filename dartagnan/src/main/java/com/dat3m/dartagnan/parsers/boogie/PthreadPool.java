package com.dat3m.dartagnan.parsers.boogie;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PthreadPool {

	private List<String> threads = new ArrayList<>();
	private Map<String, String> mapPtrName = new HashMap<>();
	private Map<Integer, String> mapIntPtr = new HashMap<>();
	private Map<String, String> mapRegPtr = new HashMap<>();
	
	public void add(String ptr, String name) {
		threads.add(ptr);
		mapPtrName.put(ptr, name);
	}
	
	public String getNameFromPtr(String ptr) {
		return mapPtrName.get(ptr);
	}

	public void addIntPtr(Integer i, String ptr) {
		mapIntPtr.put(i, ptr);
	}
	
	public String getPtrFromInt(Integer i) {
		return mapIntPtr.get(i);
	}

	public void addRegPtr(String reg, String ptr) {
		mapRegPtr.put(reg, ptr);
	}
	
	public String getPtrFromReg(String reg) {
		return mapRegPtr.get(reg);
	}
	
	public boolean canCreate() {
		return !threads.isEmpty();
	}
	
	public String next() {
		return threads.remove(0);
	}
}
