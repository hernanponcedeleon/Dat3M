package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.microsoft.z3.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Init;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Location;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class Graph {

    public static Set<String> getDefaultRelations(){
        return new HashSet<>(Arrays.asList("po", "co", "rf"));
    }

    private static Map<String, String> colorMap;
    static
    {
        colorMap = new HashMap<>();
        colorMap.put("rf", "red");
        colorMap.put("co", "blue");
        colorMap.put("po", "brown");
    }

    private Model model;
    private Context ctx;

    private StringBuilder buffer;
    private Map<Integer, Location> mapAddressLocation;
    private Set<String> relations = new HashSet<>();

    private final String L1 = "  ";
    private final String L2 = "    ";
    private final String L3 = "      ";

    private final String sourceLabel = "Program Compiled to Source Architecture";
    private final String targetLabel = "Program Compiled to Target Architecture";

    private final String DEFAULT_EDGE_COLOR = "indigo";

    public Graph(Model model, Context ctx, Program program, Collection<String> relations){
        this(model, ctx, relations);
        build(program);
    }

    public Graph(Model model, Context ctx, Program pSource, Program pTarget, Collection<String> relations){
        this(model, ctx, relations);
        build(pSource, pTarget);
    }

    private Graph(Model model, Context ctx, Collection<String> relations){
        this.model = model;
        this.ctx = ctx;
        this.relations.addAll(relations);
        this.relations.add("rf");
        this.relations.remove("po");
        this.relations.remove("co");
    }

    @Override
    public String toString(){
        return buffer.toString();
    }

    private void build(Program program){
        buffer = new StringBuilder();
        buffer.append("digraph G {\n")
        		.append(L1).append("subgraph cluster_Target { ").append(getProgramDef(targetLabel)).append("\n")
                .append(buildProgramGraph(program))
                .append(L1).append("}\n")
                .append("}\n");
    }

    private void build(Program pSource, Program pTarget){
        buffer = new StringBuilder();
        buffer.append("digraph G {\n");

        buffer.append(L1).append("subgraph cluster_Source { ").append(getProgramDef(sourceLabel)).append("\n")
                .append(buildProgramGraph(pSource))
                .append(buildCycle())
                .append(L1).append("}\n");

        buffer.append(L1).append("subgraph cluster_Target { ").append(getProgramDef(targetLabel)).append("\n")
                .append(buildProgramGraph(pTarget))
                .append(L1).append("}\n");

        buffer.append("}\n");
    }

    private StringBuilder buildProgramGraph(Program program){
        buildAddressLocationMap(program);
        return buildEvents(program)
                .append(buildPo(program))
                .append(buildCo(program))
                .append(buildRelations(program));
    }

    private StringBuilder buildEvents(Program program){
        StringBuilder sb = new StringBuilder();

        int tId = 0;
        for(Thread t : program.getThreads()) {
            Event firstEvent = t.getEntry().getSuccessor();
            if(firstEvent instanceof Init){
                Init e = (Init)firstEvent;
                Location location = mapAddressLocation.get(e.getAddress().getIntValue(e, model, ctx));
                String label = e.label() + " " + location.getName() + " = " + e.getValue();
                sb.append(L3).append(e.repr()).append(" ").append(getEventDef(label)).append(";\n");
            } else {
                sb.append(L2).append("subgraph cluster_Thread_").append(t.getId()).append(" { ").append(getThreadDef(tId++)).append("\n");
                for(Event e : t.getCache().getEvents(FilterBasic.get(EType.VISIBLE))) {
                    if(model.getConstInterp(e.exec()).isTrue()){
                        String label = e.label();
                        if(e instanceof MemEvent) {
                            Location location = mapAddressLocation.get(((MemEvent) e).getAddress().getIntValue(e, model, ctx));
                            int value = 0;
                            if(e instanceof Load){
                                Register r = ((Load) e).getResultRegister();
                                value = Integer.parseInt(model.getConstInterp(r.toZ3IntResult(e, ctx)).toString());
                            } else {
                                value = ((MemEvent) e).getMemValue().getIntValue(e, model, ctx);
                            }
                            label += " " + location + " = " + value;
                        }
                        sb.append(L3).append(e.repr()).append(" ").append(getEventDef(label, t.getId())).append(";\n");
                    }
                }
                sb.append(L2).append("}\n");
            }
        }

        return sb;
    }

    private StringBuilder buildPo(Program program){
        StringBuilder sb = new StringBuilder();
        String edge = " " + getEdgeDef("po") + ";\n";

        for(Thread thread : program.getThreads()) {
            List<Event> events = thread.getCache()
                    .getEvents(FilterBasic.get(EType.VISIBLE))
                    .stream()
                    .filter(e -> model.getConstInterp(e.exec()).isTrue())
                    .collect(Collectors.toList());

            for(int i = 1; i < events.size(); i++){
                Event e1 = events.get(i - 1);
                Event e2 = events.get(i);
                sb.append(L3).append(e1.repr()).append(" -> ").append(e2.repr()).append(edge);
            }
        }
        return sb;
    }

    private StringBuilder buildCo(Program program){
        StringBuilder sb = new StringBuilder();
        String edge = " " + getEdgeDef("co") + ";\n";

        Map<Integer, Set<Event>> mapAddressEvent = new HashMap<>();
        for(Event e : program.getCache().getEvents(FilterBasic.get(EType.WRITE))){
            if(model.getConstInterp(e.exec()).isTrue()){
                int address = ((MemEvent)e).getAddress().getIntValue(e, model, ctx);
                mapAddressEvent.putIfAbsent(address, new HashSet<>());
                mapAddressEvent.get(address).add(e);
            }
        }

        for(int address : mapAddressEvent.keySet()){
            Map<Event, Integer> map = new HashMap<>();
            for(Event e2 : mapAddressEvent.get(address)){
                map.put(e2, 0);
                for(Event e1 : mapAddressEvent.get(address)){
                    Expr expr = model.getConstInterp(Utils.edge("co", e1, e2, ctx));
                    if(expr != null && expr.isTrue()){
                        map.put(e2, map.get(e2) + 1);
                    }
                }
            }

            List<Map.Entry<Event, Integer>> list = new ArrayList<>(map.entrySet());
            list.sort(Map.Entry.comparingByValue());

            for(int i = 1; i < list.size(); i++){
                Event e1 = list.get(i - 1).getKey();
                Event e2 = list.get(i).getKey();
                sb.append("      ").append(e1.repr()).append(" -> ").append(e2.repr()).append(edge);
            }
        }
        return sb;
    }

    private StringBuilder buildRelations(Program program){
        StringBuilder sb = new StringBuilder();

        List<Event> events = program.getCache()
                .getEvents(FilterBasic.get(EType.VISIBLE))
                .stream()
                .filter(e -> model.getConstInterp(e.exec()).isTrue())
                .collect(Collectors.toList());

        for(String relName : relations) {
            String edge = " " + getEdgeDef(relName) + ";\n";
            for(Event e1 : events) {
                for(Event e2 : events) {
                    Expr expr = model.getConstInterp(Utils.edge(relName, e1, e2, ctx));
                    if(expr != null && expr.isTrue()){
                        sb.append("      ").append(e1.repr()).append(" -> ").append(e2.repr()).append(edge);
                    }
                }
            }
        }
        return sb;
    }

    private StringBuilder buildCycle(){
        Pattern pattern = Pattern.compile("\\((E\\d+),(E\\d+)\\)$");
        StringBuilder sb = new StringBuilder();
        sb.append(L2).append("/* Cycle */\n");
        for(FuncDecl m : model.getDecls()) {
            String edge = m.getName().toString();
            if(edge.contains("Cycle:") && model.getConstInterp(m).isTrue()) {
                Matcher matcher = pattern.matcher(edge);
                if(matcher.find()){
                    sb.append(L2).append(matcher.group(1)).append(" -> ")
                            .append(matcher.group(2)).append("[style=bold, color=green, weight=1];\n");
                }
            }
        }
        return sb;
    }

    private void buildAddressLocationMap(Program program){
        mapAddressLocation = new HashMap<>();
        for(Location location : program.getLocations()){
            mapAddressLocation.put(location.getAddress().getIntValue(null, model, ctx), location);
        }
    }

    private String getProgramDef(String label){
        return "rank=sink; fontsize=20; label=\"" + label + "\"; color=grey; shape=box; weight=1;";
    }

    private String getThreadDef(int tId){
        return "rank=sink; fontsize=15; label=\"Thread " + tId + "\"; color=magenta; shape=box;";
    }

    private String getEdgeDef(String relName){
        String color = colorMap.getOrDefault(relName, DEFAULT_EDGE_COLOR);
        return "[label=\"" + relName + "\", color=\"" + color + "\", fontcolor=\"" + color + "\" weight=1]";
    }

    private String getEventDef(String label){
        return "[label=\"" + label + "\", shape=\"box\", color=\"blue\", root=true]";
    }

    private String getEventDef(String label, int group){
        return "[label=\"" + label + "\", shape=\"box\", color=\"blue\", group=\"s" + group + "\"]";
    }
}
