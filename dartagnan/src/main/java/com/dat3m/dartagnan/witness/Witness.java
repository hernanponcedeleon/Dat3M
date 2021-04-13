package com.dat3m.dartagnan.witness;

import static com.dat3m.dartagnan.program.utils.EType.PTHREAD;
import static com.dat3m.dartagnan.program.utils.EType.WRITE;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.TimeZone;
import java.util.TreeSet;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.microsoft.z3.Solver;

public class Witness {
	
	private WitnessGraph graph;
	private Program program;
	private Context ctx;
	private Solver solver;
	private String type ;
	private String path;
	
	private Map<Event, Integer> eventThreadMap = new HashMap<>();
	
	private static List<String> graphAttr = Arrays.asList(
			"witness-type",
			"sourcecodelang",
			"producer",
			"specification",
			"programfile",
			"programhash",
			"architecture",
			"creationtime");

	private static List<String> nodeAttr = Arrays.asList(
			"entry",
			"violation");

	private static List<String> edgeAttr = Arrays.asList(
			"startline",
			"enterFunction",
			"threadId",
			"createThread");

	public Witness(Program program, Context ctx, Solver solver, Result result, String path) {
		this.graph = new WitnessGraph();
		this.program = program;
		this.ctx = ctx;
		this.solver = solver;
		this.type = result.equals(FAIL) ? "violation" : "correctness";
		this.path = path;
		buildGraph();
	}
	
	public void write() {
        File newTextFile = new File(System.getenv().get("DAT3M_HOME") + "/output/witness.graphml");
        FileWriter fw;
		try {
			fw = new FileWriter(newTextFile);
			fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n");
			fw.write("<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n");
			for(String attr : graphAttr) {
				fw.write("<key attr.name=\"" + attr + "\" attr.type=\"string\" for=\"graph\" id=\"" + attr + "\"/>\n");
			}
			for(String attr : nodeAttr) {
				fw.write("<key attr.name=\"" + attr + "\" attr.type=\"boolean\" for=\"node\" id=\"" + attr + "\"/>\n");
			}
			for(String attr : edgeAttr) {
				fw.write("<key attr.name=\"" + attr + "\" attr.type=\"string\" for=\"edge\" id=\"" + attr + "\"/>\n");
			}
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
		graph.addAttribute("witness-type", type + "_witness");
		graph.addAttribute("sourcecodelang", "C");
		graph.addAttribute("producer", "Dartagnan");
		graph.addAttribute("specification", "CHECK( init(main()), LTL(G ! call(reach_error())))");
		graph.addAttribute("programfile", path);
		graph.addAttribute("architecture", "32bit");
		graph.addAttribute("programhash", checksum());
		
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		df.setTimeZone(TimeZone.getTimeZone("UTC"));
		graph.addAttribute("creationtime", df.format(new Date()));

		Node v0 = new Node("N0");
		v0.addAttribute("entry", "true");
		Node v1 = new Node("N1");
		Node v2 = new Node("N2");
		
		Edge edge = new Edge(v0, v1); 
		edge.addAttribute("createThread", "0");
		graph.addEdge(edge);
		edge = new Edge(v1, v2); 
		edge.addAttribute("threadId", "0");
		edge.addAttribute("enterFunction", "main");
		graph.addEdge(edge);
		
		int nextNode = 2;
		int threads = 1;
		
		if(type.equals("correctness")) {
			return;
		}

		List<Event> execution = getSCExecutionOrder(ctx, solver.getModel());
		for(int i = 0; i < execution.size(); i++) {
			Event e = execution.get(i);
			if(i+1 < execution.size() && e.getCLine() == execution.get(i+1).getCLine()) {
				continue;
			}
			
			edge = new Edge(new Node("N" + nextNode), new Node("N" + (nextNode+1)));
			edge.addAttribute("threadId", String.valueOf(eventThreadMap.get(e)));
			edge.addAttribute("startline", String.valueOf(e.getCLine()));
			
			if(e.hasFilter(WRITE) && e.hasFilter(PTHREAD)) {
				edge.addAttribute("createThread", String.valueOf(threads));
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
		List<Event> execEvents = new ArrayList<Event>();
		execEvents.addAll(program.getCache().getEvents(FilterBasic.get(EType.INIT)).stream().filter(e -> model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1).collect(Collectors.toList()));
		execEvents.addAll(program.getEvents().stream().filter(e -> model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1).collect(Collectors.toList()));
		
		Map<Integer, List<Event>> map = new HashMap<Integer, List<Event>>();
        for(Event e : execEvents) {
			// TODO improve this: these events correspond to return statements
			if(e instanceof MemEvent && ((MemEvent)e).getMemValue() instanceof BConst && !((BConst)((MemEvent)e).getMemValue()).getValue()) {
				continue;
			}
        	Expr var = model.getConstInterp(intVar("hb", e, ctx));
        	if(var != null) {
        		int key = Integer.parseInt(var.toString());
				if(!map.containsKey(key)) {
					map.put(key, new ArrayList<Event>());
				}
				List<Event> lst = new ArrayList<Event>(Arrays.asList(e));
				Event next = e.getSuccessor();
				// This collects all the successors not accessing global variables
				while(next != null && execEvents.contains(next) && model.getConstInterp(intVar("hb", next, ctx)) == null) {
					lst.add(next);
					next = next.getSuccessor();
				}
        		map.get(key).addAll(lst);
        	}
        }
        
        List<Event> exec = new ArrayList<Event>();
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
