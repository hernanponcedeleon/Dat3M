package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PthreadPool {

	private final List<Expression> threads = new ArrayList<>();
	private final Map<Expression, List<String>> mapPtrName = new HashMap<>();
	private final Map<Expression, List<Integer>> mapPtrCreator = new HashMap<>();
	private final Map<Integer, Expression> mapIntPtr = new HashMap<>();
	// This is needed during the compilation pass to match a Start 
	// with its corresponding Create. Both events access the same address, 
	// i.e. the communication channel (cc), which we only use for modeling 
	// purposes. During the compilation of Start the Create was already 
	// compiled and thus we use an annotation event which remains after the compilation."
	private final Map<Expression, Event> mapCcMatcher = new HashMap<>();
	
	public void add(Expression ptr, String name, int creator) {
		threads.add(ptr);
		mapPtrName.computeIfAbsent(ptr, key -> new ArrayList<>()).add(name);
		mapPtrCreator.computeIfAbsent(ptr, key -> new ArrayList<>()).add(creator);
	}
	
	public String getNameFromPtr(Expression ptr) {
		return mapPtrName.get(ptr).remove(0);
	}

	public Integer getCreatorFromPtr(Expression ptr) {
		return mapPtrCreator.get(ptr).get(0);
	}

	public void addIntPtr(Integer i, Expression ptr) {
		mapIntPtr.put(i, ptr);
	}
	
	public Expression getPtrFromInt(Integer i) {
		return mapIntPtr.get(i);
	}

	public boolean canCreate() {
		return !threads.isEmpty();
	}
	
	public Expression next() {
		return threads.remove(0);
	}

	public void addMatcher(Expression cc, Event e) {
		mapCcMatcher.put(cc, e);
	}

	public Event getMatcher(Expression cc) {
		return mapCcMatcher.get(cc);
	}

}
