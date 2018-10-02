package dartagnan.utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collection;

import com.microsoft.z3.*;

import dartagnan.program.event.*;
import dartagnan.program.Location;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.utils.EventRepository;

public class Utils {

	public static void drawGraph(Program p, Context ctx, Model model, String filename, String[] relations) throws IOException {
        File newTextFile = new File(filename);
        FileWriter fw = new FileWriter(newTextFile);

		GraphViz gv = new GraphViz();
		gv.addln(gv.start_graph());
		gv.addln("  subgraph cluster_Source { rank=sink; fontsize=20; label = \"Program Compiled to Target Architecture\"; color=red; shape=box;");
		addExecutionGraph(gv, p, ctx, model, relations);
		gv.addln("  }");
		gv.addln(gv.end_graph());

        fw.write(gv.getDotSource());
        fw.close();
	}
	
	public static void drawGraph(Program p, Program pSource, Program pTarget, Context ctx, Model model, String filename, String[] relations) throws IOException {
		File newTextFile = new File(filename);
		FileWriter fw = new FileWriter(newTextFile);
		GraphViz gv = new GraphViz();
		gv.addln(gv.start_graph());

		gv.addln("  subgraph cluster_Source { rank=sink; fontsize=20; label = \"Program Compiled to Source Architecture\"; color=red; shape=box;");
		addExecutionGraph(gv, pSource, ctx, model, relations);
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
		addExecutionGraph(gv, pTarget, ctx, model, relations);
		gv.addln("  }");

		gv.addln(gv.end_graph());
		fw.write(gv.getDotSource());
		fw.close();
	}

	private static void addExecutionGraph(GraphViz gv, Program p, Context ctx, Model model, String[] relations) throws IOException {
		int tid = 0;
		for(dartagnan.program.Thread t : p.getThreads()) {
			tid++;
			if(!(t instanceof Init)) {
				gv.addln("    subgraph cluster_Thread_Source" + t.getTId() + " { rank=sink; fontsize=15; label = \"Thread " + tid + "\"; color=magenta; shape=box;");
			}

			for(Event e : p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE | EventRepository.EVENT_RCU)) {
				if (!model.getConstInterp(e.executes(ctx)).isTrue() || !e.getMainThreadId().equals(t.getTId())) {continue;}
				String label = e.getEId() + ": ";
				if(e instanceof Store || e instanceof Init) {
					label += "W_" + e.getLoc() + "_" + model.getConstInterp(((MemEvent) e).ssaLoc).toString() + "\\n";
				} else if(e instanceof Load) {
					label += "R_" + e.getLoc() + "_" + model.getConstInterp(((MemEvent) e).ssaLoc).toString() + "\\n";
				} else if(e instanceof Fence) {
					label += ((Fence)e).getName() + "\\n";
				} else {
                    label += e + "\\n";
                }
				for(Event eHL : p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY)) {
					if(!(e instanceof Init) && e.getHLId() != null && e.getHLId() == eHL.hashCode()) {
						label += eHL.toString().replaceAll("\\s","");
					}
				}
                if(e instanceof Init) {
                    gv.addln("      " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", root=true];");
                } else {
					gv.addln("      " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=s" + e.getMainThreadId() + "];");
				}

			}
			if(!(t instanceof Init)) {
				gv.addln("    }");
			}
		}

		for(Event e1 : p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY)) {
			if (!(model.getConstInterp(e1.executes(ctx)).isTrue())) continue;
			for(Event e2 : p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY)) {
				if (!(model.getConstInterp(e2.executes(ctx)).isTrue())) continue;
				if(model.getConstInterp(edge("rf", e1, e2, ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"rf\", color=\"red\", fontcolor=\"red\", weight=1];");
				}
				if(model.getConstInterp(edge("fr", e1, e2, ctx)).isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"fr\", color=\"#ffa040\", fontcolor=\"#ffa040\", weight=1];");
				}
				if(e1.getLoc() == e2.getLoc() && (e1 instanceof Store || e1 instanceof Init) && (e2 instanceof Store || e2 instanceof Init) && Integer.parseInt(model.getConstInterp(intVar("co", e1, ctx)).toString()) == Integer.parseInt(model.getConstInterp(intVar("co", e2, ctx)).toString()) - 1) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"co\", color=\"blue\", fontcolor=\"blue\", weight=1];");
				}
			}
		}

		for(Event e1 : p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE | EventRepository.EVENT_RCU)) {
			if (!(model.getConstInterp(e1.executes(ctx)).isTrue())) continue;
			for(Event e2 : p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE | EventRepository.EVENT_RCU)) {
				if (!(model.getConstInterp(e2.executes(ctx)).isTrue())) continue;
				if(model.getConstInterp(edge("po", e1, e2, ctx)).isTrue() && e1.getEId().equals(e2.getEId() - 1)) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"po\", color=\"brown\", fontcolor=\"brown\", weight=1];");
				}
				Expr syncExpr = model.getConstInterp(edge("sync", e1, e2, ctx));
				if(syncExpr != null && syncExpr.isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"sync\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				Expr lwsyncExpr = model.getConstInterp(edge("lwsync", e1, e2, ctx));
				if(lwsyncExpr != null && lwsyncExpr.isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"lwsync\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				Expr mfenceExpr = model.getConstInterp(edge("mfence", e1, e2, ctx));
				if(mfenceExpr != null && mfenceExpr.isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"mfence\", color=\"black\", fontcolor=\"black\", weight=1];");
				}
				Expr gpExpr = model.getConstInterp(edge("gp", e1, e2, ctx));
				if(gpExpr != null && gpExpr.isTrue()) {
					gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"gp\", color=\"black\", fontcolor=\"black\", weight=1];");
				}

                Expr dataExpr = model.getConstInterp(edge("data", e1, e2, ctx));
                if(dataExpr != null && dataExpr.isTrue()) {
                    gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"data\", color=\"black\", fontcolor=\"black\", weight=1];");
                }
			}
		}

		Collection<Event> rcuLocks = p.getEventRepository().getEvents(EventRepository.EVENT_RCU_LOCK);
		Collection<Event> rcuUnlocks = p.getEventRepository().getEvents(EventRepository.EVENT_RCU_UNLOCK);
		for(Event lock : rcuLocks){
			if(model.getConstInterp(lock.executes(ctx)).isTrue()){
				for(Event unlock : rcuUnlocks){
					if(model.getConstInterp(unlock.executes(ctx)).isTrue() && model.getConstInterp(edge("crit", lock, unlock, ctx)).isTrue()){
						gv.addln("      " + lock.repr() + " -> " + unlock.repr() + " [label=\"crit\", color=\"black\", fontcolor=\"black\", weight=1];");
					}
				}
			}
		}

		for(String r : relations) {
			if(r == null) {continue;}
			for(Event e1 : p.getEventRepository().getEvents(EventRepository.EVENT_ALL)) {
				for(Event e2 : p.getEventRepository().getEvents(EventRepository.EVENT_ALL)) {
					if(!Arrays.asList(model.getDecls()).contains(edge(r, e1, e2, ctx).getFuncDecl())) {
						continue;
					}
					if(model.getConstInterp(edge(r, e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
						gv.addln("      " + e1.repr() + " -> " + e2.repr() + " [label=\"" + r + "\", color=\"indigo\", fontcolor=\"indigo\"];");
					}
				}
			}
		}
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