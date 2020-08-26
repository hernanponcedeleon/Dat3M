package com.dat3m.dartagnan.utils;

import static com.dat3m.dartagnan.program.utils.EType.INIT;
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

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
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
			fw.write("    <data key=\"specification\">CHECK( init(main()), LTL(G ! call(__VERIFIER_error())) )</data>\n");
			fw.write("    <data key=\"programfile\">" + path + "</data>\n");
			fw.write("    <data key=\"architecture\">32bit</data>\n");
			fw.write("    <data key=\"programhash\">" + checksum() + "</data>\n");
			fw.write("    <data key=\"sourcecodelang\">C</data>\n");
			fw.write("");
			fw.write("    <node id=\"N0\"> <data key=\"entry\">true</data> </node>\n");
			fw.write("    <edge source=\"N0\" target=\"N1\">\n");
			fw.write("      <data key=\"threadId\">0</data>\n");
			fw.write("      <data key=\"enterFunction\">main</data>\n");
			fw.write("    </edge>\n");
			fw.write("    <node id=\"N1\"> </node>\n");
			int nextNode = 1;
			int noMainThreads = program.getThreads().size() - program.getCache().getEvents(FilterBasic.get(INIT)).size() - 1;
			for(int i= 1 ; i < noMainThreads ; i++) {
				fw.write("    <edge source=\"N" + nextNode + "\" target=\"N" + (nextNode+1) + "\">\n");
				fw.write("      <data key=\"createThread\">" + i + "</data>\n");
				fw.write("    </edge>\n");
				fw.write("    <node id=\"N" + (nextNode+1) + "\"> </node>\n");
				nextNode++;
			}
			for(Event e : getSCExecutionOrder()) {
				fw.write("    <edge source=\"N" + nextNode + "\" target=\"N" + (nextNode+1) + "\">\n");
				fw.write("      <data key=\"threadId\">" + eventThreadMap.get(e) + "</data>\n");
				fw.write("      <data key=\"startline\">" + e.getCLine() + "</data>\n");
				fw.write("    </edge>\n");
				fw.write("    <node id=\"N" + (nextNode+1) + "\"> </node>\n");
				nextNode++;
			}
			fw.write("    <node id=\"N" + (nextNode+1) + "\"> <data key=\"violation\">true</data> </node>\n");
			fw.write("  </graph>\n");
			fw.write("</graphml>\n");
			fw.close();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
	
	private void populateMap() {
		for(Thread t : program.getThreads()) {
			for(Event e : t.getCache().getEvents(FilterBasic.get(EType.ANY))) {
				eventThreadMap.put(e, t.getId()-1);
			}
		}
	}
	
	private List<Event> getSCExecutionOrder() {
		List<Event> exec = new ArrayList<Event>();
		Map<Integer, Event> map = new HashMap<Integer, Event>();
        for(Event e : program.getCache().getEvents(FilterBasic.get(EType.MEMORY))) {
        	Expr var = model.getConstInterp(intVar("hb", e, ctx));
        	if(model.getConstInterp(e.exec()).isTrue() && e.getCLine() > -1 && var != null) {
        		map.put(Integer.parseInt(var.toString()), e);
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
