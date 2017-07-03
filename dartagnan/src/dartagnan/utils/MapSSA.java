package dartagnan.utils;

import java.text.NumberFormat;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import dartagnan.program.Location;
import dartagnan.program.Register;

public class MapSSA {

	private ConcurrentHashMap<Register, Integer> regMap;
	private ConcurrentHashMap<Location, Integer> locMap;

	public MapSSA() {
		this.regMap = new ConcurrentHashMap<Register, Integer>();
		this.locMap = new ConcurrentHashMap<Location, Integer>();
	}
	
	public Set<Object> keySet() {
		Set<Object> ret = new HashSet<Object>();
		ret.addAll(regMap.keySet());
		ret.addAll(locMap.keySet());
		return ret;
	}
	
	public Integer getFresh(Location loc){
		if(!locMap.containsKey(loc)) {
			locMap.put(loc, 0);
		}
		else {
			locMap.put(loc, locMap.get(loc) + 1);
		}
		return locMap.get(loc);
	}
	
	public Integer getFresh(Register reg){
		if(!regMap.containsKey(reg)) {
			regMap.put(reg, 0);
		}
		else {
			regMap.put(reg, regMap.get(reg) + 1);
		}
		return regMap.get(reg);
	}
	
	public Integer get(Object o) {
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
		System.out.println(String.format("Check get for %s and %s", this, o));
		return null;
	}
	
	public void put(Object o, Integer i) {
		if(o instanceof Register) {
			regMap.put((Register) o, i);
			return;
		}
		if(o instanceof Location) {
			locMap.put((Location) o, i);
			return;
		}
		System.out.println(String.format("Check get for %s and %s", this, o));
		return;
	}
	
	
	public MapSSA clone() {
		MapSSA map = new MapSSA();
		map.locMap = new ConcurrentHashMap<Location, Integer>();
		map.regMap = new ConcurrentHashMap<Register, Integer>();
		
		for(Register reg : regMap.keySet()) {
			map.put(reg, this.get(reg));
		}
		
		for(Location loc: locMap.keySet()) {
			map.put(loc, this.get(loc));
		}
		
		return map;
	}
	
	public String toString() {
		return (String) "[" + regMap.reduce(1, (k, v) -> k + " = " + NumberFormat.getInstance().format(v), (r1, r2) -> r1 + ", " + r2) + ", " + locMap.reduce(1, (k, v) -> k + " = " + NumberFormat.getInstance().format(v), (r1, r2) -> r1 + ", " + r2) + "]";
	}
}
