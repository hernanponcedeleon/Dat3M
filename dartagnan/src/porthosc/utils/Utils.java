package porthosc.utils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Z3Exception;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XLocation;
import porthosc.languages.syntax.xgraph.memories.XSharedLvalueMemoryUnit;


public class Utils {

    //public static void drawGraph(Program p, Program pSource, Program pTarget, Context ctx, Model model, String filename, String[] relations) throws IOException {
    //    File newTextFile = new File(filename);
    //    FileWriter fw = new FileWriter(newTextFile);
    //    GraphViz gv = new GraphViz();
    //    gv.addln(gv.start_graph());
    //
    //    gv.addln("subgraph cluster_Source { rank=sink; fontsize=20; label = \"Program Compiled to Source Architecture\"; color=red; shape=box;");
    //    int tid = 0;
    //    for(old.dartagnan.program.Thread t : pSource.getThreads()) {
    //        tid++;
    //        if(!(t instanceof InitEvent)) {
    //            gv.addln("  subgraph cluster_Thread_Source" + t.getTId() + " { rank=sink; fontsize=15; label = \"Thread " + tid + "\"; color=magenta; shape=box;");
    //        }
    //
    //        gv.start_subgraph(t.getTId());
    //
    //        for(Event e : pSource.getEvents()) {
    //            String label = "";
    //            if (!(e instanceof SharedMemEvent || e instanceof LocalEvent)) {continue;}
    //            for(Event eHL : p.getEvents().stream().filter(x -> x instanceof SharedMemEvent).collect(Collectors.toSet())) {
    //                if(e instanceof StoreEvent) {
    //                    label = "W_" + e.getLoc() + "_" + model.getConstInterp(((SharedMemEvent) e).ssaLoc).toString() + "\n";
    //                }
    //                if(e instanceof LoadEvent) {
    //                    label = "R_" + e.getLoc() + "_" + model.getConstInterp(((SharedMemEvent) e).ssaLoc).toString() + "\n";
    //                }
    //                if(e.getHLId() != null && e.getHLId() == eHL.hashCode()) {
    //                    label = label + eHL.toString().replaceAll("\\s","");
    //                }
    //            }
    //            if(e instanceof StoreEvent && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=s" + e.getMainThread() + "];");
    //            }
    //            if(e instanceof LoadEvent && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=s" + e.getMainThread() + "];");
    //            }
    //            if(e instanceof InitEvent && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e.repr() + " [label=\"W_" + e.getLoc() + "_0\", shape=\"box\", color=\"blue\", root=true];");
    //            }
    //            if(e instanceof LocalEvent && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e.repr() + " [style=invis];");
    //            }
    //        }
    //        if(!(t instanceof InitEvent)) {
    //            gv.addln("  }");
    //        }
    //    }
    //
    //    for(Event e1 : pSource.getEvents()) {
    //        for(Event e2 : pSource.getEvents()) {
    //            if (!(e1 instanceof SharedMemEvent || e1 instanceof LocalEvent)) {continue;}
    //            if (!(e2 instanceof SharedMemEvent || e2 instanceof LocalEvent)) {continue;}
    //            if(e1.getMainThread() == e2.getMainThread() && e1.getEId() < e2.getEId() - 1 && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [style=invis, weight=10];");
    //            }
    //            if (!(e1 instanceof SharedMemEvent && e2 instanceof SharedMemEvent)) {continue;}
    //            if(model.getConstInterp(Utils.edge("rf", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"rf\", color=\"black\", fontcolor=\"black\", weight=1];");
    //            }
    //            if(model.getConstInterp(Utils.edge("fr", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"fr\", color=\"black\", fontcolor=\"black\", weight=1];");
    //            }
    //            if(e1.getLoc() == e2.getLoc() && (e1 instanceof StoreEvent || e1 instanceof InitEvent) && (e2 instanceof StoreEvent || e2 instanceof InitEvent) && Integer.parseInt(model.getConstInterp(Utils.intVar("co", e1, ctx)).toString()) == Integer.parseInt(model.getConstInterp(Utils.intVar("co", e2, ctx)).toString()) - 1 && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()    ) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"co\", color=\"black\", fontcolor=\"black\", weight=1];");
    //            }
    //
    //            for(String r : relations) {
    //                if(r == null) {continue;}
    //                if(!Arrays.asList(model.getDecls()).contains(Utils.edge(r, e1, e2, ctx).getFuncDecl())) {
    //                    continue;
    //                }
    //                if(model.getConstInterp(Utils.edge(r, e1, e2, ctx)).isTrue()) {
    //                    gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"" + r + "\", color=\"red\", fontcolor=\"black\"];");
    //                }
    //            }
    //        }
    //    }
    //
    //    gv.addln("/* Cycle */");
    //    for(FuncDecl m : model.getDecls()) {
    //        String edge = m.getName().toString();
    //        if(edge.contains("Cycle:") && model.getConstInterp(m).isTrue()) {
    //            String source = getSourceFromEdge(edge);
    //            String target = getTargetFromEdge(edge);
    //            gv.addln("    " + source + " -> " + target + "[style=bold, color=green, weight=0];");
    //        }
    //    }
    //    gv.addln("}");
    //
    //    gv.addln("subgraph cluster_Target { rank=sink; fontsize=20; label = \"Program Compiled to Target Architecture\"; color=red; shape=box;");
    //    tid = 0;
    //    for(old.dartagnan.program.Thread t : pTarget.getThreads()) {
    //        tid++;
    //        if(!(t instanceof InitEvent)) {
    //            gv.addln("  subgraph cluster_Thread_Target" + t.getTId() + " { rank=sink; fontsize=15; label = \"Thread " + tid + "\"; color=magenta; shape=box;");
    //        }
    //
    //        gv.start_subgraph(t.getTId());
    //
    //        for(Event e : pTarget.getEvents()) {
    //            String label = "";
    //            if (!(e instanceof SharedMemEvent || e instanceof LocalEvent)) {continue;}
    //            for(Event eHL : p.getEvents().stream().filter(x -> x instanceof SharedMemEvent).collect(Collectors.toSet())) {
    //                if(e instanceof StoreEvent) {
    //                    label = "W_" + e.getLoc() + "_" + model.getConstInterp(((SharedMemEvent) e).ssaLoc).toString() + "\n";
    //                }
    //                if(e instanceof LoadEvent) {
    //                    label = "R_" + e.getLoc() + "_" + model.getConstInterp(((SharedMemEvent) e).ssaLoc).toString() + "\n";
    //                }
    //                if(e.getHLId() != null && e.getHLId() == eHL.hashCode()) {
    //                    label = label + eHL.toString().replaceAll("\\s","");
    //                }
    //            }
    //            if(e instanceof StoreEvent && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=t" + e.getMainThread() + "];");
    //            }
    //            if(e instanceof LoadEvent && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e.repr() + " [label=\"" + label + "\", shape=\"box\", color=\"blue\", group=t" + e.getMainThread() + "];");
    //            }
    //            if(e instanceof InitEvent && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e.repr() + " [label=\"W_" + e.getLoc() + "_0\", shape=\"box\", color=\"blue\", root=true];");
    //            }
    //            if(e instanceof LocalEvent && e.getMainThread() == t.getTId() && model.getConstInterp(e.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e.repr() + " [style=invis];");
    //            }
    //        }
    //        if(!(t instanceof InitEvent)) {
    //            gv.addln("  }");
    //        }
    //    }
    //
    //    for(Event e1 : pTarget.getEvents()) {
    //        for(Event e2 : pTarget.getEvents()) {
    //            if (!(e1 instanceof SharedMemEvent || e1 instanceof LocalEvent)) {continue;}
    //            if (!(e2 instanceof SharedMemEvent || e2 instanceof LocalEvent)) {continue;}
    //            if(e1.getMainThread() == e2.getMainThread() && e1.getEId() == e2.getEId() - 1 && model.getConstInterp(e1.executes(ctx)).isTrue()  && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [style=invis, weight=10];");
    //            }
    //            if (!(e1 instanceof SharedMemEvent && e2 instanceof SharedMemEvent)) {continue;}
    //            if(model.getConstInterp(Utils.edge("rf", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"rf\", color=\"black\", fontcolor=\"black\", weight=1];");
    //            }
    //            if(model.getConstInterp(Utils.edge("fr", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"fr\", color=\"black\", fontcolor=\"black\", weight=1];");
    //            }
    //            if(e1.getLoc() == e2.getLoc() && (e1 instanceof StoreEvent || e1 instanceof InitEvent) && (e2 instanceof StoreEvent || e2 instanceof InitEvent) && Integer.parseInt(model.getConstInterp(Utils.intVar("co", e1, ctx)).toString()) == Integer.parseInt(model.getConstInterp(Utils.intVar("co", e2, ctx)).toString()) - 1 && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"co\", color=\"black\", fontcolor=\"black\", weight=1];");
    //            }
    //            if(model.getConstInterp(Utils.edge("mfence", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"mfence\", color=\"black\", fontcolor=\"black\", weight=1];");
    //            }
    //            if(model.getConstInterp(Utils.edge("sync", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"sync\", color=\"black\", fontcolor=\"black\", weight=1];");
    //            }
    //            if(model.getConstInterp(Utils.edge("lwsync", e1, e2, ctx)).isTrue() && model.getConstInterp(e1.executes(ctx)).isTrue() && model.getConstInterp(e2.executes(ctx)).isTrue()) {
    //                gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"lwsync\", color=\"black\", fontcolor=\"black\", weight=1];");
    //            }
    //            for(String r : relations) {
    //                if(r == null) {continue;}
    //                if(!Arrays.asList(model.getDecls()).contains(Utils.edge(r, e1, e2, ctx).getFuncDecl())) {
    //                    continue;
    //                }
    //                if(model.getConstInterp(Utils.edge(r, e1, e2, ctx)).isTrue()) {
    //                    gv.addln("    " + e1.repr() + " -> " + e2.repr() + " [label=\"" + r + "\", color=\"red\", fontcolor=\"black\"];");
    //                }
    //            }
    //        }
    //    }
    //    gv.addln("  }");
    //
    //    gv.addln(gv.end_graph());
    //    fw.write(gv.getDotSource());
    //    fw.close();
    //
    //    return;
    //}

    //public static String getSourceFromEdge(String edge) {
    //    return edge.split("\\(")[1].split(",")[0];
    //}
    //
    //public static String getTargetFromEdge(String edge) {
    //    return edge.split("\\(")[1].split(",")[1].split("\\)")[0];
    //}

    //// adding intermidiate missing dumb
    //public static BoolExpr encodeMissingIndexes(If t, MapSSA map1, MapSSA map2, Context ctx) throws Z3Exception {
    //
    //    BoolExpr ret = ctx.mkTrue();
    //    BoolExpr index = ctx.mkTrue();
    //
    //    for(Object o : map1.keySet()) {
    //        Integer i1 = map1.get(o);
    //        Integer i2 = map2.get(o);
    //        if(i1 > i2) {
    //            if(o instanceof Register) {
    //                // If the ssa index of a register differs in the two branches
    //                // I need to maintain the value when the event is not executed
    //                // for testing reachability
    //                for(Event e : t.getEvents()) {
    //                    if(!(e instanceof LoadEvent || e instanceof LocalEvent)) {continue;}
    //                    if(e.getSsaRegIndex() == i1) {
    //                        //ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkNot(e.executes(ctx)), ctx.mkEq(ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i1)), ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i1-1)))));
    //                        ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkNot(e.executes(ctx)), ctx.mkEq(ssaReg((Register)o, i1, ctx), ssaReg((Register)o, i1-1, ctx))));
    //                    }
    //                }
    //                //index = ctx.mkEq(ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i1)), ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i2)));
    //                index = ctx.mkEq(ssaReg((Register)o, i1, ctx), ssaReg((Register)o, i2, ctx));
    //            }
    //            if(o instanceof Location) {
    //                index = ctx.mkEq(ctx.mkIntConst(String.format("%s_%s", o, i1)), ctx.mkIntConst(String.format("%s_%s", o, i2)));
    //            }
    //            ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkBoolConst(t.getT2().cfVar()), index));
    //        }
    //    }
    //
    //    for(Object o : map2.keySet()) {
    //        Integer i1 = map1.get(o);
    //        Integer i2 = map2.get(o);
    //        if(i2 > i1) {
    //            if(o instanceof Register) {
    //                for(Event e : t.getEvents()) {
    //                    if(!(e instanceof LoadEvent || e instanceof LocalEvent)) {continue;}
    //                    if(e.getSsaRegIndex() == i2) {
    //                        //ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkNot(e.executes(ctx)), ctx.mkEq(ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i2)), ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i2-1)))));
    //                        ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkNot(e.executes(ctx)), ctx.mkEq(ssaReg((Register)o, i2, ctx), ssaReg((Register)o, i2-1, ctx))));
    //                    }
    //                }
    //                //index = ctx.mkEq(ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i2)), ctx.mkIntConst(String.format("%s_t%s_%s", o, t.getMainThread(), i1)));
    //                index = ctx.mkEq(ssaReg((Register)o, i2, ctx), ssaReg((Register)o, i1, ctx));
    //            }
    //            if(o instanceof Location) {
    //                index = ctx.mkEq(ctx.mkIntConst(String.format("%s_%s", o, i2)), ctx.mkIntConst(String.format("%s_%s", o, i1)));
    //            }
    //            ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkBoolConst(t.getT1().cfVar()), index));
    //        }
    //    }
    //    return ret;
    //}
    //
    //public static MapSSA mergeMaps(MapSSA map1, MapSSA map2) {
    //    MapSSA map = new MapSSA();
    //    for(Object o : map1.keySet()) {
    //        if(map2.keySet().contains(o)) {
    //            map.put(o, Math.max(map1.get(o), map2.get(o)));
    //        }
    //        else {
    //            map.put(o, map1.get(o));
    //        }
    //    }
    //    for(Object o : map2.keySet()) {
    //        if(map1.keySet().contains(o)) {
    //            map.put(o, Math.max(map1.get(o), map2.get(o)));
    //        }
    //        else {
    //            map.put(o, map2.get(o));
    //        }
    //    }
    //    return map;
    //}
    //
    //public static LastModMap mergeMapLastMod(LastModMap map1, LastModMap map2) {
    //    LastModMap retMap = map1.clone();
    //    for(Object o : map2.keySet()) {
    //        if(retMap.keySet().contains(o)) {
    //            retMap.get(o).addAll(map2.get(o));
    //        }
    //        else {
    //            retMap.put(o, map2.get(o));
    //        }
    //    }
    //    return retMap;
    //}

    //public static BoolExpr edge(String relName, Event e1, Event e2, Context ctx) throws Z3Exception {
    //    return (BoolExpr) ctx.mkConst(String.format("%s(%s,%s)", relName, e1.repr(), e2.repr()), ctx.mkBoolSort());
    //}
    public static BoolExpr edge(String relName, XEvent e1, XEvent e2, Context ctx) throws Z3Exception {
        return (BoolExpr) ctx.mkConst(String.format("%s(%s,%s)", relName, e1.repr(), e2.repr()), ctx.mkBoolSort());
    }

    //public static BoolExpr edge(String relName, String program, Event e1, Event e2, Context ctx) throws Z3Exception {
    //    return (BoolExpr) ctx.mkConst(String.format("%s@%s(%s,%s)", relName, program, e1.repr(), e2.repr()), ctx.mkBoolSort());
    //}

    //public static IntExpr intVar(String relName, Event e, Context ctx) throws Z3Exception {
    //    return ctx.mkIntConst(String.format("%s(%s)", relName, e.repr()));
    //}
    public static IntExpr intVar(String relName, XEvent e, Context ctx) throws Z3Exception {
        return ctx.mkIntConst(String.format("%s(%s)", relName, e.repr()));
    }

    //public static IntExpr lastValueLoc(Location loc, Context ctx) throws Z3Exception {
    //    return ctx.mkIntConst(loc.getName() + "_final");
    //}
    public static IntExpr lastValueLoc(XSharedLvalueMemoryUnit loc, Context ctx) throws Z3Exception {
        return ctx.mkIntConst(loc.getName() + "_final");
    }

    //public static IntExpr lastValueReg(Register reg, Context ctx) throws Z3Exception {
    //    return ctx.mkIntConst(reg.getName() + "_" + reg.getMainThread() + "_final");
    //}
    public static IntExpr lastValueReg(XLocalLvalueMemoryUnit reg, Context ctx) throws Z3Exception {
        return ctx.mkIntConst(reg.getName() + "_" + reg.getProcessId().getValue() + "_final");
    }

    //public static IntExpr ssaLoc(Location loc, Integer mainThread, Integer ssaIndex, Context ctx) throws Z3Exception {
    //    return ctx.mkIntConst(String.format("T%s_%s_%s", mainThread, loc.getName(), ssaIndex));
    //}
    public static IntExpr ssaLoc(XLocation loc, Integer ssaIndex, Context ctx) throws Z3Exception {
        return ctx.mkIntConst(String.format("T%s_%s", loc.getName(), ssaIndex));
    }

    //public static IntExpr ssaReg(Register reg, Integer ssaIndex, Context ctx) throws Z3Exception {
    //    return ctx.mkIntConst(String.format("T%s_%s_%s", reg.getMainThread(), reg.getName(), ssaIndex));
    //}
    public static IntExpr ssaReg(XLocalLvalueMemoryUnit reg, Integer ssaIndex, Context ctx) throws Z3Exception {
        return ctx.mkIntConst(String.format("T%s_%s_%s", reg.getProcessId().getValue(), reg.getName(), ssaIndex));
    }

    //public static BoolExpr lastCoOrder(Event e, Context ctx) throws Z3Exception {
    //    return ctx.mkBoolConst(String.format("last_%s(%s)", ((SharedMemEvent) e).getLoc(), e.repr()));
    //}

    //public static IntExpr intCount(String relName, Event e1, Event e2, Context ctx) throws Z3Exception {
    //    return ctx.mkIntConst(String.format("%s(%s,%s)", relName, e1.repr(), e2.repr()));
    //}
    public static IntExpr intCount(String relName, XEvent e1, XEvent e2, Context ctx) throws Z3Exception {
        return ctx.mkIntConst(String.format("%s(%s,%s)", relName, e1.repr(), e2.repr()));
    }

    //public static BoolExpr cycleVar(String relName, Event e, Context ctx) throws Z3Exception {
    //    return ctx.mkBoolConst(String.format("Cycle(%s)(%s)", e.repr(), relName));
    //}
    public static BoolExpr cycleVar(String relName, XEvent e, Context ctx) throws Z3Exception {
        return ctx.mkBoolConst(String.format("Cycle(%s)(%s)", e.repr(), relName));
    }

    //public static BoolExpr cycleEdge(String relName, Event e1, Event e2, Context ctx) throws Z3Exception {
    //    return ctx.mkBoolConst(String.format("Cycle:%s(%s,%s)", relName, e1.repr(), e2.repr()));
    //}
    public static BoolExpr cycleEdge(String relName, XEvent e1, XEvent e2, Context ctx) throws Z3Exception {
        return ctx.mkBoolConst(String.format("Cycle:%s(%s,%s)", relName, e1.repr(), e2.repr()));
    }
}