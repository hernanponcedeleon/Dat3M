package com.dat3m.dartagnan.witness;

import static com.dat3m.dartagnan.program.utils.EType.PTHREAD;
import static com.dat3m.dartagnan.program.utils.EType.WRITE;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.witness.EdgeAttributes.CREATETHREAD;
import static com.dat3m.dartagnan.witness.EdgeAttributes.ENTERFUNCTION;
import static com.dat3m.dartagnan.witness.EdgeAttributes.EVENTID;
import static com.dat3m.dartagnan.witness.EdgeAttributes.HBPOS;
import static com.dat3m.dartagnan.witness.EdgeAttributes.STARTLINE;
import static com.dat3m.dartagnan.witness.EdgeAttributes.THREADID;
import static com.dat3m.dartagnan.witness.GraphAttributes.ARCHITECTURE;
import static com.dat3m.dartagnan.witness.GraphAttributes.CREATIONTIME;
import static com.dat3m.dartagnan.witness.GraphAttributes.PRODUCER;
import static com.dat3m.dartagnan.witness.GraphAttributes.PROGRAMFILE;
import static com.dat3m.dartagnan.witness.GraphAttributes.PROGRAMHASH;
import static com.dat3m.dartagnan.witness.GraphAttributes.SOURCECODELANG;
import static com.dat3m.dartagnan.witness.GraphAttributes.SPECIFICATION;
import static com.dat3m.dartagnan.witness.GraphAttributes.UNROLLBOUND;
import static com.dat3m.dartagnan.witness.GraphAttributes.WITNESSTYPE;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static java.lang.String.valueOf;

import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.options.DartagnanOptions;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.microsoft.z3.Solver;

public class WitnessBuilder {
	
	private WitnessGraph graph;
	private Program program;
	private Context ctx;
	private Solver solver;
	private String type ;
	private String path;
	
	private Map<Event, Integer> eventThreadMap = new HashMap<>();
	
	public WitnessBuilder(Program program, Context ctx, Solver solver, Result result, DartagnanOptions options) {
		this.graph = new WitnessGraph();
		this.graph.addAttribute(UNROLLBOUND.toString(), String.valueOf(options.getSettings().getBound()));
		this.program = program;
		this.ctx = ctx;
		this.solver = solver;
		this.type = result.equals(FAIL) ? "violation" : "correctness";
		this.path = options.createWitness();
		buildGraph();
	}
	
	public void write() {
		try {
			FileWriter fw = new FileWriter(System.getenv().get("DAT3M_HOME") + "/output/witness.graphml");
			fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n");
			fw.write("<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n");
			for(GraphAttributes attr : GraphAttributes.values()) {fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"string\" for=\"graph\" id=\"" + attr + "\"/>\n");}
			for(NodeAttributes attr : NodeAttributes.values()) {fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"boolean\" for=\"node\" id=\"" + attr + "\"/>\n");}
			for(EdgeAttributes attr : EdgeAttributes.values()) {fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"string\" for=\"edge\" id=\"" + attr + "\"/>\n");}
			fw.write(graph.toXML());
			fw.write("</graphml>\n");
			fw.close();
		}
		catch (IOException e1) {
			e1.printStackTrace();
		}		
	}

	private void buildGraph() {
		populateMap();
		graph.addAttribute(WITNESSTYPE.toString(), type + "_witness");
		graph.addAttribute(SOURCECODELANG.toString(), "C");
		graph.addAttribute(PRODUCER.toString(), "Dartagnan");
		graph.addAttribute(SPECIFICATION.toString(), "CHECK( init(main()), LTL(G ! call(reach_error())))");
		graph.addAttribute(PROGRAMFILE.toString(), path);
		graph.addAttribute(ARCHITECTURE.toString(), "32bit");
		graph.addAttribute(PROGRAMHASH.toString(), checksum());
		
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		df.setTimeZone(TimeZone.getTimeZone("UTC"));
		graph.addAttribute(CREATIONTIME.toString(), df.format(new Date()));

		Node v0 = new Node("N0");
		v0.addAttribute("entry", "true");
		Node v1 = new Node("N1");
		Node v2 = new Node("N2");
		
		Edge edge = new Edge(v0, v1); 
		edge.addAttribute(CREATETHREAD.toString(), "0");
		graph.addEdge(edge);
		edge = new Edge(v1, v2); 
		edge.addAttribute(THREADID.toString(), "0");
		edge.addAttribute(ENTERFUNCTION.toString(), "main");
		graph.addEdge(edge);
		
		int nextNode = 2;
		int threads = 1;
		
		if(type.equals("correctness")) {
			return;
		}

		List<Event> execution = getSCExecutionOrder(ctx, solver.getModel());
		for(int i = 0; i < execution.size(); i++) {
			Event e = execution.get(i);
			if(i+1 < execution.size() && e.getCLine() == execution.get(i+1).getCLine() && e.getThread().equals(execution.get(i+1).getThread())) {
				continue;
			}
			
			edge = new Edge(new Node("N" + nextNode), new Node("N" + (nextNode+1)));
			edge.addAttribute(THREADID.toString(), valueOf(eventThreadMap.get(e)));
			edge.addAttribute(STARTLINE.toString(), valueOf(e.getCLine()));
			if(solver.getModel().getConstInterp(intVar("hb", e, ctx)) != null) {
				edge.addAttribute(EVENTID.toString(), valueOf(e.getCId()));
				edge.addAttribute(HBPOS.toString(), valueOf(solver.getModel().getConstInterp(intVar("hb", e, ctx))));				
			}
			
			if(e.hasFilter(WRITE) && e.hasFilter(PTHREAD)) {
				edge.addAttribute(CREATETHREAD.toString(), valueOf(threads));
				threads++;
			}

			graph.addEdge(edge);
			
			nextNode++;
			if(e.hasFilter(EType.ASSERTION)) {
				break;
			}
		}
		graph.getNode("N" + nextNode).addAttribute("violation", "true");
	}
	
	private void populateMap() {
		for(Thread t : program.getThreads()) {
			for(Event e : t.getEntry().getSuccessors()) {
				eventThreadMap.put(e, t.getId()-1);
			}
		}
	}
	
	private List<Event> getSCExecutionOrder(Context ctx, Model model) {
		List<Event> execEvents = new ArrayList<>();
		execEvents.addAll(program.getCache().getEvents(FilterBasic.get(EType.INIT)).stream().filter(e -> model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1).collect(Collectors.toList()));
		execEvents.addAll(program.getEvents().stream().filter(e -> model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1).collect(Collectors.toList()));
		
		Map<Integer, List<Event>> map = new HashMap<>();
        for(Event e : execEvents) {
			// TODO improve this: these events correspond to return statements
			if(e instanceof MemEvent && ((MemEvent)e).getMemValue() instanceof BConst && !((BConst)((MemEvent)e).getMemValue()).getValue()) {
				continue;
			}
        	Expr var = model.getConstInterp(intVar("hb", e, ctx));
        	if(var != null) {
        		int key = Integer.parseInt(var.toString());
				if(!map.containsKey(key)) {
					map.put(key, new ArrayList<>());
				}
				List<Event> lst = new ArrayList<>(Collections.singletonList(e));
				Event next = e.getSuccessor();
				// This collects all the successors not accessing global variables
				while(next != null && execEvents.contains(next) && model.getConstInterp(intVar("hb", next, ctx)) == null) {
					lst.add(next);
					next = next.getSuccessor();
				}
        		map.get(key).addAll(lst);
        	}
        }
        
        List<Event> exec = new ArrayList<>();
        SortedSet<Integer> keys = new TreeSet<>(map.keySet());
        for (Integer key : keys) {
        	exec.addAll(map.get(key));
        }
        
        return exec.isEmpty() ? execEvents : exec;
	}
	
	private String checksum() {
		String output = null;
		try {
			Process proc = Runtime.getRuntime().exec("sha256sum " + path);
			BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			try {
				proc.waitFor();
			} catch(InterruptedException e) {
				System.out.println(e.getMessage());
				System.exit(0);
			}
			while(read.ready()) {
				output = read.readLine();
			}
			if(proc.exitValue() == 1) {
				BufferedReader error = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
				while(error.ready()) {
					System.out.println(error.readLine());
				}
				System.exit(0);
			}
		} catch(IOException e) {
			System.out.println(e.getMessage());
			System.exit(0);
		}
		output = output.substring(0, output.lastIndexOf(' '));
		output = output.substring(0, output.lastIndexOf(' '));
		return output;
	}

}
