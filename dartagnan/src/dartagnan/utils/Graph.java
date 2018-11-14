package dartagnan.utils;

import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.FuncDecl;
import com.microsoft.z3.Model;
import dartagnan.program.Location;
import dartagnan.program.Program;
import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.event.Init;
import dartagnan.program.event.MemEvent;
import dartagnan.program.utils.EventRepository;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class Graph {

    private Set<String> relations = new HashSet<>(Arrays.asList(
            "rf", "mfence", "sync", "isync", "lwsync", "isb", "ish", "mb", "wmb", "rmb")
    );

    // TODO: HashMap<> instead of HashMap<String, String> brokes the compilation in my pc
    private Map<String, String> colorMap = new HashMap<>(){{
        put("rf", "red");
        put("co", "blue");
        put("po", "brown");
        put("mfence", "black");
        put("sync", "black");
        put("isync", "black");
        put("lwsync", "black");
        put("isb", "black");
        put("ish", "black");
        put("mb", "black");
        put("rmb", "black");
        put("wmb", "black");
    }};

    private Model model;
    private Context ctx;

    private StringBuilder buffer;

    private final String L1 = "  ";
    private final String L2 = "    ";
    private final String L3 = "      ";

    private final String sourceLabel = "Program Compiled to Source Architecture";
    private final String targetLabel = "Program Compiled to Target Architecture";

    private final String DEFAULT_EDGE_COLOR = "indigo";

    public Graph(Model model, Context ctx){
        this.model = model;
        this.ctx = ctx;
    }

    public void addRelations(Collection<String> relations){
        this.relations.addAll(relations);
    }

    public static Set<String> getDefaultRelations(){
        return new HashSet<>(Arrays.asList("po", "co", "rf"));
    }

    public Graph build(Program program){
        buffer = new StringBuilder();
        buffer.append("digraph G {\n")
                .append(L1).append("subgraph cluster_Target { ").append(getProgramDef(targetLabel)).append("\n")
                .append(buildProgramGraph(program))
                .append(L1).append("}\n")
                .append("}\n");
        return this;
    }

    public Graph build(Program pSource, Program pTarget){
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

        return this;
    }

    public void draw(String filename) throws IOException {
        File newTextFile = new File(filename);
        FileWriter fw = new FileWriter(newTextFile);
        fw.write(buffer.toString());
        fw.close();
    }

    private StringBuilder buildProgramGraph(Program program){
        return buildEvents(program)
                .append(buildPo(program))
                .append(buildCo(program))
                .append(buildRelations(program));
    }

    private StringBuilder buildEvents(Program program){
        StringBuilder sb = new StringBuilder();

        int tId = 0;
        for(dartagnan.program.Thread t : program.getThreads()) {

            if(t instanceof Init){
                Init e = (Init)t.getEvents().iterator().next();
                String label = e.label() + " = " + model.getConstInterp(e.getSsaLoc()).toString();
                sb.append(L3).append(e.repr()).append(" ").append(getEventDef(label)).append(";\n");

            } else {
                sb.append(L2).append("subgraph cluster_Thread_").append(t.getTId()).append(" { ").append(getThreadDef(tId++)).append("\n");

                List<Event> events = t.getEventRepository().getEvents(EventRepository.VISIBLE).stream()
                        .filter(e -> model.getConstInterp(e.executes(ctx)).isTrue())
                        .sorted(Comparator.comparing(Event::getEId)).collect(Collectors.toList());

                for(Event e2 : events) {
                    String label = e2.label();
                    if(e2 instanceof MemEvent) {
                        label += " = " + model.getConstInterp(((MemEvent) e2).getSsaLoc()).toString();
                    }
                    sb.append(L3).append(e2.repr()).append(" ").append(getEventDef(label, t.getTId())).append(";\n");
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
            List<Event> events = thread.getEventRepository().getEvents(EventRepository.VISIBLE).stream()
                    .filter(e -> model.getConstInterp(e.executes(ctx)).isTrue())
                    .sorted(Comparator.comparing(Event::getEId)).collect(Collectors.toList());

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

        Set<MemEvent> events = program.getEventRepository()
                .getEvents(EventRepository.STORE | EventRepository.INIT)
                .stream()
                .map(e -> (MemEvent)e)
                .collect(Collectors.toSet());

        Set<Location> locations = program.getEventRepository().getLocations();

        for(Location location : locations){
            Map<Event, Integer> map = new HashMap<>();
            Set<Event> locEvents = new HashSet<>();

            for(Event e : events){
                if(e.getLoc().equals(location)){
                    map.put(e, 0);
                    locEvents.add(e);
                }
            }

            for(Event e1 :locEvents){
                for(Event e2 : locEvents){
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
        List<Event> events = program.getEventRepository().getEvents(EventRepository.VISIBLE).stream()
                .filter(e -> model.getConstInterp(e.executes(ctx)).isTrue()).collect(Collectors.toList());

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
        StringBuilder sb = new StringBuilder();
        sb.append(L2).append("/* Cycle */\n");
        for(FuncDecl m : model.getDecls()) {
            String edge = m.getName().toString();
            if(edge.contains("Cycle:") && model.getConstInterp(m).isTrue()) {
                String source = getSourceFromEdge(edge);
                String target = getTargetFromEdge(edge);
                sb.append(L2).append(source).append(" -> ").append(target).append("[style=bold, color=green, weight=1];\n");
            }
        }
        return sb;
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

    private String getSourceFromEdge(String edge) {
        return edge.split("\\(")[1].split(",")[0];
    }

    private String getTargetFromEdge(String edge) {
        return edge.replace(")", "").split(",")[1];
    }
}
