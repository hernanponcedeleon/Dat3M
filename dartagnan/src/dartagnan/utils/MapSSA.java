package dartagnan.utils;

import dartagnan.program.Register;

import java.text.NumberFormat;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class MapSSA {

	private ConcurrentHashMap<Register, Integer> regMap;

	public MapSSA() {
		this.regMap = new ConcurrentHashMap<>();
	}
	
	public Set<Register> keySet() {
		return new HashSet<>(regMap.keySet());
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

	public int get(Register reg) {
		if(!regMap.containsKey(reg)) {
			regMap.put(reg, 0);
		}
		return regMap.get(reg);
	}

	public void put(Register reg, int i) {
		regMap.put(reg, i);
	}
	
	
	public MapSSA clone() {
		MapSSA map = new MapSSA();
		map.regMap = new ConcurrentHashMap<>();
		
		for(Register reg : regMap.keySet()) {
			map.put(reg, this.get(reg));
		}
		return map;
	}
	
	public String toString() {
		return "[" + regMap.reduce(1, (k, v) -> k + " = "
                + NumberFormat.getInstance().format(v), (r1, r2) -> r1 + ", " + r2) + "]";
	}
}
