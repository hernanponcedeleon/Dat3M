package dartagnan.utils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.program.Register;
import dartagnan.program.event.Event;
import dartagnan.program.memory.Location;

public class Utils {

	public static MapSSA mergeMaps(MapSSA map1, MapSSA map2) {
		MapSSA map = new MapSSA();
		for(Register reg : map1.keySet()) {
	        if(map2.keySet().contains(reg)) {
				map.put(reg, Math.max(map1.get(reg), map2.get(reg)));
	        }
	        else {
	        	map.put(reg, map1.get(reg));
	        }
		}
		for(Register reg : map2.keySet()) {
	        if(map1.keySet().contains(reg)) {
				map.put(reg, Math.max(map1.get(reg), map2.get(reg)));
	        }
	        else {
	        	map.put(reg, map2.get(reg));
	        }
		}
		return map;
	}
	
	public static BoolExpr edge(String relName, Event e1, Event e2, Context ctx) {
		return (BoolExpr) ctx.mkConst(relName + "(" + e1.repr() + "," + e2.repr() + ")", ctx.mkBoolSort());
	}

	public static IntExpr intVar(String relName, Event e, Context ctx) {
		return ctx.mkIntConst(relName + "(" + e.repr() + ")");
	}
	
	public static IntExpr ssaLoc(Location loc, int mainThreadId, int ssaIndex, Context ctx) {
		return ctx.mkIntConst("T" + mainThreadId + "_" + loc.getName() + "_" + ssaIndex);
	}
	
	public static IntExpr ssaReg(Register reg, int ssaIndex, Context ctx) {
		return ctx.mkIntConst("T" + reg.getPrintMainThreadId() + "_" + reg.getName() + "_" + ssaIndex);
	}
	
	public static IntExpr intCount(String relName, Event e1, Event e2, Context ctx) {
		return ctx.mkIntConst(relName + "(" + e1.repr() + "," + e2.repr() + ")");
	}
}