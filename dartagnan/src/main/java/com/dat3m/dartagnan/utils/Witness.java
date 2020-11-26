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
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.TimeZone;
import java.util.TreeSet;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Address;
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

		int lastLineWritten = -1;
		int lastOid = -1;
		Event lastEventWritten = null;
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
			
			TimeZone tz = TimeZone.getTimeZone("UTC");
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
			df.setTimeZone(tz);
			String nowAsISO = df.format(new Date());
			fw.write("    <data key=\"creationtime\">" + nowAsISO + "</data>\n");
			
			fw.write("    <node id=\"N0\"> <data key=\"entry\">true</data> </node>\n");
			fw.write("    <edge source=\"N0\" target=\"N1\">\n");
			fw.write("      <data key=\"createThread\">0</data>\n");
			fw.write("    </edge>\n");
			fw.write("    <node id=\"N1\"></node>\n");
			fw.write("    <edge source=\"N1\" target=\"N2\">\n");
			fw.write("      <data key=\"threadId\">0</data>\n");
			fw.write("      <data key=\"enterFunction\">main</data>\n");
			fw.write("    </edge>\n");
			
			int nextNode = 2;
			int threads = 1;
			
			if(result.equals(PASS)) {
				fw.write("    <node id=\"N" + nextNode + "\"></node>\n");
				fw.write("  </graph>\n");
				fw.write("</graphml>\n");
				fw.close();
				return;
			}
			
			for(Event e : getSCExecutionOrder(ctx, solver)) {
				// TODO improve this: these events correspond to return statements
				if(e instanceof MemEvent && ((MemEvent)e).getMemValue() instanceof BConst && !((BConst)((MemEvent)e).getMemValue()).getValue()) {
					continue;
				}
				if(e.getCLine() != lastLineWritten || eventThreadMap.get(e) != eventThreadMap.get(lastEventWritten) || e.getOId() <= lastOid) {
					fw.write("    <node id=\"N" + nextNode + "\"> </node>\n");
					fw.write("    <edge source=\"N" + nextNode + "\" target=\"N" + (nextNode+1) + "\">\n");
					fw.write("      <data key=\"threadId\">" + eventThreadMap.get(e) + "</data>\n");
					fw.write("      <data key=\"startline\">" + e.getCLine() + "</data>\n");
					if(e instanceof MemEvent 
							&& ((MemEvent)e).getAddress() instanceof Address
							&& program.getMemory().getLocationForAddress((Address)((MemEvent)e).getAddress()) != null) {
						if(program.getMemory().getLocationForAddress((Address)((MemEvent)e).getAddress()).getName().contains("_active")) {
							fw.write("      <data key=\"createThread\">" + threads + "</data>\n");
							threads++;
						}
					}	
					// We need to keep this because SVCOMP assumes every statement is atomic
					lastLineWritten = e.getCLine();
					// Needed because of the above
					// We need to differentiate two events being instances of the same 
					// instructions if a thread is created more than once 
					lastEventWritten = e;
					fw.write("    </edge>\n");
					nextNode++;
				}
				lastOid = e.getOId();
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
	
	private List<Event> getSCExecutionOrder(Context ctx, Solver solver) {
		Model model = solver.getModel();
		List<Event> exec = new ArrayList<Event>();
		Map<Integer, Set<Event>> map = new HashMap<Integer, Set<Event>>();
        for(Event e : program.getEvents()) {
        	Expr var = model.getConstInterp(intVar("hb", e, ctx));
        	if(model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1 && var != null) {
        		int key = Integer.parseInt(var.toString());
				if(!map.containsKey(key)) {
					map.put(key, new HashSet<Event>());
				}
        		map.get(key).add(e);
        	}
        }
        if(map.keySet().isEmpty()) {
            for(Event e : program.getEvents()) {
            	if(model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1) {
            		int key = e.getCId();
    				if(!map.containsKey(key)) {
    					map.put(key, new HashSet<Event>());
    				}
            		map.get(key).add(e);
            	}
            }        	
        }
        SortedSet<Integer> keys = new TreeSet<>(map.keySet());
        for (Integer key : keys) {
        	exec.addAll(map.get(key));
        }
		return exec;
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
