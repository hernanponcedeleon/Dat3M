package dartagnan.utils;

import java.util.List;

import com.microsoft.z3.*;

import dartagnan.program.Event;
import dartagnan.program.If;
import dartagnan.program.Load;
import dartagnan.program.Local;
import dartagnan.program.Location;
import dartagnan.program.MemEvent;
import dartagnan.program.Register;

public class Utils {
	
	public static void getResults(Solver s, List<String> varNames) throws Z3Exception {
		Status result = s.check();
		System.out.println(result);
		if (result == Status.SATISFIABLE) {
			Model model = s.getModel();
			for(FuncDecl m : model.getDecls()) {
				if(model.eval(model.getConstInterp(m), true).isTrue()) {
					for(String string : varNames) {
						if(m.getName().toString().contains(string)) {
						System.out.println(m.getName());
						}
					}
				}
			}
		}
		else {
			System.out.println(s.getUnsatCore());
		}
	}
	
	public static BoolExpr encodeMissingIndexes(If t, MapSSA map1, MapSSA map2, Context ctx) throws Z3Exception {

		BoolExpr ret = ctx.mkTrue();
		BoolExpr index = ctx.mkTrue();

		for(Object o : map1.keySet()) {
			Integer i1 = map1.get(o);
			Integer i2 = map2.get(o);
			if(i1 > i2) {
				if(o instanceof Register) {
					// If the ssa index of a register differs in the two branches
					// I need to maintain the value when the event is not executed
					// for testing reachability
					for(Event e : t.getEvents()) {
						if(!(e instanceof Load || e instanceof Local)) {continue;}
						if(e.getSsaRegIndex() == i1) {
							ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkNot(e.executes(ctx)), ctx.mkEq(ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i1)), ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i1-1)))));
						}
					}
					index = ctx.mkEq(ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i1)), ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i2)));
				}
				if(o instanceof Location) {
					index = ctx.mkEq(ctx.mkIntConst(String.format("%s_%s", o, i1)), ctx.mkIntConst(String.format("%s_%s", o, i2)));
				}
				ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkBoolConst(t.getT2().cfVar()), index));
			}
		}
		
		for(Object o : map2.keySet()) {
			Integer i1 = map1.get(o);
			Integer i2 = map2.get(o);
			if(i2 > i1) {
				if(o instanceof Register) {
					for(Event e : t.getEvents()) {
						if(!(e instanceof Load || e instanceof Local)) {continue;}
						if(e.getSsaRegIndex() == i2) {
							ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkNot(e.executes(ctx)), ctx.mkEq(ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i2)), ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i2-1)))));
						}
					}
					index = ctx.mkEq(ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i2)), ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i1)));
				}
				if(o instanceof Location) {
					index = ctx.mkEq(ctx.mkIntConst(String.format("%s_%s", o, i2)), ctx.mkIntConst(String.format("%s_%s", o, i1)));
				}
				ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkBoolConst(t.getT1().cfVar()), index));
			}
		}
		return ret;	
	}
	
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
	
	public static LastModMap mergeMapLastMod(LastModMap map1, LastModMap map2) {
		LastModMap retMap = map1.clone();
		for(Object o : map2.keySet()) {
			if(retMap.keySet().contains(o)) {
				retMap.get(o).addAll(map2.get(o));
			}
			else {
				retMap.put(o, map2.get(o));
			}
		}
		return retMap;
	}
	
	public static BoolExpr edge(String relName, Event e1, Event e2, Context ctx) throws Z3Exception {
		return (BoolExpr) ctx.mkConst(String.format("%s(%s,%s)", relName, e1.repr(), e2.repr()), ctx.mkBoolSort());
	}

	public static BoolExpr edge(String relName, String program, Event e1, Event e2, Context ctx) throws Z3Exception {
		return (BoolExpr) ctx.mkConst(String.format("%s@%s(%s,%s)", relName, program, e1.repr(), e2.repr()), ctx.mkBoolSort());
	}
	
	public static IntExpr intVar(String relName, Event e, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(String.format("%s(%s)", relName, e.repr()));
	}
	
	public static BoolExpr lastCoOrder(Event e, Context ctx) throws Z3Exception {
		return ctx.mkBoolConst(String.format("last_%s(%s)", ((MemEvent) e).getLoc(), e.repr()));
	}

	public static IntExpr intCount(String relName, Event e1, Event e2, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(String.format("%s(%s,%s)", relName, e1.repr(), e2.repr()));
	}

	public static BoolExpr cycleVar(String relName, Event e, Context ctx) throws Z3Exception {
		return ctx.mkBoolConst(String.format("Cycle(%s)(%s)", e.repr(), relName));
	}
	
	public static BoolExpr cycleEdge(String relName, Event e1, Event e2, Context ctx) throws Z3Exception {
		return ctx.mkBoolConst(String.format("Cycle:%s(%s,%s)", relName, e1.repr(), e2.repr()));
	}
}