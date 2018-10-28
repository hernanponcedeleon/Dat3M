package dartagnan.utils;

import dartagnan.program.Location;
import dartagnan.program.Register;

import java.text.NumberFormat;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class MapSSA {

	private ConcurrentHashMap<Register, Integer> regMap;
	private ConcurrentHashMap<Location, Integer> locMap;

	public MapSSA() {
		this.regMap = new ConcurrentHashMap<>();
		this.locMap = new ConcurrentHashMap<>();
	}
	
	public Set<Object> keySet() {
		Set<Object> ret = new HashSet<>();
		ret.addAll(regMap.keySet());
		ret.addAll(locMap.keySet());
		return ret;
	}
	
	public int getFresh(Location loc){
		if(!locMap.containsKey(loc)) {
			locMap.put(loc, 0);
		}
		else {
			locMap.put(loc, locMap.get(loc) + 1);
		}
		return locMap.get(loc);
	}
	
	public int getFresh(Register reg){
		if(!regMap.containsKey(reg)) {
			regMap.put(reg, 0);
		}
		else {
			regMap.put(reg, regMap.get(reg) + 1);
		}
		return regMap.get(reg);
	}

	public int get(Object o) {
		if(o instanceof Register) {
			if(!regMap.containsKey(o)) {
				regMap.put((Register) o, 0);
			}
			return regMap.get(o);
		}
		if(o instanceof Location) {
			if(!locMap.containsKey(o)) {
				locMap.put((Location) o, 0);
			}
			return locMap.get(o);
		}
		throw new RuntimeException("Invalid object supplied to MapSSA: " + o);
	}

	public void put(Object o, int i) {
		if(o instanceof Register) {
			regMap.put((Register) o, i);
			return;
		}
		if(o instanceof Location) {
			locMap.put((Location) o, i);
			return;
		}
		throw new RuntimeException("Invalid object supplied to MapSSA: " + o);
	}
	
	
	public MapSSA clone() {
		MapSSA map = new MapSSA();
		map.locMap = new ConcurrentHashMap<>();
		map.regMap = new ConcurrentHashMap<>();
		
		for(Register reg : regMap.keySet()) {
			map.put(reg, this.get(reg));
		}
		
		for(Location loc: locMap.keySet()) {
			map.put(loc, this.get(loc));
		}
		
		return map;
	}
	
	public String toString() {
		return "[" + regMap.reduce(1, (k, v) -> k + " = "
                + NumberFormat.getInstance().format(v), (r1, r2) -> r1 + ", " + r2) + ", "
                + locMap.reduce(1, (k, v) -> k + " = "
                + NumberFormat.getInstance().format(v), (r1, r2) -> r1 + ", " + r2) + "]";
	}
}
