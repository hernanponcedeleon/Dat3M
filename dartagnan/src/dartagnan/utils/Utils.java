package dartagnan.utils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.program.memory.Location;
import dartagnan.program.Register;
import dartagnan.program.event.Event;

public class Utils {

	public static MapSSA mergeMaps(MapSSA map1, MapSSA map2) {
		MapSSA map = new MapSSA();
		for(Object o : map1.keySet()) {
	        if(map2.keySet().contains(o)) {
				map.put(o, Math.max(map1.get(o), map2.get(o)));
	        }
	        else {
	        	map.put(o, map1.get(o));
	        }
		}
		for(Object o : map2.keySet()) {
	        if(map1.keySet().contains(o)) {
				map.put(o, Math.max(map1.get(o), map2.get(o)));
	        }
	        else {
	        	map.put(o, map2.get(o));
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
	
	public static IntExpr uniqueValue(Event e, Context ctx) {
		return ctx.mkIntConst(e.getLoc() + "_unique");
	}
	
	public static IntExpr initValue(Event e, Context ctx) {
		return ctx.mkIntConst(e.getLoc() + "_init");
	}
	
	public static IntExpr initValue2(Event e, Context ctx) {
		return ctx.mkIntConst(e.getLoc() + "_init_prime");
	}
	
	public static IntExpr intCount(String relName, Event e1, Event e2, Context ctx) {
		return ctx.mkIntConst(relName + "(" + e1.repr() + "," + e2.repr() + ")");
	}
}