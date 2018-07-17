package dartagnan.utils;

import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import dartagnan.program.event.Event;

public class LastModMap {
	
	private ConcurrentHashMap<Object, Set<Event>> map;
	
	public LastModMap() {
		this.map = new ConcurrentHashMap<Object, Set<Event>>();
	}
	
	public int size() {
		return this.map.size();
	}
	
	public void put(Object o, Set<Event> set) {
		this.map.put(o, set);
	}
	
	public Set<Event> get(Object o) {
		if(keySet().contains(o)) {
			return map.get(o);
		}
		else {
			System.out.println(String.format("Check get() for %s and %s", this, o));
			return new HashSet<Event>();
		}
	}
	
	public LastModMap clone() {
		LastModMap retMap = new LastModMap();
		for(Object o : map.keySet()) {
			retMap.put(o, map.get(o));
		}
		return retMap;
	}

	public Set<Object> keySet() {
		return map.keySet();
	}
	
	public String toString() {
		return (String) "[" + map.reduce(1, (k, v) -> k + " = " + v, (r1, r2) -> r1 + ", " + r2) + "]";
	}
}