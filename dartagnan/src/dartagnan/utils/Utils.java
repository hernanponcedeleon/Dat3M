package dartagnan.utils;

import com.microsoft.z3.*;

import dartagnan.program.event.*;
import dartagnan.program.Location;
import dartagnan.program.Register;

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
	
	public static BoolExpr edge(String relName, Event e1, Event e2, Context ctx) throws Z3Exception {
		return (BoolExpr) ctx.mkConst(String.format("%s(%s,%s)", relName, e1.repr(), e2.repr()), ctx.mkBoolSort());
	}

	public static IntExpr intVar(String relName, Event e, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(String.format("%s(%s)", relName, e.repr()));
	}
	
	public static IntExpr ssaLoc(Location loc, Integer mainThreadId, Integer ssaIndex, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(String.format("T%s_%s_%s", mainThreadId, loc.getName(), ssaIndex));
	}
	
	public static IntExpr ssaReg(Register reg, Integer ssaIndex, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(String.format("T%s_%s_%s", reg.getMainThreadId(), reg.getName(), ssaIndex));
	}
	
	public static IntExpr uniqueValue(Event e, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(e.getLoc() + "_unique");
	}
	
	public static IntExpr initValue(Event e, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(e.getLoc() + "_init");
	}
	
	public static IntExpr initValue2(Event e, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(e.getLoc() + "_init_prime");
	}
	
	public static IntExpr intCount(String relName, Event e1, Event e2, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(String.format("%s(%s,%s)", relName, e1.repr(), e2.repr()));
	}
}