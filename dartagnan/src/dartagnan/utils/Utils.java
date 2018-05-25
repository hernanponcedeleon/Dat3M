package dartagnan.utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.Event;
import dartagnan.program.Init;
import dartagnan.program.Load;
import dartagnan.program.Location;
import dartagnan.program.MemEvent;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.Store;

public class Utils {

	public static void drawGraph(Program p, Context ctx, Model model, String filename, String[] relations) throws IOException {
        File newTextFile = new File(filename);
        FileWriter fw = new FileWriter(newTextFile);
        GraphViz gv = new GraphViz();
		gv.addln(gv.start_graph());
		
		gv.addln("  subgraph cluster_Source { rank=sink; fontsize=20; label = \"Program Compiled to Target Architecture\"; color=red; shape=box;");
		int tid = 0;
		for(dartagnan.program.Thread t : p.getThreads()) {
			tid++;
			if(!(t instanceof Init)) {
				gv.addln("    subgraph cluster_Thread_Source" + t.getTId() + " { rank=sink; fontsize=15; label = \"Thread " + tid + "\"; color=magenta; shape=box;");
			}
			
			for(Event e : p.getEvents()) {
				String label = "";
				if (!(e instanceof MemEvent)) {continue;}
				if((e instanceof Store || e instanceof Init) && model.getConstInterp(e.executes(ctx)).isTrue()) {
					label = "W_" + e.getLoc() + "_" + model.getConstInterp(((MemEvent) e).ssaLoc).toString() + "\\n";
				}
				if(e instanceof Load && model.getConstInterp(e.executes(ctx)).isTrue()) {
					label = "R_" + e.getLoc() + "_" + model.getConstInterp(((MemEvent) e).ssaLoc).toString() + "\\n";
				}
				for(Event eHL : p.getEvents().stream().filter(x -> x instanceof MemEvent).collect(Collectors.toSet())) {
					if(!(e instanceof Init) && e.getHLId() != null && e.getHLId() == eHL.hashCode()) {
						label = label + eHL.toString().replaceAll("\\s","");
					}
				}				
				if((e instanceof Store || e instanceof Load) && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
					gv.addln("      " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=s" + e.getMainThread() + "];");	
				}
				if(e instanceof Init && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
					gv.addln("      " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", root=true];");	
				}
			}
			if(!(t instanceof Init)) {
				gv.addln("    }");
			}
		}

		for(Event e1 : p.getEvents()) {
			for(Event e2 : p.getEvents()) {
				if (!(e1 instanceof MemEvent && e2 instanceof MemEvent)) {continue;}
				if (!(model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue())) {continue;}
				if(model.getConstInterp(edge("rf", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"rf\", color=\"red\", fontcolor=\"red\", weight=1];");
				}
				if(model.getConstInterp(edge("fr", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"fr\", color=\"#ffa040\", fontcolor=\"#ffa040\", weight=1];");
				}
				if(e1.getLoc() == e2.getLoc() && (e1 instanceof Store || e1 instanceof Init) && (e2 instanceof Store || e2 instanceof Init) && Integer.parseInt(model.getConstInterp(intVar("co", e1, ctx)).toString()) == Integer.parseInt(model.getConstInterp(intVar("co", e2, ctx)).toString()) - 1 && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()	) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"co\", color=\"brown\", fontcolor=\"brown\", weight=1];");	
				}
				if(model.getConstInterp(edge("sync", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"sync\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				if(model.getConstInterp(edge("lwsync", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"lwsync\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				if(model.getConstInterp(edge("mfence", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"mfence\", color=\"black\", fontcolor=\"black\", weight=1];");
				}				
			}
		}
		
		gv.addln("  }");

		gv.addln(gv.end_graph());
        fw.write(gv.getDotSource());
        fw.close();
		return;
	}
	
	public static void drawGraph(Program p, Program pSource, Program pTarget, Context ctx, Model model, String filename, String[] relations) throws IOException {
        File newTextFile = new File(filename);
        FileWriter fw = new FileWriter(newTextFile);
        GraphViz gv = new GraphViz();
		gv.addln(gv.start_graph());
		
		gv.addln("  subgraph cluster_Source { rank=sink; fontsize=20; label = \"Program Compiled to Source Architecture\"; color=red; shape=box;");
		int tid = 0;
		for(dartagnan.program.Thread t : pSource.getThreads()) {
			tid++;
			if(!(t instanceof Init)) {
				gv.addln("    subgraph cluster_Thread_Source" + t.getTId() + " { rank=sink; fontsize=15; label = \"Thread " + tid + "\"; color=magenta; shape=box;");
			}
			
			for(Event e : pSource.getEvents()) {
				String label = "";
				if (!(e instanceof MemEvent)) {continue;}
				if(e instanceof Store && model.getConstInterp(e.executes(ctx)).isTrue()) {
					label = "W_" + e.getLoc() + "_" + model.getConstInterp(((MemEvent) e).ssaLoc).toString() + "\\n";
				}
				if(e instanceof Load && model.getConstInterp(e.executes(ctx)).isTrue()) {
					label = "R_" + e.getLoc() + "_" + model.getConstInterp(((MemEvent) e).ssaLoc).toString() + "\\n";
				}
				for(Event eHL : p.getEvents().stream().filter(x -> x instanceof MemEvent).collect(Collectors.toSet())) {
					if(e.getHLId() != null && e.getHLId() == eHL.hashCode()) {
						label = label + eHL.toString().replaceAll("\\s","");
					}
				}				
				if(e instanceof Store && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
					gv.addln("      " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=s" + e.getMainThread() + "];");	
				}
				if(e instanceof Load && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
					gv.addln("      " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=s" + e.getMainThread() + "];");	
				}
				if(e instanceof Init && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
					gv.addln("      " + e.repr() + " [label=\"W_" + e.getLoc() + "_0\", shape=\"box\", color=\"blue\", root=true];");	
				}
			}
			if(!(t instanceof Init)) {
				gv.addln("    }");
			}
		}

		for(Event e1 : pSource.getEvents()) {
			for(Event e2 : pSource.getEvents()) {
				if (!(e1 instanceof MemEvent && e2 instanceof MemEvent)) {continue;}
				if (!(model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue())) {continue;}
				if(model.getConstInterp(edge("rf", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"rf\", color=\"red\", fontcolor=\"red\", weight=1];");
				}
				if(model.getConstInterp(edge("fr", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"fr\", color=\"#ffa040\", fontcolor=\"#ffa040\", weight=1];");
				}
				if(e1.getLoc() == e2.getLoc() && (e1 instanceof Store || e1 instanceof Init) && (e2 instanceof Store || e2 instanceof Init) && Integer.parseInt(model.getConstInterp(intVar("co", e1, ctx)).toString()) == Integer.parseInt(model.getConstInterp(intVar("co", e2, ctx)).toString()) - 1 && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()	) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"co\", color=\"brown\", fontcolor=\"brown\", weight=1];");	
				}
				if(model.getConstInterp(edge("sync", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"sync\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				if(model.getConstInterp(edge("lwsync", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"lwsync\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				if(model.getConstInterp(edge("mfence", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"mfence\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				
				for(String r : relations) {
					if(r == null) {continue;}
					if(!Arrays.asList(model.getDecls()).contains(edge(r, e1, e2, ctx).getFuncDecl())) {
						continue;
					}
					if(model.getConstInterp(edge(r, e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
						gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"" + r + "\", color=\"indigo\", fontcolor=\"indigo\"];");
					}	
				}
			}
		}
		
		gv.addln("      /* Cycle */");
		for(FuncDecl m : model.getDecls()) {
			String edge = m.getName().toString(); 
			if(edge.contains("Cycle:") && model.getConstInterp(m).isTrue()) {
				String source = getSourceFromEdge(edge);
				String target = getTargetFromEdge(edge);
				gv.addln("      " + source + " -> " + target + "[style=bold, color=green, weight=0];");
			}
		}
		gv.addln("  }");

		gv.addln("  subgraph cluster_Target { rank=sink; fontsize=20; label = \"Program Compiled to Target Architecture\"; color=red; shape=box;");
		tid = 0;
		for(dartagnan.program.Thread t : pTarget.getThreads()) {
			tid++;
			if(!(t instanceof Init)) {
				gv.addln("    subgraph cluster_Thread_Target" + t.getTId() + " { rank=sink; fontsize=15; label = \"Thread " + tid + "\"; color=magenta; shape=box;");
			}
			
			for(Event e : pTarget.getEvents()) {
				String label = "";
				if (!(e instanceof MemEvent)) {continue;}
				if(e instanceof Store && model.getConstInterp(e.executes(ctx)).isTrue()) {
					label = "W_" + e.getLoc() + "_" + model.getConstInterp(((MemEvent) e).ssaLoc).toString() + "\\n";
				}
				if(e instanceof Load && model.getConstInterp(e.executes(ctx)).isTrue()) {
					label = "R_" + e.getLoc() + "_" + model.getConstInterp(((MemEvent) e).ssaLoc).toString() + "\\n";
				}
				for(Event eHL : p.getEvents().stream().filter(x -> x instanceof MemEvent).collect(Collectors.toSet())) {
					if(e.getHLId() != null && e.getHLId() == eHL.hashCode()) {
						label = label + eHL.toString().replaceAll("\\s","");
					}
				}				
				if(e instanceof Store && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
					gv.addln("      " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=t" + e.getMainThread() + "];");	
				}
				if(e instanceof Load && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
					gv.addln("      " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=t" + e.getMainThread() + "];");	
				}
				if(e instanceof Init && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
					gv.addln("      " + e.repr() + " [label=\"W_" + e.getLoc() + "_0\", shape=\"box\", color=\"blue\", root=true];");	
				}
			}
			if(!(t instanceof Init)) {
				gv.addln("    }");
			}
		}

		for(Event e1 : pTarget.getEvents()) {
			for(Event e2 : pTarget.getEvents()) {
				if (!(e1 instanceof MemEvent && e2 instanceof MemEvent)) {continue;}
				if (!(model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue())) {continue;}
				if(model.getConstInterp(edge("rf", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"rf\", color=\"red\", fontcolor=\"red\", weight=1];");
				}
				if(model.getConstInterp(edge("fr", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"fr\", color=\"#ffa040\", fontcolor=\"#ffa040\", weight=1];");
				}
				if(e1.getLoc() == e2.getLoc() && (e1 instanceof Store || e1 instanceof Init) && (e2 instanceof Store || e2 instanceof Init) && Integer.parseInt(model.getConstInterp(intVar("co", e1, ctx)).toString()) == Integer.parseInt(model.getConstInterp(intVar("co", e2, ctx)).toString()) - 1 && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"co\", color=\"brown\", fontcolor=\"brown\", weight=1];");	
				}
				if(model.getConstInterp(edge("sync", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"sync\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				if(model.getConstInterp(edge("lwsync", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"lwsync\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				if(model.getConstInterp(edge("mfence", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"mfence\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				
				for(String r : relations) {
					if(r == null) {continue;}
					if(!Arrays.asList(model.getDecls()).contains(edge(r, e1, e2, ctx).getFuncDecl())) {
						continue;
					}
					if(model.getConstInterp(edge(r, e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
						gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"" + r + "\", color=\"indigo\", fontcolor=\"indigo\"];");
					}	
				}
			}
		}
		gv.addln("  }");

		gv.addln(gv.end_graph());
        fw.write(gv.getDotSource());
        fw.close();
		return;
	}
	
	private static String getSourceFromEdge(String edge) {
		return edge.split("\\(")[1].split(",")[0];
	}

	private static String getTargetFromEdge(String edge) {
		return edge.split("\\(")[1].split(",")[1].split("\\)")[0];
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

	public static IntExpr intVar(String relName, Event e, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(String.format("%s(%s)", relName, e.repr()));
	}
	
	public static IntExpr lastValueLoc(Location loc, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(loc.getName() + "_final");
	}
	
	public static IntExpr lastValueReg(Register reg, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(reg.getName() + "_" + reg.getMainThread() + "_final");
	}
	
	public static IntExpr ssaLoc(Location loc, Integer mainThread, Integer ssaIndex, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(String.format("T%s_%s_%s", mainThread, loc.getName(), ssaIndex));
	}
	
	public static IntExpr ssaReg(Register reg, Integer ssaIndex, Context ctx) throws Z3Exception {
		return ctx.mkIntConst(String.format("T%s_%s_%s", reg.getMainThread(), reg.getName(), ssaIndex));
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

	public static BoolExpr cycleVar(String relName, Event e, Context ctx) throws Z3Exception {
		return ctx.mkBoolConst(String.format("Cycle(%s)(%s)", e.repr(), relName));
	}
	
	public static BoolExpr cycleEdge(String relName, Event e1, Event e2, Context ctx) throws Z3Exception {
		return ctx.mkBoolConst(String.format("Cycle:%s(%s,%s)", relName, e1.repr(), e2.repr()));
	}
}