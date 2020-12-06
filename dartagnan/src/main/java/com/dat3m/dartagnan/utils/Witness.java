package com.dat3m.dartagnan.utils;

import static com.dat3m.dartagnan.utils.Result.PASS;
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
import java.util.Stack;
import java.util.TimeZone;
import java.util.TreeSet;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.FunCall;
import com.dat3m.dartagnan.program.event.FunRet;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.microsoft.z3.Solver;

public class Witness {
	
	private Program program;
	private String path;
	
	private Map<Event, Integer> eventThreadMap = new HashMap<>();

	public Witness(Program program, String path) {
		this.program = program;
		this.path = path;
	}
	
	public void write(Context ctx, Solver solver, Result result) {
		String type;
		switch(result) {
			case PASS:
				type = "correctness";
				break;
			case FAIL:
				type = "violation";
				break;
			default:
				return;
		}

		HashMap<Integer, Stack<String>> callStack = new HashMap<Integer, Stack<String>>();
		for(Thread t : program.getThreads()) {
			callStack.put(t.getId()-1, new Stack<String>());
			callStack.get(t.getId()-1).push(t.getName());
		}
		callStack.get(0).push("main");
		populateMap();
        File newTextFile = new File("./output/witness.graphml");        
        FileWriter fw;
		try {
			fw = new FileWriter(newTextFile);
			fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n");
			fw.write("<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n");
			fw.write("<key attr.name=\"sourcecodeLanguage\" attr.type=\"string\" for=\"graph\" id=\"sourcecodelang\"/>\n");
			fw.write("<key attr.name=\"programFile\" attr.type=\"string\" for=\"graph\" id=\"programfile\"/>\n");
			fw.write("<key attr.name=\"programHash\" attr.type=\"string\" for=\"graph\" id=\"programhash\"/>\n");
			fw.write("<key attr.name=\"specification\" attr.type=\"string\" for=\"graph\" id=\"specification\"/>\n");
			fw.write("<key attr.name=\"architecture\" attr.type=\"string\" for=\"graph\" id=\"architecture\"/>\n");
			fw.write("<key attr.name=\"producer\" attr.type=\"string\" for=\"graph\" id=\"producer\"/>\n");
			fw.write("<key attr.name=\"startline\" attr.type=\"int\" for=\"edge\" id=\"startline\"/>\n");
			fw.write("<key attr.name=\"enterFunction\" attr.type=\"string\" for=\"edge\" id=\"enterFunction\"/>\n");
			fw.write("<key attr.name=\"assumption\" attr.type=\"string\" for=\"edge\" id=\"assumption\"/>");
			fw.write("<key attr.name=\"assumption.scope\" attr.type=\"string\" for=\"edge\" id=\"assumption.scope\"/>");
			fw.write("<key attr.name=\"witness-type\" attr.type=\"string\" for=\"graph\" id=\"witness-type\"/>\n");
			fw.write("<key attr.name=\"creationTime\" attr.type=\"string\" for=\"graph\" id=\"creationtime\"/>\n");
			fw.write("<key attr.name=\"threadId\" attr.type=\"string\" for=\"edge\" id=\"threadId\"/>\n");
			fw.write("<key attr.name=\"createThread\" attr.type=\"string\" for=\"edge\" id=\"createThread\"/>\n");
			fw.write("<key attr.name=\"isEntryNode\" attr.type=\"boolean\" for=\"node\" id=\"entry\"><default>false</default></key>\n");
			fw.write("<key attr.name=\"isViolationNode\" attr.type=\"boolean\" for=\"node\" id=\"violation\"><default>false</default></key>\n");
			
			fw.write("  <graph edgedefault=\"directed\">\n");
			fw.write("    <data key=\"witness-type\">" + type + "_witness</data>\n");
			fw.write("    <data key=\"sourcecodelang\">C</data>\n");
			fw.write("    <data key=\"producer\">Dartagnan</data>\n");
			fw.write("    <data key=\"specification\">CHECK( init(main()), LTL(G ! call(reach_error())) )</data>\n");
			fw.write("    <data key=\"programfile\">" + path + "</data>\n");
			fw.write("    <data key=\"architecture\">32bit</data>\n");
			fw.write("    <data key=\"programhash\">" + checksum() + "</data>\n");
			
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
			df.setTimeZone(TimeZone.getTimeZone("UTC"));
			fw.write("    <data key=\"creationtime\">" + df.format(new Date()) + "</data>\n");
			
			fw.write("    <node id=\"N0\"> <data key=\"entry\">true</data> </node>\n");
			fw.write("    <edge source=\"N0\" target=\"N1\">\n");
			fw.write("      <data key=\"threadId\">0</data>\n");
			fw.write("      <data key=\"enterFunction\">main</data>\n");
			fw.write("    </edge>\n");
			
			int nextNode = 1;
			int threads = 1;
			
			if(result.equals(PASS)) {
				fw.write("    <node id=\"N" + nextNode + "\"></node>\n");
				fw.write("  </graph>\n");
				fw.write("</graphml>\n");
				fw.close();
				return;
			}
			
			String nextAss = "";
			
			List<Event> execution = getSCExecutionOrder(ctx, solver.getModel());
			for(int i = 0; i < execution.size(); i++) {
				Event e = execution.get(i);
				// TODO improve this: these events correspond to return statements
				if(e instanceof MemEvent && ((MemEvent)e).getMemValue() instanceof BConst && !((BConst)((MemEvent)e).getMemValue()).getValue()) {
					continue;
				}
				if(i+1 < execution.size() && e.getCLine() == execution.get(i+1).getCLine()) {
					continue;
				}
				fw.write("    <node id=\"N" + nextNode + "\"></node>\n");
				fw.write("    <edge source=\"N" + nextNode + "\" target=\"N" + (nextNode+1) + "\">\n");
				fw.write("      <data key=\"threadId\">" + eventThreadMap.get(e) + "</data>\n");
				fw.write("      <data key=\"startline\">" + e.getCLine() + "</data>\n");
				if(nextAss != "") {
					fw.write(nextAss);
					nextAss = "";	
				}
				if(e instanceof FunCall) {
					String name = ((FunCall)e).getFunctionName();
					callStack.get(eventThreadMap.get(e)).push(name);
					fw.write("      <data key=\"enterFunction\">" + name + "</data>\n");
				}
				if(e instanceof FunRet) {
					callStack.get(eventThreadMap.get(e)).pop();
					fw.write("      <data key=\"returnFromFunction\">" + ((FunRet)e).getFunctionName() + "</data>\n");
				}
				if(e instanceof Local) {
					Register reg = ((Local)e).getResultRegister();
					if(reg.getCVar() != null) {
						long value = Long.parseLong(solver.getModel().getConstInterp(reg.toZ3IntResult(e, ctx)).toString());
						nextAss += "      <data key=\"assumption\">" + reg.getCVar() + "=" + value + ";</data>\n";
						nextAss += "      <data key=\"assumption.scope\">" + callStack.get(eventThreadMap.get(e)).peek() + ";</data>\n";
					}
				}
				if(e instanceof MemEvent 
						&& ((MemEvent)e).getAddress() instanceof Address
						&& program.getMemory().getLocationForAddress((Address)((MemEvent)e).getAddress()) != null) {
					String variable = program.getMemory().getLocationForAddress((Address)((MemEvent)e).getAddress()).getName();
					if(variable.contains("_active")) {
						fw.write("      <data key=\"createThread\">" + threads + "</data>\n");
						threads++;
					} else {
						int value = program.getMemory().getLocationForAddress((Address)((MemEvent)e).getAddress()).getIntValue(e, solver.getModel(), ctx);
						nextAss += "      <data key=\"assumption\">" + variable + "=" + value + ";</data>\n";
					}
				}	
				fw.write("    </edge>\n");
				nextNode++;
				if(e.hasFilter(EType.ASSERTION)) {
					break;
				}
			}
			fw.write("    <node id=\"N" + nextNode + "\"> <data key=\"violation\">true</data> </node>\n");
			fw.write("  </graph>\n");
			fw.write("</graphml>\n");
			fw.close();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
	
	private void populateMap() {
		for(Thread t : program.getThreads()) {
			for(Event e : t.getEntry().getSuccessors()) {
				eventThreadMap.put(e, t.getId()-1);
			}
		}
	}
	
	private List<Event> getSCExecutionOrder(Context ctx, Model model) {
		List<Event> execEvents = program.getEvents().stream().filter(e -> model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1).collect(Collectors.toList());
		
		Map<Integer, List<Event>> map = new HashMap<Integer, List<Event>>();
        for(Event e : execEvents) {
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
