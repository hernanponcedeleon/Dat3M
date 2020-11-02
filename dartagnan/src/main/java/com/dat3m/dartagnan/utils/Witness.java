package com.dat3m.dartagnan.utils;

import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.FunCall;
import com.dat3m.dartagnan.program.event.FunRet;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Address;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

public class Witness {
	
	private Program program;
	private Context ctx;
	private Model model;
	private String path;
	
	private Map<Event, Integer> eventThreadMap = new HashMap<>();

	public Witness(Program program, Context ctx, Model model, String path) {
		this.program = program;
		this.ctx = ctx;
		this.model = model;
		this.path = path;
	}
	
	public void write() {
		int lastLineWritten = -1;
		Event lastEventWritten = null;
		populateMap();
        File newTextFile = new File("./output/witness.graphml");        
        FileWriter fw;
		try {
			fw = new FileWriter(newTextFile);
			fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n");
			fw.write("<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n");
			fw.write("  <graph edgedefault=\"directed\">\n");
			fw.write("    <data key=\"witness-type\">violation_witness</data>\n");
			fw.write("    <data key=\"sourcecodelang\">C</data>\n");
			fw.write("    <data key=\"producer\">Dartagnan</data>\n");
			fw.write("    <data key=\"specification\">CHECK( init(main()), LTL(G ! call(reach_error())) )</data>\n");
			fw.write("    <data key=\"programfile\">" + path + "</data>\n");
			fw.write("    <data key=\"architecture\">32bit</data>\n");
			fw.write("    <data key=\"programhash\">" + checksum() + "</data>\n");
			fw.write("    <data key=\"sourcecodelang\">C</data>\n");
			fw.write("");
			int nextNode = 0;
			int threads = 1;
			
			fw.write("    <node id=\"N" + nextNode + "\"> <data key=\"entry\">true</data> </node>\n");
			fw.write("    <edge source=\"N" + nextNode + "\" target=\"N" + (nextNode+1) + "\">\n");
			fw.write("      <data key=\"threadId\">0</data>\n");
			fw.write("      <data key=\"enterFunction\">main</data>\n");
			fw.write("    </edge>\n");
			nextNode++;
			
			for(Event e : getSCExecutionOrder()) {
				// TODO improve this: these events correspond to return statements
				if(e instanceof MemEvent && ((MemEvent)e).getMemValue() instanceof BConst && !((BConst)((MemEvent)e).getMemValue()).getValue()) {
					continue;
				}
				if(e.getCLine() != lastLineWritten || eventThreadMap.get(e) != eventThreadMap.get(lastEventWritten)) {
					fw.write("    <node id=\"N" + nextNode + "\"> </node>\n");
					fw.write("    <edge source=\"N" + nextNode + "\" target=\"N" + (nextNode+1) + "\">\n");
					fw.write("      <data key=\"threadId\">" + eventThreadMap.get(e) + "</data>\n");
					fw.write("      <data key=\"startline\">" + e.getCLine() + "</data>\n");
					if(e instanceof MemEvent && ((MemEvent)e).getAddress() instanceof Address) {
						if(program.getMemory().getLocationForAddress((Address)((MemEvent)e).getAddress()).getName().contains("_active")) {
							fw.write("      <data key=\"createThread\">" + threads + "</data>\n");
							threads++;
						}
					}	
					if(e instanceof FunCall) {
						fw.write("      <data key=\"enterFunction\">" + ((FunCall)e).getFunctionName()+ "</data>\n");
					}	
					if(e instanceof FunRet) {
						fw.write("      <data key=\"returnFrom\">" + ((FunRet)e).getFunctionName()+ "</data>\n");
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
	
	private List<Event> getSCExecutionOrder() {
		List<Event> exec = new ArrayList<Event>();
		Map<Integer, Event> map = new HashMap<Integer, Event>();
        for(Event e : program.getEvents()) {
        	Expr var = model.getConstInterp(intVar("hb", e, ctx));
        	if(model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1 && var != null) {
        		map.put(Integer.parseInt(var.toString()), e);
        	}
        }
        if(map.keySet().isEmpty()) {
            for(Event e : program.getEvents()) {
            	if(model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1) {
            		map.put(e.getCId(), e);
            	}
            }        	
        }
        SortedSet<Integer> keys = new TreeSet<>(map.keySet());
        for (Integer key : keys) {
        	exec.add(map.get(key));
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
		return output;
	}

}
